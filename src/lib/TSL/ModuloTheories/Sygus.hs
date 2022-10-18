-------------------------------------------------------------------------------
-- |
-- Module      :  TSL.ModuloTheories.Sygus
-- Description :  Generates SyGuS problems from a Data Transformation Obligation.
-- Maintainer  :  Wonhyuk Choi

-------------------------------------------------------------------------------
{-# LANGUAGE LambdaCase      #-}
{-# LANGUAGE RecordWildCards #-}

-------------------------------------------------------------------------------
module TSL.ModuloTheories.Sygus
  ( Dto
  , buildDto
  , buildDtoList
  , fixedSizeQuery
  ) where

-------------------------------------------------------------------------------

import qualified Data.Set as Set

import Data.Set (Set)

import qualified Data.Map as Map

import Data.Map (Map)

import Data.List (inits)

import Control.Exception(assert)

import Control.Monad.Trans.Except

import TSL.Error(Error, errSolver)

import TSL.Specification(Specification(..))

import TSL.Ast(Ast(..), AstInfo(..), SymbolInfo(..))

import TSL.ModuloTheories.Cfg ( Cfg(..)
                              , outputSignals
                              , productionRules
                              , extendCfg
                              )

import TSL.ModuloTheories.Predicates( TheoryPredicate
                                    , predInfo
                                    , pred2Tsl
                                    , pred2Smt
                                    , predTheory
                                    , predSignals
                                    , predReplacedSmt
                                    , enumeratePreds
                                    )

import TSL.ModuloTheories.Theories( Theory
                                  , TheorySymbol
                                  , TAst
                                  , tastByDepth
                                  , tast2Tsl
                                  , tastSignals
                                  , tast2Smt
                                  , symbol2Smt
                                  , symbolType
                                  , symbolTheory
                                  , smtSortDecl
                                  , makeSignal
                                  , isUninterpreted
                                  , getAst
                                  )

-------------------------------------------------------------------------------

data Temporal =
      Next Int
    | Eventually
    deriving (Eq)

instance Show Temporal where
  show = \case
    Next numNext -> replicate numNext 'X'
    Eventually   -> "F"

-- | Data Transformation Obligation.
data Dto = Dto 
    {   theory        :: Theory
    ,   preCondition  :: TheoryPredicate
    ,   postCondition :: TheoryPredicate
    }

buildDto :: TheoryPredicate -> TheoryPredicate -> Dto
buildDto pre post = Dto theory pre post
  where theory   = assert theoryEq $ predTheory pre
        theoryEq = (predTheory pre) == (predTheory post)

buildDtoList :: [TheoryPredicate] -> [Dto]
buildDtoList preds = concat $ map buildWith preds
  where buildWith pred = map (buildDto pred) preds

tabulate :: Int -> String -> String
tabulate n = (++) (replicate n '\t')

minitab :: Int -> String -> String
minitab n = (++) (replicate (2 * n) ' ')

functionName :: String
functionName = "function"

parenthize :: Int -> String -> String
parenthize repeats str = lpars ++ str ++ rpars
  where lpars = replicate repeats '(' 
        rpars = replicate repeats ')'

declareVar :: TheorySymbol -> String
declareVar symbol = parenthize 1 $ unwords [show symbol, symbolType symbol]

dto2Sygus :: TheorySymbol -> Dto -> String
dto2Sygus synthTarget (Dto _ pre post) = 
  unlines [ "(constraint"
          ,  forallExpr
          , ")"
          ]
  where 
    precondSygus  = pred2Smt pre
    fApplied      = parenthize 1 $ unwords [functionName, show synthTarget]
    postcondSygus = predReplacedSmt synthTarget fApplied post
    forallExpr    = unlines [forallDecl, forallBody, minitab 1 ")"]
    -- FIXME: should instead be "all nonterminals used"
    forallDecl    = minitab 1 $ unwords ["(forall", parenthize 1 (declareVar synthTarget)]
    forallBody    = unlines $ map (minitab 2) [ "(=>"
                                              , minitab 1 precondSygus
                                              , minitab 1 postcondSygus
                                              , ")"
                                              ]

getSygusTargets :: Dto -> Cfg -> [TheorySymbol]
getSygusTargets (Dto _ _ post) cfg = Set.toList intersection
  where outputs      = outputSignals cfg
        postSignals  = Set.fromList $ predSignals post
        intersection = Set.intersection outputs postSignals

-- | Picks one signal to synthesize SyGuS for.
-- Unfortunately, the current procedure only allows synthesis 
-- of one single function. More info:
-- tsltools/docs/tslmt2tsl-limitations.md#simultaneous-updates
pickTarget :: [TheorySymbol] -> TheorySymbol
pickTarget = head

getProductionRules :: TheorySymbol -> Cfg -> Maybe [TAst]
getProductionRules nonterminal cfg = Map.lookup nonterminal (grammar cfg)

nonterminalsUsed :: TheorySymbol -> Cfg -> Set TheorySymbol
nonterminalsUsed symbol cfg = helper symbol Set.empty
  where
    helper :: TheorySymbol -> Set TheorySymbol -> Set TheorySymbol
    helper symbol set =
        case getProductionRules symbol cfg of
          Nothing    -> set
          Just rules -> Set.union set $ Set.fromList $ concat $ map tastSignals rules

productionRules2Sygus :: TheorySymbol -> [TAst] -> String
productionRules2Sygus nonterminal rules = unlines
  [ minitab 2 $ "(" ++ declaration
  , expansion
  , minitab 2 ")"
  ]
  where declaration = unwords [show nonterminal, symbolType nonterminal]
        expansion   = minitab 3 $ parenthize 1 rulesSygus
        rulesSygus  = unwords $ map tast2Smt rules

syntaxConstraint :: TheorySymbol -> Cfg -> String
syntaxConstraint functionInput cfg = unlines
  [ funDeclComment
  , "("  ++ functionDeclaration
  , varDeclComment
  , varDecls
  , ""
  , minitab 1 "("
  , unlines $ fmap sygusGrammar nonterminals
  , minitab 1 ")"
  , ")" ]
  where
    sygusGrammar :: TheorySymbol -> String
    sygusGrammar nonterminal =
      case (getProductionRules nonterminal cfg') of
        Nothing    -> minitab 2 $ ";; No grammar for " ++ show nonterminal ++ "\n"
        Just rules -> productionRules2Sygus nonterminal rules

    functionDeclaration = unwords 
      [ "synth-fun"
      , functionName
      , "(("
      , inputName
      , varType
      , "))"
      , varType
      ]
    nonterminals = Set.toList $ nonterminalsUsed functionInput cfg
    varDecls     = parenthize 1 $ unwords $ map declareVar nonterminals
    varType      = symbolType functionInput
    inputName    = "input"
    inputTast    = makeSignal (symbolTheory functionInput) inputName
    cfg'         = extendCfg (functionInput, inputTast) cfg

    funDeclComment = "\r\n;; Name and signature of the function to be synthesized"
    varDeclComment = "\r\n;; Declare the nonterminals used in the grammar"


fixedSizeQuery :: Dto -> Cfg -> Maybe String
fixedSizeQuery dto@(Dto theory pre post) cfg =
  if null sygusTargets
    then Nothing
    else Just $ unlines 
      [ declTheory
      , sortDecl
      , grammar
      , constraint
      , checkSynth
      ]
  where
    sygusTargets = getSygusTargets dto cfg
    synthTarget  = pickTarget sygusTargets
    grammar      = syntaxConstraint synthTarget cfg
    constraint   = dto2Sygus synthTarget dto
    declTheory   = "(set-logic " ++ show theory ++ ")"
    checkSynth   = "(check-synth)"
    sortDecl     = smtSortDecl theory

recursiveQuery :: Dto -> Cfg -> String
recursiveQuery = undefined

findRecursion :: [TAst] -> TAst
findRecursion [] = error "Empty list for recursion!"
findRecursion _  = undefined

tast2UpdateChain :: TheorySymbol -> TAst -> String
tast2UpdateChain = undefined
-- (zipWith strConcat nextChains) . tastByDepth
-- where nextChains      = inits $ repeat $ show $ Next 1
--       strConcat s1 s2 = s1 ++ " " ++ s2

sygus2TslAss :: Temporal -> Dto -> TAst -> String
sygus2TslAss = undefined
-- sygus2TslAss temporal (Dto _ pre post) tast = unwords
--   [ "G("
--   , "("
--   , "(" ++ pred2Tsl pre ++ ")"
--   , "&&"
--   , "(" ++ updateTerm ++ ")"
--   , ")"
--   , "->"
--   , show temporal
--   , "(" ++ pred2Tsl post ++ ")"
--   , ";"
--   ]
--   where
--     updateChain = tast2UpdateChain tast
--     updateTerm  = if (temporal == Eventually)
--                      then updateChain ++ " W " ++ pred2Tsl post
--                      else updateChain

-- | A SyGuS Query is based off of:
-- 1) Data Transformation Obligation (the "semantic  constraint") and
-- 2) Context-Free Grammar           (the "syntactic constraint")
sygusAssumptions
  :: (Int -> String -> ExceptT Error IO (Maybe TAst))
  -> [(TheoryPredicate, Temporal)]
  -> Cfg
  -> ExceptT Error IO [String]
sygusAssumptions sygusSolver preds cfg = undefined

-- (set-logic LIA)
-- (declare-const vruntime1 Int)
-- (synth-fun function ((vruntime1 Int)) Int
-- 	((I Int))(
-- 		(I Int (
-- 				(+ vruntime1 1)
-- 				(+ I 1)
-- 			)
-- 		)
-- 	)
-- )
-- (assert (= vruntime1 (- 1)))
-- (constraint (forall ((vruntime1 Int))
-- 	(=> (<= vruntime1 4)
-- 	(> (function vruntime1) vruntime1)
-- )))
-- (check-synth)
