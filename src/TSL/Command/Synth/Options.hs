module TSL.Command.Synth.Options where

import TSL (CodeTarget)

data Options = Options
  { inputPath :: Maybe FilePath,
    outputPath :: Maybe FilePath,
    target :: CodeTarget,
    solverPath :: String
  }