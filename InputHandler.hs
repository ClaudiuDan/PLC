module InputHandler where 
import System.IO (isEOF)
getInputNumber:: Int -> IO (Int)
getInputNumber x = do 
                   done <- isEOF
                   c <- getChar
                   print (c : " uite ce am facut")
                   if (isDigit c) && done == False 
                     then return x
                   else do
                     res <- getInputNumber (x * 10 + read [c])  
                     return res

isDigit :: Char -> Bool
isDigit c 
  | c >= '0' && c <= '9' = True
  | otherwise = False

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