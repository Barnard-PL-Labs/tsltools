module TSL.Command.Synthesize (command) where

import Options.Applicative (Parser, ParserInfo, action, flag', fullDesc, header, help, helper, info, long, metavar, optional, progDesc, short, showDefault, strOption, value, (<|>))
import qualified TSL.HOA as HOA
import qualified TSL.LTL as LTL
import qualified TSL.ModuloTheories as ModuloTheories
import qualified TSL.Preprocessor as Preprocessor
import qualified TSL.TLSF as TLSF
import TSL.Utils (readInput, writeOutput)

data Options = Options
  { inputPath :: Maybe FilePath,
    outputPath :: Maybe FilePath,
    target :: HOA.CodeTarget,
    solverPath :: FilePath,
    ltlsyntPath :: FilePath
  }

optionsParserInfo :: ParserInfo Options
optionsParserInfo =
  info (helper <*> optionsParser) $
    fullDesc
      <> progDesc "Spec (TSL) -> synthesized program (in target language)"
      <> header "tsl synthesize"

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
    <*> ( flag' HOA.Arduino (long "arduino" <> help "generates code for Arduino")
            <|> flag' HOA.Python (long "python" <> help "generates code for Python")
            <|> flag' HOA.JS (long "js" <> help "generates code for JS backend")
            <|> flag' HOA.XState (long "xstate" <> help "generates code for xstate diagrams")
            <|> flag' HOA.Verilog (long "verilog" <> help "generates code for Verilog")
        )
    <*> strOption
      ( long "solver"
          <> value "cvc5"
          <> showDefault
          <> metavar "SOLVER"
          <> help "Path to SMT and SyGus solver"
          <> action "file"
      )
    <*> strOption
      ( long "ltlsynt"
          <> value "ltlsynt"
          <> showDefault
          <> metavar "LTLSYNT"
          <> help "Path to ltlsynt"
      )

synthesize :: Options -> IO ()
synthesize (Options {inputPath, outputPath, target, solverPath, ltlsyntPath}) = do
  -- Read input
  input <- readInput inputPath

  -- user-provided TSLMT spec (String) -> desugared TSLMT spec (String)
  preprocessedSpec <- Preprocessor.preprocess input

  -- desugared TSLMT spec (String) -> theory-encoded TSL spec (String)
  theorizedSpec <- ModuloTheories.theorize solverPath preprocessedSpec

  -- theory-encoded TSL spec (String) -> TLSF (String)
  tlsfSpec <- TLSF.lower' theorizedSpec

  -- TLSF (String) -> HOA controller (String)
  hoaController <- LTL.synthesize ltlsyntPath tlsfSpec

  -- HOA controller (String) -> controller in target language (String)
  targetController <- HOA.implement' False target hoaController

  -- Write to output
  writeOutput outputPath targetController

command :: ParserInfo (IO ())
command = synthesize <$> optionsParserInfo
