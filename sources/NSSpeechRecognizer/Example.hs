{-# LANGUAGE NamedFieldPuns #-}

{-|

-}
module NSSpeechRecognizer.Example where
import NSSpeechRecognizer

import Foreign.C.String (withCString,peekCString)
import Foreign (FunPtr)
import Control.Concurrent.STM (newTChanIO,readTChan, atomically)
import Control.Monad (forever)
import Control.Concurrent (forkIO)

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

mainRecognizer = do
 putStrLn "\nrecognizing…\n"

 let rState = defaultRecognizerState {rVocabulary = ["start listening","stop listening"]}
 rChannel <- newTChanIO

 ns_thread <- forkIO $ do
   let recognizer = Recognizer {rState, rChannel}
   ns_recognizer <- newNSSpeechRecognizer recognizer
   putStrLn "(NSSpeechRecognizer)"

 forever $ do
    putStrLn "(waiting)"
    c_recognition <- atomically $ readTChan rChannel
    recognition <- peekCString c_recognition
    print recognition

--------------------------------------------------------------------------------
