{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE RecordWildCards #-}

-- |
-- Module      :  TSL.ModuloTheories.Cfg
-- Description :  Builds a Cfg for cells and outputs from the specification.
-- Maintainer  :  Wonhyuk Choi
--
-- This module builds a Context-Free Grammar for cell and output signals
-- from the original specification.
-- This is necessary to build a Syntax-Guided Synthesis grammar when
-- transforming a TSL-MT specification to TSL.
module TSL.ModuloTheories.Cfg
  ( Cfg (..),
    cfgFromSpec,
    outputSignals,
    productionRules,
    extendCfg,
  )
where

import Control.Applicative (liftA2)
import Data.Map (Map)
import qualified Data.Map as Map
import Data.Set (Set)
import qualified Data.Set as Set
import TSL.Base.Ast (Ast, fromSignalTerm)
import TSL.Base.Logic (updates)
import TSL.Base.Specification (Specification (..))
import TSL.Base.SymbolTable (Id, SymbolTable (..))
import TSL.Base.Types (arity)
import TSL.Error (Error)
import TSL.ModuloTheories.Theories
  ( TAst,
    Theory,
    TheorySymbol,
    applySemantics,
    read2Symbol,
  )

newtype Cfg = Cfg {grammar :: Map TheorySymbol [TAst]}

instance Show Cfg where
  show cfg = unlines $ map showPair $ Map.assocs $ grammar cfg
    where
      showSymbol = (++ " :\n") . show
      showRules = unlines . (map (('\t' :) . show))
      showPair (k, v) = showSymbol k ++ showRules v

cfgFromSpec :: Theory -> Specification -> Either Error Cfg
cfgFromSpec theory spec = Cfg <$> newGrammar
  where
    unhash = stName $ symboltable spec
    idMap = updatesMap spec
    toTAst = (applySemantics theory) . (fmap unhash)
    toTSymbol = read2Symbol theory . unhash
    theorize (k, vs) = liftA2 (,) (toTSymbol k) (traverse toTAst vs)
    newGrammar = fmap Map.fromList $ traverse theorize $ Map.assocs idMap

updatesMap :: Specification -> Map Id [Ast Id]
updatesMap (Specification a g s) = Map.map (map toAst) updMap
  where
    add (sink, rule) = mapConsInsert sink rule
    updatesList = concat $ map (Set.toList . updates) $ a ++ g
    updMap = foldr add Map.empty updatesList
    toAst = fromSignalTerm (arity . (stType s))

mapConsInsert :: (Ord k) => k -> v -> Map k [v] -> Map k [v]
mapConsInsert k v mp = Map.insert k (v : vs) mp
  where
    vs = Map.findWithDefault [] k mp

outputSignals :: Cfg -> Set TheorySymbol
outputSignals cfg = Map.keysSet $ grammar cfg

productionRules :: TheorySymbol -> Cfg -> [TAst]
productionRules ts cfg = Map.findWithDefault [] ts $ grammar cfg

extendCfg :: (TheorySymbol, TAst) -> Cfg -> Cfg
extendCfg (nonterminal, rule) cfg =
  case Map.lookup nonterminal (grammar cfg) of
    Nothing -> Cfg $ Map.insert nonterminal [rule] (grammar cfg)
    Just rules -> Cfg $ Map.insert nonterminal (rule : rules) (grammar cfg)
