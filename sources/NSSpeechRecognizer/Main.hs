module NSSpeechRecognizer.Main where
import NSSpeechRecognizer.Foreign
import NSSpeechRecognizer.Bindings

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

 let f = fromRecognitionHandler f'        -- "dynamic"

 print f'

 withCString "wrapper/dynamic roundtrip" $ \s' -> do
      f s'
