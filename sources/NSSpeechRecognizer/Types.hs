module NSSpeechRecognizer.Types where

import Foreign.C.String


{-|

see

<https://hackage.haskell.org/package/base-4.9.0.0/docs/Foreign-Ptr.html#t:FunPtr>

-}
type RecognitionHandler = CString -> IO ()
