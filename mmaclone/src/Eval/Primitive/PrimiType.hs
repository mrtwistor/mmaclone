{-#LANGUAGE FlexibleContexts , TemplateHaskell#-}

module Eval.Primitive.PrimiType where

import Data.DataType
import Data.Number.Number
import Data.Environment.EnvironmentType

import qualified Data.Map.Strict as M
import Control.Monad
import Control.Monad.Except
import Control.Monad.Trans.State
import Control.Lens hiding(List, Context)
import Data.Maybe
import qualified Data.Text as T


-- * Types and common functions for defining primitive functions.

type Result = ThrowsError (Maybe LispVal)
type IOResult = IOThrowsError (Maybe LispVal)

type EvalResult = IOThrowsError LispVal

type StateResult a = StateT PrimiEnv IOThrowsError a

-- | Basic primitive function which only perform simple term rewriting
type Primi = StateResult LispVal

type Eval = LispVal -> Primi

type Primitives = M.Map T.Text Primi

type EvalArguments = [LispVal] -> IOThrowsError LispVal


-- | Envrionment for primitive function
data PrimiEnv = PrimiEnv
  { _eval :: Eval
  , _con :: Context
  , _args :: [LispVal]
  -- , _modified :: Bool
  , _dep :: Int
  , _line :: Int
  }

makeLenses ''PrimiEnv
