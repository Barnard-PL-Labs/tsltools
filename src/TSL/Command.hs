module TSL.Command where

import Options.Applicative (Parser, ParserInfo, command, fullDesc, header, helper, info, progDesc, subparser)
import qualified TSL.Command.Synth as Synth

optionsParser :: ParserInfo (IO ())
optionsParser =
  info (helper <*> commands) $
    fullDesc
      <> progDesc "TSL synthesis tool"
      <> header "tsl"

commands :: Parser (IO ())
commands =
  subparser $
    command "synth" Synth.command