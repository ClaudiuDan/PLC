import Tokens
import Grammar

main = do
  s <- readFile "file.txt"
  putStrLn $ doSomethingWith s

doSomethingWith :: String -> String
doSomethingWith str = show $ parseCalc $ alexScanTokens str
