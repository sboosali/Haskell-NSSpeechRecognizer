module NSSpeechRecognizer.Example where
import NSSpeechRecognizer

import Foreign.C.String

{- |
@
stack build && stack exec -- NSSpeechRecognizer-example
@
-}
main :: IO ()
main = do
 print =<< _NSSpeechRecognizer

 f' <- newRecognitionHandler $ \s' -> do  -- "wrapper"
     s <- peekCString s'
     print s

 let f = peekRecognitionHandler f'        -- "dynamic"

 print f'

 withCString "wrapper/dynamic roundtrip" f