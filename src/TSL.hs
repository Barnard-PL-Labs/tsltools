-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
{-# LANGUAGE LambdaCase #-}

-----------------------------------------------------------------------------

-- |
-- Module      :  TSL
-- Maintainer  :  Felix Klein
--                Philippe Heim
--                Gideon Geier
--                Marvin Stenger
--
--
-- TSL tools library interface.
module TSL
  ( -- * Formula Structure
    Formula (..),
    SignalTerm (..),
    FunctionTerm (..),
    PredicateTerm (..),
    updates,
    checks,
    inputs,
    outputs,
    functions,
    predicates,
    encodeInputAP,
    encodeOutputAP,
    decodeInputAP,
    decodeOutputAP,
    size,

    -- * TSL Utilities
    DependencyRepresentation (..),
    Specification (..),
    fromTSL,
    tslFormula,
    toFormula,
    toTSL,
    toTLSF,
    toTOML,
    split,
    splitAssumptions,
    specifications2dependencies,
    tlsfToTslTerm,

    -- * CFM Utilities
    CodeTarget (..),
    CFM,
    ModuleName,
    FunctionName,
    fromCFM,
    statistics,
    symbolTable,
    implementHoa,

    -- * Symbol Table
    SymbolTable,
    Kind (..),
    stName,
    stArgs,
    stDeps,
    stKind,
    toCSV,

    -- * Simulation
    simulate,

    -- * Error Handling
    Error,
    unwrap,

    -- * Preprocessor
    preprocess,

    -- * Modulo Theories
    Cfg (..),
    predsFromSpec,
    cfgFromSpec,
    Theory,
    TheoryPredicate,
    tUninterpretedFunctions,
    readTheory,
    generateConsistencyAssumptions,
    consistencyDebug,
    ConsistencyDebugInfo (..),
    generateSygusAssumptions,
    sygusDebug,
    SygusDebugInfo (..),
    IntermediateResults (..),
    buildDtoList,
  )
where

-----------------------------------------------------------------------------

import qualified Hanoi as H (HOA (..))
import TSL.CFM (CFM, fromCFM, statistics, symbolTable)
import TSL.Dependency
  ( DependencyRepresentation (..),
    specifications2dependencies,
  )
import TSL.Error (Error, unwrap)
import TSL.Logic
  ( Formula (..),
    FunctionTerm (..),
    PredicateTerm (..),
    SignalTerm (..),
    checks,
    decodeInputAP,
    decodeOutputAP,
    encodeInputAP,
    encodeOutputAP,
    functions,
    inputs,
    outputs,
    predicates,
    size,
    tslFormula,
    updates,
  )
import TSL.ModuloTheories.Cfg (Cfg (..), cfgFromSpec)
import TSL.ModuloTheories.ConsistencyChecking
  ( ConsistencyDebugInfo (..),
    consistencyDebug,
    generateConsistencyAssumptions,
  )
import TSL.ModuloTheories.Debug (IntermediateResults (..))
import TSL.ModuloTheories.Predicates (TheoryPredicate, predsFromSpec)
import TSL.ModuloTheories.Sygus
  ( SygusDebugInfo (..),
    buildDtoList,
    generateSygusAssumptions,
    sygusDebug,
  )
import TSL.ModuloTheories.Theories (Theory (..), readTheory, tUninterpretedFunctions)
import TSL.Preprocessor (preprocess)
import TSL.Reader (fromTSL)
import TSL.Simulation (simulate)
import TSL.Specification (Specification (..), toFormula, toTSL)
import TSL.Splitter (split, splitAssumptions)
import TSL.SymbolTable (Kind (..), SymbolTable (..), toCSV)
import TSL.TLSF
  ( tlsfToTslTerm,
    toTLSF,
  )
import TSL.TOML (toTOML)
import qualified TSL.Writer.HOA.Arduino as Arduino (implementHoa)
import qualified TSL.Writer.HOA.JavaScript as JS (implementHoa)
import qualified TSL.Writer.HOA.Python as Python (implementHoa)
import qualified TSL.Writer.HOA.Verilog as Verilog (implementHoa)
import qualified TSL.Writer.HOA.XState as XState (implementHoa)

-----------------------------------------------------------------------------

data CodeTarget
  = Python
  | Arduino
  | JS
  | Verilog
  | XState
  deriving (Show, Ord, Eq)

-----------------------------------------------------------------------------

type ModuleName = String

type FunctionName = String

-----------------------------------------------------------------------------

implementHoa ::
  Bool -> CodeTarget -> H.HOA -> String
implementHoa isCounter = \case
  Python -> Python.implementHoa isCounter
  XState -> XState.implementHoa
  JS -> JS.implementHoa isCounter
  Arduino -> Arduino.implementHoa isCounter
  Verilog -> Verilog.implementHoa isCounter

-----------------------------------------------------------------------------
