-- | Adds preprocessing capabilities to TSL syntax.
module TSL.Preprocessor
  ( preprocess,
    parse,
  )
where

-- Imports

import Control.Monad (forM_, void)
import Data.Functor.Identity (Identity)
import Numeric (showFFloat)
import TSL.Error (Error, genericError, parseError, unwrap, warn)
import TSL.ModuloTheories.Theories (Theory (..))
import Text.Parsec
  ( alphaNum,
    char,
    endBy,
    letter,
    many,
    oneOf,
    option,
    sepBy,
    spaces,
    try,
    (<?>),
    (<|>),
  )
import qualified Text.Parsec as Parsec
import Text.Parsec.Expr
  ( Assoc (..),
    Operator (..),
    buildExpressionParser,
  )
import Text.Parsec.Language (emptyDef)
import Text.Parsec.String (Parser)
import qualified Text.Parsec.Token as Token

-- Utility Functions

surround :: a -> a -> [a] -> [a]
surround left right inside = left : inside ++ [right]

parenthize :: String -> String
parenthize = surround '(' ')'

bracketify :: String -> String
bracketify = surround '[' ']'

data Specification = Specification (Maybe Theory) [Section]
  deriving (Eq)

data Section = Section (Maybe TemporalWrapper) SectionType [Expr]
  deriving (Show, Eq)

data TemporalWrapper = Initially | Always
  deriving (Show, Eq)

data SectionType = Assume | Guarantee
  deriving (Show, Eq)

data Expr
  = PredicateExpr Predicate
  | Update Signal Signal
  | Unary UnaryOp Expr
  | Binary BinaryOp Expr Expr
  deriving (Show, Eq)

data Predicate
  = BinaryPredicate BinaryComparator Signal Signal
  | UninterpretedPredicate String [Signal]
  deriving (Show)

data UnaryOp = Not | Next | Globally | Eventually
  deriving (Show, Eq)

data BinaryOp
  = And
  | Or
  | Implies
  | Iff
  | Until
  | WeakUntil
  | Release
  deriving (Show, Eq)

data Signal
  = TSLInt Integer
  | TSLReal Double
  | Symbol String
  | BinaryFunction BinaryFunction Signal Signal
  | UninterpretedFunction String [Signal]
  deriving (Show)

data BinaryComparator
  = Eq
  | Lt
  | Gt
  | Lte
  | Gte
  deriving (Show, Eq)

data BinaryFunction
  = Add
  | Sub
  | Mult
  | Div
  deriving (Show, Eq)

-- Fmt instances

class (Show a) => Fmt a where
  fmt :: a -> String

instance (Fmt a) => Fmt [a] where
  fmt = concatMap fmt

instance Fmt Char where
  fmt c = [c]

instance Fmt Specification where
  fmt (Specification (Just theory) sections) = unlines $ ('#' : show theory) : map fmt sections
  fmt (Specification Nothing sections) = unlines $ map fmt sections

instance Show Specification where
  show = fmt

instance Fmt Section where
  fmt (Section temporalWrapper sectionType expressions) =
    unlines
      [header ++ " {", unlines (map fmtExpr expressions), "}"]
    where
      header =
        (++ fmt sectionType)
          ( case temporalWrapper of
              Nothing -> ""
              Just tw -> fmt tw ++ " "
          )
      fmtExpr = (++ ";") . fmt

instance Fmt TemporalWrapper where
  fmt = \case
    Initially -> "initially"
    Always -> "always"

instance Fmt SectionType where
  fmt = \case
    Assume -> "assume"
    Guarantee -> "guarantee"

instance Fmt Expr where
  fmt = \case
    PredicateExpr p -> fmt p
    Update dst src -> bracketify $ unwords [fmt dst, "<-", fmt src]
    Unary op expr -> parenthize $ unwords [fmt op, fmt expr]
    Binary op ex1 ex2 -> parenthize $ unwords [fmt ex1, fmt op, fmt ex2]

instance Fmt Predicate where
  fmt = \case
    BinaryPredicate comp lhs rhs ->
      parenthize $ unwords [fmt comp, fmt lhs, fmt rhs]
    UninterpretedPredicate p args -> parenthize $ unwords $ p : map fmt args

instance Fmt UnaryOp where
  fmt = \case
    Not -> "!"
    Next -> "X"
    Globally -> "G"
    Eventually -> "F"

instance Fmt BinaryOp where
  fmt = \case
    And -> "&&"
    Or -> "||"
    Implies -> "->"
    Iff -> "<->"
    Until -> "U"
    WeakUntil -> "W"
    Release -> "R"

numSign :: (Ord a, Num a) => a -> String
numSign x = if x < 0 then "Neg" else ""

instance Fmt Signal where
  fmt = \case
    TSLInt s -> "int" ++ numSign s ++ show (abs s) ++ "()"
    TSLReal s -> "real" ++ numSign s ++ showFFloat Nothing (abs s) "" ++ "()"
    Symbol s -> s
    BinaryFunction f lhs rhs -> parenthize $ unwords [fmt f, fmt lhs, fmt rhs]
    UninterpretedFunction f [] -> f
    UninterpretedFunction f args -> parenthize $ unwords $ f : map fmt args

instance Fmt BinaryFunction where
  fmt = \case
    Add -> "add"
    Sub -> "sub"
    Mult -> "mult"
    Div -> "div"

instance Fmt BinaryComparator where
  fmt = \case
    Eq -> "eq"
    Lt -> "lt"
    Gt -> "gt"
    Lte -> "lte"
    Gte -> "gte"

-- Eq instances

instance Eq Predicate where
  (==) = \case
    (BinaryPredicate comp lhs rhs) -> \case
      (BinaryPredicate comp' lhs' rhs') ->
        comp == comp' && lhs == lhs' && rhs == rhs'
      (UninterpretedPredicate p [lhs', rhs']) ->
        fmt comp == p && lhs == lhs' && rhs == rhs'
      _ -> False
    u@(UninterpretedPredicate p1 args1) -> \case
      (UninterpretedPredicate p2 args2) -> p1 == p2 && args1 == args2
      binary -> binary == u

instance Eq Signal where
  int@(TSLInt _) == other = fmt int == fmt other
  real@(TSLReal _) == other = fmt real == fmt other
  (Symbol s) == (UninterpretedFunction f []) = s == f
  symbol@(Symbol _) == other = fmt symbol == fmt other
  (BinaryFunction f lhs rhs) == (BinaryFunction g lhs' rhs') =
    f == g && lhs == lhs' && rhs == rhs'
  (BinaryFunction f lhs rhs) == (UninterpretedFunction g [lhs', rhs']) =
    fmt f == g && lhs == lhs' && rhs == rhs'
  (BinaryFunction {}) == _ = False
  (UninterpretedFunction f args) == (UninterpretedFunction g args') =
    f == g && args == args'
  uninterpreted@(UninterpretedFunction _ _) == other = other == uninterpreted

-- Lexer

binOpNames :: [String]
binOpNames = ["=", "<", ">", "<=", ">=", "+", "-", "*", "/"]

sectionNames :: [String]
sectionNames = ["initially", "always", "assume", "guarantee"]

temporalOpNames :: [String]
temporalOpNames = ["R", "U", "W", "X", "F"]

tslDef :: Token.LanguageDef a
tslDef =
  emptyDef
    { Token.identStart = char '_' <|> letter,
      Token.identLetter = alphaNum <|> oneOf "._",
      Token.commentLine = "//",
      Token.commentStart = "/*",
      Token.commentEnd = "*/",
      Token.nestedComments = True,
      Token.caseSensitive = True,
      Token.opStart = oneOf "!&|=/+*[-<",
      Token.opLetter = oneOf "!&|=/+*[]<->",
      Token.reservedNames = sectionNames ++ temporalOpNames,
      Token.reservedOpNames = binOpNames
    }

lexer :: Token.GenTokenParser String p Identity
lexer = Token.makeTokenParser tslDef

whiteSpace :: Parser ()
whiteSpace = Token.whiteSpace lexer

identifier :: Parser String
identifier = Token.identifier lexer

reserved :: String -> Parser ()
reserved = Token.reserved lexer

reservedOp :: String -> Parser ()
reservedOp = Token.reservedOp lexer

parens :: (Show a, Fmt a) => Parser a -> Parser a
parens = Token.parens lexer

braces :: (Show a, Fmt a) => Parser a -> Parser a
braces = Token.braces lexer

brackets :: Parser a -> Parser a
brackets = Token.brackets lexer

lexeme :: Parser a -> Parser a
lexeme parser = do
  x <- parser
  _ <- whiteSpace
  return x

sign :: (Num a) => Parser (a -> a)
sign = (char '-' >> return negate) <|> (char '+' >> return id) <|> return id

integer :: Parser Integer
integer = lexeme (sign <*> Token.natural lexer) <?> "integer"

float :: Parser Double
float = lexeme (sign <*> Token.float lexer) <?> "float"

semicolon :: Parser ()
semicolon = void (Token.semi lexer)

exprOperators :: [[Operator String () Identity Expr]]
exprOperators =
  [ [ Prefix (reservedOp "!" >> return (Unary Not)),
      Prefix (reserved "X" >> return (Unary Next)),
      Prefix (reserved "G" >> return (Unary Globally)),
      Prefix (reserved "F" >> return (Unary Eventually))
    ],
    [ Infix (reservedOp "&&" >> return (Binary And)) AssocLeft,
      Infix (reservedOp "||" >> return (Binary Or)) AssocLeft,
      Infix (reservedOp "->" >> return (Binary Implies)) AssocLeft,
      Infix (reservedOp "<->" >> return (Binary Iff)) AssocLeft,
      Infix (reserved "U" >> return (Binary Until)) AssocLeft,
      Infix (reserved "W" >> return (Binary WeakUntil)) AssocLeft,
      Infix (reserved "R" >> return (Binary Release)) AssocLeft
    ]
  ]

binaryFunctions :: [[Operator String () Identity Signal]]
binaryFunctions =
  [ [ Infix (reservedOp "+" >> return (BinaryFunction Add)) AssocLeft,
      Infix (reservedOp "-" >> return (BinaryFunction Sub)) AssocLeft,
      Infix (reservedOp "*" >> return (BinaryFunction Mult)) AssocLeft,
      Infix (reservedOp "/" >> return (BinaryFunction Div)) AssocLeft
    ]
  ]

-- Parser

specParser :: Parser Specification
specParser = do
  whiteSpace
  theory <- option Nothing (Just <$> theoryParser)
  -- whiteSpace
  sections <- sectionParser `sepBy` spaces
  return $ Specification theory sections

theoryParser :: Parser Theory
theoryParser = do
  (reserved "#UF" >> return Uf)
    <|> (reserved "#EUF" >> return EUf)
    <|> (reserved "#LIA" >> return Lia)

-- <|> return Nothing

sectionParser :: Parser Section
sectionParser = do
  temporalWrapper <- temporalParser
  sectionType <- sectionTypeParser
  exprs <- braces $ exprParser `endBy` semicolon
  return $ Section temporalWrapper sectionType exprs
  where
    temporalParser :: Parser (Maybe TemporalWrapper)
    temporalParser =
      (reserved "initially" >> return (Just Initially))
        <|> (reserved "always" >> return (Just Always))
        <|> return Nothing

    sectionTypeParser :: Parser SectionType
    sectionTypeParser =
      (reserved "guarantee" >> return Guarantee)
        <|> (reserved "assume" >> return Assume)

exprParser :: Parser Expr
exprParser = buildExpressionParser exprOperators exprTerm

exprPrefixParser :: Parser Expr
exprPrefixParser = prefixParser <*> exprParser
  where
    prefixParser :: Parser (Expr -> Expr)
    prefixParser =
      (reservedOp "!" >> return (Unary Not))
        <|> (reserved "X" >> return (Unary Next))
        <|> (reserved "G" >> return (Unary Globally))
        <|> (reserved "F" >> return (Unary Eventually))

exprTerm :: Parser Expr
exprTerm =
  updateTerm
    <|> try (fmap PredicateExpr predicateParser)
    <|> parens exprParser
    <|> exprPrefixParser

predicateParser :: Parser Predicate
predicateParser = try interpreted <|> uninterpreted
  where
    uninterpreted :: Parser Predicate
    uninterpreted = fmap (uncurry UninterpretedPredicate) functionLiteralParser

    interpreted :: Parser Predicate
    interpreted = do
      lhs <- signalParser
      comparator <- comparatorParser
      BinaryPredicate comparator lhs <$> signalParser

comparatorParser :: Parser BinaryComparator
comparatorParser =
  (reservedOp "=" >> return Eq)
    <|> (reservedOp "<=" >> return Lte)
    <|> (reservedOp ">=" >> return Gte)
    <|> (reservedOp "<" >> return Lt)
    <|> (reservedOp ">" >> return Gt)

updateTerm :: Parser Expr
updateTerm = brackets $ do
  dst <- identifier
  _ <- reservedOp "<-"
  Update (Symbol dst) <$> signalParser

signalParser :: Parser Signal
signalParser = buildExpressionParser binaryFunctions signalTerm

literalParser :: Parser Signal
literalParser = try realParser <|> intParser <|> constantParser
  where
    intParser = fmap TSLInt integer
    realParser = fmap TSLReal float
    constantParser = do
      symbol <- identifier
      nullary <- Parsec.string "()"
      _ <- spaces
      return $ Symbol $ symbol ++ nullary

signalTerm :: Parser Signal
signalTerm =
  parens signalParser
    <|> try literalParser
    <|> try (fmap (uncurry UninterpretedFunction) functionLiteralParser)
    <|> fmap Symbol identifier

functionLiteralParser :: Parser (String, [Signal])
functionLiteralParser = do
  function <- identifier
  args <- many argParser
  return (function, args)
  where
    argParser =
      try literalParser <|> fmap Symbol (try identifier) <|> try signalParser

parse :: String -> Either Error Specification
parse input =
  let result = Parsec.parse (specParser <* Parsec.eof) errMsg input
   in case result of
        Left err -> parseError err
        Right spec -> Right spec
  where
    errMsg =
      "\n\nParser Failed! Input was:\n\n"
        ++ unlines (map ('\t' :) (lines input))
        ++ "\n\n"

preprocess :: String -> IO String
preprocess input = do
  spec <- unwrap $ parse input
  check spec
  return $ fmt spec

check :: Specification -> IO ()
check (Specification mTheory sections) = case mTheory of
  Nothing -> checkUf False sections -- only warn if no tag
  Just Uf -> checkUf True sections
  Just EUf -> checkEUf sections
  Just Lia -> return ()

checkUf :: Bool -> [Section] -> IO ()
checkUf isError sections = forM_ sections checkUfSection
  where
    checkUfSection :: Section -> IO ()
    checkUfSection (Section _ _ exprs) = forM_ exprs checkUfExpr

    checkUfExpr :: Expr -> IO ()
    checkUfExpr (PredicateExpr p) = checkUfPredicate p
    checkUfExpr (Update sig1 sig2) = forM_ [sig1, sig2] checkUfSignal
    checkUfExpr (Unary _ e) = checkUfExpr e
    checkUfExpr (Binary _ e1 e2) = forM_ [e1, e2] checkUfExpr

    checkUfPredicate :: Predicate -> IO ()
    checkUfPredicate (UninterpretedPredicate _ sigs) = forM_ sigs checkUfSignal
    checkUfPredicate (BinaryPredicate binComparator _ _) = unsupported binComparator

    checkUfSignal :: Signal -> IO ()
    checkUfSignal (TSLInt _) =
      unsupported "integer"
    checkUfSignal (TSLReal _) =
      unsupported "real number "
    checkUfSignal (Symbol _) = return ()
    checkUfSignal (BinaryFunction binaryFunc _ _) = unsupported binaryFunc
    checkUfSignal (UninterpretedFunction _ sigs) = forM_ sigs checkUfSignal

    unsupported :: (Fmt a) => a -> IO ()
    unsupported x =
      let message = "'" ++ fmt x ++ "' is not available in Uf theory."
       in if isError
            then unwrap $ genericError message
            else warn message

checkEUf :: [Section] -> IO ()
checkEUf sections = forM_ sections checkEUfSection
  where
    checkEUfSection :: Section -> IO ()
    checkEUfSection (Section _ _ exprs) = forM_ exprs checkEUfExpr

    checkEUfExpr :: Expr -> IO ()
    checkEUfExpr (PredicateExpr p) = checkEUfPredicate p
    checkEUfExpr (Update sig1 sig2) = forM_ [sig1, sig2] checkEUfSignal
    checkEUfExpr (Unary _ e) = checkEUfExpr e
    checkEUfExpr (Binary _ e1 e2) = forM_ [e1, e2] checkEUfExpr

    checkEUfPredicate :: Predicate -> IO ()
    checkEUfPredicate (UninterpretedPredicate _ sigs) = forM_ sigs checkEUfSignal
    checkEUfPredicate (BinaryPredicate Eq sig1 sig2) = forM_ [sig1, sig2] checkEUfSignal
    checkEUfPredicate (BinaryPredicate binComparator _ _) = unsupported binComparator

    checkEUfSignal :: Signal -> IO ()
    checkEUfSignal (TSLInt _) =
      unsupported "integer"
    checkEUfSignal (TSLReal _) =
      unsupported "real"
    checkEUfSignal (Symbol _) = return ()
    checkEUfSignal (BinaryFunction binaryFunc _ _) = unsupported binaryFunc
    checkEUfSignal (UninterpretedFunction _ sigs) = forM_ sigs checkEUfSignal

    unsupported :: (Fmt a) => a -> IO ()
    unsupported x = unwrap $ genericError $ "'" ++ fmt x ++ "' is not available in EUf theory."
