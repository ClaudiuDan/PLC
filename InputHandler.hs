module InputHandler where
import System.IO (isEOF)

getInputNumber:: Int -> Bool -> IO (Int)
getInputNumber x isNegative = do
                              done <- isEOF
                              if done
                                then do
                                     if isNegative
                                       then do return ( negate x )
                                     else do
                                          return x
                              else do
                                   c <- getChar
                                   if ( (not $ isDigit c ) && c /= '-')
                                     then do
                                          if isNegative
                                            then do return ( negate x )
                                          else do
                                               return x
                                   else do
                                        if (c == '-')
                                          then do
                                               res <- getInputNumber 0 True
                                               return res
                                        else do
                                             res <- getInputNumber (x * 10 + read [c]) isNegative
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
