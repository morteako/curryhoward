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
paginate: true 

---
<!-- paginate: true -->

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

# False

* En verdi av typen A beviser A
* Vi skal ikke kunne bevise noe som ikke er sant
* False (usant) må da være en type uten verdier
* Er faktisk nyttig og inkludert i standardbiblioteker
  * Kotlin : Nothing
  * Rust : ! (never)
  * Haskell : Void

Haskell
```haskell
data False
```
Kotlin
```kotlin
class False private constructor()
```

---
# False - absurd
Fra noe usant kan man utlede hva som helst!

Dette kan vi implementere/bevise 

```haskell
absurd :: False -> a
absurd false = case false of {}
```

```kotlin
fun <A> absurd(fals:False):A =
    when(fals) {}
```

---

# Absurd : eksempel

```haskell
orFalse :: Or a False -> a
orFalse or_a_False = case or_a_False of
    OrLeft a -> a
    OrRight false -> todo
```

---

# Not - Negasjon
Nå mangler vi bare Not , altså å negere et uttrykk
* Sanne utsagn til usanne utsagn
* Typer med verdier til typer uten verdier og motsatt 

Et hendig logikktriks er da å implementere not ved hjelp av `False` og implikasjon
```haskell
type Not a = a -> False           --Haskell
```

```kotlin
typealias Not<T> = (T) -> False   //Kotlin
```
* Ide: Hvis noe er usant, skal man da kunne utlede noe usant
* Gir akkurat den oppførselen man får fra Not i logikk
---

# Not : eksempler

```haskell
explosion :: And a (Not a) -> False
--        :: And a (a -> False) -> False
explosion (And a notA) = todo

```

--- 
# Not Not

* Vi har lært at dobbelnegering gjør at man ender opp med samme
    * Not (Not a) $\rightarrow$ a
    * a $\rightarrow$ Not (Not a)

* Hvis et utsagn er sant, så er det ikke sant at det utsagnet er usant (og motsatt)
* "Hvis det ikke er tilfelle at vi ikke jobber i Bekk, så jobber vi i Bekk "

```haskell
impliesNotNot :: a -> Not (Not a)
--            :: a -> (Not (a -> False)
--            :: a -> ((a -> False) -> False)
--            :: a -> (a -> False) -> False
impliesNotNot a a2false = todo
```


---

# Not Not - andre veien

```haskell
notnotImplies :: Not (Not a) -> a
--            :: (Not (a -> False)) -> a
--            :: ((a -> False) -> False) -> a
notnotImplies a2false_false = todo
```




---


# Not Not - andre veien

* Hva går galt her?
* Har alt vært forgjeves?
* Henger det ikke på greip?
* Burde jeg holdt foredrag om noe annet, som gir mer mening?
  * Feks Spring og JavaBeans 
* Eller kan vi redde oss inn? 


---

# Logikk - klassisk

* Det finnes flere logikksystemer
* Den mest vanlig blir kalt "klassisk logikk"
* Funker bra til ENDEL, men ikke til alt
* Inkluderer
  * Excluded middle :: Or a (Not a)
  * Dobbelnegasjon (begge veier)
  * Motsigelsesbevis
    * Viser at det motsatte og viser til at det fører til usannhet, og derfor må det orginale være tilfelle
    * Feks : bevise at $\sqrt{2}$ er et irrasjonelt tall ved å anta at det er et rasjonelt tall og vise at det fører til en kontradiksjon (noe usant)
---
# Konstruktiv logikk
* Alle bevis demonstrerer eksistens
  * Å bevise A er å demonstrere at A eksisterer
  * Demonstrerer ved å gi et eksempel
* En "svakere" logikk
  * Alt som er sant i konstruktiv logikk er sant i klassisk, men ikke motsatt
  * Så alt vi kan bevise med programmering er gyldige klassiske bevis også, men vi kan ikke bevise alt
* Eksluderer:
  * Excluded middle :: Or a (Not a) 
  * Not (Not a) -> a 
  * Motsigelsesbevis
---

# DeMorgans

---

# Slutt

