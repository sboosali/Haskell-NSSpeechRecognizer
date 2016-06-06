{-# LANGUAGE NamedFieldPuns #-}

{-|

-}
module NSSpeechRecognizer.Example where
import NSSpeechRecognizer

import Foreign.C.String (withCString,peekCString)
import Foreign (FunPtr)
-- import Control.Concurrent.STM (newTChanIO,readTChan, atomically)
import Control.Monad (forever)
import Control.Concurrent (forkIO,threadDelay) -- forkOS

--------------------------------------------------------------------------------

{- |
@
stack build && stack exec -- NSSpeechRecognizer-example
@
-}
main :: IO ()
main = do
 mainRoundtrip
 mainRecognizer

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

hang = forever $ do
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
 ns_recognizer <- newNSSpeechRecognizer recognizer
 putStrLn "(NSSpeechRecognizer Started)"

 _thread <- forkIO $ do
   forever $ do
     putStrLn "(Child Thread Runs)"
     threadDelay 1000000

 beginCurrentRunLoop -- NOTE the NSRunLoop *must* be run on the main thread, It seems
 putStrLn "(ERROR NSRunLoop ended)" -- isn't seen

{-TODO

needs 2 C-c

solutions:(?)
-threaded
ccall safe
main thread

-}

printerHandler c_recognition = do
  putStrLn ""
  recognition <- peekCString c_recognition
  print recognition

--------------------------------------------------------------------------------
