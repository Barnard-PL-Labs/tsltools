----------------------------------------------------------------------------
-- |
-- Module      :  Main
-- Maintainer  :  Marvin Stenger (klein@react.uni-saarland.de)
--
-- Transforms TSL specifications into TLSF specifications.
--
-----------------------------------------------------------------------------

{-# LANGUAGE

    ImplicitParams

  #-}

-----------------------------------------------------------------------------

module Main
  ( main
  ) where

-----------------------------------------------------------------------------

import TSL
  ( fromTSL
  , toTSL
  )

import System.Directory
  ( doesFileExist
  )

import System.Environment
  ( getArgs
  )

import System.Console.ANSI
  ( SGR(..)
  , ConsoleLayer(..)
  , ColorIntensity(..)
  , Color(..)
  , setSGR
  , hSetSGR
  )

import System.IO
  ( stderr
  , hPrint
  , hPutStr
  , hPutStrLn
  )

import GHC.IO.Encoding
  ( utf8
  , setLocaleEncoding
  , setFileSystemEncoding
  , setForeignEncoding
  )

import System.Exit
  ( exitFailure
  )

-----------------------------------------------------------------------------

main
  :: IO ()

main = do
  setLocaleEncoding utf8
  setFileSystemEncoding utf8
  setForeignEncoding utf8

  input <- parseArgs

  case input of
    Nothing -> do
      let ?specFilePath = Nothing
      str <- getContents
      res <- fromTSL str
      case res of
        Left err -> do
          cPutStr Red "invalid"
          resetColors
          hPrint stderr err
          exitFailure
        Right s  ->
          putStr $ toTSL s
    Just filepath -> do
      let ?specFilePath = Just filepath
      exists <- doesFileExist filepath

      if not exists then do
        cError Red "File not found: "
        cErrorLn White filepath
        resetColors
        exitFailure
      else do
        str <- readFile filepath
        res <- fromTSL str
        case res of
          Left err -> do
            cPutStr Red "invalid: "
            cPutStrLn White filepath
            resetColors
            hPrint stderr err
            exitFailure
          Right s  ->
            putStr $ toTSL s

  where
    cPutStr c str = do
      setSGR [ SetColor Foreground Vivid c ]
      putStr str

    cPutStrLn c str = do
      setSGR [ SetColor Foreground Vivid c ]
      putStrLn str

    cError c str = do
      hSetSGR stderr [ SetColor Foreground Vivid c ]
      hPutStr stderr str

    cErrorLn c str = do
      hSetSGR stderr [ SetColor Foreground Vivid c ]
      hPutStrLn stderr str

    resetColors = do
      hSetSGR stderr [ Reset ]
      setSGR [ Reset ]

    parseArgs = do
      args <- getArgs
      case args of
        []  -> return Nothing
        x:_ -> return $ Just x
    
-----------------------------------------------------------------------------
