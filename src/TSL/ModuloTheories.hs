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

import Control.Monad.Trans.Except
import Data.Maybe (catMaybes)
import TSL.Base.Reader (readTSL)
import TSL.Base.Specification (Specification)
import TSL.Error (unwrap)
import TSL.ModuloTheories.Cfg
import TSL.ModuloTheories.ConsistencyChecking
import TSL.ModuloTheories.Predicates
import TSL.ModuloTheories.Sygus
import TSL.ModuloTheories.Theories

theorize :: FilePath -> String -> IO String
theorize solverPath spec = do
  (theory, tslSpec, specStr) <- parse spec
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
  (++ specStr) <$> assumptionsBlock
  where
    unError :: (Show a) => Either a b -> b
    unError = \case
      Left err -> error $ show err
      Right val -> val

parse :: String -> IO (Theory, Specification, String)
parse spec = do
  let linesList = lines spec
      hasTheoryAnnotation = '#' == head (head linesList)
      theory = readTheory $ head linesList
      specStr = unlines $ tail linesList -- FIXME: unlines.lines is computationally wasteful
  if hasTheoryAnnotation
    then do
      tslmt <- readTSL specStr
      unwrap $ (,,specStr) <$> theory <*> tslmt
    else do
      rawTSL <- readTSL spec
      unwrap $ (,,spec) <$> Right tUninterpretedFunctions <*> rawTSL
