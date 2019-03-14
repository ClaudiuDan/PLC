module Evaluator where
import Grammar
import Tokens 

data Variable = Variable String Exp

run :: IO ()
run = do
      statements <- main
      evalStatements [] statements

evalStatements :: [Variable] -> [Statement] -> IO ()
evalStatements _ [] = do return ()
evalStatements vars ((Print expr) : statements) = do 
                                                  print $ evalExpr expr vars
                                                  evalStatements vars statements
evalStatements vars ((Assign v expr) : statements) = do 
                                                     evalStatements ((Variable v expr) : vars) statements
evalStatements vars ((Loop expr s) : statements) = do
                                                   loop (evalNum expr) vars s
                                                   evalStatements vars statements

loop :: Int -> [Variable] -> [Statement] -> IO ()
loop 0 _ _ = return ()
loop n vars statements = do 
                         evalStatements vars statements
                         loop (n - 1) vars statements

evalExpr :: Exp -> [Variable] -> String
evalExpr (Var x) vars = show $ lookVar x vars
evalExpr expr vars = show $ evalNum expr

evalNum :: Exp -> Int
evalNum (Int a) = a
evalNum (Plus a b) = evalNum a + evalNum b
evalNum (Times a b) = evalNum a * evalNum b

lookVar :: String -> [Variable] -> Int
lookVar x [] = 0
lookVar x ((Variable a expr) : vars) 
  | x == a = evalNum expr
  | otherwise = lookVar x vars

main :: IO ([Statement])
main = do
  s <- readFile "file.txt"
  return (doSomethingWith s)

doSomethingWith :: String -> [Statement]
doSomethingWith str = parseCalc $ alexScanTokens str
