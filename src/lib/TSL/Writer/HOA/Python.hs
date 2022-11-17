module TSL.Writer.HOA.Python
  ( implementHoa
  ) where

import           Data.List                      ( intercalate
                                                , isPrefixOf
                                                )
import qualified Hanoi                         as H
import qualified TSL.Writer.HOA.Codegen        as CG


implementHoa :: H.HOA -> String
implementHoa hoa = writeProgram $ CG.codegen hoa


-- | WRITE PROGRAM TO STRING

writeProgram :: CG.Program -> String
writeProgram (CG.Program stateTransList) =
  let lines =
        concat $ zipWith writeStateTrans (False : repeat True) stateTransList
  in  intercalate "\n" lines

writeStateTrans :: Bool -> CG.StateTrans -> [String]
writeStateTrans useElif (CG.StateTrans state transList) =
  let innerLines = concat $ zipWith writeTrans (False : repeat True) transList
      opIf       = if useElif then "elif" else "if"
  in  (opIf ++ " currentState == " ++ state ++ ":") : map (indent 1) innerLines


writeTrans :: Bool -> CG.Trans -> [String]
writeTrans useElif (CG.Trans ps us target) =
  let ps'         = map writePredicate ps
      us'         = map writeUpdate us
      condition   = intercalate (" " ++ opAnd ++ " ") ps'
      assignments = map (indent 1) us'
      opIf        = if useElif then "elif" else "if"
  in  [opIf ++ " " ++ condition ++ ":"]
        ++ assignments
        ++ [indent 1 $ assign "currentState" target]

writePredicate :: CG.Predicate -> String
writePredicate p = case p of
  CG.PTrue      -> "True"
  CG.PFalse     -> "False"
  CG.PNot  p'   -> opNot ++ " (" ++ writePredicate p' ++ ")"
  CG.PTerm term -> writeTerm term

writeUpdate :: CG.Update -> String
writeUpdate (CG.Update var term) = assign var $ writeTerm term

writeTerm :: CG.Term -> String
writeTerm term = case term of
  CG.Var x      -> x
  CG.App f args -> if isTSLMT f && null args
    then replaceTSLMT f
    else funcApp f $ map writeTerm args


-- | HELPERS

indent :: Int -> String -> String
indent n s = replicate (2 * n) ' ' ++ s

opAnd :: String
opAnd = "and"

opNot :: String
opNot = "not"

argSep :: String
argSep = ", "

funcApp :: String -> [String] -> String
funcApp f args = f ++ "(" ++ intercalate argSep args ++ ")"

assign :: String -> String -> String
assign var term = var ++ " = " ++ term

isTSLMT :: String -> Bool
isTSLMT s = isReal s || isInt s

replaceTSLMT :: String -> String
replaceTSLMT s | isReal s  = drop 4 s
               | isInt s   = drop 3 s
               | otherwise = s

isReal :: String -> Bool
isReal s = "real" `isPrefixOf` s

isInt :: String -> Bool
isInt s = "int" `isPrefixOf` s
