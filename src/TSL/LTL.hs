-- | Utilities related to LTL synthesis.
module TSL.LTL (synthesize) where

import qualified Syfco as S
import System.Exit (ExitCode (ExitSuccess), die)
import System.Process (readProcessWithExitCode)

-- | Given LTL spec in TLSF format, synthesize an HOA controller
synthesize :: String -> IO String
synthesize tlsfContents = do
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
  (exitCode, stdout, stderr) <- readProcessWithExitCode "ltlsynt" ltlCommandArgs ""
  if exitCode /= ExitSuccess
    then do
      die $ "TSL spec UNREALIZABLE. ltlsynt output: \n" ++ stderr
    else return . unlines . tail . lines $ stdout
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