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
  print             { \p s -> TokenPrint p         }
  printString       { \p s -> TokenPrintString p   }   
  sqrt              { \p s -> TokenSqrt p          }
  read              { \p s -> TokenRead p          }
  \^                { \p s -> TokenExp p           }
  wi                { \p s -> TokenWhileInput p    }
  whileInput        { \p s -> TokenWhileInput p    }
  endWhileInput     { \p s -> TokenEndWhileInput p }
  notEOF            { \p s -> TokenNotEOF p        }
  endNotEOF         { \p s -> TokenEndNotEOF p     }
  loop              { \p s -> TokenLoop p          }
  endLoop           { \p s -> TokenEndLoop p       }
  $digit+           { \p s -> TokenInt p (read s)  }
  \=                { \p s -> TokenEq p            }
  \>                { \p s -> TokenHigher p        }
  \<                { \p s -> TokenLess p          }
  \+                { \p s -> TokenPlus p          }
  \-                { \p s -> TokenMinus p         }
  \*                { \p s -> TokenTimes p         }
  \/                { \p s -> TokenDiv p           }
  \(                { \p s -> TokenLParen p        }
  \)                { \p s -> TokenRParen p        }
  \[                { \p s -> TokenOpenVec p       }
  \]                { \p s -> TokenCloseVec p      }
  if                { \p s -> TokenIf p            }
  endIf             { \p s -> TokenEndIf p         }
  $alpha [$alpha $digit \_ \’]*   { \p s -> TokenVar p s }

{
-- Each action has type :: String -> Token
-- The token type:
data Token =
  TokenInt      AlexPosn Int  |
  TokenPrint    AlexPosn      |
  TokenEq       AlexPosn      |
  TokenMinus    AlexPosn      |
  TokenPlus     AlexPosn      |
  TokenWhileInput AlexPosn    |
  TokenEndWhileInput AlexPosn |
  TokenLoop     AlexPosn |
  TokenExp      AlexPosn |
  TokenEndLoop  AlexPosn |
  TokenSqrt     AlexPosn |
  TokenTimes    AlexPosn |
  TokenDiv      AlexPosn |
  TokenLParen   AlexPosn |
  TokenRParen   AlexPosn |
  TokenRead     AlexPosn |
  TokenNotEOF      AlexPosn |
  TokenEndNotEOF   AlexPosn |
  TokenOpenVec     AlexPosn |
  TokenCloseVec    AlexPosn |
  TokenPrintString AlexPosn |
  TokenHigher AlexPosn |
  TokenLess AlexPosn |
  TokenIf AlexPosn |
  TokenEndIf AlexPosn |
  TokenVar         AlexPosn String
  deriving (Eq,Show)


tokenPosn :: Token -> String
tokenPosn (TokenInt (AlexPn a l c) _ )      = show(l) ++ ":" ++ show(c)
tokenPosn (TokenPrint (AlexPn a l c) )      = show(l) ++ ":" ++ show(c)
tokenPosn (TokenEq (AlexPn a l c) )         = show(l) ++ ":" ++ show(c)
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
tokenPosn (TokenRead (AlexPn a l c) )       = show(l) ++ ":" ++ show(c)
tokenPosn (TokenPrintString (AlexPn a l c) ) = show(l) ++ ":" ++ show(c)

tokenPosn (TokenWhileInput (AlexPn a l c) )       = show(l) ++ ":" ++ show(c)
tokenPosn (TokenEndWhileInput (AlexPn a l c) )       = show(l) ++ ":" ++ show(c)
tokenPosn (TokenNotEOF (AlexPn a l c) )       = show(l) ++ ":" ++ show(c)
tokenPosn (TokenEndNotEOF (AlexPn a l c) )       = show(l) ++ ":" ++ show(c)
tokenPosn (TokenOpenVec (AlexPn a l c) )       = show(l) ++ ":" ++ show(c)
tokenPosn (TokenCloseVec (AlexPn a l c) )       = show(l) ++ ":" ++ show(c)

tokenPosn (TokenHigher (AlexPn a l c) )       = show(l) ++ ":" ++ show(c)
tokenPosn (TokenLess (AlexPn a l c) )       = show(l) ++ ":" ++ show(c)
tokenPosn (TokenIf (AlexPn a l c) )       = show(l) ++ ":" ++ show(c)
tokenPosn (TokenEndIf (AlexPn a l c) )       = show(l) ++ ":" ++ show(c)
}
