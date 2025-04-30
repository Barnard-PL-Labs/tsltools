module TSL.Command.Synthesize (command) where

import Data.Maybe (fromJust)
import Options.Applicative (Parser, ParserInfo, action, flag, flag', fullDesc, header, help, helper, info, long, metavar, optional, progDesc, short, showDefault, strOption, value, (<|>))
import System.Exit (ExitCode (ExitFailure), exitSuccess, exitWith)
import TSL.Error (warn, unwrap)
import qualified TSL.HOA as HOA
import qualified TSL.LTL as LTL
import qualified TSL.ModuloTheories as ModuloTheories
import qualified TSL.Preprocessor as Preprocessor
import qualified TSL.TLSF as TLSF
import TSL.Utils (readInput, writeOutput)
import qualified Control.Monad as ControlM
import qualified TSL.Base.Reader as Base (readTSL)
import TSL.Base.Logic (inputs, outputs, functions, predicates, updates)
import TSL.Base.Specification (toFormula, Specification(..))
import TSL.Base.SymbolTable (stName)
import Data.Set (toList)
import qualified Data.Set as Set

data Options = Options
  { inputPath :: Maybe FilePath,
    outputPath :: Maybe FilePath,
    target :: HOA.CodeTarget,
    solverPath :: FilePath,
    ltlsyntPath :: FilePath,
    analyzeSpec :: Bool
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
    <*> flag False True
      ( long "analyze"
          <> help "Analyze the specification before synthesis"
      )

synthesize :: Options -> IO ()
synthesize (Options {inputPath, outputPath, target, solverPath, ltlsyntPath, analyzeSpec}) = do
  -- Read input
  input <- readInput inputPath

  -- user-provided TSLMT spec (String) -> desugared TSLMT spec (String)
  preprocessedSpec <- Preprocessor.preprocess input

  -- desugared TSLMT spec (String) -> theory-encoded TSL spec (String)
  theorizedSpec <- ModuloTheories.theorize solverPath preprocessedSpec

  ControlM.when analyzeSpec $ do
    spec <- Base.readTSL theorizedSpec >>= unwrap
    let formula = toFormula (assumptions spec) (guarantees spec)
    putStrLn "=== Specification Metadata ==="
    putStrLn $ "Inputs:     " ++ show (map (stName (symboltable spec)) $ toList $ inputs formula)
    putStrLn $ "Outputs:    " ++ show (map (stName (symboltable spec)) $ toList $ outputs formula)
    putStrLn $ "Functions:  " ++ show (map (stName (symboltable spec)) $ toList $ functions formula)
    putStrLn $ "Predicates: " ++ show (map (stName (symboltable spec)) $ toList $ predicates formula)

  -- theory-encoded TSL spec (String) -> TLSF (String)
  tlsfSpec <- TLSF.lower' theorizedSpec

  -- TLSF (String) -> HOA controller (String)
  hoaController <- LTL.synthesize ltlsyntPath tlsfSpec

  hoaController <-
    case hoaController of
      Nothing -> TLSF.counter' theorizedSpec >>= LTL.synthesize ltlsyntPath >>= return . Left . fromJust
      Just c -> return $ Right c

  -- HOA controller (String) -> controller in target language (String)
  targetController <-
    either
      (\h -> warn "Warning: Unrealizable Spec, generating counterstrategy" >> HOA.implement' True target h)
      (HOA.implement' False target)
      hoaController

  -- Write to output
  writeOutput outputPath targetController

  case hoaController of
    Left _ -> exitWith $ ExitFailure 1
    Right _ -> exitSuccess

command :: ParserInfo (IO ())
command = synthesize <$> optionsParserInfo
