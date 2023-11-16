module TSL.HOA (CodeTarget (..), implement) where

import qualified Hanoi as H
import qualified TSL.HOA.Arduino as Arduino (implement)
import qualified TSL.HOA.JavaScript as JS (implement)
import qualified TSL.HOA.Python as Python (implement)
import qualified TSL.HOA.Verilog as Verilog (implement)
import qualified TSL.HOA.XState as XState (implement)

data CodeTarget
  = Python
  | Arduino
  | JS
  | Verilog
  | XState
  deriving (Show, Ord, Eq)

implement :: Bool -> CodeTarget -> H.HOA -> String
implement isCounter = \case
  Python -> Python.implement isCounter
  XState -> XState.implement
  JS -> JS.implement isCounter
  Arduino -> Arduino.implement isCounter
  Verilog -> Verilog.implement isCounter
