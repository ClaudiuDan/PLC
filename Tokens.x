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
  times;
  free              { \p s -> TokenDelete p        }
  print             { \p s -> TokenPrint p         }
  sqrt              { \p s -> TokenSqrt p          }
  read              { \p s -> TokenRead p          }
  "<-"              { \p s -> TokenReadShort p          }
  \^                { \p s -> TokenExp p           }
  "..."             { \p s -> TokenWhileInputShort p    }
  whileInput        { \p s -> TokenWhileInput p    }
  "...;"            { \p s -> TokenEndWhileInputShort p }
  endWhileInput     { \p s -> TokenEndWhileInput p }
  "@"               { \p s -> TokenNotEOFShort p        }
  notEOF            { \p s -> TokenNotEOF p        }
  "@;"              { \p s -> TokenEndNotEOFShort p     }
  endNotEOF         { \p s -> TokenEndNotEOF p     }

  loop              { \p s -> TokenLoop p          }
  "&"               { \p s -> TokenLoopShort p          }
  endLoop           { \p s -> TokenEndLoop p       }
  "&;"              { \p s -> TokenEndLoopShort p       }
  \-$digit+         { \p s -> TokenInt p (read s)  }
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

  "|"                { \p s -> TokenIfShort p           }
  if                { \p s -> TokenIf p            }
  "|;"             { \p s -> TokenEndIfShort p          }
  endIf             { \p s -> TokenEndIf p         }
  \\                { \p s -> TokenBack p          }
  \:                { \p s -> TokenPoints p        }
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
  TokenBack AlexPosn |
  TokenPoints AlexPosn |
  TokenDelete AlexPosn |

  TokenWhileInputShort AlexPosn |
  TokenEndWhileInputShort AlexPosn |

  TokenNotEOFShort AlexPosn |
  TokenEndNotEOFShort AlexPosn |

  TokenLoopShort AlexPosn |
  TokenEndLoopShort AlexPosn |

  TokenIfShort AlexPosn |
  TokenEndIfShort AlexPosn |
  TokenReadShort AlexPosn |

  TokenVar         AlexPosn String
  deriving (Eq,Show)


tokenPosn :: Token -> String
tokenPosn (TokenInt (AlexPn a l c) _ )      = show(l) ++ ":" ++ show(c) ++ " \n •  Int was wrongly typed"
tokenPosn (TokenPrint (AlexPn a l c) )      = show(l) ++ ":" ++ show(c) ++ " \n •  Maybe you meant print ?"
tokenPosn (TokenEq (AlexPn a l c) )         = show(l) ++ ":" ++ show(c) ++ " \n •  Maybe you meant '= ?"
tokenPosn (TokenMinus (AlexPn a l c) )      = show(l) ++ ":" ++ show(c) ++ " \n •  Maybe you meant '-' ?"
tokenPosn (TokenPlus (AlexPn a l c) )       = show(l) ++ ":" ++ show(c) ++ " \n •  Maybe you meant '+' ?"

tokenPosn (TokenLoop (AlexPn a l c) )       = show(l) ++ ":" ++ show(c) ++ " \n •  Maybe you meant loop ?"
tokenPosn (TokenEndLoop (AlexPn a l c) )    = show(l) ++ ":" ++ show(c) ++ " \n •  Maybe you meant endLoop ?"
tokenPosn (TokenLoopShort (AlexPn a l c) )       = show(l) ++ ":" ++ show(c) ++ " \n •  Maybe you meant '->' ?"
tokenPosn (TokenEndLoopShort (AlexPn a l c) )    = show(l) ++ ":" ++ show(c) ++ " \n •  Maybe you meant '->;' ?"

tokenPosn (TokenExp (AlexPn a l c) )        = show(l) ++ ":" ++ show(c) ++ " \n •  Maybe you meant '^' ?"
tokenPosn (TokenSqrt (AlexPn a l c) )       = show(l) ++ ":" ++ show(c) ++ " \n •  Maybe you meant sqrt ?"
tokenPosn (TokenTimes (AlexPn a l c) )      = show(l) ++ ":" ++ show(c) ++ " \n •  Maybe you meant '*' ?"
tokenPosn (TokenDiv (AlexPn a l c) )        = show(l) ++ ":" ++ show(c) ++ " \n •  Maybe you meant '/' ?"
tokenPosn (TokenLParen (AlexPn a l c) )     = show(l) ++ ":" ++ show(c) ++ " \n •  Maybe you meant '(' ?"
tokenPosn (TokenRParen (AlexPn a l c) )     = show(l) ++ ":" ++ show(c) ++ " \n •  Maybe you meant ')' ?"
tokenPosn (TokenVar (AlexPn a l c) _)       = show(l) ++ ":" ++ show(c) ++ " \n •  Variable was wrongly typed"

tokenPosn (TokenRead (AlexPn a l c) )       = show(l) ++ ":" ++ show(c) ++ " \n •  Maybe you meant read ?"
tokenPosn (TokenReadShort (AlexPn a l c) )       = show(l) ++ ":" ++ show(c) ++ " \n •  Maybe you meant '<-' ?"

tokenPosn (TokenDelete (AlexPn a l c) )       = show(l) ++ ":" ++ show(c) ++ " \n •  Maybe you meant 'free' ?"



tokenPosn (TokenWhileInput (AlexPn a l c) )       = show(l) ++ ":" ++ show(c) ++ " \n •  Maybe you meant whileInput ?"
tokenPosn (TokenEndWhileInput (AlexPn a l c) )       = show(l) ++ ":" ++ show(c) ++ " \n •  Maybe you meant endWhileInput ?"
tokenPosn (TokenWhileInputShort (AlexPn a l c) )       = show(l) ++ ":" ++ show(c) ++ " \n •  Maybe you meant '...' ?"
tokenPosn (TokenEndWhileInputShort (AlexPn a l c) )       = show(l) ++ ":" ++ show(c) ++ " \n •  Maybe you meant '...;' ?"

tokenPosn (TokenNotEOF (AlexPn a l c) )       = show(l) ++ ":" ++ show(c) ++ " \n •  Maybe you meant notEOF ?"
tokenPosn (TokenEndNotEOF (AlexPn a l c) )       = show(l) ++ ":" ++ show(c) ++ " \n • Maybe you meant endNotEOF ?"
tokenPosn (TokenNotEOFShort (AlexPn a l c) )       = show(l) ++ ":" ++ show(c) ++ " \n •  Maybe you meant '@' ?"
tokenPosn (TokenEndNotEOFShort (AlexPn a l c) )       = show(l) ++ ":" ++ show(c) ++ " \n • Maybe you meant '@;' ?"


tokenPosn (TokenOpenVec (AlexPn a l c) )       = show(l) ++ ":" ++ show(c) ++ " \n •  Maybe you meant '[' ?"
tokenPosn (TokenCloseVec (AlexPn a l c) )       = show(l) ++ ":" ++ show(c) ++ " \n •  Maybe you meant ']' ?"

tokenPosn (TokenHigher (AlexPn a l c) )       = show(l) ++ ":" ++ show(c) ++ " \n • Maybe you meant '>' ?"
tokenPosn (TokenLess (AlexPn a l c) )       = show(l) ++ ":" ++ show(c) ++ " \n •  Maybe you meant '<' ?"

tokenPosn (TokenIf (AlexPn a l c) )       = show(l) ++ ":" ++ show(c) ++ " \n • Maybe you meant if ?"
tokenPosn (TokenEndIf (AlexPn a l c) )       = show(l) ++ ":" ++ show(c) ++ " \n • v Maybe you meant endIf ?"
tokenPosn (TokenIfShort (AlexPn a l c) )       = show(l) ++ ":" ++ show(c) ++ " \n • Maybe you meant '|' ?"
tokenPosn (TokenEndIfShort (AlexPn a l c) )       = show(l) ++ ":" ++ show(c) ++ " \n • v Maybe you meant '|;' ?"



tokenPosn (TokenBack (AlexPn a l c) )       = show(l) ++ ":" ++ show(c) ++ " \n • Maybe you meant '\\' ?"
tokenPosn (TokenPoints (AlexPn a l c) )       = show(l) ++ ":" ++ show(c) ++ " \n • Maybe you meant ':' ?"
}
