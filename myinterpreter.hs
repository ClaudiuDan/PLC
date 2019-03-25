module Main where
import Grammar
import Tokens
import InputHandler
import Control.Exception
import System.Environment
import System.IO


--c <- evalExpr expr vars
--when (c == "endline")         putStrLn ""
--when(c == "space")                    putStr . id $ " "
--when ( (c /= "endline") && (c /= "space") ) putStr . id $ c

data Variable = Variable String String

main :: IO ()
main = catch main' noParse

noParse :: ErrorCall -> IO ()
noParse e = do let err =  show e
               hPutStr stderr err
               return ()
main' :: IO()
main' = do
        (fileName : _ ) <- getArgs
        sourceText <- readFile fileName
        let parsedProg = parseCalc (alexScanTokens sourceText)
        evalStatements [] parsedProg


evalStatements :: [Variable] -> [Statement] -> IO ()
evalStatements _ [] = do return ()
evalStatements vars ((Print expr) : statements) = do
                                                  s <- evalExpr expr vars
                                                  putStr . id $ s
                                                  evalStatements vars statements
evalStatements vars ((PrintString expr ) : statements) = do
                                                  c <- evalExpr expr vars
                                                  if (c == "endline")
                                                    then putStrLn ""
                                                    else if (c == "space")
                                                      then putStr . id $ " "
                                                      else putStr . id $ c
                                                  evalStatements vars statements
evalStatements vars ((Assign v expr) : statements) = do
                                                     r <- evalExpr expr vars
                                                     evalStatements ((Variable v r) : vars) statements
evalStatements vars ((Loop expr s) : statements) = do
                                                   loop (evalNum expr vars) vars s
                                                   evalStatements vars statements

loop :: Int -> [Variable] -> [Statement] -> IO ()
loop 0 _ _ = return ()
loop n vars statements = do
                         evalStatements vars statements
                         loop (n - 1) vars statements

evalExpr :: Exp -> [Variable]  -> IO (String)
evalExpr (Read) vars = do
                       x <- getInputNumber 0 False
                       return $ show x
evalExpr (Var x) vars = do return (lookVar x vars)
evalExpr expr vars = do return (show $ evalNum expr vars)

evalNum :: Exp -> [Variable] -> Int
evalNum (Int a) vars = a
evalNum (Plus (Var x) (Var y)) vars   = (read $ lookVar x vars) + (read $ lookVar y vars)
evalNum (Plus (Var x) b)       vars   = (read $ lookVar x vars) + evalNum b vars
evalNum (Plus b (Var x))       vars   = evalNum b vars + (read $ lookVar x vars)
evalNum (Plus a b)             vars   = evalNum a vars + evalNum b vars

evalNum (Minus (Var x) (Var y)) vars  = (read $ lookVar x vars) - (read $ lookVar y vars)
evalNum (Minus (Var x) b)       vars  = (read $ lookVar x vars) - evalNum b vars
evalNum (Minus b (Var x))       vars  = evalNum b vars - (read $ lookVar x vars)
evalNum (Minus a b)             vars  = evalNum a vars - evalNum b vars

evalNum (Times (Var x) (Var y)) vars  = (read $ lookVar x vars) * (read $ lookVar y vars)
evalNum (Times (Var x) b)       vars  = (read $ lookVar x vars) * evalNum b vars
evalNum (Times b (Var x))       vars  = evalNum b vars * (read $ lookVar x vars)
evalNum (Times a b)             vars  = evalNum a vars * evalNum b vars

evalNum (Div (Var x) (Var y))   vars  = (read $ lookVar x vars) `div` (read $ lookVar y vars)
evalNum (Div (Var x) b)         vars  = (read $ lookVar x vars) `div` evalNum b vars
evalNum (Div b (Var x))         vars  = evalNum b vars `div` (read $ lookVar x vars)
evalNum (Div a b)               vars  = evalNum a vars `div` evalNum b vars

evalNum (Expo (Var x) (Var y))  vars = (read $ lookVar x vars) ^ (read $ lookVar y vars)
evalNum (Expo (Var x) b)        vars = (read $ lookVar x vars) ^ evalNum b vars
evalNum (Expo b (Var x))        vars  = evalNum b vars ^ (read $ lookVar x vars)
evalNum (Expo a b)              vars  = evalNum a vars ^ evalNum b vars

lookVar :: String -> [Variable] -> String
lookVar x [] = x
lookVar x ((Variable a r) : vars)
  | x == a  = r
  | otherwise = lookVar x vars


  -- && head r == '-' s -- = negate (read $ tail r)
--  | x == a = read r
