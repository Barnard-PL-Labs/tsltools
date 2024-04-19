-- | Implement HOA controller in Python
module TSL.HOA.Python
  ( implement,
  )
where

import Data.List (intercalate)
import qualified Data.Set as Set
import qualified Hanoi as H
import TSL.HOA.Codegen (codegen, splitInputsCellsOutputs)
import TSL.HOA.Imp
  ( ImpConfig (..),
    cellOutputNextPrefix,
    functionName,
    withConfig',
  )

implement :: Bool -> H.HOA -> String
implement isCounterStrat hoa =
  let prog = codegen hoa
      controller = withConfig' config isCounterStrat prog
      (is', cs', os') = splitInputsCellsOutputs prog
      is = Set.toList is'
      cs = Set.toList cs'
      os = Set.toList os'
   in "def "
        ++ functionName
        ++ "(_inputs_and_cells):\n"
        -- inputs and cells
        ++ ( if not (null (is ++ cs))
               then
                 indent 1
                   ++ commas ("currentState" : is ++ cs)
                   ++ " = itemgetter("
                   ++ commas ("currentState" : map wrapQuotes (is ++ cs))
                   ++ ")(_inputs_and_cells)"
                   ++ "\n\n"
               else ""
           )
        -- controller logic
        ++ controller
        ++ "\n\n"
        -- return next cells and outputs (using JS object)
        ++ indent 1
        ++ "return {"
        ++ commas ("\"currentState\": currentState" : map cellToNext (cs ++ os))
        ++ "}\n"
        ++ "}"
  where
    wrapQuotes s = "\"" ++ s ++ "\""
    commas = intercalate ", "
    cellToNext c = wrapQuotes c ++ ": " ++ cellOutputNextPrefix ++ c

indent :: Int -> String
indent n = replicate (2 * n) ' '

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
      impIndent = indent,
      impBlockStart = ":",
      impBlockEnd = "",
      impInitialIndent = 1
    }
