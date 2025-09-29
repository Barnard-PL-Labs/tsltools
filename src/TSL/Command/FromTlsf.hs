module TSL.Command.FromTlsf (command) where

import Options.Applicative
  ( Parser,
    ParserInfo,
    action,
    fullDesc,
    header,
    help,
    helper,
    info,
    long,
    metavar,
    optional,
    progDesc,
    short,
    strOption,
  )
import TSL.TLSF2TSL (tlsfToTsl')
import TSL.Utils (readInput, writeOutput)

data Options = Options
  { inputPath :: Maybe FilePath,
    outputPath :: Maybe FilePath
  }

optionsParserInfo :: ParserInfo Options
optionsParserInfo =
  info (helper <*> optionsParser) $
    fullDesc
      <> progDesc "Convert TLSF format back to TSL format"
      <> header "tsl fromtlsf - Convert TLSF to TSL"

optionsParser :: Parser Options
optionsParser =
  Options
    <$> optional
      ( strOption $
          long "input"
            <> short 'i'
            <> metavar "FILE"
            <> help "Input TLSF file (STDIN, if not set)"
            <> action "file"
      )
    <*> optional
      ( strOption $
          long "output"
            <> short 'o'
            <> metavar "FILE"
            <> help "Output TSL file (STDOUT, if not set)"
            <> action "file"
      )

fromTlsf :: Options -> IO ()
fromTlsf (Options {inputPath, outputPath}) = do
  -- Read TLSF input
  input <- readInput inputPath

  -- Convert TLSF to TSL
  tslSpec <- tlsfToTsl' input

  -- Write TSL output
  writeOutput outputPath tslSpec

command :: ParserInfo (IO ())
command = fromTlsf <$> optionsParserInfo
