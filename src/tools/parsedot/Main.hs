----------------------------------------------------------------------------
-- |
-- Module      :  Main
-- Maintainer  :  Morgan Zee, Wonhyuk Choi
-- 
-- Description : Parse a dot file with labels and transitions from TSL and re-render the lables in a human readable form
-----------------------------------------------------------------------------
{-# LANGUAGE PartialTypeSignatures #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RankNTypes #-}

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
import Data.Tuple

import System.Environment

import Data.Text (Text)
import qualified Data.Text as T
import Data.Monoid
import qualified Data.Text.IO as T

import Data.String

import qualified Data.Map as M
import Debug.Trace

andToken = "&#8743;"
notToken = "&#172;"
endToken = "&#10;"
topToken = "&#8868;"

type Transition = ([Text], [Text])
type Edge = [Transition] 

main :: IO ()
main = do
       args <- getArgs
       let filename = head args
       contents <- T.readFile filename

       let newContent = T.unlines $ map translateLabeltooltip $ T.lines contents

       T.writeFile ("parsed_" ++ filename) newContent

-- | translate a single edge's label into TSL
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

squashTransitions :: [(Text, Text)] -> [(Text, Text)]
squashTransitions ts = let
  updatePreds = map swap ts
 in
  map swap $ M.toList $ M.fromListWithKey (\k p1 p2 -> p1 <> " || \\l" <> p2) updatePreds

combinepsus :: Edge -> Text
combinepsus labels = let
  c = map (\(ps,us) -> ((T.intercalate " && " ps), (T.intercalate "\\l" us))) labels 
  c1 = squashTransitions c :: [(Text, Text)]
 in
  T.intercalate "\\l --- \n" $ map 
      (\(ps,us) -> ps <> "\\l=>\n" <> us) 
      c1

getTerms :: Text -> Edge 
getTerms t = let
  transitionLabels = init $ T.splitOn endToken t
  predsUpdates = map ((\[x1,x2] -> (x1,T.takeWhile (/= '+') x2)). T.splitOn "/") $ transitionLabels --TODO figure out why we have "+" in the dot file output. for now, if we see +, just drop the rest of the line. maybe + means or? in which case it is fine to drop the stuff that comes after
  splitAnds = (\f (x,y) -> (f x, f y)) (T.splitOn andToken)
 in
  map splitAnds predsUpdates


removeNegation :: Text -> Text
removeNegation t = case T.stripPrefix notToken t of
  Just t' -> t'
  Nothing -> t

generateTSLString :: forall a b. _ -> (String -> Either a b) -> Text -> Text
generateTSLString tslType decoder x = let
  negationPrefix :: Text -> Text
  negationPrefix z = if T.isPrefixOf notToken z then "!" else ""
  preprocess decode =  
    (decode. T.unpack) .  removeNegation 
 in
  either (\t -> if x == topToken then "T" else "ERR") (\t -> (negationPrefix x) <> (T.pack $ tslFormula id $ tslType t)) $
    preprocess decoder x

decodeWrapper :: Transition -> Transition
decodeWrapper (ps, us) = 
  (map (generateTSLString Check decodeInputAP) ps, 
   map (generateTSLString (uncurry Update) decodeOutputAP) (filter (not. T.isPrefixOf notToken) us))

