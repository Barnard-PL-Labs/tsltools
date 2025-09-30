-- | Convert TLSF format back to TSL format
module TSL.TLSF2TSL
  ( tlsfToTsl,
    tlsfToTsl',
  )
where

import Data.Char (isDigit)
import Data.List (intercalate, isPrefixOf, isSuffixOf)
import Data.Maybe (mapMaybe)

-- | Convert TLSF string to TSL string
tlsfToTsl :: String -> String
tlsfToTsl input =
  let linesInput = lines input
      -- Extract assumes and guarantees from TLSF
      assumes = extractSection "ASSUME" linesInput
      guarantees = extractSection "GUARANTEE" linesInput

      -- Convert back to TSL
      assumeTsl =
        if null assumes
          then ""
          else "always assume {\n" ++ unlines (map ("  " ++) assumes) ++ "}\n"
      guaranteeTsl =
        if null guarantees
          then ""
          else "always guarantee {\n" ++ unlines (map ("  " ++) guarantees) ++ "}"
   in assumeTsl ++ "\n" ++ guaranteeTsl

-- | IO version for file handling
tlsfToTsl' :: String -> IO String
tlsfToTsl' = return . tlsfToTsl

-- | Extract a section (ASSUME or GUARANTEE) from TLSF
extractSection :: String -> [String] -> [String]
extractSection section lns =
  let start = dropWhile (not . ((section ++ " {") `isInfixOf`)) lns
      content =
        if null start
          then []
          else takeWhile (not . isClosingBrace) (drop 1 start)
   in mapMaybe processFormula content
  where
    isClosingBrace line = trim line == "}" || "GUARANTEE {" `isInfixOf` line

-- | Process a single formula line
processFormula :: String -> Maybe String
processFormula line =
  let trimmed = trim line
   in if null trimmed || trimmed == "}" || trimmed == "{"
        then Nothing
        else Just $ decodeTlsfFormula trimmed

-- | Remove trailing semicolon
removeSemicolon :: String -> String
removeSemicolon s = if ";" `isSuffixOf` s then init s else s

-- | Trim whitespace from both ends
trim :: String -> String
trim = f . f
  where
    f = reverse . dropWhile (== ' ')

-- | Decode a TLSF formula back to TSL
decodeTlsfFormula :: String -> String
decodeTlsfFormula formula =
  let -- First decode all atomic propositions
      decoded = decodeAllPropositions formula
      -- Then remove the G operator (always is handled at section level)
      -- Also be sure to replace & with && and | with ||
      result = replaceAll "G " "" $ replaceAll "&" "&&" $ replaceAll "|" "||" decoded
   in result

-- | Decode all propositions in a formula
decodeAllPropositions :: String -> String
decodeAllPropositions = decodeFormula ""
  where
    decodeFormula acc [] = acc
    decodeFormula acc str@(c : cs)
      | "p0p0" `isPrefixOf` str =
          let (prop, rest) = span isIdentChar str
              decoded = decodePredicate prop
           in decodeFormula (acc ++ decoded) rest
      | "u0" `isPrefixOf` str =
          let (prop, rest) = span isIdentChar str
              decoded = decodeUpdate prop
           in decodeFormula (acc ++ decoded) rest
      | otherwise = decodeFormula (acc ++ [c]) cs

    isIdentChar c = c `elem` (['a' .. 'z'] ++ ['A' .. 'Z'] ++ ['0' .. '9'] ++ ['_'])

-- | Decode a predicate like p0p0rightmost0ball -> rightmost ball
decodePredicate :: String -> String
decodePredicate token =
  let withoutPrefix = drop 4 token -- Remove "p0p0"
  -- Split and filter out empty parts
      parts = filter (not . null) $ splitOn '0' withoutPrefix
   in case parts of
        [] -> token
        _ -> unwords parts

-- | Decode an update like u0ball0f1dmove2right0ball1b -> [ball <- moveRight ball]
decodeUpdate :: String -> String
decodeUpdate token =
  let withoutPrefix = drop 2 token -- Remove "u0"
   in if "f1d" `isInfixOf` withoutPrefix
        then decodeComplexUpdate withoutPrefix
        else decodeSimpleUpdate withoutPrefix

-- | Decode simple update like u0ball0ball -> ball
decodeSimpleUpdate :: String -> String
decodeSimpleUpdate token =
  let parts = splitOn '0' token
   in case parts of
        [] -> token
        [x] -> x
        (x : _) -> x

-- | Decode complex update like ball0f1dmove2right0ball1b -> [ball <- moveRight ball]
decodeComplexUpdate :: String -> String
decodeComplexUpdate token =
  let -- Split by "f1d" to get target and function parts
      (target, rest) = span (/= 'f') token
      targetClean = takeWhile (/= '0') target

      -- Extract function name from the rest
      funcPart =
        if "f1d" `isPrefixOf` rest
          then drop 3 rest -- Remove "f1d"
          else rest

      -- Convert move2right to moveRight, move2left to moveLeft
      funcName = decodeFunctionName funcPart

      -- Extract argument (usually same as target)
      argPart = reverse $ takeWhile (/= '0') $ reverse funcPart
      arg = if "1b" `isSuffixOf` argPart then take (length argPart - 2) argPart else argPart
   in "[" ++ targetClean ++ " <- " ++ funcName ++ " " ++ arg ++ "]"

-- | Decode function names like move2right -> moveRight
decodeFunctionName :: String -> String
decodeFunctionName s =
  let -- Extract the function name part (before the 0 and argument)
      funcRaw = takeWhile (/= '0') s
      -- Replace 2 with capital letter for camelCase
      decoded = replaceCamelCase funcRaw
   in decoded

-- | Convert move2right to moveRight
replaceCamelCase :: String -> String
replaceCamelCase s =
  case s of
    "move2left" -> "moveLeft"
    "move2right" -> "moveRight"
    other -> replaceNumbers other
  where
    replaceNumbers [] = []
    replaceNumbers ('2' : c : cs) = toUpper c : replaceNumbers cs
    replaceNumbers (c : cs) = c : replaceNumbers cs
    toUpper c = if c >= 'a' && c <= 'z' then toEnum (fromEnum c - 32) else c

-- | Split string by a character
splitOn :: Char -> String -> [String]
splitOn _ [] = []
splitOn c s =
  let (first, rest) = span (/= c) s
   in first : case rest of
        [] -> []
        (_ : xs) -> splitOn c xs

-- | Replace all occurrences of a substring
replaceAll :: String -> String -> String -> String
replaceAll _ _ [] = []
replaceAll from to str@(c : cs)
  | from `isPrefixOf` str = to ++ replaceAll from to (drop (length from) str)
  | otherwise = c : replaceAll from to cs

-- | Check if string contains substring
isInfixOf :: String -> String -> Bool
isInfixOf needle haystack = any (isPrefixOf needle) (tails haystack)
  where
    tails [] = [[]]
    tails xs@(_ : xs') = xs : tails xs'
