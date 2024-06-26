{-# LANGUAGE ImplicitParams #-}

module TSL.HOA.Codegen
  ( codegen,
    splitInputsCellsOutputs,
    Program (..),
    StateTrans (..),
    Trans (..),
    State,
    Predicate (..),
    Update (..),
    Term (..),
  )
where

import Control.Monad
  ( filterM,
    void,
  )
import Control.Monad.Reader (Reader)
import qualified Control.Monad.Reader as Reader
import Data.Char (toUpper)
import Data.List (isPrefixOf)
import qualified Data.Map as Map
import Data.Maybe
  ( catMaybes,
    fromJust,
  )
import qualified Data.Set as Set
import qualified Finite as F
import qualified Hanoi as H
import Text.Parsec
  ( alphaNum,
    char,
    eof,
    lookAhead,
    parse,
    string,
    try,
    (<|>),
  )
import Text.Parsec.String (Parser)

-- | GENERIC PROGRAM DEFINITIONS
newtype Program = Program [StateTrans]
  deriving (Show)

data StateTrans = StateTrans State [Trans] -- State is for the current state
  deriving (Show)

data Trans = Trans [Predicate] [Update] State -- State is for the target state
  deriving (Show)

type State = String

data Predicate
  = PTrue
  | PFalse
  | PNot Predicate
  | PTerm Term
  deriving (Show)

data Update = Update String Term
  deriving (Show)

data Term
  = Var String
  | App String [Term]
  deriving (Show)

-- | SPLIT INPUTS, CELLS, OUTPUTS
splitInputsCellsOutputs :: Program -> (Set.Set String, Set.Set String, Set.Set String)
splitInputsCellsOutputs p =
  let (is, os) = ioFromProgram p
   in splitSets is os
  where
    splitSets :: Set.Set String -> Set.Set String -> (Set.Set String, Set.Set String, Set.Set String)
    splitSets is os = (is', cs, os')
      where
        cs = Set.intersection is os -- Elements common to both is and os
        is' = is `Set.difference` os -- Elements in is not in os
        os' = os `Set.difference` is -- Elements in os not in is
    ioFromProgram :: Program -> (Set.Set String, Set.Set String)
    ioFromProgram (Program stateTransList) = foldr ((\(ps, us) (ps', us') -> (Set.union ps ps', Set.union us us')) . ioFromStateTrans) (Set.empty, Set.empty) stateTransList
    ioFromStateTrans :: StateTrans -> (Set.Set String, Set.Set String)
    ioFromStateTrans (StateTrans _ transList) = foldr ((\(ps, us) (ps', us') -> (Set.union ps ps', Set.union us us')) . ioFromTrans) (Set.empty, Set.empty) transList
    ioFromTrans :: Trans -> (Set.Set String, Set.Set String)
    ioFromTrans (Trans ps us _) = (Set.unions (map varsFromPredicate ps) `Set.union` Set.unions (map varsFromUpdateRHS us), Set.fromList (map varsFromUpdateLHS us))
    varsFromPredicate :: Predicate -> Set.Set String
    varsFromPredicate PTrue = Set.empty
    varsFromPredicate PFalse = Set.empty
    varsFromPredicate (PNot p) = varsFromPredicate p
    varsFromPredicate (PTerm t) = varsFromTerm t
    varsFromTerm :: Term -> Set.Set String
    varsFromTerm (Var x) = Set.singleton x
    varsFromTerm (App _ ts) = Set.unions (map varsFromTerm ts)
    varsFromUpdateLHS :: Update -> String
    varsFromUpdateLHS (Update x _) = x
    varsFromUpdateRHS :: Update -> Set.Set String
    varsFromUpdateRHS (Update _ t) = varsFromTerm t

-- | CODEGEN MONAD
type Gen a = Reader GenCtx a

data GenCtx = GenCtx
  { _hoa :: H.HOA,
    _apMap :: Map.Map Int String
  }

-- | CODEGEN FROM HOA
codegen :: H.HOA -> Program
codegen hoa = Reader.runReader genProgram initGenCtx
  where
    initGenCtx = GenCtx {_hoa = hoa, _apMap = apMap}
    apMap =
      Map.fromList $
        zipWith (\i ap -> (i, H.atomicPropositionName hoa ap)) [0 ..] apList
    apList = let ?bounds = hoa in F.values

genProgram :: Gen Program
genProgram = do
  hoa <- Reader.asks _hoa
  let states = let ?bounds = hoa in F.values
  Program <$> mapM genStateTrans states

genStateTrans :: H.State -> Gen StateTrans
genStateTrans s = do
  state <- toState s

  hoa <- Reader.asks _hoa
  let edges = Set.toList $ H.edges hoa s
  -- we should only ever have one target state in TSL models (I think)
  transLists <-
    mapM
      ( \(targetStates, formula, _) ->
          genTransList (head targetStates) (fromJust formula)
      )
      edges

  return $ StateTrans state (concat transLists)

genTransList :: H.State -> H.Formula H.AP -> Gen [Trans]
genTransList s formula = do
  targetState <- toState s
  let dnf = decomposeDNF formula
  mapM (genTrans targetState) dnf

genTrans :: State -> [H.Formula H.AP] -> Gen Trans
genTrans targetState formulas = do
  predicateFormulas <- filterM (fmap not . isUpdateFormula) formulas
  updateFormulas <- filterM isUpdateFormula formulas
  predicates <- mapM genPredicate predicateFormulas
  updates <- catMaybes <$> mapM genUpdate updateFormulas

  -- if no predicates, it means always true
  let predicates' = if null predicates then [PTrue] else predicates

  return $ Trans predicates' updates targetState

genPredicate :: H.Formula H.AP -> Gen Predicate
genPredicate f = case f of
  H.FTrue -> return PTrue
  H.FFalse -> return PFalse
  H.FNot f' -> PNot <$> genPredicate f'
  H.FVar ap -> PTerm . parsePredicateTerm <$> apToString ap
  x -> error $ "unexpected formula structure on transition: " ++ show x

genUpdate :: H.Formula H.AP -> Gen (Maybe Update)
genUpdate f = case f of
  H.FNot _ -> return Nothing
  H.FVar ap -> Just . parseUpdate <$> apToString ap
  x -> error $ "unexpected formula structure on transition: " ++ show x

-- | PARSE TERMS FROM STRING ENCODING
parsePredicateTerm :: String -> Term
parsePredicateTerm str =
  case parse (string "p0" >> predicateParser) "Format Error" str of
    Left _ -> error "error when parsing predicate AP in code generation"
    Right x -> x

parseUpdate :: String -> Update
parseUpdate str = case parse outputParser "Format Error" str of
  Left _ -> error "error when decoding AP in code generation"
  Right (var, update) -> Update var update
  where
    outputParser = do
      void $ string "u0"
      u <- identParser
      void $ char '0'
      s <- parseSignal
      return (u, s)
    parseSignal =
      try (string "p1d" >> predicateParser)
        <|> try (string "f1d" >> functionParser)
        <|> (Var <$> identParser)

functionParser :: Parser Term
functionParser = do
  f <- identParser
  argsRev <- next []
  return $ App f (reverse argsRev)
  where
    next argsRev =
      (char '0' >> parseArgs >>= \arg -> next (arg : argsRev))
        <|> (string "1b" >> return argsRev)
        <|> (eof >> return argsRev)
    parseArgs =
      try (string "p1d" >> predicateParser)
        <|> try (string "f1d" >> functionParser)
        <|> (Var <$> identParser)

predicateParser :: Parser Term
predicateParser = do
  try varParser
    <|> appParser
  where
    next argsRev =
      (char '0' >> parseArgs >>= \arg -> next (arg : argsRev))
        <|> (string "1b" >> return argsRev)
        <|> (eof >> return argsRev)

    parseArgs =
      try (string "p1d" >> predicateParser)
        <|> try (string "f1d" >> functionParser)
        <|> (Var <$> identParser)

    varParser = do
      ident <-
        char 'b'
          >> ( (char '0' >> identParser)
             )
      return $ Var ident
    appParser = do
      _ <- string "p0"
      p <- identParser
      argsRev <- next []
      return $ App p (reverse argsRev)

-- | Identifier parser that reverses character escaping
identParser :: Parser String
identParser = ident ""
  where
    ident :: String -> Parser String
    ident a = (eof >> return (reverse a)) <|> ident1 a

    ident1 :: String -> Parser String
    ident1 a =
      lookAhead alphaNum >>= \case
        '0' -> return $ reverse a
        '1' -> return $ reverse a
        '2' ->
          alphaNum >> alphaNum >>= \case
            '3' -> ident ('0' : a)
            '4' -> ident ('1' : a)
            '5' -> ident ('2' : a)
            '6' -> ident ('_' : a)
            '7' -> ident ('@' : a)
            '8' -> ident ('\'' : a)
            '9' -> ident ('.' : a)
            c -> ident (toUpper c : a)
        c -> alphaNum >> ident (c : a)

-- | HELPERS
toState :: H.State -> Gen State
toState s = do
  hoa <- Reader.asks _hoa
  return $ let ?bounds = hoa in show (F.index s - F.offset (F.v2t s))

-- | in TSL, the formulas on the edges will always be conjunctions separated by disjunctions
decomposeDNF :: H.Formula H.AP -> [[H.Formula H.AP]]
decomposeDNF f = map conjunctionsToList $ disjunctionsToList f
  where
    conjunctionsToList f = case f of
      H.FAnd fs -> concatMap conjunctionsToList fs
      _ -> [f]
    disjunctionsToList f = case f of
      H.FOr fs -> concatMap disjunctionsToList fs
      _ -> [f]

isUpdateFormula :: H.Formula H.AP -> Gen Bool
isUpdateFormula f = case f of
  H.FVar ap -> isPrefixOf "u0" <$> apToString ap
  H.FNot f' -> isUpdateFormula f'
  _ -> return False

apToString :: H.AP -> Gen String
apToString ap = do
  hoa <- Reader.asks _hoa
  apMap <- Reader.asks _apMap
  return $ let ?bounds = hoa in apMap Map.! (F.index ap - F.offset (F.v2t ap))
