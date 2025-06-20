-- | Utilities related to LTL synthesis.
module TSL.LTL (synthesize, synthesize', realizable) where

import Control.Exception (handle)
import Control.Monad (unless, when)
import qualified Control.Monad as ControlM
import Data.Maybe (fromMaybe, isJust)
import qualified Syfco as S
import System.Directory (createDirectoryIfMissing, getCurrentDirectory, findExecutable)
import System.FilePath      ((</>))
import System.Exit (ExitCode (ExitSuccess))
import System.Process (readProcessWithExitCode)
import TSL.Error (genericError, unwrap)

-- | Given LTL spec in TLSF format, synthesize a Right HOA controller
--   If unrealizable, generate a Left counterstrategy
synthesize :: FilePath -> String -> Bool -> IO (Maybe String)
synthesize ltlsyntPath tlsfContents debugSpec = do
  ControlM.when debugSpec $ do
    cwd <- getCurrentDirectory
    putStrLn $ "[LTL][DEBUG] cwd is: " ++ cwd

    let debugDir  = "debug" </> "tlsf"
        debugFile = debugDir </> "spec.tlsf"

    putStrLn "[LTL][DEBUG] writing raw TLSF spec to disk"
    createDirectoryIfMissing True debugDir
    writeFile debugFile tlsfContents
    putStrLn $ "[LTL][DEBUG] wrote TLSF to " ++ debugFile

  (exitCode, out, err) <- synthesize' ltlsyntPath tlsfContents debugSpec
  if exitCode /= ExitSuccess
    then return Nothing
    else return . Just . unlines . tail . lines $ out

realizable :: FilePath -> String -> IO Bool
realizable ltlsyntPath tlsfContents = do
  (exitCode, _, _) <- synthesize' ltlsyntPath tlsfContents False
  return (exitCode == ExitSuccess)

synthesize' :: FilePath -> String -> Bool -> IO (ExitCode, String, String)
synthesize' ltlsyntPath tlsfContents debugSpec = do
  ltlsyntAvailable <- checkLtlsynt ltlsyntPath
  unless ltlsyntAvailable $
    unwrap . genericError $
      "Invalid path to ltlsynt: " ++ ltlsyntPath
  ControlM.when debugSpec $ do
    putStrLn "[LTL] -> parsing TLSF via Syfco.fromTLSF"
  
  let tlsfSpec =
        case S.fromTLSF tlsfContents of
          Left err   -> error $ show err
          Right spec -> spec

  ControlM.when debugSpec $ do
    putStrLn "[LTL] -> extracting inputs"
  let ltlIns = prInputs S.defaultCfg tlsfSpec
      ltlOuts = prOutputs S.defaultCfg tlsfSpec
  ControlM.when debugSpec $ do
    let debugDir = "debug" </> "LTL_Inputs"
        debugFile = debugDir </> "LTL.tlsf"
    createDirectoryIfMissing True debugDir
    writeFile debugFile ltlIns
    putStrLn $ "[LTL][DEBUG] wrote inputs to " ++ debugFile
  ControlM.when debugSpec $ do
    putStrLn $ "[LTL]    outputs = " ++ show ltlOuts
    let debugDir = "debug" </> "LTL_Outputs"
        debugFile = debugDir </> "LTL.tlsf"
    createDirectoryIfMissing True debugDir
    writeFile debugFile ltlOuts
    putStrLn $ "[LTL][DEBUG] wrote inputs to " ++ debugFile

    putStrLn "[LTL] -> building formulae"
  let cfg = S.defaultCfg
          { S.outputFormat = S.LTLXBA   -- LTL2BA / LTL3BA input format
          , S.outputMode   = S.Pretty   -- or `Fully` if you need every paren
          }
      ltlFormulae = prFormulae cfg tlsfSpec

  putStrLn "[LTL] -> Writing Formula"
  -- write out the formula file no matter what
  let formulaDir  = "debug" </> "LTL_Formula"
      formulaFile = formulaDir </> "formula.tlsf"
  createDirectoryIfMissing True formulaDir
  writeFile formulaFile ltlFormulae

  let ltlCommandArgs =
        [ "-F", formulaFile
        , "--ins="  ++ ltlIns
        , "--outs=" ++ ltlOuts
        , "--hoaf=i"
        ]
  putStrLn "[LTL] -> Results being written to readProcess"
  result <- readProcessWithExitCode ltlsyntPath ltlCommandArgs ""

  ControlM.when debugSpec $ do
    let debugDir  = "debug" </> "LTL_Args"
        debugFile = debugDir </> "args.txt"
        argsText  = unlines ltlCommandArgs
    createDirectoryIfMissing True debugDir
    writeFile debugFile argsText
    putStrLn $ "[LTL][DEBUG] wrote ltlsynt args to " ++ debugFile
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
