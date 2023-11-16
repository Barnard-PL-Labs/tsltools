module Main where

import Control.Monad (join)
import Options.Applicative (execParser)
import TSL.Command (optionsParser)

main :: IO ()
main = join $ execParser optionsParser