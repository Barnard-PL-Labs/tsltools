-- | Implement HOA controller in C
module TSL.HOA.C
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
      allCellsOutputs = cs ++ os
      allVars = is ++ allCellsOutputs
   in -- includes
      "#include <stdbool.h>\n\n"
        -- global variable declarations
        ++ concatMap (\v -> "int " ++ v ++ ";\n") allVars
        ++ "\n"
        -- read_inputs stub (game harness provides the real one)
        ++ "void read_inputs(void) { }\n\n"
        -- main function
        ++ "void main() {\n"
        ++ "  int currentState = 0;\n"
        -- _next_ variable declarations for cells and outputs
        ++ concatMap (\v -> "  int " ++ cellOutputNextPrefix ++ v ++ ";\n") allCellsOutputs
        ++ "\n"
        ++ "  while (1) {\n"
        ++ "    read_inputs();\n\n"
        -- default identity: _next_var = var for each cell
        ++ concatMap (\v -> "    " ++ cellOutputNextPrefix ++ v ++ " = " ++ v ++ ";\n") allCellsOutputs
        ++ "\n"
        -- controller state machine logic
        ++ controller
        ++ "\n\n"
        -- copy _next_ values back to real variables
        ++ concatMap (\v -> "    " ++ v ++ " = " ++ cellOutputNextPrefix ++ v ++ ";\n") allCellsOutputs
        ++ "  }\n"
        ++ "}\n"

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
      impTrue = "true",
      impFalse = "false",
      impNot = "!",
      -- language constructs
      impIf = "if",
      impElif = "else if",
      impCondition = \c -> "(" ++ c ++ ")",
      impFuncApp = \f args -> f ++ "(" ++ intercalate ", " args ++ ")",
      impAssign = \x y -> x ++ " = " ++ y ++ ";",
      impIndent = \n -> replicate (2 * n) ' ',
      impBlockStart = " {",
      impBlockEnd = "}",
      -- indent level 2 = 4 spaces, matching nesting inside main() { while(1) { ... } }
      impInitialIndent = 2
    }
