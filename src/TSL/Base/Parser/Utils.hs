-- | Functions shared among the different parsers.
module TSL.Base.Parser.Utils
  ( stringParser,
    identifier,
    positionParser,
    getPos,
    ch,
  )
where

import Control.Monad (void)
import Data.Functor.Identity (Identity)
import TSL.Base.Expression (ExprPos (..), SrcPos (..))
import TSL.Base.Parser.Data (globalDef)
import Text.Parsec
  ( ParsecT,
    Stream,
    anyChar,
    char,
    getPosition,
    many,
    noneOf,
    sourceColumn,
    sourceLine,
    (<|>),
  )
import Text.Parsec.String (Parser)
import Text.Parsec.Token (identLetter, identStart)

-- | Parses a string surrounded by double quotation marks.  Double
-- quotation marks inside the string have to be escabed by a
-- backslash.  The string may contain special characters like new line
-- or tabs.
stringParser ::
  Parser String
stringParser = do
  void $ char '"'
  xs <- many character
  void $ char '"'
  return $ concat xs
  where
    character =
      escaped <|> nonescaped

    escaped = do
      d <- char '\\'
      c <- anyChar
      case c of
        '"' -> return [c]
        _ -> return [d, c]

    nonescaped = do
      c <- noneOf "\""
      return [c]

-- | @identifier wp@ is an exteded version of its equivalent exported
-- by 'Text.Parser.Token', which additionally stores the starting
-- source position and the ending source position. The parser @wp@ is
-- assumed to parse the subsequent whitespace after the identifier.
identifier ::
  ParsecT String u Identity () -> ParsecT String u Identity (String, ExprPos)
identifier wp = positionParser wp $ do
  x <- identStart globalDef
  xr <- many $ identLetter globalDef
  return (x : xr)

-- | @positionParser wp p@ parses the same as parser @p@, but
-- additionally returns the starting and ending source positions of
-- the result parsed by @p@. The parser @wp@ is assumed to parse the
-- subsequent whitespace after @p@ has been invoked.
positionParser ::
  (Stream s m t) =>
  ParsecT s u m () ->
  ParsecT s u m a ->
  ParsecT s u m (a, ExprPos)
positionParser wp p = do
  x <- getPos
  e <- p
  y <- getPos
  wp
  return (e, ExprPos x y Nothing)

-- | Return the current position of the parser in the source file.
getPos ::
  (Stream s m t) => ParsecT s u m SrcPos
getPos = do
  x <- getPosition
  return $ SrcPos (sourceLine x) (sourceColumn x - 1)

ch ::
  Char -> Parser ()
ch = void . char
