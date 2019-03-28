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
    printString { TokenPrintString _ }
    print { TokenPrint _ }
    read { TokenRead _ }
    loop { TokenLoop _ }
    endLoop { TokenEndLoop _ }
    wi        {TokenWhileInput _  }
    whileInput { TokenWhileInput _ }
    endWhileInput { TokenEndWhileInput _ }
    notEOF { TokenNotEOF _ }
    endNotEOF { TokenEndNotEOF _ }
    '=' { TokenEq _ }
    '+' { TokenPlus _ }
    '-' { TokenMinus _ }
    '*' { TokenTimes _ }
    '^' { TokenExp _ }
    '/' { TokenDiv _ }
    '(' { TokenLParen _ }
    ')' { TokenRParen _ }
    '[' { TokenOpenVec _ }
    ']' { TokenCloseVec _ }
    '>' { TokenHigher _ }
    '<' { TokenLess _ }
    if  { TokenIf _ }
    endIf { TokenEndIf _ }
    '\\' { TokenBack _ }
    ':' { TokenPoints _ }
%left '+' '-'
%left '*' '/'
%left '^'
%%

ListStatement : Statement { [$1] }
              | Statement ListStatement { $1 : $2 }

Statement : loop Exp ListStatement endLoop { Loop $2 $3 }
          | whileInput ListStatement endWhileInput { While $2 }
          | wi ListStatement endWhileInput { While $2 }
          | notEOF ListStatement endNotEOF { NotEOF $2 }
          | if Exp '>' Exp ListStatement endIf { If $2 $4 $5 '>' }
          | if Exp '<' Exp ListStatement endIf { If $2 $4 $5 '<' }
          | if Exp '=' '=' Exp ListStatement endIf { If $2 $5 $6 '=' }
          | if Exp '/' '=' Exp ListStatement endIf { If $2 $5 $6 '/' }
          | var '[' Exp ']' '=' Exp { VecAssign $1 $3 $6 }
          | var '=' Exp { Assign $1 $3 }
          | print ':' ListExp ':'             { Print $3 }

ListExp : Exp { [$1] }
        | Exp ListExp { $1 : $2 }

Exp : Exp '+' Exp            { Plus $1 $3 }
    | Exp '-' Exp            { Minus $1 $3 }
    | Exp '*' Exp            { Times $1 $3 }
    | Exp '/' Exp            { Div $1 $3 }
    | Exp '^' Exp            { Expo $1 $3 }
    | var '[' Exp ']'        { VecVar $1 $3 }
    | read                   { Read }
    | '(' Exp ')'            { $2 }
    | int                    { Int $1 }
    | var                    { Var $1 }
    | '\\' var               { Var ('\\' : $2) }

{

parseError :: [Token] -> a
parseError []     = error " Unclosed statemet \n\
      \   • whileInput Statement?  \n\
      \   • loop Statement? \n\
      \   • if Statement? \n\
      \   • notEOF Statement?"
parseError (t:ts) = error ("Parse error at line:column " ++ (tokenPosn t))

data Exp = Plus Exp Exp
         | Minus Exp Exp
         | Times Exp Exp
         | Div Exp Exp
         | Expo Exp Exp
         | Int Int
         | Var String
         | Read
         | VecVar String Exp
         deriving Show

data Statement = Assign String Exp
               | VecAssign String Exp Exp
               | Loop Exp [Statement]
               | While [Statement]
               | NotEOF [Statement]
               | Print [Exp]
               | PrintString Exp
               | If Exp Exp [Statement] Char
               deriving Show
}
