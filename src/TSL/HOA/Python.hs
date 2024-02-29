-- | Implement HOA controller in Python
module TSL.HOA.Python
  ( implement,
  )
where

import Data.List (intercalate)
import qualified Hanoi as H
import TSL.HOA.Imp
  ( ImpConfig (..),
    withConfig,
  )

implement :: Bool -> H.HOA -> String
implement = withConfig config

config :: ImpConfig
config =
  ImpConfig
    { -- binary functions
      impAdd = "+",
      impSub = "-",
      impMult = "*",
      impDiv = "/",
      -- binary comparators
      impEq = "==",
      impNeq = "!=",
      impLt = "<",
      impGt = ">",
      impLte = "<=",
      impGte = ">=",
      -- logic
      impAnd = "and",
      impTrue = "True",
      impFalse = "False",
      impNot = "not ",
      -- language constructs
      impIf = "if",
      impElif = "elif",
      impCondition = id,
      impFuncApp = \f args -> f ++ "(" ++ intercalate ", " args ++ ")",
      impAssign = \x y -> x ++ " = " ++ y,
      impIndent = \n -> replicate (2 * n) ' ',
      impBlockStart = ":",
      impBlockEnd = ""
    }