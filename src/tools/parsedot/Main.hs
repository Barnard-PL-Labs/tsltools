----------------------------------------------------------------------------
-- |
-- Module      :  Main
-- Maintainer  :  Mark Santolucito, Morgan Zee, Wonhyuk Choi
-- 
-- Description : Parse a dot file with labels and transitions from TSL and re-render the lables in a human readable form
-----------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE PartialTypeSignatures #-}
{-# LANGUAGE MultiWayIf #-}

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

data APType = Pred | Upd
  deriving (Show, Eq)
main :: IO ()
main = do
   args <- getArgs
   let filename = head args
   contents <- T.readFile filename

   let translatedContent = T.unlines $ map translateLabels $ T.lines contents
   let apMap = genAPMap contents
   let updateIds = map (\(i, _, _) -> i) $ filter (\(i, ty, tx) -> ty == Upd) apMap
   let cleanedContent = T.unlines $ map (cleanLabels apMap) $ T.lines translatedContent
   T.writeFile ("parsed_" ++ filename) cleanedContent

-- this crap function should be replace by a proper HAO parser
genAPMap :: Text -> [(Int, APType, Text)]
genAPMap t = let
  aps = head $ filter (T.isPrefixOf "AP:") $ T.lines t
  
  typedAPs = map (\l -> if T.isPrefixOf "\"p0" l then (Pred, l) else (Upd, l)) $ drop 2 $ T.words aps
  labelledAPs = zipWith (\(ty, ap) i -> (i, ty, ap)) typedAPs [0..]
 in
  if T.length ((T.words aps) !! 1) >= 2
  then error "too many APs. give me a real parser!"
  else labelledAPs 

-- remove negated updates
-- to remove negations, just change and number that is negated to an f
-- then it becomes !f, and we can rely on simplification of autfilt to remove 
-- TODO to remove only the negated updates, we need to actually parse the formulas
-- right now, this breaks if we have more than 10 APs, since we only look at on char at a time
-- let's try out https://github.com/reactive-systems/hanoi
-- parsing will give us lots of flexiblity
cleanLabels :: [(Int, APType, Text)] -> Text -> Text
cleanLabels apMap t = let
  updateIds = map (\(i, _, _) -> i) $ filter (\(i, ty, tx) -> ty == Upd) apMap
  replaceNegated s c = s ++ if
    | isNumber c && last s == 'f' -> "" --if we just made a replacement but still have more digits, delete them (e.g. !14)
    | isNumber c && last s == '!' && (digitToInt c) `elem` updateIds -> "f"
    | otherwise -> [c]
  removedNegationUpdates = T.foldl (replaceNegated :: String -> Char -> String) " " t
 in
  if T.isPrefixOf "[" t
  then T.pack removedNegationUpdates 
  else t
  
  


-- | translate a single edge's label into TSL
translateLabels :: Text -> Text
translateLabels lineOfHAOFile =
  if T.isInfixOf "AP: " lineOfHAOFile
  then applyTranslations lineOfHAOFile
  else lineOfHAOFile

applyTranslations :: Text -> Text
applyTranslations t = let
  tokens = T.words t
  terms = drop 2 tokens
  stripQuotes = T.tail. T.init
  addQuotes x = "\"" <> x <> "\""
  translated = map (addQuotes. translateToTSL. stripQuotes) terms
 in
  T.unwords $ (take 2 tokens) ++ translated

translateToTSL :: Text -> Text
translateToTSL t = 
  if T.isPrefixOf "p0" t
  then generateTSLString Check decodeInputAP t
  else generateTSLString (uncurry Update) decodeOutputAP t

generateTSLString :: forall a b. _ -> (String -> Either a b) -> Text -> Text
generateTSLString tslType decoder x =
  either (const "ERR") (\t -> (T.pack $ tslFormula id $ tslType t)) $
    (decoder. T.unpack) x
