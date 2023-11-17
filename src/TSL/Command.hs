-- | CLI commands and options parser
module TSL.Command (optionsParser) where

import Options.Applicative (Parser, ParserInfo, command, fullDesc, header, helper, info, progDesc, subparser)
import qualified TSL.Command.Coregen as Coregen
import qualified TSL.Command.Hoa as Hoa
import qualified TSL.Command.Minrealizable as Minrealizable
import qualified TSL.Command.Preprocess as Preprocess
import qualified TSL.Command.Synthesize as Synthesize
import qualified TSL.Command.Theorize as Theorize
import qualified TSL.Command.Tlsf as Tlsf

optionsParser :: ParserInfo (IO ())
optionsParser =
  info (helper <*> commands) $
    fullDesc
      <> progDesc "TSL synthesis tool"
      <> header "tsl"

commands :: Parser (IO ())
commands =
  subparser $
    command "preprocess" Preprocess.command
      <> command "theorize" Theorize.command
      <> command "tlsf" Tlsf.command
      <> command "hoa" Hoa.command
      <> command "synthesize" Synthesize.command
      <> command "coregen" Coregen.command
      <> command "minrealizable" Minrealizable.command
