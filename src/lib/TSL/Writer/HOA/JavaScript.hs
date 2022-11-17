module TSL.Writer.HOA.JavaScript
  ( implementHoa
  ) where

import           Data.List                      ( intercalate )
import qualified Hanoi                         as H
import           TSL.Writer.HOA.Imp             ( ImpConfig(..)
                                                , withConfig
                                                )

implementHoa :: H.HOA -> String
implementHoa = withConfig config

config :: ImpConfig
config = ImpConfig { impAnd        = "&&"
                   , impTrue       = "true"
                   , impFalse      = "false"
                   , impNot        = \s -> "!(" ++ s ++ ")"
                   , impIf         = "if"
                   , impElif       = "else if"
                   , impFuncApp    = funcApp
                   , impAssign     = \x y -> x ++ " = " ++ y
                   , impIndent     = \n -> replicate (2 * n) ' '
                   , impBlockStart = " {"
                   , impBlockEnd   = "}"
                   , impEqual      = \x y -> x ++ " === " ++ y
                   }

funcApp :: String -> [String] -> String
funcApp f args = f ++ "(" ++ intercalate argSep args ++ ")"
 where
  argSep :: String
  argSep = ", "
