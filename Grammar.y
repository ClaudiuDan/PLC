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
    '[' { TokenOpenMat _ }
    ']' { TokenCloseMat _ }
    ';' { TokenEndExpr _ }

%left '+' '-'
%left '*' '/'
%left '^'
%%
ListExp : Exp { [$1] }
        | Exp ListExp { $1 : $2 }

Exp : loop Exp ListExp endLoop   { Loop $2 $3 }
    | var '[' int ']' '[' int ']' { Mat2 $1 $3 $6}
    | var '[' int ']'        { Mat1 $1 $3 }
    | print Exp              { Print $2 }
    | var '=' Exp            { Assign $1 $3 }
    | Exp '+' Exp            { Plus $1 $3 }
    | Exp '-' Exp            { Minus $1 $3 }
    | Exp '*' Exp            { Times $1 $3 }
    | Exp '/' Exp            { Div $1 $3 }
    | Exp '^' Exp            { Expo $1 $3 }
    | '(' Exp ')'            { $2 }
    | int                    { Int $1 }
    | var                    { Var $1 }

{
parseError :: [Token] -> a
parseError []     = error "Unknown Parse error"
parseError (t:ts) = error ("Parse error at line:column " ++ (tokenPosn t))

data Exp =  Plus Exp Exp
         | Assign String Exp
         | Print Exp
         | Loop Exp [Exp]
         | Minus Exp Exp
         | Times Exp Exp
         | Div Exp Exp
         | Expo Exp Exp
         | Int Int
         | Var String
         | Mat2 String Int Int
         | Mat1 String Int
         deriving Show
}
