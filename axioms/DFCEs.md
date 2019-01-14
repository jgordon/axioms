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





### Dynamic Functional Composite Entities

```
(forall (x y f)
  (if (and (decreaseFct y) (function f x))
      (decreaseStruct x)))
```

```
(forall (x y f)
  (if (and (increaseFct y) (function f x))
      (increaseStruct x)))
```

