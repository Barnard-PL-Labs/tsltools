module TSL.ModuloTheories (tslmt2tsl) where

import Control.Monad.Trans.Except
import Data.Maybe (catMaybes)
import TSL
  ( Cfg,
    ConsistencyDebugInfo (..),
    Error,
    IntermediateResults (..),
    Specification,
    SygusDebugInfo (..),
    Theory,
    TheoryPredicate,
    buildDtoList,
    cfgFromSpec,
    consistencyDebug,
    fromTSL,
    generateConsistencyAssumptions,
    generateSygusAssumptions,
    predsFromSpec,
    readTheory,
    sygusDebug,
    tUninterpretedFunctions,
    unwrap,
  )

tslmt2tsl :: FilePath -> Maybe FilePath -> String -> IO String
tslmt2tsl solverPath inputPath spec = do
  (theory, tslSpec, specStr) <- loadTSLMT
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
    loadTSLMT :: IO (Theory, Specification, String)
    loadTSLMT = do
      let linesList = lines spec
          hasTheoryAnnotation = '#' == (head $ head linesList)
          theory = readTheory $ head linesList
          specStr = unlines $ tail linesList -- FIXME: unlines.lines is computationally wasteful
      if hasTheoryAnnotation
        then do
          tslmt <- fromTSL inputPath specStr
          unwrap $ (,,specStr) <$> theory <*> tslmt
        else do
          rawTSL <- fromTSL inputPath spec
          unwrap $ (,,spec) <$> Right tUninterpretedFunctions <*> rawTSL

    unError :: (Show a) => Either a b -> b
    unError = \case
      Left err -> error $ show err
      Right val -> val
