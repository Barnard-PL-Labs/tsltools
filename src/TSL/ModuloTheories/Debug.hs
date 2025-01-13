-- |
-- Module      :  TSL.ModuloTheories.Sygus.Debug
-- Description :  Data Structures for Debugging
-- Maintainer  :  Wonhyuk Choi
module TSL.ModuloTheories.Debug (IntermediateResults (..)) where

data IntermediateResults = IntermediateResults
  { problem :: String,
    query :: String,
    result :: String
  }

instance Show IntermediateResults where
  show (IntermediateResults problem query result) =
    "IntermediateResults {\n"
      ++ "  problem: "
      ++ problem
      ++ ",\n"
      ++ "  query: "
      ++ query
      ++ ",\n"
      ++ "  result: "
      ++ result
      ++ "\n}"
