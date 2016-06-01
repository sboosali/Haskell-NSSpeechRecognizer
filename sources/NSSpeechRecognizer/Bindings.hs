module NSSpeechRecognizer.Bindings where
import NSSpeechRecognizer.Foreign

import Foreign.C


{-|

>>> _Playground
"Playground"

-}
_NSSpeechRecognizer :: IO String
_NSSpeechRecognizer = c_NSSpeechRecognizer >>= peekCString
