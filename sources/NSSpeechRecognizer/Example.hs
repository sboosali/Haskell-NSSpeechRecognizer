
{-|

-}
module NSSpeechRecognizer.Example where
import NSSpeechRecognizer

import Foreign.C.String
import Foreign (FunPtr)

{- |
@
stack build && stack exec -- NSSpeechRecognizer-example
@
-}
main :: IO ()
main = do
 putStrLn ""

 f' <- newRecognitionHandler $ \s' -> do  -- "wrapper"
     s <- peekCString s'
     print s

 let f = peekRecognitionHandler f'        -- "dynamic"

 print f'

 withCString "wrapper/dynamic roundtrip" f

 test_NSSpeechRecognizer f' "Haskell calls ObjectiveC calls Haskell"

test_NSSpeechRecognizer :: FunPtr RecognitionHandler -> String -> IO ()
test_NSSpeechRecognizer hs_f s = withCString s $ c_NSSpeechRecognizer hs_f
