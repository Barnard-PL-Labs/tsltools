module TSL.Command.Preprocess (command) where

import Options.Applicative (Parser, ParserInfo, action, fullDesc, header, help, helper, info, long, metavar, optional, progDesc, short, strOption)
import qualified TSL.Preprocessor as Preprocessor
import TSL.Utils (readInput, writeOutput)

data Options = Options
  { inputPath :: Maybe FilePath,
    outputPath :: Maybe FilePath
  }

optionsParserInfo :: ParserInfo Options
optionsParserInfo =
  info (helper <*> optionsParser) $
    fullDesc
      <> progDesc "Spec (TSL) -> Spec (Base TSL)"
      <> header "tsl preprocess"

optionsParser :: Parser Options
optionsParser =
  Options
    <$> optional
      ( strOption $
          long "input"
            <> short 'i'
            <> metavar "FILE"
            <> help "Input file (STDIN, if not set)"
            <> action "file"
      )
    <*> optional
      ( strOption $
          long "output"
            <> short 'o'
            <> metavar "FILE"
            <> help "Output file (STDOUT, if not set)"
            <> action "file"
      )

preprocess :: Options -> IO ()
preprocess (Options {inputPath, outputPath}) = do
  -- Read input
  input <- readInput inputPath

  -- user-provided TSLMT spec (String) -> desugared TSLMT spec (String)
  preprocessedSpec <- Preprocessor.preprocess input

  -- Write to output
  writeOutput outputPath preprocessedSpec

command :: ParserInfo (IO ())
command = preprocess <$> optionsParserInfo
