module Evaluator where
import Grammar
import Tokens 

data Variable = Variable String Exp

run :: IO ()
run = do
      statements <- main
      evalStatements [] statements []

evalStatements :: [Variable] -> [Statement] -> [[Int]] -> IO ()
evalStatements _ [] input = do return ()
evalStatements vars ((Print expr) : statements) input = do 
                                                  print $ evalExpr expr vars input
                                                  evalStatements vars statements input
evalStatements vars ((Assign v expr) : statements) input = do 
                                                           evalStatements ((Variable v expr) : vars) statements input
evalStatements vars ((Loop expr s) : statements) input = do
                                                         loop (evalNum expr) vars s input
                                                         evalStatements vars statements input

loop :: Int -> [Variable] -> [Statement] -> [[Int]] -> IO ()
loop 0 _ _ _ = return ()
loop n vars statements input = do 
                               evalStatements vars statements input
                               loop (n - 1) vars statements input

evalExpr :: Exp -> [Variable] -> [[Int]] -> String
--evalExpr (Mat2 name line col) vars input = show (getInput input line col)
evalExpr (Var x) vars input = show $ lookVar x vars
evalExpr expr vars input = show $ evalNum expr

evalNum :: Exp -> Int
evalNum (Int a) = a
evalNum (Plus a b) = evalNum a + evalNum b
evalNum (Times a b) = evalNum a * evalNum b

lookVar :: String -> [Variable] -> Int
lookVar x [] = 0
lookVar x ((Variable a expr) : vars) 
  | x == a = evalNum expr
  | otherwise = lookVar x vars

getInputLine :: IO ()
getInputLine = do 
               s <- getLine 
               print $ parseInputLine s
  
parseInputLine :: [Char] -> [Int]
parseInputLine [] = []
parseInputLine ('\n' : cs) = []
parseInputLine (' ' : cs) = parseInputLine cs
parseInputLine cs = (read $ getDigits cs) : (parseInputLine $ eliminateDigitsUntilSpace cs)

eliminateDigitsUntilSpace :: [Char] -> [Char]
eliminateDigitsUntilSpace [] = []
eliminateDigitsUntilSpace (c : cs) 
  | c == ' ' = c : cs
  | otherwise = eliminateDigitsUntilSpace cs  
 
getDigits :: [Char] -> String
getDigits [] = []
getDigits (c : cs) 
  | c == ' ' = []
  | c == '\n' = []
  | otherwise = c : (getDigits cs)
 
main :: IO ([Statement])
main = do
  s <- readFile "file.txt"
  return (doSomethingWith s)

doSomethingWith :: String -> [Statement]
doSomethingWith str = parseCalc $ alexScanTokens str
