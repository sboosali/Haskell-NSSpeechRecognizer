{-# LANGUAGE NamedFieldPuns #-}
{-# OPTIONS_GHC -fno-warn-missing-signatures #-}

{-|

-}
module NSSpeechRecognizer.Example where
import NSSpeechRecognizer

import Foreign.C.String (withCString,peekCString)
import Foreign (FunPtr)
-- import Control.Concurrent.STM (newTChanIO,readTChan, atomically)
import Control.Monad (forever) -- ,replicateM_)
import Control.Concurrent (forkIO,threadDelay) -- forkOS
import Control.Exception (throwIO,AsyncException(..))

--------------------------------------------------------------------------------

{- |
@
stack build && stack exec -- NSSpeechRecognizer-example
@
-}
main :: IO ()
main = do
 mainRoundtrip
 -- mainRecognizer
 mainVoiceMap

--------------------------------------------------------------------------------

mainRoundtrip = do
 putStrLn "\nRound tripping…\n"

 f' <- newRecognitionHandler $ \s' -> do  -- "wrapper"
     s <- peekCString s'
     print s

 let f = peekRecognitionHandler f'        -- "dynamic"

 print f'

 withCString "wrapper/dynamic roundtrip" f

 test_NSSpeechRecognizer f' "Haskell calls ObjectiveC calls Haskell"

test_NSSpeechRecognizer :: FunPtr RecognitionHandler -> String -> IO ()
test_NSSpeechRecognizer hs_f s = withCString s $ c_NSSpeechRecognizer hs_f

--------------------------------------------------------------------------------

hang = forever $
   threadDelay 1000000

mainRecognizer = do
 putStrLn "\nrecognizing…\n"

 let rState = defaultRecognizerState {rVocabulary = ["start listening","stop listening"]}

 let rHandler = printerHandler

 -- ns_thread <- forkOS $ do
 --   let recognizer = Recognizer {rState, rHandler}
 --   ns_recognizer <- newNSSpeechRecognizer recognizer
 --   putStrLn "(NSSpeechRecognizer Started)"
 --   beginMainRunLoop
 --   putStrLn "(NSRunLoop Ended)" -- shouldn't be seen, but is!
 --   hang

 let recognizer = Recognizer {rState, rHandler}
 _ns_recognizer <- newNSSpeechRecognizer recognizer
 putStrLn "(NSSpeechRecognizer Started)"

 _thread <- forkIO $ do
   forever $ do
     putStrLn "(Child Thread Runs)"
     threadDelay 1000000

 beginCurrentRunLoop -- NOTE the NSRunLoop *must* be run on the main thread, It seems
 putStrLn "(ERROR NSRunLoop ended)" -- isn't seen


{-TODO: why's it need 2 C-c?

attempts:
-threaded
ccall safe
main thread

C-\ (i.e. SIGQUIT) works

-}

printerHandler c_recognition = do
  putStrLn ""
  recognition <- peekCString c_recognition
  print recognition

--------------------------------------------------------------------------------

mainVoiceMap = do
  recognizeVoiceMap
   [ "start listening"-: putStrLn "started listening" --TODO Extend example to actually enable more vocabularies in these two, on the recognition of start listening
   , "stop listening"-: throwIO UserInterrupt
   ]

{-old

Activating the nsrunloop seems to demand two C-c's.

#1.

twice doesn't even work:
, "stop listening"-: sequence_ [throwIO UserInterrupt, threadDelay (1000*1000), throwIO UserInterrupt]

#2.

, "stop listening"-: throwIO ThreadKilled

But is it safe? With some system resource be freed?

-}

--------------------------------------------------------------------------------
