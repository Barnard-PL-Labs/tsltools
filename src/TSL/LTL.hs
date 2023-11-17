-- | Utilities related to LTL synthesis.
module TSL.LTL (synthesize, synthesize', realizable) where

import Control.Monad (unless)
import Data.Maybe (isJust)
import qualified Syfco as S
import System.Directory (findExecutable)
import System.Exit (ExitCode (ExitSuccess))
import System.Process (readProcessWithExitCode)
import TSL.Error (genericError, unwrap)

-- | Given LTL spec in TLSF format, synthesize an HOA controller
synthesize :: FilePath -> String -> IO String
synthesize ltlsyntPath tlsfContents = do
  (exitCode, stdout, stderr) <- synthesize' ltlsyntPath tlsfContents
  if exitCode /= ExitSuccess
    then unwrap . genericError $ "TSL spec UNREALIZABLE. ltlsynt stdout:\n" ++ stdout ++ "\nltlstderr:\n" ++ stderr
    else return . unlines . tail . lines $ stdout

realizable :: FilePath -> String -> IO Bool
realizable ltlsyntPath tlsfContents = do
  (exitCode, _, _) <- synthesize' ltlsyntPath tlsfContents
  if exitCode /= ExitSuccess
    then return True
    else return False

synthesize' :: FilePath -> String -> IO (ExitCode, String, String)
synthesize' ltlsyntPath tlsfContents = do
  -- check if ltlsynt is available on path
  ltlsyntAvailable <- checkLtlsynt ltlsyntPath
  unless ltlsyntAvailable $
    unwrap . genericError $
      "Invalid path to ltlsynt: " ++ ltlsyntPath

  -- prepare arguments for ltlsynt
  let tlsfSpec =
        case S.fromTLSF tlsfContents of
          Left err -> error $ show err
          Right spec -> spec
  let ltlIns = prInputs S.defaultCfg tlsfSpec
      ltlOuts = prOutputs S.defaultCfg tlsfSpec
      ltlFormulae = prFormulae S.defaultCfg {S.outputMode = S.Fully, S.outputFormat = S.LTLXBA} tlsfSpec
      ltlCommandArgs =
        [ "--formula=" ++ ltlFormulae,
          "--ins=" ++ ltlIns,
          "--outs=" ++ ltlOuts,
          "--hoaf=i"
        ]

  -- call ltlsynt
  readProcessWithExitCode ltlsyntPath ltlCommandArgs ""
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

-- | Check if 'ltlsynt' is available on path
checkLtlsynt :: FilePath -> IO Bool
checkLtlsynt path = do
  m <- findExecutable path
  return $ isJust m
