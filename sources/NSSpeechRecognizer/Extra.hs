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

(-:) :: a -> b -> (a,b)
(-:) = (,)
infix 1 -:

_TODO :: a --TODO call stack / warning
_TODO = error "TODO"
