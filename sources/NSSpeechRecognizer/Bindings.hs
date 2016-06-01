module NSSpeechRecognizer.Bindings where
import NSSpeechRecognizer.Types
import NSSpeechRecognizer.Foreign

import Foreign (FunPtr)
import Foreign.C (withCString)


{-|

-}
_NSSpeechRecognizer :: FunPtr RecognitionHandler -> String -> IO ()
_NSSpeechRecognizer hs_f s = withCString s $ c_NSSpeechRecognizer hs_f
