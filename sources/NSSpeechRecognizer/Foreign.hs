{-# LANGUAGE ForeignFunctionInterface, CPP #-}
module NSSpeechRecognizer.Foreign where
import NSSpeechRecognizer.Types

import Foreign (FunPtr)
import Foreign.C.String

--------------------------------------------------------------------------------

foreign import ccall safe "NSSpeechRecognizer.h NSSpeechRecognizer"
 c_NSSpeechRecognizer
  :: FunPtr RecognitionHandler
  -> CString
  -> IO ()

--------------------------------------------------------------------------------

foreign import ccall "wrapper"
  newRecognitionHandler :: RecognitionHandler -> IO (FunPtr RecognitionHandler)

foreign import ccall "dynamic"
  peekRecognitionHandler :: FunPtr RecognitionHandler -> RecognitionHandler

--------------------------------------------------------------------------------
