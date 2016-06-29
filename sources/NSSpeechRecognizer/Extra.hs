module NSSpeechRecognizer.Extra
 ( module NSSpeechRecognizer.Extra
 , module X
 ) where

-- import Control.DeepSeq as X (NFData)
-- import Data.Hashable as X (Hashable)
-- import Data.Semigroup as X (Semigroup)

import Data.Data as X (Data)
import GHC.Generics as X (Generic)
import Control.Arrow as X ((>>>))
import Data.Function as X ((&),on)
import Data.Foldable as X (traverse_)
import Control.Exception as X (bracket)
import Control.Monad as X ((>=>))

import Control.Exception (ErrorCall(..))
import Control.Exception (throwIO)

nothing :: (Monad m) => m ()
nothing = return ()

_TODO :: a --TODO call stack / warning
_TODO = error "TODO"

throwS :: String -> IO a
throwS = ErrorCall >>> throwIO

