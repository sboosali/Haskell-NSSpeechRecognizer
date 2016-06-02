{-# LANGUAGE RecordWildCards #-}

{-|

-}
module NSSpeechRecognizer.Bindings where
import NSSpeechRecognizer.Extra
import NSSpeechRecognizer.Types
import NSSpeechRecognizer.Foreign

import Foreign (FunPtr)
import Foreign.C (CString, withCString)
import Control.Concurrent.STM

{-|

-}
pokeRecognizer :: NSSpeechRecognizer -> Recognizer -> IO ()
pokeRecognizer p Recognizer{..} = do
  p `pokeRecognizerState` rState

  c_callback <- channelRecognitionHandler rChannel
  p `setCallback_NSSpeechRecognizer` c_callback  -- safe? thread-safe? prop atomic.

pokeRecognizerState :: NSSpeechRecognizer -> RecognizerState -> IO ()
pokeRecognizerState p RecognizerState{..} = do
 p `pokeRecognizerVocabulary`  rVocabulary
 p `pokeRecognizerStatus`      rStatus
 p `pokeRecognizerExclusivity` rExclusivity

pokeRecognizerVocabulary :: NSSpeechRecognizer -> Vocabulary -> IO ()
pokeRecognizerVocabulary p vocabulary = do
  c_vocabulary <- marshallVocabulary vocabulary
  p `setCommands_NSSpeechRecognizer` c_vocabulary

-- |   -- _TODO idempotent?
pokeRecognizerStatus :: NSSpeechRecognizer -> Status -> IO ()
pokeRecognizerStatus p = \case
  On  -> p & start_NSSpeechRecognizer
  Off -> p & stop_NSSpeechRecognizer

-- |
pokeRecognizerExclusivity :: NSSpeechRecognizer -> Exclusivity -> IO ()
pokeRecognizerExclusivity p = \case
  Inclusive -> p `setExclusivity_NSSpeechRecognizer` 0
  Exclusive -> p `setExclusivity_NSSpeechRecognizer` 1

-- |
channelRecognitionHandler :: TChan CString -> IO (FunPtr RecognitionHandler)
channelRecognitionHandler channel = do
  let callback = atomically . writeTChan channel
  newRecognitionHandler callback

marshallVocabulary :: Vocabulary -> IO NSVocabulary
marshallVocabulary vocabulary = do
  return _TODO
