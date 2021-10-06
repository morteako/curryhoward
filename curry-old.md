---

```haskell
{-# LANGUAGE EmptyCase #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# OPTIONS -fwarn-incomplete-patterns #-}
import Prelude hiding (Bool(..))
main = print 0
```
}}}
marp: true
<!-- paginate: true -->

---
# Curry-Howard isomorfismen
---
# 

---
# 

---

# Proving theorems in Haskell


## If ->

```haskell
aa :: a -> a
aa a = a

aba :: a -> (b -> a)
aba a b = a
```

---

## Or

```haskell
data Or a b = OrL a | OrR b


```
---

## And

```haskell
data And a b = And a b
```

---


```haskell
andL :: And a b -> a
andL (And a b) = a

andR :: And a b -> b
andR (And a b) = b

orA :: Or a a -> a
orA (OrL a) = a
orA (OrR a) = a


-- p -> p or p
pp :: a -> Or a a
pp a = OrL a

mm :: And a b -> Or a q
mm (And a b) = OrL a

-- !(p & !p) 
andAnotA :: Not (And a (Not a))
andAnotA = undefined
```
---
## True

`true` is something that is trivially true.
Therefor we can represent `true` by a type where we can just create values of that type out of thin air.
By using the constructor.

```haskell
data True = True
```
---
## False

To represent `false`, we need a type that which it is impossible to create values for.
How is this possible?
By making a data type without any constructors[2].

```haskell
data False
```

Because `False` has no constructors, it is impossible to create value of type `False`

How can we use this to represents `not`?

---

In logic[3] the semantics of not is often treated as a -> `false`.
Because if a is true, then a -> false, becomes false.
If a is false, then false -> false, becomes true. Which is what we expect from `not`.

To represent not, we make a type alias `Not` that says that not p == a -> false , Not p == a -> False.

```haskell
type Not a = a -> False


-- F -> p
absurd :: False -> a
absurd x = case x of {

}
```

---

We can then prove that `a => not (not a)` represented by the function.

```haskell
-- a -> !!a






nonContra :: Not (And a (Not a))
nonContra (And a notA) = notA a
```

In classical logic, we have both `a <=> not (not a)`, so it would be natural to try to prove the other way,
`not (not a) => a`, represented by the function



If you look at the resulting type and think that it looks hard to implement, you are correct!
It is actually impossible.
But how can that happen, when we have learned in "school" that `not (not a) == a` ?

This is because the Haskell type system (and most other type systems) represents intuinistic logic, and not classical logic.
Here `not (not a) -> a` is not a theorem.
This is because in inuinistic logic, you need concrete evidence of your proofs.
The You can't use the law of excluded middle,



```haskell
noe :: Or a False -> a
noe (OrL a) = a
noe (OrR false) = absurd false
```

```haskell
-- ?
implOr :: (a -> b) -> Or (Not a) b
implOr f = undefined

--a -> False
orImpl :: Or (Not a) b -> a -> b
orImpl (OrL notA) a = absurd $ notA a
orImpl (OrR b) a = b
```



## Law of excluded middle

A classical classical :) axiom is the law of excluded middle, which means that for any proposition, either the proposition is true or the negation is true.
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
--law1 :: (Or a b -> False) -> And (a -> False) (b -> False)
law1 orAB2Void = And a2False b2False
    where
        a2False a = orAB2Void (OrL a) 

        b2False b = orAB2Void (OrR b) 

law2 :: And (Not a) (Not b) -> Not (Or a b)
-- And (a -> False) (b -> False) -> Or a b -> False
law2 (And a2False b2False) (OrL a) = a2False a
law2 (And a2False b2False) (OrR b) = b2False b

law3 :: Not (And a b) -> Or (Not a) (Not b)
--(And a b -> False) -> Or (a -> False) (b -> False)
law3 andAB2False = undefined

law4  :: Or (Not a) (Not b) -> Not (And a b)
--Or (a -> False) (b -> False) -> And a b -> False
law4 (OrL af) (And a b) = af a
law4 (OrR bf) (And a b) = bf b




```
---
# Notes

[1] : Excluding bottom.

[2] : Data.Void

[3] : Could have used the cannonical datatypes (a,b) and Either a b instead of And and Or


