{-# LANGUAGE NamedFieldPuns #-}

-- |
-- Module      :  Main
-- Description :  TSL CLI
-- Maintainer  :  Feitong Leo Qiao
--
-- This module exposes all TSL features as a CLI.
module Main
  ( main,
  )
where

import Config (CliCommand (..), CliConfig (..), SynthConfig (..), getCliConfig)
import Control.Monad (unless)
import Data.Maybe (isJust)
import EncodingUtils (initEncoding)
import FileUtils (tryReadContent, writeContent)
import GHC.IO.Encoding
  ( setFileSystemEncoding,
    setForeignEncoding,
    setLocaleEncoding,
    utf8,
  )
import System.Directory (findExecutable)
import System.Exit (die)
import System.IO (BufferMode (LineBuffering), hPutStrLn, hSetBuffering, stderr, stdout)

-- | Entrypoint for TSL CLI
main :: IO ()
main = do
  initEncoding
  CliConfig {debugMode, cliCommand} <- getCliConfig
  checkDependencies
  case cliCommand of
    Synth config -> tslSynth config

-- | Check denpendencies for TSL commands
checkDependencies :: IO ()
checkDependencies = do
  checkRequired "ltlsynt"
  where
    checkRequired :: String -> IO ()
    checkRequired name = do
      m <- findExecutable name
      unless (isJust m) $ do
        die $ "'" ++ name ++ "' is required but not found."

-- | 'tsl synth' command entrypoint
tslSynth :: SynthConfig -> IO ()
tslSynth config@SynthConfig {synthInputPath, synthOutputPath} = do
  input <- tryReadContent synthInputPath
  writeContent synthOutputPath input