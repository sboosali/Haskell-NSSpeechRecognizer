{-# LANGUAGE ForeignFunctionInterface #-}

{-|

-}
module NSSpeechRecognizer.Foreign where
import NSSpeechRecognizer.Extra
import NSSpeechRecognizer.Types

import Foreign (Ptr,FunPtr)
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

{-

-- |
foreign import ccall "Recognizer.h xxx" xxx
 :: Ptr NSSpeechRecognizer -> () -> IO ()

-}

-- |
foreign import ccall "Recognizer.h new_NSSpeechRecognizer"   new_NSSpeechRecognizer
 :: IO (Ptr NSSpeechRecognizer)

-- |
foreign import ccall "Recognizer.h free_NSSpeechRecognizer"  free_NSSpeechRecognizer
 :: Ptr NSSpeechRecognizer -> IO ()

 -- |
foreign import ccall "Recognizer.h start_NSSpeechRecognizer" start_NSSpeechRecognizer
 :: Ptr NSSpeechRecognizer -> IO ()

 -- |
foreign import ccall "Recognizer.h stop_NSSpeechRecognizer"  stop_NSSpeechRecognizer
 :: Ptr NSSpeechRecognizer -> IO ()

 -- |
foreign import ccall "Recognizer.h setExclusivity_NSSpeechRecognizer" setExclusivity_NSSpeechRecognizer
 :: Ptr NSSpeechRecognizer -> BOOL -> IO ()

-- |
foreign import ccall "Recognizer.h setForegroundOnly_NSSpeechRecognizer" setForegroundOnly_NSSpeechRecognizer
 :: Ptr NSSpeechRecognizer -> BOOL -> IO ()

setCommands_NSSpeechRecognizer = _TODO

-- |
foreign import ccall "Recognizer.h registerHandler_NSSpeechRecognizer" registerHandler_NSSpeechRecognizer
 :: Ptr NSSpeechRecognizer -> FunPtr RecognitionHandler -> IO ()

--------------------------------------------------------------------------------
