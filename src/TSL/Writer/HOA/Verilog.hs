module TSL.Writer.HOA.Verilog
  ( implementHoa,
  )
where

import Data.List (intercalate)
import qualified Hanoi as H
import TSL.Writer.HOA.Imp
  ( ImpConfig (..),
    withConfig,
  )

implementHoa :: Bool -> H.HOA -> String
implementHoa = withConfig config

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
      impAnd = "&&",
      impTrue = "1",
      impFalse = "0",
      impNot = "!",
      -- language constructs
      impIf = "if",
      impElif = "else if",
      impCondition = \c -> "(" ++ c ++ ")",
      impFuncApp = \f args -> f ++ "(" ++ intercalate ", " args ++ ")",
      impAssign = \x y -> x ++ " <= " ++ y ++ ";",
      impIndent = \n -> replicate (2 * n) ' ',
      impBlockStart = " begin",
      impBlockEnd = "end "
    }
