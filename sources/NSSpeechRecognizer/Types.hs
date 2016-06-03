{-# LANGUAGE EmptyCase, RecordWildCards #-}

{-|

-}
module NSSpeechRecognizer.Types where
import NSSpeechRecognizer.Extra

import Data.Default.Class (Default(..))

import Foreign.C.String (CString)
import Control.Concurrent.STM.TChan (TChan)

--------------------------------------------------------------------------------

{-| Opaque.

see
<https://developer.apple.com/library/mac/documentation/Cocoa/Reference/ApplicationKit/Classes/NSSpeechRecognizer_Class/>

-}
data NSSpeechRecognizer

-- NSArrayOfNSString
type NSVocabulary = ()

{-| A foreign pointer to a haskell function.

@
-- A.hs
hs_f :: FunPtr (CString -> IO ())
@

marshalls to:

@
-- A.c
void(*hs_f)(const char*)
@

see
<https://hackage.haskell.org/package/base-4.9.0.0/docs/Foreign-Ptr.html#t:FunPtr>

-}
type RecognitionHandler = CString -> IO ()

--------------------------------------------------------------------------------

{-| The complete state of an 'NSSpeechRecognizer'.

Can be @poke@d into the pointer.

-}
data Recognizer = Recognizer
 { rState    :: RecognizerState
 , rChannel  :: TChan CString --TODO mapChan to string
 } deriving (Eq)

{-| The part of the state of a 'Recognizer' that is "simple"
(i.e. can one derive the standard instances for).

-}
data RecognizerState = RecognizerState
 { rVocabulary  :: Vocabulary
 , rStatus      :: Status
 , rExclusivity :: Exclusivity
 } deriving (Show,Read,Eq,Ord,Data,Generic)
-- instance NFData MouseButton
-- instance Hashable MouseButton
-- instance IsList RecognizerState?

-- | 'defaultRecognizerState'
instance Default RecognizerState where
  def = defaultRecognizerState

type Vocabulary = [String] --TODO newtype

-- | 'Bool'-like.
data Status = On | Off
 deriving (Show,Read,Eq,Ord,Bounded,Enum,Data,Generic) -- TODO Monoid All?

-- | 'Bool'-like.
data Exclusivity = Inclusive | Exclusive -- TODO Monoid Any?
 deriving (Show,Read,Eq,Ord,Bounded,Enum,Data,Generic)

--------------------------------------------------------------------------------

{-|

-}
defaultRecognizerState :: RecognizerState
defaultRecognizerState = RecognizerState{..}
  where
  rVocabulary  = []
  rStatus      = On
  rExclusivity = Inclusive

--------------------------------------------------------------------------------
