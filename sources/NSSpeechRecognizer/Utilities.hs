{-# LANGUAGE RecordWildCards, NamedFieldPuns, ViewPatterns #-}

module NSSpeechRecognizer.Utilities where
import NSSpeechRecognizer.Extra
import NSSpeechRecognizer.Types
import NSSpeechRecognizer.Bindings
import NSSpeechRecognizer.Foreign

import Foreign.C (peekCString)
import qualified Data.Map as Map


{- | Fake dictionary syntax.

Lowest possible precedence, makes it feel like a keyword.
Same president/associativity as '$', let's you mix them.
(Otherwise, it would be unassociative, i.e. @infix@)

e.g.

@
 [ "start listening"-: putStrLn "started listening..."
 , "stop listening"-: replicateM_ 2 $ throwIO UserInterrupt
 ]
@

-}
(-:) :: a -> b -> (a,b)
(-:) = (,)
infixr 0 -:

{-| Execute the value when its key is recognized
('rHandler' calls 'Map.lookup');
having registered the keys as the 'rVocabulary'.

NOTE must be called on the main thread.

Doesn't return.

@
recognizeVoiceMap = 'foreverRecognizer' . 'aVoiceMapRecognizer'
@

-}
recognizeVoiceMap :: VoiceMap -> IO ()
recognizeVoiceMap mapping = foreverRecognizer (aVoiceMapRecognizer mapping)

foreverRecognizer :: Recognizer -> IO ()
foreverRecognizer recognizer = do
 _ <- newNSSpeechRecognizer recognizer
 beginCurrentRunLoop

aVoiceMapRecognizer :: VoiceMap -> Recognizer
aVoiceMapRecognizer (Map.fromList -> mapping) = Recognizer{..}
  -- share the mapping
  where
  rHandler = peekCString >=> (\recognition -> Map.lookup recognition mapping & maybe nothing id)
    -- non-matches are ignored, though they should never be received
  rState = defaultRecognizerState{rVocabulary}
  rVocabulary = Map.keys mapping
