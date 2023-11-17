-- | Helper functions.
module TSL.Utils (readInput, writeOutput) where

-- | Read input from file or stdin.
readInput :: Maybe FilePath -> IO String
readInput Nothing = getContents
readInput (Just filename) = readFile filename

-- | Writes content either to given file or STDOUT
writeOutput :: Maybe FilePath -> String -> IO ()
writeOutput Nothing = putStrLn
writeOutput (Just file) = writeFile file
