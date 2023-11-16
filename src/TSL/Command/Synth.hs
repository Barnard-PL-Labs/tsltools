module TSL.Command.Synth where

import qualified Hanoi
import Options.Applicative (Parser, ParserInfo, action, flag', fullDesc, header, help, helper, info, long, metavar, optional, progDesc, short, strOption, (<|>))
import qualified Syfco as S
import System.Exit (ExitCode (ExitSuccess), die)
import System.FilePath (takeBaseName)
import System.Process (readProcessWithExitCode)
import TSL (CodeTarget (..), implementHoa)
import TSL.Command.Synth.Options (Options (..))
import TSL.Error (Error)
import TSL.ModuloTheories (tslmt2tsl)
import TSL.Preprocessor (preprocess)
import TSL.Reader (fromTSL)
import TSL.TLSF (toTLSF)

optionsParserInfo :: ParserInfo Options
optionsParserInfo =
  info (helper <*> optionsParser) $
    fullDesc
      <> progDesc "Synthesize a TSL specification"
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
    <*> ( flag' Arduino (long "arduino" <> help "generates code for Arduino")
            <|> flag' Python (long "python" <> help "generates code for Python")
            <|> flag' JS (long "js" <> help "generates code for JS backend")
            <|> flag' XState (long "xstate" <> help "generates code for xstate diagrams")
            <|> flag' Verilog (long "verilog" <> help "generates code for Verilog")
        )
    <*> strOption
      ( long "solver"
          <> metavar "SOLVER"
          <> help "Path to SMT and SyGus solver"
      )

synth :: Options -> IO ()
synth (Options {inputPath, outputPath, target, solverPath}) = do
  let fileBaseName = maybe "input" takeBaseName inputPath

  -- Read input
  input <- readInput inputPath

  -- user-provided TSLMT spec (String) -> desugared TSLMT spec (String)
  preprocessedSpec <- case preprocess input of
    Left err -> die $ show err
    Right s -> return $ show s

  -- desugared TSLMT spec (String) -> theory-encoded TSL spec (String)
  theorizedSpec <- tslmt2tsl solverPath inputPath preprocessedSpec

  -- theory-encoded TSL spec (String) -> TLSF (String)
  tlsfSpec <- toTLSF fileBaseName <$> (fromTSL inputPath theorizedSpec >>= rightOrInvalidInput inputPath)

  -- TLSF (String) -> HOA controller (String)
  hoaController <- callLtlsynt tlsfSpec

  -- HOA controller (String) -> controller in target language (String)
  let targetController = either id (implementHoa False target) $ Hanoi.parse hoaController

  -- Write to output
  writeOutput outputPath targetController

command :: ParserInfo (IO ())
command = synth <$> optionsParserInfo

----------------------------------------------
-- HELPER FUNCTIONS
----------------------------------------------

callLtlsynt :: String -> IO String
callLtlsynt tlsfContents = do
  let tlsfSpec =
        case S.fromTLSF tlsfContents of
          Left err -> error $ show err
          Right spec -> spec
  let ltlIns = prInputs S.defaultCfg tlsfSpec
      ltlOuts = prOutputs S.defaultCfg tlsfSpec
      ltlFormulae = prFormulae S.defaultCfg {S.outputMode = S.Fully, S.outputFormat = S.LTLXBA} tlsfSpec
      ltlCommandArgs = [ltlFormulae, ltlIns, ltlOuts]
  (exitCode, stdout, _) <- readProcessWithExitCode "./tlsfSynt.sh" ltlCommandArgs []
  if exitCode /= ExitSuccess
    then do
      die "TSL spec UNREALIZABLE"
    else return . unlines . tail . lines $ stdout
  where
    prFormulae ::
      S.Configuration -> S.Specification -> String
    prFormulae c s = case S.apply c s of
      Left err -> show err
      Right formulae -> formulae

    -- \| Prints the input signals of the given specification.
    prInputs ::
      S.Configuration -> S.Specification -> String
    prInputs c s = case S.inputs c s of
      Left err -> show err
      Right [] -> ""
      Right (x : xr) -> x ++ concatMap ((:) ',' . (:) ' ') xr

    -- \| Prints the output signals of the given specification.
    prOutputs ::
      S.Configuration -> S.Specification -> String
    prOutputs c s = case S.outputs c s of
      Left err -> show err
      Right [] -> ""
      Right (x : xr) -> x ++ concatMap ((:) ',' . (:) ' ') xr

-- | Read input from file or stdin.
readInput :: Maybe FilePath -> IO String
readInput Nothing = getContents
readInput (Just filename) = readFile filename

-- | Writes content either to given file or STDOUT
writeOutput :: Maybe FilePath -> String -> IO ()
writeOutput Nothing = putStrLn
writeOutput (Just file) = writeFile file

-- | helper function returning valid result or exiting with an error message
rightOrInvalidInput :: Maybe FilePath -> Either Error a -> IO a
rightOrInvalidInput inputPath = \case
  Right r -> return r
  Left err -> do
    die $ "invalid" ++ show inputPath ++ ": " ++ show err