----------------------------------------------------------------------------
-- |
-- Module      :  Main
-- Maintainer  :  Morgan Zee, Wonhyuk Choi, Mark Santolucito
-- 
-- Description : Parse a dot file with labels and transitions from TSL and re-render the lables in a human readable form
-----------------------------------------------------------------------------
{-# LANGUAGE PartialTypeSignatures #-}
{-# LANGUAGE OverloadedStrings #-}
module Main
  ( main
  ) where

-----------------------------------------------------------------------------
import TSL (decodeOutputAP) 
import TSL (decodeInputAP)
import TSL (tslFormula)
import TSL (Formula(..))
import Data.Either 
import Data.Char 
import Data.List 

import System.Environment

import Data.Text (Text)
import qualified Data.Text as T
import qualified Data.Text.IO as T


--TODO: 
--remove logical operators, decode predicates and updates, put the AND and NOT back to decode 

andToken = "&#8743;"
notToken = "&#172;"
endToken = "&#10;"

main :: IO ()
main = do
       args <- getArgs
       contents <- T.readFile $ head args

       --translateLabeltooltip

       --Splitting at &#10 which indicates the end of a label 
       let terms =  getTerms contents
       let terms' = map decoder terms

       mapM_ print terms'

getTerms :: Text -> [([Text], [Text])]
getTerms t = let
  lines = T.splitOn endToken t
  predsUpdates = map ((\[x1,x2] -> (x1,x2)). T.splitOn "/") lines 
  splitAnds = (\f (x,y) -> (f x, f y)) (T.splitOn andToken)
 in
  map splitAnds predsUpdates


decoder :: ([Text], [Text]) -> _
decoder (ps, us) = let
  unpackClean = 
    T.unpack. 
    T.replace notToken "". --TODO keep track of negations to combine with... something
    T.replace "+" "" --TODO figure out why we have "+" in the dot file output
  tryInput  = map (decodeInputAP. unpackClean) ps
  tryOutput = map (decodeOutputAP. unpackClean) us
  generatePredString   = either (const "ERR") (tslFormula id. Check)
  generateUpdateString = either (const "ERR") (tslFormula id. (uncurry Update))
 in
  (map generatePredString tryInput, map generateUpdateString tryOutput)

{-
safeDecode :: (String,String) -> _ 
safeDecode c = 
  let
    parsedInput = decodeInputAP $ takeWhile (isAlphaNum)(fst c) 
    parsedOutput = decodeOutputAP (snd c)
  in 
    (parsedInput, parsedOutput)

decodeInputWrapper :: String -> (String, String)
decodeInputWrapper splitDash = 
  case splitDash of 
    "&#8743;" -> "AND" 
    "&#172;" -> "NOT"
    other -> 
      case decodeOutputAP other of 
        Left err -> "err" 
        Right result -> result       
-}

--Helpful: 
-- | https://stackoverflow.com/questions/7867723/haskell-file-reading

