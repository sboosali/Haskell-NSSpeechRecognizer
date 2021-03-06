{-# LANGUAGE RecordWildCards #-}

{-|

-}
module NSSpeechRecognizer.Bindings where
import NSSpeechRecognizer.Extra
import NSSpeechRecognizer.Types
import NSSpeechRecognizer.Foreign
import NSSpeechRecognizer.Constants

import Foreign (Ptr,withArrayLen,free)
import Foreign.C (newCString,peekCString)
--import Control.Concurrent (myThreadId)
import Control.Concurrent.STM (TChan,atomically,writeTChan)
-- import Data.List (genericLength)

--------------------------------------------------------------------------------

{-|

-}
newNSSpeechRecognizer :: Recognizer -> IO P'NSSpeechRecognizer
newNSSpeechRecognizer recognizer = do
  p <- new_NSSpeechRecognizer
  p `pokeRecognizer` recognizer
  return p

{-|

the @NSRunLoop@ *must* be run on the main thread, otherwise.

TODO throws when not on main thread.

-}
beginRunLoop :: IO ()
beginRunLoop = do
  beginMainRunLoop

  -- isOnMainThread <- (==) <$> myThreadId <*> mainThreadId
  -- if   isOnMainThread
  -- then throwS "{NSSpeechRecognizer.Bindings.beginRunLoop} must be run on only the main thread"
  -- else beginMainRunLoop

-- | "reinvert control" with a channel.
channelRecognitionHandler :: TChan String -> RecognitionHandler
channelRecognitionHandler channel = handler
  where
  handler c_s = do
    s <- peekCString c_s -- UTF8-decode
    atomically . writeTChan channel $ s

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
