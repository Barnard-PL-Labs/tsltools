{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE RecordWildCards #-}

-- |
-- Module      :  TSL.ModuloTheories.Predicates Description :  Predicate term operations for TSL-MT
-- Maintainer  :  Wonhyuk Choi
module TSL.ModuloTheories.Predicates
  ( TheoryPredicate (..),
    predsFromSpec,
    enumeratePreds,
    predTheory,
    pred2Tsl,
    pred2Smt,
    predInfo,
    predSignals,
    predReplacedSmt,
  )
where

import Control.Exception (assert)
import Control.Monad (filterM)
import TSL.Base.Ast (AstInfo, fromPredicateTerm, (+++))
import TSL.Base.Logic (Formula (..), PredicateTerm, foldFormula)
import TSL.Base.Specification (Specification (..))
import TSL.Base.SymbolTable (SymbolTable (..))
import TSL.Base.Types (arity)
import TSL.Error (Error)
import TSL.ModuloTheories.Theories
  ( TAst,
    Theory,
    TheorySymbol,
    applySemantics,
    replaceSmtShow,
    tast2Smt,
    tast2Tsl,
    tastInfo,
    tastSignals,
    tastTheory,
  )

data TheoryPredicate
  = PLiteral TAst
  | NotPLit TheoryPredicate
  | OrPLit TheoryPredicate TheoryPredicate
  | AndPLit TheoryPredicate TheoryPredicate

instance Show TheoryPredicate where show = pred2Smt

andPreds :: [TheoryPredicate] -> TheoryPredicate
andPreds [] = error "`mempty` undefined"
andPreds [x] = x
andPreds (x : xs) = AndPLit x $ andPreds xs

pred2Smt :: TheoryPredicate -> String
pred2Smt = \case
  PLiteral tast -> tast2Smt tast
  NotPLit p -> "(not " ++ pred2Smt p ++ ")"
  OrPLit p q -> "(or " ++ pred2Smt p ++ " " ++ pred2Smt q ++ ")"
  AndPLit p q -> "(and " ++ pred2Smt p ++ " " ++ pred2Smt q ++ ")"

predReplacedSmt :: TheorySymbol -> String -> TheoryPredicate -> String
predReplacedSmt symbol replacer = \case
  PLiteral tast -> replaceSmtShow symbol tast replacer
  NotPLit p -> "(not " ++ predReplacedSmt symbol replacer p ++ ")"
  OrPLit p q ->
    "(or "
      ++ predReplacedSmt symbol replacer p
      ++ " "
      ++ predReplacedSmt symbol replacer q
      ++ ")"
  AndPLit p q ->
    "(and "
      ++ predReplacedSmt symbol replacer p
      ++ " "
      ++ predReplacedSmt symbol replacer q
      ++ ")"

pred2Tsl :: TheoryPredicate -> String
pred2Tsl = \case
  PLiteral tast -> tast2Tsl tast
  NotPLit p -> "!" ++ pred2Tsl p
  OrPLit p q -> "(" ++ pred2Tsl p ++ " || " ++ pred2Tsl q ++ ")"
  AndPLit p q -> "(" ++ pred2Tsl p ++ " && " ++ pred2Tsl q ++ ")"

predTheory :: TheoryPredicate -> Theory
predTheory = \case
  PLiteral tast -> tastTheory tast
  NotPLit p -> predTheory p
  OrPLit p q -> assert (predTheory p == predTheory q) (predTheory p)
  AndPLit p q -> assert (predTheory p == predTheory q) (predTheory p)

predInfo :: TheoryPredicate -> AstInfo TheorySymbol
predInfo = \case
  PLiteral tast -> tastInfo tast
  NotPLit p -> predInfo p
  OrPLit p q -> predInfo p +++ predInfo q
  AndPLit p q -> predInfo p +++ predInfo q

predSignals :: TheoryPredicate -> [TheorySymbol]
predSignals = \case
  PLiteral tast -> tastSignals tast
  NotPLit p -> predSignals p
  OrPLit p q -> predSignals p ++ predSignals q
  AndPLit p q -> predSignals p ++ predSignals q

powerset :: [a] -> [[a]]
powerset = filterM (const [True, False])

-- FIXME: make this tractable
enumeratePreds :: [TheoryPredicate] -> [TheoryPredicate]
enumeratePreds preds = map andPreds $ filter (not . null) $ powerset preds'
  where
    preds' = preds ++ map NotPLit preds

predsFromSpec :: Theory -> Specification -> Either Error [TheoryPredicate]
predsFromSpec theory (Specification assumptions guarantees symtable) = mapM toTheoryPred asts
  where
    pTerms = concatMap fromFormula (assumptions ++ guarantees)
    unhash = stName symtable
    toAst = fromPredicateTerm (arity . stType symtable)
    asts = map (fmap unhash . toAst) pTerms
    toTheoryPred = fmap PLiteral . applySemantics theory

fromFormula :: Formula a -> [PredicateTerm a]
fromFormula = foldFormula baseCaseExtender []
  where
    baseCaseExtender (Check p) ps = p : ps
    baseCaseExtender _ ps = ps
