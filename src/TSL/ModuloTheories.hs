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

import Control.Monad (unless)
import Control.Monad.Trans.Except
import Data.Maybe (catMaybes, isJust)
import System.Directory (findExecutable)
import TSL.Base.Reader (readTSL)
import TSL.Base.Specification (Specification)
import TSL.Error (genericError, unwrap)
import TSL.ModuloTheories.Cfg
import TSL.ModuloTheories.ConsistencyChecking
import TSL.ModuloTheories.Predicates
import TSL.ModuloTheories.Sygus
import TSL.ModuloTheories.Theories

theorize :: FilePath -> String -> IO String
theorize solverPath spec = do
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
          sygusAssumptions = do
            putStrLn "Generating sygus assumptions"
            putStrLn $ "preds: " ++ show (buildDtoList preds)
            putStrLn $ "cfg: " ++ show cfg
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
      (++ specStr) <$> assumptionsBlock
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
