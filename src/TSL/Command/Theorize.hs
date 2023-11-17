module TSL.Command.Theorize (command) where

import Options.Applicative (Parser, ParserInfo, action, fullDesc, header, help, helper, info, long, metavar, optional, progDesc, short, showDefault, strOption, value)
import qualified TSL.ModuloTheories as ModuloTheories
import qualified TSL.Preprocessor as Preprocessor
import TSL.Utils (readInput, writeOutput)

data Options = Options
  { inputPath :: Maybe FilePath,
    outputPath :: Maybe FilePath,
    solverPath :: FilePath
  }

optionsParserInfo :: ParserInfo Options
optionsParserInfo =
  info (helper <*> optionsParser) $
    fullDesc
      <> progDesc "Spec (TSL) -> theory-encoded (Base TSL)"
      <> header "tsl theorize"

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
    <*> strOption
      ( long "solver"
          <> value "cvc5"
          <> showDefault
          <> metavar "SOLVER"
          <> help "Path to SMT and SyGus solver"
          <> action "file"
      )

theorize :: Options -> IO ()
theorize (Options {inputPath, outputPath, solverPath}) = do
  -- Read input
  input <- readInput inputPath

  -- user-provided TSLMT spec (String) -> desugared TSLMT spec (String)
  preprocessedSpec <- Preprocessor.preprocess input

  -- desugared TSLMT spec (String) -> theory-encoded TSL spec (String)
  theorizedSpec <- ModuloTheories.theorize solverPath preprocessedSpec

  -- Write to output
  writeOutput outputPath theorizedSpec

command :: ParserInfo (IO ())
command = theorize <$> optionsParserInfo
