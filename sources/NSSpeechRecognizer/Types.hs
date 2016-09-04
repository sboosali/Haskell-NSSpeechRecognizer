{-# LANGUAGE EmptyCase, RecordWildCards #-}

{-|

-}
module NSSpeechRecognizer.Types where
import NSSpeechRecognizer.Extra

import Data.Default.Class (Default(..))

import Foreign (Ptr)
import Foreign.C.String (CString)
-- import Control.Concurrent.STM.TChan (TChan)
import Data.Int(Int8)

--------------------------------------------------------------------------------
-- Haskell types

{-| The complete state of an 'NSSpeechRecognizer'.

Can be @poke@d into the pointer.

-}
data Recognizer = Recognizer
 { rState    :: RecognizerState
 , rHandler  :: RecognitionHandler
 -- , rChannel  :: TChan CString --TODO mapTChan to string?
 }
 -- deriving (Eq)

{-| The part of the state of a 'Recognizer' that is "simple"
(i.e. can one derive the standard instances for).

-}
data RecognizerState = RecognizerState
 { rVocabulary     :: Vocabulary
 , rStatus         :: Status
 , rExclusivity    :: Exclusivity
 , rForegroundOnly :: ForegroundOnly
 } deriving (Show,Read,Eq,Ord,Data,Generic)
-- instance NFData RecognizerState
-- instance Hashable RecognizerState
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

-- | 'Bool'-like.
data ForegroundOnly = ForegroundOnly | BackgroundAlso -- TODO Monoid?
 deriving (Show,Read,Eq,Ord,Bounded,Enum,Data,Generic)

--------------------------------------------------------------------------------
-- Objective-C types

{-|

@\<objc.h>@ defines:

@
typedef signed char BOOL;
@

-}
type BOOL = Int8

--------------------------------------------------------------------------------

{-| Opaque.

see
<https://developer.apple.com/library/mac/documentation/Cocoa/Reference/ApplicationKit/Classes/NSSpeechRecognizer_Class/>

Corresponds to @native/Recognizer.h@, which:

* implements the @NSSpeechRecognizerDelegate@ interface, and
* wraps a @NSSpeechRecognizer@ object.

-}
data NSSpeechRecognizer

-- |
type P'NSSpeechRecognizer = Ptr NSSpeechRecognizer

{- |

The native code marhsalls a 'CStringArrayLen' into a @NSArray<NSString*>*@

Given a vocabulary with more than a thousand phrases,
recognition is already less efficient and less accurate;
so 'Int' is large enough.

-}
type NSVocabulary = CStringArrayLen --TODO

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
--TODO type CRecognitionHandler = CString -> IO ()
--TODO type RecognitionHandler = String -> IO ()
-- :: RecognitionHandler -> CRecognitionHandler
-- = (peekCString >=>)

--------------------------------------------------------------------------------
-- C types

-- |
type CArray = Ptr

-- | @char* a[];@ ~ @a :: Ptr (Ptr CChar)@
type CStringArray = CArray CString

-- | @(char* a[], int l)@ ~ @a :: (Ptr (Ptr CChar), CInt)@
type CStringArrayLen = (CArray CString, Int)

--------------------------------------------------------------------------------

{-| Map a set of phrases to actions.

Naming: like "keymap".

-}
type VoiceMap = [(String, IO ())]

--------------------------------------------------------------------------------
-- Values

-- |
defaultRecognizer :: RecognitionHandler -> Recognizer
defaultRecognizer rHandler = Recognizer{..}
  where
  rState = defaultRecognizerState

-- defaultRecognizer :: TChan CString -> Recognizer
-- defaultRecognizer rChannel = Recognizer{..}
--   where
--   rState = defaultRecognizerState

{-|

@
'rVocabulary'     = []
'rStatus'         = 'On'
'rExclusivity'    = 'Inclusive'
'rForegroundOnly' = 'BackgroundAlso'
@

-}
defaultRecognizerState :: RecognizerState
defaultRecognizerState = RecognizerState{..}
  where
  rVocabulary     = []
  rStatus         = On
  rExclusivity    = Inclusive
  rForegroundOnly = BackgroundAlso

--------------------------------------------------------------------------------
