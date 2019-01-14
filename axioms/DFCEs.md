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
           (not' e3 e2) (cause e2 f :0.2) (Subst x1 e1 x2 e2 :0.2))
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
