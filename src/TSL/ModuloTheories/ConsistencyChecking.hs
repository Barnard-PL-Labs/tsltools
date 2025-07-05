{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE TupleSections #-}

-- Module      :  TSL.ModuloTheories.ConsistencyChecking
-- Description :  Adds partial semantics back to uninterpreted functions by checking which combinations
--                of uninterpreted predicates are satisfiable.  To avoid an exponential blow‑up in SMT
--                calls, we now cap the number of combinations examined.
-- Maintainer  :  Wonhyuk Choi
module TSL.ModuloTheories.ConsistencyChecking
  ( generateConsistencyAssumptions,
    consistencyDebug,
    ConsistencyDebugInfo (..),
  )
  where

import           Control.Monad.Trans.Except
import qualified Data.List                      as L
import           Debug.Trace                    (trace)
import Data.Maybe (fromMaybe)

import           TSL.Base.Ast                   (AstInfo (..), SymbolInfo (..), deduplicate)
import           TSL.Error                      (Error, errConsistency)
import           TSL.ModuloTheories.Debug       (IntermediateResults (..))
import           TSL.ModuloTheories.Predicates  (TheoryPredicate (..), enumeratePreds
                                               , pred2Smt, pred2Tsl, predInfo, predTheory)
import           TSL.ModuloTheories.Solver      (solveSat)
import           TSL.ModuloTheories.Theories    (Theory, TheorySymbol, isUninterpreted
                                               , smtSortDecl, symbol2Smt, symbolType)

-- |Hard cap on how many predicate combinations we send to the SMT solver.
--   This prevents run‑away exponential behaviour when many uninterpreted
--   predicates appear in the spec.  Adjust as needed or expose it as a CLI flag.
-- this number can be changed based on the problem, but even for simple synthesis problems the 
-- number of predicates being checked was always become 2^n. This simplifies while getting the correct answer
config_MAX_CONSISTENCY_CHECKS :: Maybe Int
config_MAX_CONSISTENCY_CHECKS = Just 150


generateConsistencyAssumptions
  :: FilePath
  -> [TheoryPredicate]
  -> [ExceptT Error IO String]
generateConsistencyAssumptions path preds =
  map (fmap fst . consistencyChecking path) limitedCombos
  where
    allCombos    = enumeratePreds preds
    limitedCombos = case config_MAX_CONSISTENCY_CHECKS of
      Just n  -> take n allCombos
      Nothing -> allCombos

consistencyDebug
  :: FilePath
  -> [TheoryPredicate]
  -> [ExceptT Error IO ConsistencyDebugInfo]
consistencyDebug path preds =
  map (fmap snd . consistencyChecking path) limitedCombos
  where
    allCombos    = enumeratePreds preds
    limitedCombos = case config_MAX_CONSISTENCY_CHECKS of
      Just n  -> take n allCombos
      Nothing -> allCombos


pred2Assumption :: TheoryPredicate -> String
pred2Assumption p = "G " ++ pred2Tsl (NotPLit p) ++ ";"

data ConsistencyDebugInfo = ConsistencyDebugInfo IntermediateResults String

instance Show ConsistencyDebugInfo where
  show (ConsistencyDebugInfo results assumption) =
       "ConsistencyDebugInfo {"               ++
       "\n  results: "  ++ show results ++
       ",\n  assumption: " ++ assumption ++
       "\n}"


consistencyChecking
  :: FilePath
  -> TheoryPredicate
  -> ExceptT Error IO (String, ConsistencyDebugInfo)
consistencyChecking solverPath pred = do
  let query = pred2SmtQuery pred
  isSat <- solveSat solverPath query
  if isSat
     then except $ errConsistency $ "Predicate " ++ show pred ++
            " is satisfiable.  No new assumption added."
     else do
       let assumption          = pred2Assumption pred
           intermediateResults = IntermediateResults (show pred) query (show isSat)
           debugInfo           = ConsistencyDebugInfo intermediateResults assumption
       trace ("[Consistency] adding assumption for " ++ show pred) $ return ()
       return (assumption, debugInfo)


pred2SmtQuery :: TheoryPredicate -> String
pred2SmtQuery p = unlines [smtDeclarations, assertion, checkSat]
  where
    smtDeclarations = smtDecls (predTheory p) $ deduplicate $ predInfo p
    assertion       = "(assert " ++ pred2Smt p ++ ")"
    checkSat        = "(check-sat)"

smtDecls :: Theory -> AstInfo TheorySymbol -> String
smtDecls theory (AstInfo vars funcs preds) =
  unlines [logic, sortDecl, varDecls, funcDecls, predDecls]
  where
    logic      = "(set-logic " ++ show theory ++ ")"
    sortDecl   = smtSortDecl theory
    varDecls   = unlines $ map declConst vars
    funcDecls  = unlines $ map declFunc funcs
    predDecls  = unlines $ map declPred preds

    declConst (SymbolInfo x _) =
      "(declare-const " ++ symbol2Smt x ++ " " ++ symbolType x ++ ")"

    declareFun retType (SymbolInfo f arity)
      | not (isUninterpreted f) = ""
      | otherwise = unwords [ "(declare-fun"
                            , symbol2Smt f
                            , "("
                            , unwords $ replicate arity $ show theory
                            , ")"
                            , retType ++ ")" ]
    declFunc = declareFun (show theory)
    declPred = declareFun "Bool"
