{-# LANGUAGE RecordWildCards #-}

{-|

-}
module NSSpeechRecognizer.Bindings where
import NSSpeechRecognizer.Extra
import NSSpeechRecognizer.Types
import NSSpeechRecognizer.Foreign
import NSSpeechRecognizer.Constants

import Foreign (Ptr)
import Foreign.C (newCString)
import Foreign.Marshal (withArrayLen,free)
-- import Control.Concurrent.STM
-- import Data.List (genericLength)

--------------------------------------------------------------------------------

newNSSpeechRecognizer :: Recognizer -> IO (Ptr NSSpeechRecognizer)
newNSSpeechRecognizer recognizer = do
  p <- new_NSSpeechRecognizer
  p `pokeRecognizer` recognizer
  return p

--------------------------------------------------------------------------------

{-|

-}
pokeRecognizer :: Ptr NSSpeechRecognizer -> Recognizer -> IO ()
pokeRecognizer p Recognizer{..} = do
  p `pokeRecognizerState`   rState
  p `pokeRecognizerHandler` rHandler
  -- p `pokeRecognizerChannel` rChannel

pokeRecognizerHandler :: Ptr NSSpeechRecognizer -> RecognitionHandler -> IO ()
pokeRecognizerHandler p handler = do
  hs_handler <- newRecognitionHandler handler
  p `registerHandler_NSSpeechRecognizer` hs_handler

-- -- |
-- pokeRecognizerChannel :: Ptr NSSpeechRecognizer -> TChan CString -> IO ()
-- pokeRecognizerChannel p channel = do
--     c_handler <- channelRecognitionHandler channel
--     p `registerHandler_NSSpeechRecognizer` c_handler  -- safe? thread-safe? prop atomic.
--
-- -- |
-- channelRecognitionHandler :: TChan CString -> IO (FunPtr RecognitionHandler)
-- channelRecognitionHandler channel = do
--   let handler = atomically . writeTChan channel
--   newRecognitionHandler handler

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
pokeRecognizerVocabulary p vocabulary = withCStringArrayLen vocabulary go
  where
  go (c_vocabulary, c_length) = do
      setCommands_NSSpeechRecognizer p c_vocabulary c_length

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

-- -- |
-- marshallVocabulary :: Vocabulary -> IO NSVocabulary
-- marshallVocabulary vocabulary = do
--   return _TODO

-- |
withCStringArrayLen :: [String] -> (CStringArrayLen -> IO a) -> IO a
withCStringArrayLen strings f = bracket _create _destroy _use
  where
  _create  = traverse newCString strings
  _use     = \c_strings -> withArrayLen c_strings f'
  _destroy = traverse_ free --TODO Does it know the right size?
  f' = (flip . curry) f

{-old

c_strings <- newCString `traverse` strings
a <- withArrayLen c_strings f'
free `traverse_` c_strings

-}

--------------------------------------------------------------------------------
