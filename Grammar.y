{
module Grammar where
import Tokens
}

%name parseCalc
%tokentype { Token }
%error { parseError }
%token
    int { TokenInt _ $$ }
    var { TokenVar _ $$ }
    print { TokenPrint _ }
    read { TokenRead _ }
    loop { TokenLoop _ }
    endLoop { TokenEndLoop _ }
    '=' { TokenEq _ }
    '+' { TokenPlus _ }
    '-' { TokenMinus _ }
    '*' { TokenTimes _ }
    '^' { TokenExp _ }
    '/' { TokenDiv _ }
    '(' { TokenLParen _ }
    ')' { TokenRParen _ }
    ';' { TokenEndExpr _ }

%left '+' '-'
%left '*' '/'
%left '^'
%%

ListStatement : Statement { [$1] }
              | Statement ListStatement { $1 : $2 }

Statement : loop Exp ListStatement endLoop { Loop $2 $3 }
          | var '=' Exp { Assign $1 $3 }
          | print Exp              { Print $2 }

ListExp : Exp { [$1] }
        | Exp ListExp { $1 : $2 }

Exp : Exp '+' Exp            { Plus $1 $3 }
    | Exp '-' Exp            { Minus $1 $3 }
    | Exp '*' Exp            { Times $1 $3 }
    | Exp '/' Exp            { Div $1 $3 }
    | Exp '^' Exp            { Expo $1 $3 }
    | read                   { Read }
    | '(' Exp ')'            { $2 }
    | int                    { Int $1 }
    | var                    { Var $1 }

{
parseError :: [Token] -> a
parseError []     = error "Unknown Parse error"
parseError (t:ts) = error ("Parse error at line:column " ++ (tokenPosn t))

data Exp =  Plus Exp Exp
         | Minus Exp Exp
         | Times Exp Exp
         | Div Exp Exp
         | Expo Exp Exp
         | Int Int
         | Var String
         | Read 
         deriving Show
         
data Statement = 
                 Assign String Exp
               | Loop Exp [Statement]
               | Print Exp
               deriving Show
}
