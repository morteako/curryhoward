---
```haskell
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



## Bevis og programmering er sammme sak?

#### Morten Kolstad - Bekk fagdag oktober 2021

* Takk til Gaute Berge

<!--
* Advarsel 1: Uformelt (:
* Advarsel 2: Litt dårlig tid :))
* Advarsel 3: Gøy tema ((:(:
 -->
---


# Rask intro til Haskellsyntaks



```haskell
data MinDatatype a = Venstre a | Hoyre a

eksempel :: MinDatatype Int
eksempel = Venstre 1

isVenstre :: MinDatatype a -> String
isVenstre minDatatype = case minDatatype of
  Venstre a -> "Yes"
  Hoyre a -> "No"
```


<!--
* `::` - har typen
* Typevariabler (Generics) har små bokstaver : feks `a`
-->

---

# Hva er bevis?

* Et argument som viser at antagelsene garanterer konklusjonen
* Sammenheng med programmering? 
<!--
-->
---

# Curry-Howard-korrespondansen
<!-- 
  Bevisssystsemer og typesystemer
  Bruker Haskell 
  Gjelder for alle statisk typede språk med med algebraiske datatyper -->
##  Teorem i logikk $\leftrightarrow$ Typen har en verdi

<!-- -->
---
# Recap : Utsagnslogikk

* Verdier : $\top$(true), $\bot$(false)
* Operatorer : &, |, $\rightarrow$ , not
* Formler
  * Bygget opp av verdier og operatorer
  * Bruker $A$,$B$ osv for å snakke om vilkårlige formler
  * $\bot$ $\rightarrow$ $\top$ , $A$ $\rightarrow$ ($B$ & not $B$) osv
* Bevis

<!-- -->
---

# Typer er utsagn og programmer er bevis

* Du kan bevise utsagnet `Int` ved å gi en eksempelverdi av typen `Int`
```haskell
num :: Int
num = 42
```
```kotlin
val num : Int = 42
```
* En implementasjon av en verdi av en type blir da et bevis for utsagnet typen representer er sann


<!-- Men Int er et ganske uinteressant utsagn. Det blir som True, som er trivielt sant -->
---

# Implikasjon

* $A$ $\rightarrow$ $B$

* I programmering : funksjoner
  * parametertype $A$, returtype $B$
  * Haskell : `a -> b`,  Kotlin : `<A,B> fun f(a:A):B`
* Typevariabler gjør at vi ikke mister generalitet
* Eksempel : $A$ $\rightarrow$ $A$
```haskell
impliesSelf :: a -> a
impliesSelf a = a
```
```kotlin
fun <A> impliesSelf(a:A):A = a
```

<!--
Hvis jeg får en verdi med type a,så kan jeg gi en verdi med type b
-->
--- 

# Implikasjon - eksempel

* $A$ $\rightarrow$ $B$ $\rightarrow$ $A$
* Hvis jeg er fransk, så er det sant at hvis 2+2=5, så er jeg fransk

```haskell
const :: a -> b -> a
const a b = a
```
```kotlin
fun <A,B> const(a:A,b:B):A = a
```

<!--

-->
---
# $\top$ : Sant - True

* En verdi av typen $A$ beviser utsagnet $A$
* `True` er da typen som er trivielt sant.


```haskell
data True = True
```
```kotlin
object True
```
<!-- Kunne brukt Int -->
---

# & : And

* Logikk : $A$ & $B$ er et teorem kun hvis både $A$ og $B$ er teoremer 
  
```haskell
data And a b = And a b
```
```kotlin
data class And<A,B>(val a:A, val b:B)
```
<!-- For å bevise a og b, må man ha bevis for a og bevis for b-->
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
```kotlin
val ae1 : And<True,True> = And(True,True)

fun <A,B> ae2(and:And<A,B>):A = and.a

fun <A,B> ae3(and:And<A,B>):And<B,A> = And(and.b, and.a)
```
<!-- -->
---

# | : Or 

* Logikk : $A$ | $B$ er et teorem hvis $A$ er et teorem eller $B$ er et teorem
  
```haskell
data Or a b = OrLeft a | OrRight  b
```
```kotlin
sealed class Or<A,B>
data class OrLeft<A,B>(val a:A):Or<A,B>()
data class OrRight<A,B>(val b:B):Or<A,B>()
```

<!-- -->
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
```kotlin
fun <B> oe1 ():Or<True,B> = OrLeft(True)

fun <A> oe2 (orAA:Or<A,A>) : A = when(orAA) {
    is OrLeft -> orAA.a
    is OrRight -> orAA.b
}
```

<!-- -->
---

# $\bot$ : False - en type uten verdier

* En verdi av typen $A$ beviser utsagnet $A$
* $\bot$ - usant - skal aldri kunne bevises


```haskell
data False
```
```kotlin
typealias False = Nothing
```

* Er faktisk praktisk nyttig
  * Haskell : Nothing
  * Rust : ! (never)
  * Haskell : Void

<!--

* Vi skal ikke kunne bevise noe som ikke er sant
* False (usant) må da være en type uten verdier
*  -->
---
# False - absurd
Fra noe usant kan man utlede hva som helst!


```haskell
absurd :: False -> b
absurd false = case false of {}

orFalse :: Or a False -> a
orFalse or_a_False = case or_a_False of
    OrLeft a -> a
    OrRight false -> absurd false
```
```kotlin
fun <B> absurd(n:False) : B = when(n) { }

fun <A> orFalse(or_a_False:Or<A,False>):A = when(or_a_False) {
    is OrLeft -> or_a_False.a
    is OrRight -> absurd(or_a_False.b)
}
```
<!-- 
Dette kan vi implementere/bevise 
Bruke til å bevise at hvis man har 
-->
---

# Not - Negasjon

* Typer med verdier til typer uten verdier

```haskell
type Not a = a -> False
```
```kotlin
typealias Not<A> = (A) -> False
```
<!--
Mangler bare not
logikktriks å implementere not ved hjelp av `False` og implikasjon
* Ide: Hvis noe er usant, skal man da kunne utlede noe usant
* Gir akkurat den oppførselen man får fra NOt i logikk
-->


<!-- -->
--- 
# Not Not - dobbelnegering

* not (not a) $\rightarrow$ a
* a $\rightarrow$ not (not a)



```haskell
impliesNotNot :: a -> Not (Not a)
--            :: a -> (Not (a -> False)
--            :: a -> ((a -> False) -> False)
--            :: a -> (a -> False) -> False
impliesNotNot a a2false = a2false a
```
```kotlin
fun <A> impliesNotNot(a:A):Not<Not<A>> =
    {a2false: (A) -> False -> 
        a2false(a)
    }
```

<!--
* "Hvis det ikke er sant at vi ikke er på ifi, så er vi på ifi "
* * Hvis et utsagn er sant, så er det ikke sant at det utsagnet er usant (og motsatt)
 -->
---

# Not Not - andre veien

```haskell
notnotImplies :: Not (Not a) -> a
--            :: (Not (a -> False)) -> a
--            :: ((a -> False) -> False) -> a
notnotImplies a2false_false = umulig
```
```kotlin
fun <A> notnotImplies(f:Not<Not<A>>):A =
    TODO("UMULIG")
```
<!-- -->
---


# Not Not - andre veien

* Hva går galt her?
<!-- * Har alt vært forgjeves?
* Henger det ikke på greip?
* Burde jeg holdt foredrag om noe annet, som gir mer mening?
  * Javascript
* Eller har vi bare ikke vært presise nok når vi snakker om logikk? 
* -->

---

# Logikk - klassisk

* Det finnes flere logikksystemer
* Den mest vanlige blir kalt _klassisk logikk_
* Med `Or a (Not a)`,`Not (Not a) -> a` og motsigelsesbevis

* Kan føre til litt "_fjerne_" bevis


<!--
* der man sier at ting eksisterer pga det er en motsigelse hvis de ikke ikke-eksisterer
 * Viser at det motsatte og viser til at det fører til usannhet, og derfor må det orginale være tilfelle
 -->
---
# Konstruktiv logikk
* Alle bevis demonstrerer eksistens
  * Å bevise $A$ er å demonstrere at $A$ eksisterer, med et eksempel
* En "svakere" logikk
* Uten `Or a (Not a)`,`Not (Not a) -> a` og motsigelsesbevis

<!-- 
Alt som er sant i konstruktiv logikk er sant i klassisk, men ikke motsatt
Så alt vi kan bevise med programmering er gyldige klassiske bevis også, men vi kan ikke bevise alt 

-->
---

# De Morgans lover

* not ($A$ | $B$) = (not $A$) & (not $B$)

```haskell
law2 :: And (Not a) (Not b) -> Not (Or a b)
--   :: And (a -> False) (b -> False) -> Or a b -> False
law2 (And a2False b2False) orAB = case orAB of
  OrLeft a -> a2False a
  OrRight b -> b2False b
```

* not ($A$ & $B$) = (not $A$) | (not $B$)  
```haskell
law3 :: Not (And a b) -> Or (Not a) (Not b)
--(And a b -> False) -> Or (a -> False) (b -> False)
law3 andAB2False = umulig
```

<!-- -->
---

# Oppsummering

* Typer er utsagn, programmer er bevis
* Dyp korrespondanse : gjelder for mange logikk og typesystemer
* Bevisene blir maskinsjekket!
  * All koden i denne talken kompilerer*
* Grunnlaget for theorem provers som Coq, Agda, Lean
  
  
  
* *Gjelder kun hvis alt vi implementerer terminerer og ikke bruker errors/exceptions osv. Hvis ikke kan vi fort få motsigelser og inkonsistent logikk. Ref `umulig`


