{
module Tokens where
}

%wrapper "basic"
$digit = 0-9
-- digits
$alpha = [a-zA-Z]
-- alphabetic characters

tokens :-
$white+       ;
  "--".*        ;
  "Genesis".* ;
  "End Genesis";
  print { \s -> TokenPrint }
  sqrt { \s -> TokenSqrt }
  \^ { \s -> TokenExp }
  loop { \s -> TokenLoop }
  endLoop { \s -> TokenEndLoop }
  times;
  $digit+       { \s -> TokenInt (read s) }
  \=          { \s -> TokenEq }
  \+          { \s -> TokenPlus }
  \-          { \s -> TokenMinus }
  \*          { \s -> TokenTimes }
  \/          { \s -> TokenDiv }
  \(          { \s -> TokenLParen }
  \)          { \s -> TokenRParen }
  \[          { \s -> TokenOpenMat }
  \;          { \s -> TokenEndExpr }
  \]          { \s -> TokenCloseMat }
  $alpha [$alpha $digit \_ \’]*   { \s -> TokenVar s }

{
-- Each action has type :: String -> Token
-- The token type:
data Token =
  TokenInt Int |
  TokenPrint   |
  TokenEq |
  TokenEndExpr |
  TokenMinus |
  TokenPlus |
  TokenLoop |
  TokenExp |
  TokenEndLoop |
  TokenSqrt |
  TokenTimes |
  TokenDiv |
  TokenLParen |
  TokenRParen |
  TokenVar String |
  TokenOpenMat |
  TokenCloseMat
  deriving (Eq,Show)

}
