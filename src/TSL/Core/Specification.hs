-----------------------------------------------------------------------------
------------------------------------------------------------------------------
{-# LANGUAGE RecordWildCards #-}

-----------------------------------------------------------------------------

-- |
-- Module      :  TSL.Specification
-- Maintainer  :  Felix Klein
--
-- Internal data structure of a specification.
module TSL.Core.Specification
  ( Specification (..),
    toFormula,
    toTSL,
  )
where

-----------------------------------------------------------------------------

import TSL.Core.Logic (Formula (..), tslFormula)
import TSL.Core.SymbolTable (SymbolTable, stName)

-----------------------------------------------------------------------------

data Specification = Specification
  { -- | List of TSL formulas that are assumed
    assumptions :: [Formula Int],
    -- | List of TSL formulas that should be guaranteed
    guarantees :: [Formula Int],
    -- | symbol table containing information about identifiers
    symboltable :: SymbolTable
  }

-----------------------------------------------------------------------------
instance Show Specification where
  show (Specification a g s) = "Assumptions\n:" ++ stringify a ++ "\nGuarantees:\n" ++ stringify g
    where
      getName = fmap (stName s)
      stringify = unlines . (map (show . getName))

-----------------------------------------------------------------------------

-- | Create one formula out of assumptions and guarantees.
--   TODO, look into this.
--   it seems to not work, so new code in TLSF.hs was need
--   which directly generates a seperate ASSUME block
toFormula ::
  [Formula Int] -> [Formula Int] -> Formula Int
toFormula assumptions guarantees =
  case (assumptions, guarantees) of
    (_, []) -> TTrue
    ([], [g]) -> g
    ([], gs) -> And gs
    ([a], [g]) -> Implies a g
    ([a], gs) -> Implies a $ And gs
    (as, [g]) -> Implies (And as) g
    (as, gs) -> Implies (And as) $ And gs

-----------------------------------------------------------------------------

-- | Prints a TSL specification in the TSL format
toTSL ::
  Specification -> String
toTSL Specification {..} =
  "assume {"
    ++ prFormulas assumptions
    ++ "\n}\n\n"
    ++ "guarantee {"
    ++ prFormulas guarantees
    ++ "\n}\n"
  where
    prFormulas =
      concatMap $ ("\n  " ++) . (++ ";") . tslFormula (stName symboltable)

-----------------------------------------------------------------------------
