-- | Utilities to translate between TSL and TLSF.
-- Note that the translation from TSL to TLSF
-- is an under-approximation.
module TSL.TLSF
  ( lower,
    lower',
    tlsfToTslTerm,
  )
where

import Data.Function (on)
import Data.List
  ( groupBy,
    isPrefixOf,
  )
import Data.Set (elems, toList, union)
import qualified Data.Set as S (map)
import TSL.Base.Logic
  ( Formula (..),
    SignalTerm (..),
    checks,
    decodeInputAP,
    decodeOutputAP,
    exactlyOne,
    outputs,
    tlsfFormula,
    tslFormula,
    updates,
  )
import TSL.Base.Reader (readTSL)
import TSL.Base.Specification (Specification (..), toFormula)
import TSL.Base.SymbolTable (stName)
import TSL.Error (unwrap)

-- | Creates the LTL under-approximation in TLSF for a given TSL
-- specification (String).
lower' :: String -> IO String
lower' specStr = do
  spec <- readTSL specStr
  spec' <- unwrap spec
  return $ lower spec'

-- | Creates the LTL under-approximation in TLSF for a given TSL
-- specification.
lower :: Specification -> String
lower Specification {assumptions, guarantees, symboltable} =
  unlines
    [ "INFO {",
      "  TITLE:       \"Converted TSL Specification\"",
      "  DESCRIPTION: \"TSL specification, which has been converted to TLSF.\"",
      "  SEMANTICS:   Mealy",
      "  TARGET:      Mealy",
      "}",
      "MAIN {",
      if null ins
        then ""
        else
          unlines
            [ "  INPUTS {",
              concatMap ((++ ";\n") . ("    " ++)) ins ++ "  }"
            ],
      if null outs
        then ""
        else
          unlines
            [ "  OUTPUTS {",
              concatMap ((++ ";\n") . ("    " ++)) outs ++ "  }"
            ],
      "  ASSUME {",
      unlines $ map (\x -> "    " ++ toTLSF x ++ ";") assumptions,
      "  }\n",
      "  GUARANTEE {",
      unlines $ map (\x -> "    " ++ toTLSF x ++ ";") (mutual ++ [formula]),
      "  }",
      "}"
    ]
  where
    formula = toFormula assumptions guarantees

    toTLSF :: Formula Int -> String
    toTLSF =
      tlsfFormula (stName symboltable)

    ins =
      map (toTLSF . Check) $
        toList $
          checks formula

    outs =
      map (toTLSF . uncurry Update) upds

    upds =
      elems $
        union (updates formula) $
          S.map (\x -> (x, Signal x)) $
            outputs formula

    mutual =
      map (Globally . exactlyOne . map (uncurry Update)) $
        groupBy ((==) `on` fst) upds

-- | Translates tlsf term back into a TSL predicate or update term
-- only works on tslf generated from a TSL spec
tlsfToTslTerm :: String -> String
tlsfToTslTerm t =
  if "p0" `isPrefixOf` t
    then generateTSLString Check decodeInputAP t
    else generateTSLString (uncurry Update) decodeOutputAP t

generateTSLString :: (b -> Formula String) -> (String -> Either a b) -> String -> String
generateTSLString tslType decoder x =
  either (const "ERR") (tslFormula id . tslType) $
    decoder x
