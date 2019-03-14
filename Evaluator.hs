module Evaluator where
import Grammar
import Tokens 

data Variable = Variable String Int

run :: IO ()
run = do
      statements <- main
      evalStatements [] statements

evalStatements :: [Variable] -> [Statement] -> IO ()
evalStatements _ [] = do return ()
evalStatements variables ( (Print s) : statements) = do 
                                                         print s
                                                         evalStatements variables statements
evalStatements variables ( (Assign v expr) : statements) = do 
                                                           evalStatements ((Variable v (evalExpr expr)) : variables) statements


evalExpr :: Exp -> Int
evalExpr (Plus (Int a) (Int b)) = a + b



main :: IO ([Statement])
main = do
  s <- readFile "file.txt"
  return (doSomethingWith s)

doSomethingWith :: String -> [Statement]
doSomethingWith str = parseCalc $ alexScanTokens str
