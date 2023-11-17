-- | Dependency test cases.
module DependencyTests
  ( tests,
  )
where

import Control.Monad (forM)
import Distribution.TestSuite
  ( Progress (..),
    Result (..),
    Test (..),
    TestInstance (..),
  )
import System.Directory (listDirectory)
import System.FilePath (joinPath)
import TSL.Base (readTSL, specifications2dependencies)
import TSL.Error (unwrap)

tests :: [Test]
tests =
  let test =
        TestInstance
          { run = do
              let dirPath = "test/res/specs"
              paths <- listDirectory dirPath
              specs <-
                forM
                  paths
                  ( \path -> do
                      let inputPath = joinPath [dirPath, path]
                      specStr <- readFile inputPath
                      res <- readTSL specStr
                      unwrap res
                  )
              let out = show $ specifications2dependencies specs
              let refPath = "test/res/DepTestReference.txt"
              ref <- readFile refPath
              if out == ref
                then return $ Finished Pass
                else do
                  putStrLn "Reference:"
                  putStrLn ref
                  putStrLn ""
                  putStrLn "Generated:"
                  putStrLn out
                  putStrLn ""
                  return $ Finished $ Fail "output differs",
            name = "DepTest",
            tags = [],
            options = [],
            setOption = \_ _ -> Right test
          }
   in [Test test]
