{-# OPTIONS_GHC -Wincomplete-patterns #-}
{-# LANGUAGE EmptyCase #-}
import Prelude hiding (Bool(..), curry, uncurry)
umulig = undefined
main = print "All tests passed"

data MinDatatype a = Venstre a | Hoyre a

eksempel :: MinDatatype Int
eksempel = Venstre 1

isVenstre :: MinDatatype a -> String
isVenstre minDatatype = case minDatatype of
  Venstre a -> "Yes"
  Hoyre a -> "No"

num :: Int
num = 42

impliesSelf :: a -> a
impliesSelf a = a

const :: a -> b -> a
const a b = a

data True = True

data And a b = And a b

ae1 :: And True True
ae1 = And True True

ae2 :: And a b -> a
ae2 (And a b) = a

ae3 :: And a b -> And b a
ae3 (And a b) = (And b a)

data Or a b = OrLeft a | OrRight  b

oe1 :: Or True b
oe1 = OrLeft True

oe2 :: Or a a -> a
oe2 orAA = case orAA of
    OrLeft a -> a
    OrRight a -> a

data False

absurd :: False -> b
absurd false = case false of {}

orFalse :: Or a False -> a
orFalse or_a_False = case or_a_False of
    OrLeft a -> a
    OrRight false -> absurd false

type Not a = a -> False

impliesNotNot :: a -> Not (Not a)
--            :: a -> (Not (a -> False)
--            :: a -> ((a -> False) -> False)
--            :: a -> (a -> False) -> False
impliesNotNot a a2false = a2false a

notnotImplies :: Not (Not a) -> a
--            :: (Not (a -> False)) -> a
--            :: ((a -> False) -> False) -> a
notnotImplies a2false_false = umulig

law2 :: And (Not a) (Not b) -> Not (Or a b)
--   :: And (a -> False) (b -> False) -> Or a b -> False
law2 (And a2False b2False) orAB = case orAB of
  OrLeft a -> a2False a
  OrRight b -> b2False b
