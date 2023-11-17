-- | The module reads a specification to the internal format.
module TSL.Base.Reader
  ( readTSL,
  )
where

import Control.Exception (assert)
import Control.Monad ((>=>))
import qualified Data.Array.IArray as A (Array, array, (!))
import Data.Function (on)
import Data.Graph (buildG, topSort, transposeG)
import qualified Data.IntMap as IM
  ( IntMap,
    fromList,
    keys,
    lookup,
    maxViewWithKey,
    member,
    minViewWithKey,
    null,
    toAscList,
    (!),
  )
import Data.List (groupBy, sortBy)
import Data.Maybe (fromJust, fromMaybe)
import Data.Set (Set, empty, insert, member, toList)
import TSL.Base.Binding (Binding (..), BoundExpr (..))
import TSL.Base.Eval (eval)
import TSL.Base.Expression
  ( Expr (..),
    Expr' (..),
    subExpressions,
  )
import TSL.Base.Logic (Formula (..))
import TSL.Base.Parser (parse)
import qualified TSL.Base.Parser.Data as PD (Specification (..))
import TSL.Base.Reader.Abstraction (abstract)
import TSL.Base.Reader.Bindings (specBindings)
import qualified TSL.Base.Reader.Data as RD (Specification (..))
import TSL.Base.Reader.InferType (inferTypes)
import TSL.Base.Reader.Sugar (replaceSugar)
import TSL.Base.Specification (Specification (..))
import TSL.Base.SymbolTable (IdRec (..), Kind (..), SymbolTable, symbolTable)
import TSL.Base.Types (ExprType (..), SectionType (..))
import TSL.Error (Error, unwrap)

-- | Parses a TSL specification.
readTSL :: String -> IO (Either Error Specification)
readTSL specStr = do
  spec <- unwrap $ parse specStr
  return $ process spec

process :: PD.Specification -> Either Error Specification
process =
  -- replace variable names by a unique identifier
  abstract
    >=>
    -- replace syntactic sugar constructs for later converison
    replaceSugar
    >=>
    -- retrieve the bindings of expression variables
    specBindings
    >=>
    -- infer types and typecheck
    inferTypes
    >=>
    -- lift reader specification to global specification
    \s@RD.Specification {RD.sections} -> do
      let st = symtable s
      es <- eval st $ map snd sections
      return
        Specification
          { assumptions =
              [ initiate (st, f)
                | (st, f) <- zip (map fst sections) es,
                  assumption st
              ],
            guarantees =
              [ initiate (st, f)
                | (st, f) <- zip (map fst sections) es,
                  not (assumption st)
              ],
            symboltable = st
          }
  where
    assumption = \case
      InitiallyAssume -> True
      Assume {} -> True
      AlwaysAssume {} -> True
      _ -> False

initiate ::
  (SectionType, Formula Int) -> Formula Int
initiate (t, fml) = case t of
  InitiallyAssume -> fml
  Assume n -> iterate Next fml !! n
  AlwaysAssume n -> iterate Next (Globally fml) !! n
  InitiallyGuarantee -> fml
  Guarantee n -> iterate Next fml !! n
  AlwaysGuarantee n -> iterate Next (Globally fml) !! n

symtable ::
  RD.Specification -> SymbolTable
symtable
  RD.Specification
    { RD.definitions,
      RD.sections,
      RD.scopes,
      RD.types,
      RD.dependencies,
      RD.names,
      RD.bindings,
      RD.arguments,
      RD.positions
    } =
    let -- minimal element (taken from 'names' table)
        minkey = key IM.minViewWithKey
        -- maximal element (taken from 'names' table)
        maxkey = key IM.maxViewWithKey
        -- get a list of all top-level expressions in the specification
        es = concatMap (getExprs . bVal) definitions ++ map snd sections
        -- get the list of all outputs of the specification
        so = foldl extractOutputs empty es
        -- get the list of all inputs of the specification
        si = foldl (extractInputs scopes types) empty es
        -- maps every output to its dependendencies, i.e., the functions
        -- and inputs it can be computed from
        oa =
          IM.fromList $
            map (\x -> (fst $ head x, map snd x)) $
              groupBy ((==) `on` fst) $
                sortBy (compare `on` fst) $
                  toList $
                    foldl extractOutputAssignments empty es

        idT i = {-updType si so i $ -} fromMaybe (TPoly i) $ IM.lookup i types

        -- list of identifiers sorted by dependencies
        is' =
          topSort $
            transposeG $
              buildG (minkey, maxkey) $
                concatMap (\(i, xs) -> map (i,) xs) $
                  IM.toAscList dependencies

        -- update mapping accoording to dependency order
        uD = (IM.fromList $ zip is' [minkey, minkey + 1 .. maxkey])

        -- update array according to depencency order
        aD :: A.Array Int Int
        aD = A.array (minkey, maxkey) $ IM.toAscList uD

        -- depencency ordering
        cmpD :: Int -> Int -> Ordering
        cmpD x y = compare (aD A.! x) (aD A.! y)

        -- ordering accoring to expression class, using dependency
        -- ordering for equivalent classes
        cmp a b =
          let aT = tEn so si a $ idT a
              bT = tEn so si b $ idT b
           in (if aT /= bT then compare aT bT else cmpD a b)

        -- sorted identifiers by above ordering
        is = sortBy cmp $ IM.keys names
     in symbolTable $
          A.array (minkey, maxkey) $
            map (\i -> (i, entry oa si so i)) is
    where
      getExprs = \case
        GuardedBinding xs -> xs
        PatternBinding x y -> [x, y]
        SetBinding x -> [x]
        RangeBinding x _ y _ -> [x, y]

      entry oa si so i =
        let t = fromMaybe (TPoly i) $ IM.lookup i types
            as = fromMaybe [] $ IM.lookup i arguments
            ds = fromMaybe [] $ IM.lookup i dependencies
         in IdRec
              { idName = assert (IM.member i names) (names IM.! i),
                idPos =
                  assert (IM.member i positions) $
                    Just (positions IM.! i),
                idArgs = as,
                idBindings =
                  assert (IM.member i bindings) $
                    Just (bindings IM.! i),
                idType = t,
                idDeps =
                  if member i so
                    then
                      ( case IM.lookup i oa of
                          Just xs -> i : xs
                          Nothing -> ds
                      )
                    else ds,
                idKind = case IM.lookup i scopes of
                  Just () -> Internal
                  Nothing
                    | member i so -> Output
                    | member i si -> Input
                    | predicate t -> Predicate
                    | otherwise -> case t of
                        TSignal {} -> Constant
                        _ -> Function
              }

      predicate = \case
        TSignal TBoolean -> True
        TFml _ x -> predicate x
        _ -> False

      tEn ::
        Set Int -> Set Int -> Int -> ExprType -> Int

      tEn so si i = \case
        TSignal {}
          | member i si -> 0
          | member i so -> 1
          | otherwise -> 2
        TFml _ (TSignal TBoolean) -> 3
        TFml {} -> 4
        _ -> 5

      key f
        | IM.null names = 0
        | otherwise =
            fst $ fst $ fromJust $ f names

extractInputs ::
  IM.IntMap () -> IM.IntMap ExprType -> Set Int -> Expr Int -> Set Int
extractInputs sc tt a e@Expr {expr} = case expr of
  BaseId i -> case assert (IM.member i tt) (tt IM.! i) of
    TSignal {} -> case IM.lookup i sc of
      Nothing -> insert i a
      Just () -> a
    _ -> a
  _ -> foldl (extractInputs sc tt) a $ subExpressions e

extractOutputs ::
  Set Int -> Expr Int -> Set Int
extractOutputs a e@Expr {expr} = case expr of
  BaseUpd _ x -> insert x a
  _ -> foldl extractOutputs a $ subExpressions e

extractOutputAssignments ::
  Set (Int, Int) -> Expr Int -> Set (Int, Int)
extractOutputAssignments a e@Expr {expr} = case expr of
  BaseUpd x i -> collect i a x
  _ -> foldl extractOutputAssignments a $ subExpressions e
  where
    collect i a e@Expr {} = case expr of
      BaseFn x y -> collect i (collect i a x) y
      BaseConFn j -> insert (i, j) a
      BaseId j -> insert (i, j) a
      _ -> foldl (collect i) a $ subExpressions e
