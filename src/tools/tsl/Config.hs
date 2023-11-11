-----------------------------------------------------------------------------
{-# LANGUAGE ScopedTypeVariables #-}

-----------------------------------------------------------------------------

-- |
-- Module      :  Config
-- Maintainer  :  Feitong Leo Qiao
--
-- Configuration of the tool, set up via the command line arguments.
module Config
  ( CliConfig (..),
    CliCommand (..),
    SynthConfig (..),
    getCliConfig,
  )
where

-----------------------------------------------------------------------------

import Options.Applicative

-- import TSL (CodeTarget)

-----------------------------------------------------------------------------

data CliConfig = CliConfig
  { debugMode :: !Bool,
    cliCommand :: !CliCommand
  }
  deriving (Show)

data CliCommand
  = Synth SynthConfig
  deriving (Show)

data SynthConfig = SynthConfig
  { -- | The input file containing the synthesized control flow
    -- model. If no input file is given we read from STDIN.
    synthInputPath :: Maybe FilePath,
    -- | Output file path. If no path is given, the output is writtend
    -- to STDOUT.
    synthOutputPath :: Maybe FilePath
  }
  -- \| Target code type to generate.
  -- codeTarget :: CodeTarget,
  -- -- | The name of the generated module.
  -- moduleName :: String,
  -- -- | Name of the synthesized signal function that is exported by
  -- -- the module.
  -- functionName :: String,
  -- writeHoa :: FilePath

  deriving (Show)

getCliConfig :: IO CliConfig
getCliConfig = do
  (cliConfig :: CliConfig) <- execParser cliConfigParser
  return cliConfig

cliConfigParser :: ParserInfo CliConfig
cliConfigParser =
  info
    (helper <*> versionOption <*> programOptions)
    (fullDesc <> progDesc "TSL command description" <> header "tsl - command description")
  where
    versionOption :: Parser (a -> a)
    versionOption = infoOption "0.0" (long "version" <> help "Show version")
    programOptions :: Parser CliConfig
    programOptions =
      CliConfig
        <$> switch (long "global-flag" <> help "Set a global flag")
        <*> subparser synthCommand

synthCommand :: Mod CommandFields CliCommand
synthCommand =
  command
    "synth"
    (info (helper <*> options) (progDesc "Synthesize a TSL spec"))
  where
    options :: Parser CliCommand
    options =
      Synth
        <$> ( SynthConfig
                <$> optional
                  ( argument
                      str
                      ( metavar "INPUT"
                          <> help "The input file containing the synthesized control flow model."
                      )
                  )
                <*> optional
                  ( option
                      str
                      ( long "output"
                          <> short 'o'
                          <> metavar "OUTFILE"
                          <> help "output file (STDOUT, if not set)"
                      )
                  )
            )

-----------------------------------------------------------------------------
