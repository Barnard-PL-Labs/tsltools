module TSL.Command.Minrealizable (command) where

import Control.Monad (when)
import Options.Applicative
  ( Parser,
    ParserInfo,
    action,
    auto,
    footerDoc,
    fullDesc,
    header,
    help,
    helper,
    info,
    long,
    metavar,
    option,
    optional,
    progDesc,
    short,
    showDefault,
    strOption,
    switch,
    value,
  )
import Options.Applicative.Help.Pretty (text)
import qualified TSL.Base as Base
import TSL.Core as Core
import TSL.Error (genericError, unwrap)
import TSL.Utils (readInput, writeOutput)

data Options = Options
  { inputPath :: Maybe FilePath,
    outputPath :: Maybe FilePath,
    treeBased :: Bool,
    poolSize :: Int,
    verbosity :: Int,
    ltlsyntPath :: FilePath
  }

optionsParserInfo :: ParserInfo Options
optionsParserInfo =
  info (helper <*> optionsParser) $
    fullDesc
      <> progDesc "Spec (Base TSL) -> Spec that is realizable with a minimal amount of assumptions (Base TSL)"
      <> header "tsl minunrealizable"
      <> footerDoc (Just $ text verbosityMessage)
  where
    verbosityMessage :: String
    verbosityMessage =
      unlines
        [ "   Verbosity:",
          "    0: silent, only output the result",
          "    1: quiet, only output the result and important information (default)",
          "    2: output which intermediate steps are reached",
          "    3: output all intermediate steps including the specifications"
        ]

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
    <*> switch
      ( long "tree-based"
          <> short 't'
          <> help "tree based"
      )
    <*> option
      auto
      ( long "poolsize"
          <> short 'p'
          <> help "pool size"
          <> showDefault
          <> value 1
          <> metavar "INT"
      )
    <*> option
      auto
      ( long "verbose"
          <> short 'v'
          <> value 1
          <> showDefault
          <> metavar "INT"
          <> help "verbosity"
      )
    <*> strOption
      ( long "ltlsynt"
          <> value "ltlsynt"
          <> metavar "LTLSYNT"
          <> help "Path to ltlsynt"
      )

minrealizable :: Options -> IO ()
minrealizable (Options {inputPath, outputPath, treeBased, poolSize, verbosity, ltlsyntPath}) = do
  -- Read input
  input <- readInput inputPath

  -- Generate core
  checkPoolSize poolSize
  verbosity' <- convertVerbosity verbosity
  spec <- Base.readTSL input >>= unwrap
  potMinimalRealizableSpec <-
    ( if treeBased
        then treeBasedMinimalAssumptions
        else generateMinimalAssumptions
      )
      (Core.createContext poolSize verbosity' ltlsyntPath)
      spec

  -- Write to output
  case potMinimalRealizableSpec of
    Nothing -> writeOutput outputPath "UNREALIZABLE"
    Just core -> do
      writeOutput outputPath (Base.toTSL core)
  where
    -- \| 'checkPoolSize' checks the pool size and if this is invalid
    -- outputs an adequate error message on stderr and exists the program
    checkPoolSize :: Int -> IO ()
    checkPoolSize n =
      when (n <= 0) $ do
        unwrap $ genericError "The thread pool size has to be at least one"

    -- \| 'convertVerbosity' tries to convert a verbosity and if this is not
    -- possible outputs an adequate error message on stderr and exits the program
    convertVerbosity :: Int -> IO Verbosity
    convertVerbosity v =
      case v of
        0 -> return Core.SILENT
        1 -> return Core.QUIET
        2 -> return Core.STEPWISE
        3 -> return Core.DETAILED
        _ -> do
          unwrap $ genericError "The verbosity has to be given by a number between zero and three"

command :: ParserInfo (IO ())
command = minrealizable <$> optionsParserInfo
