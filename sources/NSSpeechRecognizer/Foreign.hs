{-# LANGUAGE ForeignFunctionInterface, CPP #-}
module NSSpeechRecognizer.Foreign where

import Foreign
import Foreign.C.String

foreign import ccall safe "NSSpeechRecognizer.h NSSpeechRecognizer"
 c_NSSpeechRecognizer :: IO CString

type RecognitionHandler = CString -> IO ()

foreign import ccall "wrapper"
  newRecognitionHandler :: RecognitionHandler -> IO (FunPtr RecognitionHandler)

foreign import ccall "dynamic"
  fromRecognitionHandler :: FunPtr RecognitionHandler -> RecognitionHandler
