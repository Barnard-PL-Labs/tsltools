-- | JS Code gen tests.
-- Check that the generated js code is syntactically valid.
-- Note: this generates the js code from the .hoa files rather than the .tsl spec,
-- and as such does not check for any semantic correctness.
module JSWriterTests
  ( tests,
  )
where

import Data.Maybe
import Distribution.TestSuite
  ( Progress (..),
    Result (..),
    Test (..),
    TestInstance (..),
  )
import Hanoi (parse)
import System.Directory
  ( findExecutable,
    listDirectory,
  )
import System.Exit
import System.FilePath (joinPath)
import System.Process
import TSL.HOA
  ( CodeTarget (..),
    implement,
  )

tests :: IO [Test]
tests =
  let jsTestTemplate dirPath hoaFile =
        TestInstance
          { run = jsCode dirPath hoaFile,
            name = "JS Code Gen: " ++ hoaFile,
            tags = [],
            options = [],
            setOption = \_ _ -> Right $ jsTestTemplate dirPath hoaFile
          }
      jsCode dirPath hoaFilepath = do
        c <- readFile $ joinPath [dirPath, hoaFilepath]
        let hoa = parse c
        let code = either id (implement False JS) hoa
        (exitCode, stdout, stderr) <-
          readProcessWithExitCode
            "jshint"
            ["--config=./.jshintrc", "/dev/stdin"]
            code
        case exitCode of
          ExitSuccess -> return $ Finished Pass
          ExitFailure _ -> do
            putStrLn $ "\nSynthesized JS code:\n" ++ code ++ "\n"
            return $ Finished $ Fail (stdout ++ stderr)
   in do
        let dirPath = "test/res/hoa"
        paths <- listDirectory dirPath
        jsHintPath <- findExecutable "jshint"
        if isJust jsHintPath
          then return $ map (Test . jsTestTemplate dirPath) paths
          else return []
