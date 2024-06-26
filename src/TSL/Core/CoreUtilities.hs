{-# LANGUAGE RecordWildCards #-}

-- | 'CoreUtilities' provides different functionalities that are used to
-- generate different kind of cores. This includes the wrapping of
-- different IO-operations into a context.
module TSL.Core.CoreUtilities
  ( Context (..),
    Verbosity (..),
    logNormal,
    logHigh,
    sortedPowerSet,
    optimizeSpec,
    createContext,
  )
where

import Control.Monad (when)
import Data.Set as Set (Set, empty, fromList, insert, notMember, size, toList)
import TSL.Base (Formula (..), Specification (..))
import qualified TSL.LTL as LTL
import qualified TSL.TLSF as TLSF

-- | 'Context' holds the necessary informations that are used for the
-- synthesis calls and the program logging
data Context = Context
  { -- | 'tslSpecRealizable'
    -- checks whether some
    -- 'Specification' is
    -- realizable
    tslSpecRealizable :: Specification -> IO Bool,
    -- | 'verbosityLevel' defines which output
    -- logging verbosity should be applied
    verbosityLevel :: Verbosity,
    -- | 'threadPoolSize' defines how many worker
    -- threads should be executed at once
    threadPoolSize :: Int
  }

-- | 'Verbosity' represents the different verbosity levels for the output
data Verbosity
  = -- | Do only output the result
    SILENT
  | -- | Do only output the result and other necessary information
    QUIET
  | -- | Output when important intermediate states are executed
    STEPWISE
  | -- | Output all intermediate steps including the content of the queries
    DETAILED
  deriving (Eq)

createContext :: Int -> Verbosity -> FilePath -> Context
createContext poolSize verbosity ltlsyntPath =
  Context
    { verbosityLevel = verbosity,
      threadPoolSize = poolSize,
      tslSpecRealizable = tslSpecRealizable
    }
  where
    tslSpecRealizable tslSpec = LTL.realizable ltlsyntPath $ TLSF.lower tslSpec

-- | 'logOn' writes a log message if the 'Verbosity' specified in the
-- context is one that has been given as argument.
logOn :: [Verbosity] -> Context -> String -> IO ()
logOn verbosities context logMessage =
  when (verbosityLevel context `elem` verbosities) (putStrLn logMessage)

-- | 'logNormal' writes a log message if the 'Verbosity' is at least
-- 'STEPWISE'.
logNormal :: Context -> String -> IO ()
logNormal = logOn [STEPWISE, DETAILED]

-- | 'logHigh' writes a log message if the 'Verbosity' is 'DETAILED'.
logHigh :: Context -> String -> IO ()
logHigh = logOn [DETAILED]

-- | 'sortedPowerSet' computes the powerset as list of sets such that the
-- list is sorted with ascending size.  Note that this is not done by
-- using 'powerset' and then sorting but in an on-the-fly manner.
sortedPowerSet :: Int -> [Set Int]
sortedPowerSet n = powerSetB n n
  where
    powerSetB :: Int -> Int -> [Set Int]
    powerSetB n bound
      | n < 1 = [empty]
      | n == 1 = empty : [fromList [i] | i <- [0 .. bound - 1]]
      | otherwise =
          let sub = powerSetB (n - 1) bound
              subNew =
                concatMap
                  (\s -> [insert i s | i <- [0 .. bound - 1], notMember i s])
                  (Prelude.filter (\s -> size s == n - 1) sub)
              new = toList (fromList subNew)
           in sub ++ new

-- | 'optimizeSpec' might do some preprocessing to make a specification more
-- suitable for synthesis.
optimizeSpec :: Specification -> Specification
optimizeSpec Specification {..} =
  Specification
    { symboltable = symboltable,
      assumptions = concatMap splitOnAnd assumptions,
      guarantees = concatMap splitOnAnd guarantees
    }
  where
    splitOnAnd :: Formula Int -> [Formula Int]
    splitOnAnd =
      \case
        And xs -> xs
        f -> [f]
