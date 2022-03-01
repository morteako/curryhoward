# Proving theorems in Haskell

```haskell
{-# LANGUAGE EmptyCase #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# OPTIONS -fwarn-incomplete-patterns #-}
import Prelude hiding (Bool(..))

```
## If ->

```haskell
aa :: a -> a
aa a = a

aba :: a -> b -> a
aba = undefined
```

## Or

```haskell
data Or a b = OrL a | OrR b


```

## And

```haskell
data And a b = And a b
```

## And

```haskell

andL :: And a b -> a
andL (And a b) = a

andR :: And a b -> b
andR (And a b) = undefined

orA :: Or a a -> a
orA = undefined

-- p -> p or p

-- !(p & !p) 
andAnotA :: Not (And a (Not a))
andAnotA (And a notA) = notA a
```

## True

`true` is something that is trivially true.
Therefor we can represent `true` by a type where we can just create values of that type out of thin air.
By using the constructor.

```haskell
data True = True
```

## False

To represent `false`, we need a type that which it is impossible to create values for.
How is this possible?
By making a data type without any constructors[2].

```haskell
data False
```

Because `False` has no constructors, it is impossible to create value of type `False`

How can we use this to represents `not`?

In logic[3] the semantics of not is often treated as a -> `false`.
Because if a is true, then a -> false, becomes false.
If a is false, then false -> false, becomes true. Which is what we expect from `not`.

To represent not, we make a type alias `Not` that says that not p == a -> false , Not p == a -> False.

```haskell
type Not a = a -> False
```

We can then prove that `a => not (not a)` represented by the function.

```elm
a2notNotA :: a -> Not (Not a)
```

At first glance this may seem like it is not possible to implement, but if we expand our Not-type alias,

```elm
a -> Not (Not a)
a -> Not (a -> False)
a -> ((a -> False) -> False)
a -> (a -> False) -> False
```

the implementation is fairly obvious :

```haskell
a2notNotA :: a -> (a -> False) -> False
a2notNotA a a2Void = a2Void a

nonContra :: Not (And a (Not a))
nonContra (And a notA) = notA a
```

In classical logic, we have both `a <=> not (not a)`, so it would be natural to try to prove the other way,
`not (not a) => a`, represented by the function

```elm
notNotA2A :: Not (Not a) -> a
```

We expand the type aliases

```elm
Not (Not a) -> a
(Not a -> False) -> a
((a -> False) -> False) -> a

notNotA2A :: ((a -> False) -> False) -> a
notNotA2A a2Void2Void = ?
```

If you look at the resulting type and think that it looks hard to implement, you are correct!
It is actually impossible.
But how can that happen, when we have learned in "school" that `not (not a) == a` ?

This is because the Haskell type system (and most other type systems) represents intuinistic logic, and not classical logic.
Here `not (not a) -> a` is not a theorem.
This is because in inuinistic logic, you need concrete evidence of your proofs.
The You can't use the law of excluded middle,

We can use this to prove that (a or false -> a)

```haskell
noe :: Or a False -> a
noe (OrL a) = a
noe (OrR v) = absurd v
```

```haskell
implOr :: (a -> b) -> Or (Not a) b
implOr = undefined

orImpl :: Or (Not a) b -> (a -> b)
orImpl (OrL a2Void) a = absurd (a2Void a)
orImpl (OrR b) a = b
```



## Law of excluded middle

A classic classical :) axiom is the law of excluded middle, which means that for any proposition, either the proposition is true or the negation is true.
`p or not p`.
If we try to implement a proof of this, we fall short.

```Haskell
middle :: Or a (Not a)
middle = ?
```

We need either an
OrL a, but that is not possible, because we can not just "conjure" an `a` out of nothing.
OrR needs to conjure a False out of nothing, which also is impossible.

## De morgans laws

not (A or B) = not A and not B

```haskell
law1 :: Not (Or a b) -> And (Not a) (Not b)
--law1 :: ((Or a b) -> False) -> And (a -> False) (b -> False)
law1 orAB2Void = And a2Void b2Void
    where
        a2Void a = orAB2Void (OrL a)
        b2Void b = orAB2Void (OrR b)

law2 :: And (Not a) (Not b) -> Not (Or a b)
--law2 :: And (Not a) (Not b) -> Or a b -> False
law2 (And notA notB) or =
    case or of
        OrL a -> notA a
        OrR b -> notB b

law3 :: Not (And a b) -> Or (Not a) (Not b)
--law3 :: (And a b -> False) -> Or (a -> False) (b -> False)
law3 notAandB = error "NOT POSSIBLE"

law4 :: Or (Not a) (Not b) -> Not (And a b)
--law4 :: Or (Not a) (Not b) -> And a b -> False
law4 (OrL notA) (And a b) = notA a
law4 (OrR notB) (And a b) = notB b
```

# Notes

[1] : Excluding bottom.

[2] : Data.False

[3] : Could have used the cannonical datatypes (a,b) and Either a b instead of And and Or

```haskell
main = print 0
```
