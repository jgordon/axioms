# Dynamic Functional Composite Entities

## Predicates

- `(decreaseFct y)`
- `(decreaseStruct x)`
- ...


## Axioms

### Functional Composite Entities

A functional composite entity is a composite entity with a functionality.

```
(forall (f x)
  (if (and (compositeEntity x) (function f x))
      (fCompEnt x)))
```


If f is the functionality of x and x is "functional" (with respect
to f), there is some event e involving x that causes f.

```
(forall (f x)
  (if (and (function f x) (functional x f))
      (exists (e)
        (and (cause e f) (arg* x e)))))
```


The primed version of `functional`. (This would be automatically
generated.)

```
(forall (e f x)
  (if (and (functional' e x f) (Rexist e))
      (functional x f)))
```


The next two axioms adumbrate the concept of one entity being more
functional than another.

s1 is the set of points on the functionality scale. `(scaleDefinedBy s s1
e)` says s is a scale with elements s1 and partial ordering e.

```
(forall (e f s s1 x)
  (if (and (scaleDefinedBy s s1 e) (functional' e x f))
      (functionScale s f)))
```

Essentially, x is more functional than y if x is higher on the
functionality scale, where being in the `Hi` region of the functionality
scale means something is functional (which means there is an event
involving it that brings about its functionality).

```
(forall (e f s x y)
  (if (and (partialOrdering e x y s) (functionScale s f))
      (lessFct' e x y f)))
```


The primed version of `lessFct`. (This would be automatically
generated.)

```
(forall (e f x y)
  (if (and (lessFct' e x y f) (Rexist e))
      (lessFct x y f)))
```


A weak constraint on `lessFct`: If f is the function of both x1 and
x2, and using x1 to achieve f succeeds while using x2 fails, then x2
is less functional than x1.

```
(forall (e1 e2 e3 f x1 x2)
  (if (and (function f x1) (function f x2) (cause e1 f)
           (not' e3 e2) (cause e2 f) (Subst x1 e1 x2 e2))
      (exists (x y)
        (lessFct y x f))))
```


A change from being less functional to being more functional is an
increase in function.

```
(forall (e e1 e2 f s x y1 y2)
  (if (and (change e e1 e2) (at' e1 x y1 s) (at' e2 x y2 s)
           (functionScale s f) (lessFct y1 y2 f))
      (increaseFct x f)))
```


A change from being more functional to being less functional is a
decrease in function.

```
(forall (e e1 e2 f s x y1 y2)
  (if (and (change e e1 e2) (at' e1 x y1 s) (at' e2 x y2 s)
           (functionScale s f) (lessFct y2 y1 f))
      (decreaseFct x f)))
```


If the structure of x increases, its function increases.

```
(forall (f x)
  (if (and (increaseStruct x) (function f x))
      (increaseFct x f)))
```


If the structure of x decreases, its function decreases.

```
(forall (f x)
  (if (and (decreaseStruct x) (function f x))
      (decreaseFct x f)))
```


If the function of x increases, its structure has increased.

```
(forall (x y f)
  (if (and (increaseFct x f) (function f x))
      (increaseStruct x)))
```


If the function of x decreases, its structure has decreased.

```
(forall (x y f)
  (if (and (decreaseFct x f) (function f x))
      (decreaseStruct x)))
```


### Dynamic Functional Composite Entities

A process of x is a set of changes in x.

```
(forall (e e1 e2 s x)
  (if (and (changes s) (typelt e s) (change e e1 e2)
           (arg* x e))
       (process s x)))
```


A dynamic functional composite entity is a functional composite entity for
which there is a process e that causes its function f.

```
(forall (f s x)
  (if (and (fCompEnt x) (function f x) (process s x)
           (cause s f))
      (and (dFCompEnt x) (processOf s x))))
```


## Lexical Axioms

### Doing things with DFCEs

To decrease structure is to damage.

```
(forall (x)
  (if (decreaseStruct x)
      (exists (e u v x y)
        (damage-vb e y x u v))))
```


One way of decreasing structure is to destroy.

```
(forall (x)
  (if (and (decreaseStruct x) (etc-destroy-vb1 x))
      (exists (e u v y)
        (destroy-vb e y x u v))))
```


One way of decreasing structure is to demolish.

```
(forall (x)
  (if (and (decreaseStruct x) (etc-demolish-vb1 x))
      (exists (e u v y)
        (demolish-vb e y x u v))))
```


One way of decreasing structure is to be a cataclysm.

```
(forall (e1 x)
  (if (and (decreaseStruct' e1 x) (etc-cataclysmic-adj1 e1 x))
     (exists (e)
       (cataclysmic-adj e e1))))
```


One way of increasing structure is to build.

```
(forall (x)
  (if (and (increaseStruct x) (etc-build-vb1 x))
      (exists (e u v z)
        (build-vb e z x u v))))
```


The primed version of `build`. (This would be automatically generated.)

```
(forall (e x z)
  (if (and (build' e z x) (Rexist e))
      (build z x)))
```


Building can be described by the verb "build".

```
(forall (x z)
  (if (build z x)
      (exists (e u v)
        (build-vb e z x u v))))
```


One way of increasing structure is to forge.

```
(forall (x)
  (if (and (increaseStruct x) (etc-forge-vb1 x))
      (exists (e u v y)
        (forge-vb e y x u v))))
```


To penetrate is to change to being in.

```
(forall (e1 e2 x y)
  (if (and (compositeEntity x) (change e1 e2) (in' e2 y x))
      (exists (e u v)
        (penetrate-vb1 e y x u v))))
```


## DFCE Domains

### Buildings

A building is a functional composite entity.

```
(forall (x)
  (if (and (fCompEnt x) (etc-building1 x))
      (exists (e)
        (building e x))))
```


The function of a building is to protect entities inside it.

```
(forall (x)
  (if (building x)
      (exists (f y)
        (and (function f x) (protect' f x y)))))
```


```
(forall (f x y)
  (if (and (function f x) (protect' f x y) (etc f x y))
      (building x)))
```


A door is a component of a building.

```
(forall (x)
  (if (building x)
      (exists (y)
        (and (door y) (componentOf y x)))))
```

```
(forall (y)
  (if (door y)
      (exists (x)
        (and (building x) (componentOf y x)))))
```


A door enables a change to being in, which is its function.

```
(forall (x y)
  (if (and (door y) (componentOf y x))
      (exists (e e1 e2 z)
        (and (enable y e) (change' e e1 e2) (in' e2 z x)))))
```

```
(forall (e e1 e2 x y z)
(if (and (enable y e) (change' e e1 e2) (in' e2 z x)
         (componentOf y x)
         (etc-door2a y e e1 e2 z x))
    (door y)))
```

```
(forall (f x y)
  (if (and (door y) (componentOf y x) (function f y))
      (exists (e1 e2 z)
        (and (change' f e1 e2) (in' e2 z x)))))
```


A foundation is a component of a building.

```
(forall (x y)
  (if (foundation y x)
    (and (building x) (componentOf y x))))
```


Buildings have foundations.

```
(forall (x)
  (if (building x)
      (exists (y)
        (foundation y x))))
```


Building the foundation enables building the building.

```
(forall (e1 x y z1)
  (if (and (build' e1 z1 y) (foundation y x))
      (exists (e e1 z2)
        (and (enable e1 e) (build' e z2 x)))))
```


Scaffolding enables building a building.

```
(forall (y)
  (if (scaffolding y)
      (and (building x) (enable y e) (build' e z x))))
```

```
(forall (e x y z)
  (if (and (building x) (enable y e) (build' e z x)
           (etc-scaffolding1b x y e z))
       (scaffolding y)))
```


### Cars & Engines

A car is a dynamic functional composite entity.

```
(forall (x)
  (if (and (dFCompEnt x) (etc-car1 x))
      (car x)))
```


An engine is a dynamic functional composite entity.

```
(forall (x)
  (if (engine x)
      (dFCompEnt x)))
```

```
(forall (x)
  (if (and (dFCompEnt x) (etc-engine1b x))
      (engine x)))
```


Wheels can be part of an engine.

```
(forall (y)
  (if (and (wheel y) (etc-wheel1a y))
      (exists (x)
        (and (engine x) (componentOf y x)))))
```

```
(forall (x)
  (if (and (engine x) (etc-wheel1b x))
      (exists (y)
        (and (wheel y) (componentOf y x)))))
```


A lubricant enables the process of an engine.

```
(forall (e x y)
  (if (and (lubricant y) (engine x) (processOf e x))
      (enable y e)))
```

```
(forall (e x y)
  (if (and (engine x) (processOf e x) (enable y e)
           (etc-lubricant1b x e y))
      (lubricant y)))
```


### Nuclear power

```
(forall (x)
  (if (and (dFCompEnt x) (etc-nuclearReactor1b x))
      (nuclearReactor x)))
```


One way a nuclear reactor loses structure is a meltdown.

```
(forall (e x)
  (if (and (nuclearReactor x) (decreaseStruct' e x)
           (etc-nuclearReactor2))
      (meltdown e)))
```


## The future

The future is a functional composite entity made up of events.

```
(forall (e e1 s)
  (if (and (fCompEnt e) (componentsOf s e) (typelt e1 e)
           (event e1) (etc-future-nn1 e s e1))
      (future e)))
```


Destiny is a functional composite entity made up of events.

```
(forall (e e1 s)
  (if (and (fCompEnt e) (componentsOf s e) (typelt e1 e)
           (event e1) (etc-destiny-nn1 e s e1))
      (destiny e)))
```


## Economy

One way of being a dynamic functional composite entity is by being
an economy.

```
(forall (x)
  (if (and (dFCompEnt x) (etc-economy-nn1))
      (exists (e)
        (economy-nn e x))))
```


"financial" is a noun-like adjective derived from "finance".

```
(forall (f m)
  (if (and (finance f) (nn f m))
      (exists (e)
        (financial-adj e m))))
```


One way of being a dynamic functional composite entity is by being
finance.

```
(forall (x)
  (if (and (dFCompEnt x) (etc-finance1 x))
      (finance x)))
```


One way of being a dynamic functional composite entity is by being
a business.

```
(forall (x)
  (if (and (dFCompEnt x) (etc-business1 x))
      (business x)))
```


### Stripping cars

The scenario for stripping cars.

```
(forall (e x y z)
  (if (strip-cars-schema e x y z)
      (exists (e1 e2 e3 e4 w)
        (and (then e e1 e2) (steal e1 x y) (car y)
             (then e2 e3 e4) (strip e3 x z y) (part z y) (sell e4 x z w)))))
```

Short version of the scenario for stripping cars.

```
(forall (e x y z)
  (if (and (strip-cars-schema e x y z) (part z y) (car y))
      (exists (e3)
        (strip e3 x y z))))
```


The verb phrase "x strips z from y".

```
(forall (e x y z)
  (if (strip e x y z)
      (exists (e1 u)
        (and (strip-vb e x y u) (for-in e1 e z)))))
```


A part is a component of a composite entity.

```
(forall (x y)
  (if (componentOf y x)
      (part y x)))
```


The noun "part".

```
(forall (e1 e2 y z)
  (if (part z y)
      (and (part-nn e1 z) (of-in e2 z y))))
```


```
(forall (y z)
  (if (part z y)
      (part-nn e1 z)))
```
