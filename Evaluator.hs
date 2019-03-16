module Main where
import Grammar
import Tokens 
import InputHandler
data Variable = Variable String Exp

main :: IO ()
main = do
       statements <- start
       evalStatements [] statements

evalStatements :: [Variable] -> [Statement] -> IO ()
evalStatements _ [] = do return ()
evalStatements vars ((Print expr) : statements) = do 
                                                  s <- evalExpr expr vars
                                                  print s
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

evalExpr :: Exp -> [Variable]  -> IO (String)
evalExpr (Read) vars = do
                       x <- getInputNumber 0 
                       print (show x ++ " in eval")
                       return $ show x
evalExpr (Var x) vars = do return (show $ lookVar x vars)
evalExpr expr vars = do return (show $ evalNum expr)

evalNum :: Exp -> Int
evalNum (Int a) = a
evalNum (Plus a b) = evalNum a + evalNum b
evalNum (Times a b) = evalNum a * evalNum b

lookVar :: String -> [Variable] -> Int
lookVar x [] = 0
lookVar x ((Variable a expr) : vars) 
  | x == a = evalNum expr
  | otherwise = lookVar x vars
 
start :: IO ([Statement])
start = do
        s <- readFile "file.txt"
        return (doSomethingWith s)

doSomethingWith :: String -> [Statement]
doSomethingWith str = parseCalc $ alexScanTokens str
