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
    re { TokenReadShort _ }

    lp { TokenLoopShort _ }
    loop { TokenLoop _ }
    endLoop { TokenEndLoop _ }
    elp { TokenEndLoopShort _ }

    wi     {TokenWhileInputShort _  }
    whileInput { TokenWhileInput _ }
    endWhileInput { TokenEndWhileInput _ }
    ewi { TokenEndWhileInputShort _ }

    neof { TokenNotEOFShort _ }
    notEOF { TokenNotEOF _ }
    eneof { TokenEndNotEOFShort _ }
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

    i  { TokenIfShort _ }
    if  { TokenIf _ }
    ei { TokenEndIfShort _ }
    endIf { TokenEndIf _ }

    '\\' { TokenBack _ }
    ':' { TokenPoints _ }
    del { TokenDelete _ }
%left '+' '-'
%left '*' '/'
%left '^'
%%

ListStatement : Statement { [$1] }
              | Statement ListStatement { $1 : $2 }

Statement : loop Exp ListStatement endLoop { Loop $2 $3 }
          | lp Exp ListStatement elp { Loop $2 $3 }

          | whileInput ListStatement endWhileInput { While $2 }
          | wi ListStatement ewi { While $2 }

          | notEOF ListStatement endNotEOF { NotEOF $2 }
          | neof ListStatement eneof { NotEOF $2 }

          | if Exp '>' Exp ListStatement endIf { If $2 $4 $5 '>' }
          | i Exp '>' Exp ListStatement ei { If $2 $4 $5 '>' }

          | if Exp '<' Exp ListStatement endIf { If $2 $4 $5 '<' }
          | i Exp '<' Exp ListStatement ei { If $2 $4 $5 '<' }

          | if Exp '=' '=' Exp ListStatement endIf { If $2 $5 $6 '=' }
          | i Exp '=' '=' Exp ListStatement ei { If $2 $5 $6 '=' }

          | if Exp '/' '=' Exp ListStatement endIf { If $2 $5 $6 '/' }
          | i Exp '/' '=' Exp ListStatement ei { If $2 $5 $6 '/' }

          | var '[' Exp ']' '=' Exp { VecAssign $1 $3 $6 }
          | var '=' Exp { Assign $1 $3 }
          | print ':' ListExp ':'             { Print $3 }
          | del var         { Delete $2 }

ListExp : Exp { [$1] }
        | Exp ListExp { $1 : $2 }

Exp : Exp '+' Exp            { Plus $1 $3 }
    | Exp '-' Exp            { Minus $1 $3 }
    | Exp '*' Exp            { Times $1 $3 }
    | Exp '/' Exp            { Div $1 $3 }
    | Exp '^' Exp            { Expo $1 $3 }
    | var '[' Exp ']'        { VecVar $1 $3 }
    | read                   { Read }
    | re                     { Read }
    | '(' Exp ')'            { $2 }
    | int                    { Int $1 }
    | var                    { Var $1 }
    | '\\' var               { Var ('\\' : $2) }

{

parseError :: [Token] -> a
parseError []     = error " Unclosed statement \n\
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
               | Delete String
               | If Exp Exp [Statement] Char
               deriving Show
}
