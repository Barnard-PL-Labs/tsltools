-- | Implement HOA controller in Javascript
module TSL.HOA.JavaScript
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
   in "function "
        ++ functionName
        ++ "({"
        -- inputs and cells (using JS object destructuring)
        ++ commas ("currentState" : is ++ cs)
        ++ "}) {\n"
        -- instantiate next cells (using let)
        ++ ( if not (null cs)
               then
                 indent 1
                   ++ "let "
                   ++ commas (map (cellOutputNextPrefix ++) (cs ++ os))
                   ++ "\n\n"
               else ""
           )
        -- controller logic
        ++ controller
        ++ "\n\n"
        -- return next cells and outputs (using JS object)
        ++ indent 1
        ++ "return {"
        ++ commas ("currentState" : map cellToNext (cs ++ os))
        ++ "}\n"
        ++ "}"
  where
    commas = intercalate ", "
    cellToNext c = c ++ ": " ++ cellOutputNextPrefix ++ c

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
      impEq = "===",
      impNeq = "!==",
      impLt = "<",
      impGt = ">",
      impLte = "<=",
      impGte = ">=",
      -- logic
      impAnd = "&&",
      impTrue = "true",
      impFalse = "false",
      impNot = "!",
      -- language constructs
      impIf = "if",
      impElif = "else if",
      impCondition = \c -> "(" ++ c ++ ")",
      impFuncApp = \f args -> f ++ "(" ++ intercalate ", " args ++ ")",
      impAssign = \x y -> x ++ " = " ++ y,
      impIndent = indent,
      impBlockStart = " {",
      impBlockEnd = "}",
      impInitialIndent = 1
    }
