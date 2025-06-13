-- | Utilities related to TSLMT.
module TSL.ModuloTheories
  ( theorize,
    parse,
    module TSL.ModuloTheories.Cfg,
    module TSL.ModuloTheories.ConsistencyChecking,
    module TSL.ModuloTheories.Predicates,
    module TSL.ModuloTheories.Sygus,
    module TSL.ModuloTheories.Theories,
  )
where

import Control.Monad (unless,forM_)
import qualified Control.Monad as ControlM
import Control.Monad.Trans.Except
import Data.Maybe (catMaybes, isJust)
import System.Directory (findExecutable, createDirectoryIfMissing, getDirectoryContents)
import Control.Monad.IO.Class (liftIO)
import TSL.Base.Reader (readTSL)
import TSL.Base.Specification (Specification)
import TSL.Error (genericError, unwrap)
import TSL.ModuloTheories.Cfg
import TSL.ModuloTheories.ConsistencyChecking
import TSL.ModuloTheories.Predicates
import TSL.ModuloTheories.Sygus
import TSL.ModuloTheories.Theories

theorize :: Bool -> FilePath -> String -> IO String
theorize debugSpec solverPath spec = do
  -- check if ltlsynt is available on path
  ltlsyntAvailable <- checkSolverPath solverPath
  unless ltlsyntAvailable $
    unwrap . genericError $
      "Invalid path to solver: " ++ solverPath

  -- parse and theorize
  (mTheory, tslSpec, specStr) <- parse spec
  case mTheory of
    Nothing -> return specStr
    Just theory -> do
      let cfg = unError $ cfgFromSpec theory tslSpec
          preds = unError $ predsFromSpec theory tslSpec

          mkAlwaysAssume :: String -> String
          mkAlwaysAssume assumptions =
            unlines
              [ "always assume {",
                assumptions,
                "}"
              ]

          extractAssumption :: (Monad m) => ExceptT e m a -> m (Maybe a)
          extractAssumption result = do
            either <- runExceptT result
            return $ case either of
              Left _ -> Nothing
              Right assumption -> Just assumption
              

          extractAssumptions :: (Monad m) => [ExceptT e m String] -> m String
          extractAssumptions =
            fmap (unlines . catMaybes) . mapM extractAssumption

          consistencyAssumptions :: IO String

          consistencyAssumptions =
            extractAssumptions $
              generateConsistencyAssumptions
                solverPath
                preds


          sygusAssumptions :: IO String
          sygusAssumptions =
            extractAssumptions $
              generateSygusAssumptions
                solverPath
                cfg
                (buildDtoList preds)

          assumptionsBlock :: IO String
          assumptionsBlock =
            mkAlwaysAssume
              <$> ( (++)
                      <$> consistencyAssumptions
                      <*> sygusAssumptions
                  )
      ass <- assumptionsBlock

      ControlM.when debugSpec $ do
        liftIO $ createDirectoryIfMissing True "Assumption_Block"
        let outPath = "debug/assumptions.txt"
        liftIO $ writeFile outPath ass
        putStrLn $ ">> [theorize] wrote assumptions to " ++ outPath

      -- **finally**, assemble and return your full spec:
      let fullSpec = ass ++ specStr
      return fullSpec

  where
    unError :: (Show a) => Either a b -> b
    unError = \case
      Left err -> error $ show err
      Right val -> val

parse :: String -> IO (Maybe Theory, Specification, String)
parse spec = do
  let linesList = lines spec
      hasTheoryAnnotation = '#' == head (head linesList)
  if hasTheoryAnnotation
    then do
      let specStr = unlines $ tail linesList -- FIXME: unlines.lines is computationally wasteful
      theory <- unwrap <$> readTheory $ head linesList
      tslmt <- readTSL specStr >>= unwrap
      return (Just theory, tslmt, specStr)
    else do
      rawTSL <- readTSL spec >>= unwrap
      return (Nothing, rawTSL, spec)

-- | Check if the given solver path is valid
checkSolverPath :: FilePath -> IO Bool
checkSolverPath path = do
  m <- findExecutable path
  return $ isJust m
