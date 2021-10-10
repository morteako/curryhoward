---

```haskell
{-# OPTIONS_GHC -Wincomplete-patterns #-}
{-# LANGUAGE EmptyCase #-}
{-# LANGUAGE ScopedTypeVariables #-}
import Prelude hiding (Bool(..), curry, uncurry)
todo = undefined
main = print "All tests passed"
```
}}}
math: mathjax
marp: true
<!-- paginate: true -->

---

# Bevis og programmering er sammme sak?


---

# Utsagnslogikk


---

# Korrespondanse

| Logikk      | Logikksyntaks     | Haskell | Kotlin |
| ----------- | ----------------- | ------- | ------ |
| A og B      | A & B             | ?       | ?      |
| A eller B   | A \| B            | ?       | ?      |
| Hvis A så B | A $\rightarrow$ B | ?       | ?      |
| Sant        | $\top$            | ?       | ?      |
| Usant       | $\bot$            | ?       | ?      |
| Ikke A      | $\not$            | ?       | ?      |
---
# Hva er et bevis?

---

# Alle term/verdier er et bevis

---

# True

```haskell
data True = True
```

---

# Implication

---

# And

* Logikk : A & B betyr både A og B
* Vi må da ha en datatype som har både en A og en B
* Haskell : 
  
```haskell
data And a b = And a b
```
* Kotlin : 
```kotlin
data class And<A,B>(val left:A, val right:B)
```

---

# And : eksempler

```haskell
andTrueTrue :: And True True
andTrueTrue = And True True

andLeft :: And a b -> a
andLeft (And a b) = a

andFlip :: And a b -> And b a
andFlip (And a b) = todo

aToAnd :: a -> And a b
aToAnd a = todo
```


---

# Or

* Logikk : A | B betyr enten A eller B
* Vi må da ha en datatype som enten inneholder en A eller inneholder en B
* Haskell : 
  
```haskell
data Or a b = OrLeft a | OrRight  b
```
* Kotlin : 
```kotlin
sealed class Or<A,B>

data class OrLeft<A,B>(val left:A):Or<A,B>()
data class OrRight<A,B>(val right:B):Or<A,B>() 
```

---

# Or : eksempler

```haskell
orLeftTrue :: Or True b
orLeftTrue = OrLeft True

orCombine :: Or a a -> a
orCombine orAA = case orAA of
    OrLeft a -> a
    OrRight a -> a

andImpliesOr :: And a b -> Or a q
andImpliesOr (And a b) = todo

orImpliesAnd :: Or a b -> And a b
orImpliesAnd orAB = case orAB of
    OrLeft a -> todo
    OrLeft b -> todo
```


---

# False og Not

---

# Dobbel negasjon

---

# Konstruktiv logikk


---

# DeMorgans

---

# Slutt

