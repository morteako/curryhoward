---

```haskell
{-# OPTIONS_GHC -Wincomplete-patterns #-}
{-# LANGUAGE EmptyCase #-}
{-# LANGUAGE ScopedTypeVariables #-}
import Prelude hiding (Bool(..), curry, uncurry)
umulig = undefined
main = print "All tests passed"
```
}}}
math: mathjax
marp: true
paginate: true 
---
<!-- paginate: true -->

<style>
section {
  padding-top: 150px;
}
h1 {
  position: absolute;
  left: 80px;
  top: 80px;
  right: 80px;
  height: 70px;
  line-height: 70px;
}
</style>

# Bevis og programmering er sammme sak?

* Advarsel 1: Uformelt (:
* Advarsel 2: Litt dårlig tid :))
* Advarsel 3: Gøy tema ((:(:
---

# Curry-Howard-korrespondansen

##  Teorem i logikk $\leftrightarrow$ Typen har en verdi

---

# Rask intro til Haskellsyntaks

```haskell
data MinDatatype a = Venstre a | Hoyre a

eksempel :: Mindatatype Int
eksempel = Venstre 1

isVenstre :: MinDatatype a -> String
isVenstre minDatatype = case minDatatype of
  Venstre a -> "Yes"
  Hoyre a -> "No"
```

---
# Recap : Utsagnslogikk

* Verdier : $\top$, $\bot$
* Operatorer : &, |, $\rightarrow$ , $\neg$
* Formler
  * Bygget opp av verdier og operatorer
  * Bruker $A$,$B$ osv for å snakke om vilkårlige formler
  * $\bot$ $\rightarrow$ $\top$ , $A$ $\rightarrow$ ($B$ & $\neg$ $B$) osv
* Bevis

---

# Alle term/verdier er et bevis

* Typer er utsagn
    * Du kan bevise utsagnet `Int` ved å gi en verdi av typen `Int`
* En implementasjon av en verdi av en type blir da et bevis for utsagnet typen representer er sann

```haskell
num :: Int
num = 42
```
---

# Implikasjon

* $A$ $\rightarrow$ $B$

* I programmering : funksjoner
  * parametertype $A$
  * returtype $B$
  * Haskell : `a -> b`
* Eksempel
```haskell
impliesSelf :: a -> a
impliesSelf a = a
```

--- 

# Implikasjon - eksempler

```haskell
-- Hvis jeg er fransk, så er det sant at hvis gud er død, så er jeg fransk
const :: a -> b -> a
const a b = a
```

Flere eksempler
```haskell
flip :: (a -> b -> c) -> (b -> a -> c)
flip ab2c b a = ab2c a b


modusPonens :: (a -> b) -> a -> b
modusPonens a2b a = a2b a
```

---
# Sant - True

* En verdi av typen $A$ beviser utsagnet $A$
* `True` er da typen som er trivielt sant.


```haskell
data True = True
```
---

# And

* Logikk : $A$ & $B$ er et teorem kun hvis både $A$ og $B$ er teoremer 
  
```haskell
data And a b = And a b
```
---

# And : eksempler

```haskell
ae1 :: And True True
ae1 = And True True

ae2 :: And a b -> a
ae2 (And a b) = a

ae3 :: And a b -> And b a
ae3 (And a b) = (And b a)
```


---

# Or

* Logikk : $A$ | $B$ er et teorem hvis enten $A$ er et teorem og/eller $B$ er et teorem
* Haskell : 
  
```haskell
data Or a b = OrLeft a | OrRight  b
```

---

# Or : eksempler

```haskell
oe1 :: Or True b
oe1 = OrLeft True

oe2 :: Or a a -> a
oe2 orAA = case orAA of
    OrLeft a -> a
    OrRight a -> a
```

Ekstra eksempler
```haskell
oe3 :: And a b -> Or a b
oe3 (And a b) = OrRight b

oe4 :: Or a b -> And a b
oe4 = umulig
```


---

# False

* TODO ref fra INt her
* En verdi av typen $A$ beviser $A$
* Vi skal ikke kunne bevise noe som ikke er sant
* False (usant) må da være en type uten verdier
* Er faktisk praktisk nyttig
  * Kotlin : Nothing
  * Rust : ! (never)
  * Haskell : Void

```haskell
data False
```

---
# False - absurd
Fra noe usant kan man utlede hva som helst!

Dette kan vi implementere/bevise 

```haskell
absurd :: False -> a
absurd false = case false of {}

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
* Ide: Hvis noe er usant, skal man da kunne utlede noe usant
* Gir akkurat den oppførselen man får fra Not i logikk

```haskell
type Not a = a -> False
```



--- 
# Not Not

* Vi har lært at dobbelnegering gjør at man ender opp med samme
    * not (not a) = $\rightarrow$ a
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
<!-- * Har alt vært forgjeves?
* Henger det ikke på greip?
* Burde jeg holdt foredrag om noe annet, som gir mer mening?
  * Feks Spring og JavaBeans 
* Eller kan vi redde oss inn?  -->


---

# Logikk - klassisk

* Det finnes flere logikksystemer
* Den mest vanlige blir kalt _klassisk logikk_
* Med `Or a (Not a)`,`Not (Not a) -> a` og motsigelsesbevis
    <!-- * Viser at det motsatte og viser til at det fører til usannhet, og derfor må det orginale være tilfelle -->
* Fører til litt "_fjerne_" bevis
<!-- * der man sier at ting eksisterer pga det er en motsigelse hvis de ikke ikke-eksisterer -->

---
# Konstruktiv logikk
* Alle bevis demonstrerer eksistens
  * Å bevise $A$ er å demonstrere at $A$ eksisterer, med et eksempel
* En "svakere" logikk
  <!-- * Alt som er sant i konstruktiv logikk er sant i klassisk, men ikke motsatt
  * Så alt vi kan bevise med programmering er gyldige klassiske bevis også, men vi kan ikke bevise alt -->
* Uten `Or a (Not a)`,`Not (Not a) -> a` og motsigelsesbevis
* Bevis er algoritmer
---

# DeMorgans lover

* not ($A$ | $B$) = (not $A$) & (not $B$)
* not ($A$ & $B$) = (not $A$) | (not $B$)  

```haskell
law2 :: And (Not a) (Not b) -> Not (Or a b)
--   :: And (a -> False) (b -> False) -> Or a b -> False
law2 (And a2False b2False) orAB = case oraB of
  OrL a -> a2False a
  OrR b -> b2False b


law3 :: Not (And a b) -> Or (Not a) (Not b)
--(And a b -> False) -> Or (a -> False) (b -> False)
law3 andAB2False = umulig
```

---

# Oppsummering

* Typer er utsagn
* Programmer er bevis
* Interresante typer gir interessante bevis
* Gjelder for mange logikk og typesystemer
* Grunnlaget for theorem provers som Coq, Agda, Lean
  
* PS : Gjelder kun hvis alt vi implementerer terminerer og ikke bruker errors/exceptions osv. Hvis ikke kan vi fort få motsigelser og inkonsistent logikk
<!-- * Konkrete typer gir uinteressante beviss
* Typevariabler gir interesante bevise
*  -->

