# 10 Change of State

## Predicates

- `(change e1 e2)`: There is a change from eventuality e1 to
  eventuality e2.
- `(changeIn x)`: There is a change in some property of x.
- `(changeFrom e1)`: There is a change out of eventuality e1.
- `(changeTo e2)`: There is a change into eventuality e2.
- `(move x y z)`: x moves from y to z.
- `(vertical s)`: Scale s is a real or metaphorical vertical scale.
- `(increase x s)`: x increases on scale s.
- `(decrease x s)`: x decreases on scale s.

## Axioms

10.1 The arguments of `change` are eventualities.

```
(forall (e1 e2)
  (if (change e1 e2)
      (and (eventuality e1) (eventuality e2))))
```

10.2 The eventualities involved in a change must involve some common
entity.

```
(forall (e1 e2)
  (if (change e1 e2)
      (exists (x)
        (and (arg* x e1) (arg* x e2)))))
```

10.3 Change is defeasibly transitive.

```
(forall (e1 e2 e3)
  (if (and (change e1 e2) (change e2 e3) (etc))
      (change e1 e3)))
```

10.4 If two states are not inconsistent, then the change must be a
composite of two changes, one to and the other from an inconsistent state.

```
(forall (e e1 e2)
  (if (change' e e1 e2)
      (or (inconsistent e1 e2)
          (exists (e3 e4 e5 e6)
            (and (change' e4 e1 e3) (change' e5 e3 e2) (and' e6 e4 e5)
                 (gen e6 e))))))
```

10.5 Since change is not normally cyclic, we can make it a defeasible
inference that the start and end states are inconsistent.

```
(forall (e e1 e2)
  (if (and (change e1 e2) (etc))
      (inconsistent e1 e2)))
```

10.6 There is a `changeIn` something when there is a change in its
properties.

```
(forall (e x)
  (iff (changeIn' e x)
       (exists (e1 e2 e3)
         (and (arg* x e1) (arg* x e2) (change' e3 e1 e2) (gen e3 e)))))
```

10.7 When there has been a `changeFrom` some eventuality e1 where p'(e1,x)
holds, then after the change p(x) is not true. (I.e., no eventuality
corresponding to p(x) really exists.) The `subst` expression means
that e1 and e3 have the same predicate and same arguments, other than
the self argument.

```
(forall (e e1 e3)
  (if (subst e3 e3 e1 e1)
      (iff (changeFrom' e e1)
           (exists (e2 e5)
             (and (change' e5 e1 e2) (gen e5 e) (inconsistent e3 e2))))))
```

10.8 For `changeTo`, the start state of the change must exclude any other
instance of the type e2 instantiates.

```
(forall (e e2 e4)
  (if (subst e4 e4 e2 e2)
      (iff (changeTo' e e2)
           (exists (e1 e5)
             (and (change' e5 e1 e2) (gen e5 e) (inconsistent e4 e1))))))
```

10.9 An entity x moves from y to z exactly when there is a change from x's
being at y to its being at z.

```
(forall (e x y z)
  (iff (move' e x y z)
       (exists (e1 e2 e3 s)
         (and (at' e1 x y s) (at' e2 x z s) (change' e3 e1 e2) (gen e3 e)))))
```

10.10 A non-negative numeric scale is vertical.

```
(forall (s) (if (nonNegNumericScale s) (vertical s)))
```

10.11 The argument of `vertical` has to be a scale.

```
(forall (s) (if (vertical s) (scale s)))
```

10.12 If an entity moves from a point on vertical scale to a higher point,
we say that there as been an increase.

```
(forall (e x y z s)
  (iff (increase x s)
       (exists (y z e1 e2)
         (and (at' e1 x y s) (at' e2 x z s) (lts y z s)
              (vertical s) (change e1 e2)))))
```

10.13 Similarly, if an entity moves from a point on a vertical scale to a
lower point, there has been a decrease.

```
(forall (e x y z s)
  (iff (decrease x s)
       (exists (y z e1 e2)
         (and (at' e1 x y s) (at' e2 x z s) (lts z y s)
              (vertical s) (change e1 e2)))))
```
