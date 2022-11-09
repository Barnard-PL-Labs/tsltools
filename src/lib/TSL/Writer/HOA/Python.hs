{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE ImplicitParams #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE PartialTypeSignatures #-}
{-# LANGUAGE RankNTypes #-}
----------------------------------------------------------------------------
-----------------------------------------------------------------------------
{-# LANGUAGE RecordWildCards #-}

-- |
-- Module      :  Main
-- Maintainer  :  Mark Santolucito
--
-- Generates python code from a HOA file generated from a TSL spec
module TSL.Writer.HOA.Python
  ( implementHoa
  ) where

import qualified Data.Bifunctor
import           Data.List                     as List
                                                ( intercalate
                                                , isPrefixOf
                                                , sortOn
                                                )
import qualified Data.Map                      as M
import           Data.Maybe                     ( fromJust )
import           Data.Set                      as Set
                                                ( Set
                                                , toList
                                                )
import qualified Data.Text                     as T
import           Data.Tuple                     ( swap )
import           Debug.Trace
import           Finite
import           Hanoi                          ( AcceptanceSet
                                                , HOA(..)
                                                , Label
                                                , State
                                                )
import           TSL.Writer.HOA.Utils

import           Control.Monad                  ( void )
import           Data.Char                      ( isUpper
                                                , toLower
                                                , toUpper
                                                )
import qualified TSL.Ast                       as Ast
import           Text.Parsec                    ( (<|>)
                                                , alphaNum
                                                , char
                                                , eof
                                                , lookAhead
                                                , parse
                                                , string
                                                , try
                                                )
import           Text.Parsec.String             ( Parser )

implementHoa :: HOA -> String
implementHoa = concat . printHOALines

printHOALines :: HOA -> [String]
printHOALines hoa@HOA {..} =
  let ?bounds = hoa
  in
    let -- TODO pretty sure this doesnt need to be sorted
      apNamesSorted =
        map (Data.Bifunctor.first atomicPropositionName)
          $ sortOn (atomicPropositionName . fst)
          $ zip values [0 ..]
      apNamesMap = M.fromList $ map swap apNamesSorted

      printState :: FiniteBounds HOA => State -> [String]
      printState s =
        unwords (["if (currentState == "] ++ [strInd s] ++ ["):"])
          : map printEdge (toList $ edges s)

      printEdge
        :: FiniteBounds HOA
        => ([State], Maybe Label, Maybe (Set AcceptanceSet))
        -> String
      printEdge edge =
        let (target, label, _) = edge
            -- we should only ever had one target state in TSL models (I think), so `head` works
            stateUpdate        = "currentState = " ++ strInd (head target)
        in  printLabel (fromJust label) stateUpdate

      printLabel :: FiniteBounds HOA => Label -> String -> String
      printLabel label stateUpdate =
        trace ("printLabel: " ++ show label ++ ", " ++ show stateUpdate)
          $ let
              splitFormulas = formulaToList label
              termStringList =
                map
                  (map
                    (printTSLFormula negationOperator (strIndWithMap apNamesMap)
                    )
                  )
                  (trace ("splitFormulas: " ++ show splitFormulas) splitFormulas
                  ) :: [[String]]
              predUpds = splitPredUpdates
                negationOperator
                (trace ("predUpds: " ++ show termStringList) termStringList)
              predUpdToCode (preds, upds) =
                let conditional = if null preds
                      then "True"
                      else intercalate
                        (" " ++ conjunctionOperator ++ indent 3)
                        preds
                    body = indent 4 ++ intercalate
                      (indent 4)
                      (map updateToAssignment upds ++ [stateUpdate])
                in  "if (" ++ conditional ++ "):" ++ body
            in
              concatMap (\x -> indent 2 ++ predUpdToCode x) predUpds
    in
      intercalate ["\nel"] $ map printState values

-----------------------------------------------------------------------------

-- | Language specific functions
updateToAssignment :: String -> String
updateToAssignment x =
  let constsSaved = T.unpack $ T.replace "()" "cccccc" $ T.pack x
      noBrackets =
        filter (\c -> not $ c `elem` ['[', ']', '(', ')']) constsSaved
      [val, assignment] = T.splitOn " <- " $ T.pack noBrackets
      fxnParts = map (replaceTSLMT . T.strip) $ T.splitOn " " assignment
      params = if tail fxnParts == []
        then ""
        else T.concat ["(", (T.intercalate ", " $ tail fxnParts), ");"]
  in  T.unpack $ T.replace "cccccc" "()" $ T.concat
        [val, " = ", head fxnParts, params]

negationOperator :: String
negationOperator = "not"

conjunctionOperator :: String
conjunctionOperator = "and"

----------------------------------------------------------------------------- 

data Gen
  = GenPredicate (Ast.Ast String)
  | GenUpdate String (Ast.Ast String)

-- | Decode AP to AST

decode :: String -> Gen
decode t = if "p0" `isPrefixOf` t then decodeInputAP t else decodeOutputAP t

decodeInputAP :: String -> Gen
decodeInputAP str =
  case parse (string "p0" >> predicateParser) "Format Error" str of
    Left  _ -> error "error when decoding AP in code generation"
    Right x -> GenPredicate x

decodeOutputAP :: String -> Gen
decodeOutputAP str = case parse outputParser "Format Error" str of
  Left  _             -> error "error when decoding AP in code generation"
  Right (var, update) -> GenUpdate var update

 where
  outputParser = do
    void $ string "u0"
    u <- identParser
    void $ char '0'
    s <- parseSignal
    return (u, s)
  parseSignal =
    (try (string "p1d") >> predicateParser)
      <|> (try (string "f1d") >> functionParser)
      <|> (Ast.Variable <$> identParser)

functionParser :: Parser (Ast.Ast String)
functionParser = do
  f       <- identParser
  argsRev <- next []
  return $ Ast.Function f (reverse argsRev)
 where
  next argsRev =
    (char '0' >> parseArgs >>= \arg -> next (arg : argsRev))
      <|> (string "1b" >> return argsRev)
      <|> (eof >> return argsRev)
  parseArgs =
    (try (string "p1d") >> predicateParser)
      <|> (try (string "f1d") >> functionParser)
      <|> (Ast.Variable <$> identParser)


predicateParser :: Parser (Ast.Ast String)
predicateParser = do
  p       <- identParser'
  argsRev <- next []
  return $ Ast.Predicate p (reverse argsRev)
 where
  next argsRev =
    (char '0' >> parseArgs >>= \arg -> next (arg : argsRev))
      <|> (string "1b" >> return argsRev)
      <|> (eof >> return argsRev)

  parseArgs =
    (try (string "p1d") >> predicateParser)
      <|> (try (string "f1d") >> functionParser)
      <|> (Ast.Variable <$> identParser)

  identParser' =
    (  char 'b'
      >> (   (char 't' >> error "\"True\" cannot be part of an AST.")
         <|> (char 'f' >> error "\"False\" cannot be part of an AST.")
         <|> (char '0' >> identParser)
         )
      )
      <|> (string "p0" >> identParser)


-- | Identifier parser that reverses character escaping

identParser :: Parser String
identParser = ident ""
 where
  ident :: String -> Parser String
  ident a = (eof >> return (reverse a)) <|> ident1 a

  ident1 :: String -> Parser String
  ident1 a = lookAhead alphaNum >>= \case
    '0' -> return $ reverse a
    '1' -> return $ reverse a
    '2' -> alphaNum >> alphaNum >>= \case
      '3' -> ident ('0' : a)
      '4' -> ident ('1' : a)
      '5' -> ident ('2' : a)
      '6' -> ident ('_' : a)
      '7' -> ident ('@' : a)
      '8' -> ident ('\'' : a)
      '9' -> ident ('.' : a)
      c   -> ident (toUpper c : a)
    c -> alphaNum >> ident (c : a)


-- | Escapes characters which potentially can cause problems.

escape :: String -> String
escape = escape' []
 where
  escape' a = \case
    []     -> reverse a
    c : cr -> case c of
      '0'  -> escape' ('3' : '2' : a) cr
      '1'  -> escape' ('4' : '2' : a) cr
      '2'  -> escape' ('5' : '2' : a) cr
      '_'  -> escape' ('6' : '2' : a) cr
      '@'  -> escape' ('7' : '2' : a) cr
      '\'' -> escape' ('8' : '2' : a) cr
      '.'  -> escape' ('9' : '2' : a) cr
      _ | isUpper c -> escape' (toLower c : '2' : a) cr
        | otherwise -> escape' (c : a) cr
