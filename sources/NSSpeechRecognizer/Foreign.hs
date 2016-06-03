{-# LANGUAGE ForeignFunctionInterface, CPP #-}

{-|

-}
module NSSpeechRecognizer.Foreign where
import NSSpeechRecognizer.Extra
import NSSpeechRecognizer.Types

import Foreign (FunPtr)
import Foreign.C.String

--------------------------------------------------------------------------------

foreign import ccall safe "Recognizer.h test_NSSpeechRecognizer"
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

new_NSSpeechRecognizer = _TODO
free_NSSpeechRecognizer = _TODO
start_NSSpeechRecognizer = _TODO
stop_NSSpeechRecognizer = _TODO
setCommands_NSSpeechRecognizer = _TODO
setExclusivity_NSSpeechRecognizer = _TODO
setCallback_NSSpeechRecognizer = _TODO
