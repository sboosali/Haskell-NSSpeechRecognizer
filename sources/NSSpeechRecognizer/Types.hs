module NSSpeechRecognizer.Types where

import Foreign.C.String


{-|

A foreign pointer to a haskell function:

@
-- A.hs
hs_f :: FunPtr (CString -> IO ())
@

marshalls to:

@
-- A.c
void(*hs_f)(const char*)
@

see
<https://hackage.haskell.org/package/base-4.9.0.0/docs/Foreign-Ptr.html#t:FunPtr>

-}
type RecognitionHandler = CString -> IO ()
