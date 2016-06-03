{-# LANGUAGE RecordWildCards #-}

{-|

-}
module NSSpeechRecognizer.Bindings where
import NSSpeechRecognizer.Extra
import NSSpeechRecognizer.Types
import NSSpeechRecognizer.Foreign
import NSSpeechRecognizer.Constants

import Foreign (Ptr,FunPtr)
import Foreign.C (CString, withCString)
import Control.Concurrent.STM

--------------------------------------------------------------------------------

{-|

-}
pokeRecognizer :: Ptr NSSpeechRecognizer -> Recognizer -> IO ()
pokeRecognizer p Recognizer{..} = do
  p `pokeRecognizerState`   rState
  p `pokeRecognizerChannel` rChannel

-- |
pokeRecognizerChannel :: Ptr NSSpeechRecognizer -> TChan CString -> IO ()
pokeRecognizerChannel p channel = do
    c_handler <- channelRecognitionHandler channel
    p `registerHandler_NSSpeechRecognizer` c_handler  -- safe? thread-safe? prop atomic.

-- |
channelRecognitionHandler :: TChan CString -> IO (FunPtr RecognitionHandler)
channelRecognitionHandler channel = do
  let handler = atomically . writeTChan channel
  newRecognitionHandler handler

--------------------------------------------------------------------------------

-- |
pokeRecognizerState :: Ptr NSSpeechRecognizer -> RecognizerState -> IO ()
pokeRecognizerState p RecognizerState{..} = do
 p `pokeRecognizerStatus`         rStatus
 p `pokeRecognizerExclusivity`    rExclusivity
 p `pokeRecognizerForegroundOnly` rForegroundOnly
 p `pokeRecognizerVocabulary`     rVocabulary

-- |   -- _TODO idempotent?
pokeRecognizerStatus :: Ptr NSSpeechRecognizer -> Status -> IO ()
pokeRecognizerStatus p = \case
  On  -> p & start_NSSpeechRecognizer
  Off -> p & stop_NSSpeechRecognizer

-- |
pokeRecognizerExclusivity :: Ptr NSSpeechRecognizer -> Exclusivity -> IO ()
pokeRecognizerExclusivity p = marshallExclusivity >>> setExclusivity_NSSpeechRecognizer p

-- |
pokeRecognizerForegroundOnly :: Ptr NSSpeechRecognizer -> ForegroundOnly -> IO ()
pokeRecognizerForegroundOnly p = marshallForegroundOnly >>> setForegroundOnly_NSSpeechRecognizer p

-- |
pokeRecognizerVocabulary :: Ptr NSSpeechRecognizer -> Vocabulary -> IO ()
pokeRecognizerVocabulary p vocabulary = do
  c_vocabulary <- marshallVocabulary vocabulary
  p `setCommands_NSSpeechRecognizer` c_vocabulary

--------------------------------------------------------------------------------

-- | @blocksOtherRecognizers@
marshallExclusivity :: Exclusivity -> BOOL
marshallExclusivity = \case
 Exclusive -> YES
 Inclusive -> NO

-- | @listensInForegroundOnly@
marshallForegroundOnly :: ForegroundOnly -> BOOL
marshallForegroundOnly = \case
 ForegroundOnly -> YES
 BackgroundAlso -> NO

-- |
marshallVocabulary :: Vocabulary -> IO NSVocabulary
marshallVocabulary vocabulary = do
  return _TODO

--------------------------------------------------------------------------------
