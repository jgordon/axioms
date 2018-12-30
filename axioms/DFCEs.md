# Dynamic Functional Composite Entities

## Predicates

- `(decreaseFct y)`
- `(functionality f x)`
- `(decreaseStruct x)`


## Axioms

```
(forall (x y f)
  (if (and (decreaseFct y) (functionality f x))
      (decreaseStruct x)))
```

```
(forall (x y f)
  (if (and (increaseFct y) (functionality f x))
      (increaseStruct x)))
```

