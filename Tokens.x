{
module Tokens where
}

%wrapper "posn"
$digit = 0-9
-- digits
$alpha = [a-zA-Z]
-- alphabetic characters

tokens :-
$white+       ;
  "--".*        ;
  "Genesis".* ;
  "End Genesis";
  times;
  print             { \p s -> TokenPrint p }
  sqrt              { \p s -> TokenSqrt p }
  \^                { \p s -> TokenExp p }
  loop              { \p s -> TokenLoop p }
  endLoop           { \p s -> TokenEndLoop p }
  $digit+           { \p s -> TokenInt p (read s) }
  \=                { \p s -> TokenEq p }
  \+                { \p s -> TokenPlus p }
  \-                { \p s -> TokenMinus p }
  \*                { \p s -> TokenTimes p }
  \/                { \p s -> TokenDiv p }
  \(                { \p s -> TokenLParen p }
  \)                { \p s -> TokenRParen p }
  \;                { \p s -> TokenEndExpr p }
  $alpha [$alpha $digit \_ \’]*   { \p s -> TokenVar p s }

{
-- Each action has type :: String -> Token
-- The token type:
data Token =
  TokenInt      AlexPosn Int |
  TokenPrint    AlexPosn |
  TokenEq       AlexPosn |
  TokenEndExpr  AlexPosn |
  TokenMinus    AlexPosn |
  TokenPlus     AlexPosn |
  TokenLoop     AlexPosn |
  TokenExp      AlexPosn |
  TokenEndLoop  AlexPosn |
  TokenSqrt     AlexPosn |
  TokenTimes    AlexPosn |
  TokenDiv      AlexPosn |
  TokenLParen   AlexPosn |
  TokenRParen   AlexPosn |
  TokenVar      AlexPosn String 
  deriving (Eq,Show)


tokenPosn :: Token -> String
tokenPosn (TokenInt (AlexPn a l c) _ )      = show(l) ++ ":" ++ show(c)
tokenPosn (TokenPrint (AlexPn a l c) )      = show(l) ++ ":" ++ show(c)
tokenPosn (TokenEq (AlexPn a l c) )         = show(l) ++ ":" ++ show(c)
tokenPosn (TokenEndExpr (AlexPn a l c) )    = show(l) ++ ":" ++ show(c)
tokenPosn (TokenMinus (AlexPn a l c) )      = show(l) ++ ":" ++ show(c)
tokenPosn (TokenPlus (AlexPn a l c) )       = show(l) ++ ":" ++ show(c)
tokenPosn (TokenLoop (AlexPn a l c) )       = show(l) ++ ":" ++ show(c)
tokenPosn (TokenExp (AlexPn a l c) )        = show(l) ++ ":" ++ show(c)
tokenPosn (TokenEndLoop (AlexPn a l c) )    = show(l) ++ ":" ++ show(c)
tokenPosn (TokenSqrt (AlexPn a l c) )       = show(l) ++ ":" ++ show(c)
tokenPosn (TokenTimes (AlexPn a l c) )      = show(l) ++ ":" ++ show(c)
tokenPosn (TokenDiv (AlexPn a l c) )        = show(l) ++ ":" ++ show(c)
tokenPosn (TokenLParen (AlexPn a l c) )     = show(l) ++ ":" ++ show(c)
tokenPosn (TokenRParen (AlexPn a l c) )     = show(l) ++ ":" ++ show(c)
tokenPosn (TokenVar (AlexPn a l c) _)       = show(l) ++ ":" ++ show(c)




}
