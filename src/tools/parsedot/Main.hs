----------------------------------------------------------------------------
-- |
-- Module      :  Main
-- Maintainer  :  Morgan Zee, Wonhyuk Choi
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
import Data.Monoid
import qualified Data.Text.IO as T

andToken = "&#8743;"
notToken = "&#172;"
endToken = "&#10;"

main :: IO ()
main = do
       args <- getArgs
       let filename = head args
       contents <- T.readFile filename

       let newContent = T.unlines $ map translateLabeltooltip $ T.lines contents

       T.writeFile ("parsed_" ++ filename) newContent

translateLabeltooltip :: Text -> Text
translateLabeltooltip lineOfDotFile =
  let
    transitionInfo = fst $ T.breakOn "[label=" lineOfDotFile
    dropStart = T.drop (T.length "labeltooltip=\"") 
    dropEnding = T.dropEnd 3 --drop last three chars ( "]; ) of tooltip line
    tooltip = dropStart $ dropEnding $ snd $ T.breakOn "labeltooltip=\"" lineOfDotFile
    terms = getTerms $ T.strip $ tooltip
    translatedTerms = map decodeWrapper terms
  in 
    if T.isInfixOf "labeltooltip" lineOfDotFile
    then transitionInfo <> "[label=\"" <> (combinepsus translatedTerms) <> "\\l\"];"
    else lineOfDotFile

combinepsus :: [([Text], [Text])] -> Text
combinepsus = T.intercalate "\\l\\l" . map (\(ps,us) -> (T.intercalate " /\\ " ps) <> "\\l===\n" <> (T.intercalate "\\l" us)) 

getTerms :: Text -> [([Text], [Text])]
getTerms t = let
  lines = init $ T.splitOn endToken t
  predsUpdates = map ((\[x1,x2] -> (x1,x2)). T.splitOn "/") lines 
  splitAnds = (\f (x,y) -> (f x, f y)) (T.splitOn andToken)
 in
  map splitAnds predsUpdates


decodeWrapper :: ([Text], [Text]) -> ([Text],[Text])
decodeWrapper (ps, us) = let
  unpackClean = 
    T.unpack. 
    T.replace "+" "" --TODO figure out why we have "+" in the dot file output
  preprocess decode = map (decode. unpackClean) . filter (not. T.isPrefixOf notToken) 
  tryInput  = preprocess decodeInputAP ps
  tryOutput = preprocess decodeOutputAP us
  generatePredString   = either (const "ERR") (T.pack. tslFormula id. Check)
  generateUpdateString = either (const "ERR") (T.pack. tslFormula id. (uncurry Update))
 in
  (map generatePredString tryInput, map generateUpdateString tryOutput)

