-- | Utilities related to LTL synthesis.
module TSL.LTL (synthesize, synthesize', realizable) where

import Control.Exception (handle)
import Control.Monad (unless)
import Data.Maybe (isJust)
import qualified Syfco as S
import System.Directory (findExecutable)
import System.Exit (ExitCode (ExitSuccess))
import System.Process (readProcessWithExitCode)
import TSL.Error (genericError, unwrap)

-- | Given LTL spec in TLSF format, synthesize a Right HOA controller
--   If unrealizable, generate a Left counterstrategy
synthesize :: FilePath -> String -> IO (Maybe String)
synthesize ltlsyntPath tlsfContents = do
  (exitCode, stdout, stderr) <- synthesize' ltlsyntPath tlsfContents
  if exitCode /= ExitSuccess
    then return Nothing
    else return . Just . unlines . tail . lines $ stdout

realizable :: FilePath -> String -> IO Bool
realizable ltlsyntPath tlsfContents = do
  (exitCode, _, _) <- synthesize' ltlsyntPath tlsfContents
  if exitCode /= ExitSuccess
    then return True
    else return False

synthesize' :: FilePath -> String -> IO (ExitCode, String, String)
synthesize' ltlsyntPath tlsfContents = do
  putStrLn $ "[LTL] -> checking ltlsynt at: " ++ ltlsyntPath
  ltlsyntAvailable <- checkLtlsynt ltlsyntPath
  unless ltlsyntAvailable $
    unwrap . genericError $
      "Invalid path to ltlsynt: " ++ ltlsyntPath

  putStrLn "[LTL] -> parsing TLSF via Syfco.fromTLSF"
  let tlsfSpec =
        case S.fromTLSF tlsfContents of
          Left err   -> error $ show err
          Right spec -> spec

  putStrLn "[LTL] -> extracting inputs"
  let ltlIns = prInputs S.defaultCfg tlsfSpec
      ltlOuts = prOutputs S.defaultCfg tlsfSpec

  putStrLn $ "[LTL]    inputs = " ++ show ltlIns
  putStrLn $ "[LTL]    outputs = " ++ show ltlOuts

  putStrLn "[LTL] -> building formulae"
  let ltlFormulae = prFormulae
        S.defaultCfg {S.outputMode = S.Fully, S.outputFormat = S.LTLXBA}
        tlsfSpec
  putStrLn $ "[LTL]    formula = " ++ take 80 ltlFormulae ++ "…"

  let ltlCommandArgs =
        [ "--formula=" ++ ltlFormulae
        , "--ins="     ++ ltlIns
        , "--outs="    ++ ltlOuts
        , "--hoaf=i"
        ]
  putStrLn $ "[LTL] -> invoking ltlsynt with args: " ++ show ltlCommandArgs

  result <- readProcessWithExitCode ltlsyntPath ltlCommandArgs ""
  putStrLn $ "[LTL] <- ltlsynt exited with: " ++ show (fst3 result)
  return result
  where
    fst3 (x,_,_) = x

    prFormulae :: S.Configuration -> S.Specification -> String
    prFormulae c s = case S.apply c s of
      Left err      -> show err
      Right formula -> formula

    -- | Prints the input signals of the given specification.
    prInputs :: S.Configuration -> S.Specification -> String
    prInputs c s = case S.inputs c s of
      Left err    -> show err
      Right []    -> ""
      Right (x:xr) -> x ++ concatMap ((:) ',' . (:) ' ') xr

    -- | Prints the output signals of the given specification.
    prOutputs :: S.Configuration -> S.Specification -> String
    prOutputs c s = case S.outputs c s of
      Left err    -> show err
      Right []    -> ""
      Right (x:xr) -> x ++ concatMap ((:) ',' . (:) ' ') xr

-- | Check if 'ltlsynt' is available on path
checkLtlsynt :: FilePath -> IO Bool
checkLtlsynt path = do
  m <- findExecutable path
  return $ isJust m
