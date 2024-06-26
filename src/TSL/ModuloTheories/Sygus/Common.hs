{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE RecordWildCards #-}

-- |
-- Module      :  TSL.ModuloTheories.Sygus.Common
-- Description :  Common data structures for SyGuS
-- Maintainer  :  Wonhyuk Choi
module TSL.ModuloTheories.Sygus.Common
  ( Temporal (..),
    Dto (..),
    Expansion (..),
    Term (..),
    Model (..),
    targetPostfix,
    parenthize,
  )
where

import TSL.ModuloTheories.Predicates (TheoryPredicate)
import TSL.ModuloTheories.Theories (Theory)

targetPostfix :: String
targetPostfix = "_target"

data Temporal
  = Next Int
  | Eventually
  deriving (Eq)

instance Show Temporal where
  show = \case
    Next numNext -> replicate numNext 'X'
    Eventually -> "F"

-- | Data Transformation Obligation.
data Dto = Dto
  { theory :: Theory,
    preCondition :: TheoryPredicate,
    postCondition :: TheoryPredicate
  }

instance Show Dto where
  show Dto {..} =
    unlines
      [ "DTO:",
        '\t' : show preCondition,
        '\t' : show postCondition,
        ""
      ]

data Expansion a = Expansion {nonterminal :: a, rule :: Term a} deriving (Show)

instance Functor Expansion where
  fmap f Expansion {..} = Expansion (f nonterminal) $ fmap f rule

data Term a
  = Value a
  | Expression (Expansion a)
  | Function a [Term a]
  deriving (Show)

instance Functor Term where
  fmap f = \case
    Value v -> Value $ f v
    Expression e -> Expression (fmap f e)
    Function func args -> Function (f func) $ map (fmap f) args

newtype Model a = Model (a, a)

instance (Show a) => Show (Model a) where
  show (Model (symbol, model)) =
    parenthize $
      filter (/= '\"') $
        unwords
          [ "=",
            show symbol,
            show model
          ]
    where
      parenthize = ('(' :) . (++ ")")

instance Functor Model where
  fmap f (Model (x, y)) = Model (f x, f y)

instance Applicative Model where
  pure a = Model (a, a)
  (Model (f, g)) <*> (Model (x, y)) = Model (f x, g y)

parenthize :: Int -> String -> String
parenthize repeats str = lpars ++ str ++ rpars
  where
    lpars = replicate repeats '('
    rpars = replicate repeats ')'
