module Main where
import Grammar
import Tokens
import InputHandler
import Control.Exception
import System.Environment
import System.IO
import Control.Monad

data Variable = Variable String String

main :: IO ()
main = catch main' noParse

noParse :: ErrorCall -> IO ()
noParse e = do let err =  show e
               hPutStr stderr err
               return ()
main' :: IO ()
main' = do
        (fileName : _ ) <- getArgs
        sourceText <- readFile fileName
        let parsedProg = parseCalc (alexScanTokens sourceText)
        vars <- evalStatements [] parsedProg
        return ()


evalStatements :: [Variable] -> [Statement] -> IO ([Variable])
evalStatements vars [] = return (vars)
evalStatements vars ((Print expr) : statements) = do
                                                  s <- evalExpr expr vars
                                                  when (s /= "$isEOF$") $ (putStr . id $ s)
                                                  newVars <- evalStatements vars statements
                                                  return newVars
evalStatements vars ((PrintString expr ) : statements) = do
                                                  c <- evalExpr expr vars
                                                  when (c == "endline") $ putStrLn ""
                                                  when (c == "space") $ putStr . id $ " "
                                                  when ( (c /= "endline") && (c /= "space") ) $ putStr . id $ c
                                                  newVars <- evalStatements vars statements
                                                  return newVars
evalStatements vars ((VecAssign v expr1 expr2) : statements) = do
                                                               evaluation <- evalExpr expr1 vars
                                                               newVars <- evalStatements vars ((Assign (v ++ "[" ++ evaluation ++ "]") expr2) : statements)
                                                               return newVars
evalStatements vars ((Assign v expr) : statements) = do
                                                     r <- evalExpr expr vars
                                                     if (r /= "$isEOF$")
                                                       then do
                                                               let newListOfVars = updateVars vars (Variable v r)
                                                               newVars <- evalStatements newListOfVars statements
                                                               return newVars
                                                       else do newVars <- evalStatements vars statements
                                                               return newVars

evalStatements vars ((Loop expr s) : statements) = do
                                                   evaluation <- evalNum expr vars
                                                   newVars <- loop evaluation vars s
                                                   newVars2 <- evalStatements newVars statements
                                                   return newVars2
evalStatements vars ((While s) : statements) = do
                                               newVars <- whileInput vars s
                                               newVars2 <- evalStatements newVars statements
                                               return newVars2
evalStatements vars ((NotEOF s) : statements) = do
                                                eof <- isEOF
                                                if not $ eof
                                                  then do
                                                    newVars <- evalStatements vars s
                                                    newVars2 <- evalStatements newVars statements
                                                    return newVars2
                                                  else do
                                                    newVars <- evalStatements vars statements
                                                    return newVars

evalStatements vars ((If expr1 expr2 s '/') : statements) = 
  do
  evalExpr1 <- evalExpr expr1 vars
  evalExpr2 <- evalExpr expr2 vars
  if ( (read evalExpr1 :: Integer ) /= (read evalExpr2 :: Integer) )  
    then do
      newVars <- evalStatements vars s
      newVars2 <- evalStatements newVars statements
      return newVars2
    else do
      newVars <- evalStatements vars statements
      return newVars

evalStatements vars ((If expr1 expr2 s '=') : statements) = 
  do
  evalExpr1 <- evalExpr expr1 vars
  evalExpr2 <- evalExpr expr2 vars
  if ( (read evalExpr1 :: Integer ) == (read evalExpr2 :: Integer) )  
    then do
      newVars <- evalStatements vars s
      newVars2 <- evalStatements newVars statements
      return newVars2
    else do
      newVars <- evalStatements vars statements
      return newVars

evalStatements vars ((If expr1 expr2 s '<') : statements) = 
  do
  evalExpr1 <- evalExpr expr1 vars
  evalExpr2 <- evalExpr expr2 vars
  if ( (read evalExpr1 :: Integer ) < (read evalExpr2 :: Integer) )  
    then do
      newVars <- evalStatements vars s
      newVars2 <- evalStatements newVars statements
      return newVars2
    else do
      newVars <- evalStatements vars statements
      return newVars

evalStatements vars ((If expr1 expr2 s '>') : statements) = 
  do
  evalExpr1 <- evalExpr expr1 vars
  evalExpr2 <- evalExpr expr2 vars
  if ( (read evalExpr1 :: Integer ) > (read evalExpr2 :: Integer) )  
    then do
      newVars <- evalStatements vars s
      newVars2 <- evalStatements newVars statements
      return newVars2
    else do
      newVars <- evalStatements vars statements
      return newVars 

  
--checkIf :: Expr -> Expr -> Char -> [Variable] -> [Statement] -> IO ([Variable])  
--checkIf e1 e2

updateVars :: [Variable] -> Variable -> [Variable]
updateVars [] var = [var]
updateVars ( (Variable nameInList valueInList ) : xs) (Variable name value)
  | nameInList == name = (Variable name value) : xs
  | otherwise = (Variable nameInList valueInList ) : (updateVars xs (Variable name value))



loop :: Int -> [Variable] -> [Statement] -> IO ([Variable])
loop n vars statements
  | n > 0 = do
             newVars <- evalStatements vars  statements
             newVars2 <- loop (n - 1) newVars statements
             return newVars2
  | otherwise = return vars

whileInput :: [Variable] -> [Statement] -> IO ([Variable])
whileInput vars statements = do
                             eof <- isEOF
                             if not $ eof
                               then do
                                 newVars <- evalStatements vars statements
                                 newVars2 <- whileInput newVars statements
                                 return newVars2
                               else return vars

evalExpr :: Exp -> [Variable]  -> IO (String)
evalExpr (VecVar var exp) vars = do
                                 evaluated <- evalExpr exp vars
                                 return (lookVar (var ++ "[" ++ evaluated ++ "]") vars)
evalExpr (Read) vars  = do
                        eof <- isEOF
                        if eof
                          then return ( "$isEOF$" )
                          else do x <- getInputNumber 0 False
                                  return $ show x
evalExpr (Var x) vars =  return (lookVar x vars)
evalExpr expr vars    = do
                        evaluation <- evalNum expr vars
                        return (show $ evaluation)

evalNum :: Exp -> [Variable] -> IO(Int)
evalNum (Int a)     vars  = return a
evalNum (Var x)     vars =  return (read $ lookVar x vars)
evalNum (VecVar name exp)  vars = do
                                  evaluated <- evalExpr exp vars
                                  return (read $ (lookVar (name ++ "[" ++ evaluated ++ "]") vars))
evalNum (Plus a b)  vars  = do
                            resa <- evalNum a vars
                            resb <- evalNum b vars
                            return (resa + resb)
evalNum (Minus a b) vars  = do
                            resa <- evalNum a vars
                            resb <- evalNum b vars
                            return (resa - resb)
evalNum (Times a b) vars  = do
                            resa <- evalNum a vars
                            resb <- evalNum b vars
                            return (resa * resb)
evalNum (Div a b)   vars  = do
                            resa <- evalNum a vars
                            resb <- evalNum b vars
                            return (resa `div` resb)
evalNum (Expo a b)  vars  = do
                            resa <- evalNum a vars
                            resb <- evalNum b vars
                            return (resa ^ resb)

lookVar :: String -> [Variable] -> String
lookVar x [] = x
lookVar x ((Variable a r) : vars)
  | x == a  = r
  | otherwise = lookVar x vars
