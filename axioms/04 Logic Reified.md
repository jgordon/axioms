# 4 Logic Reified

## Predicates

- `(and' e e1 e2)`: e is the eventuality of both e1 and e2 existing.
- `(not' e1 e2)`: e1 is the eventuality of e2 not existing.
- `(nott' e1 e2)`: e1 is the eventuality of nothing of e2's type existing.
- `(or' e e1 e2)`: e is the eventuality of either e1 or e2 existing.
- `(disjunction e s)`: e is the eventuality of some member of s existing.
- `(imply' e e1 e2)`: e is the eventuality of an implicational relation
  between e1 and e2 existing.
- `(inconsistent s1 s2)`: s1 and s2 are inconsistent sets of eventualities.
- `(minimallyProves s1 e2)`: s1 proves e2 and no subset of s1 proves e2.

## Axioms

4.1 The `and` of two eventualities is itself an eventuality, and it exists
when its two constituent eventualities exist.

```
(forall (e e1 e2)
  (if (and' e e1 e2)
      (and (eventuality e) (eventuality e1) (eventuality e2)
           (iff (Rexist e)
                (and (Rexist e1) (Rexist e2))))))
```

4.2 Existence of a set in the real world is always true whenever all its
members exist in the real world.

```
(forall (s)
  (if (set s)
      (iff (Rexist s)
           (forall (e)
             (if (member e s) (Rexist e))))))
```

4.3 The negation of an eventuality really exists if and only if the
eventuality doesn't.

```
(forall (e1 e2)
  (if (not' e1 e2)
      (and (eventuality e1) (eventuality e2)
           (iff (Rexist e1)
                (not (Rexist e2))))))
```

4.4 `nott` is stronger than `not`. It says there is an eventuality type of
which e2 is an instance and the negation is the negation of that type.

```
(forall (e1 e2)
  (if (nott' e1 e2)
      (exists (e3)
        (and (instance e2 e3) (not' e1 e3)))))
```

4.5 A weaker version of the existence axiom above.

```
(forall (e1 e2)
  (if (and (not' e1 e2) (Rexist e1))
      (and (eventuality e1) (eventuality e2)
           (not (Rexist e2)))))
```

4.6 Disjunction is defined analogous to conjunction: If the eventuality e
is the disjunction of eventualities e1 and e2, then e really exists
exactly when one of e1 and e2 really exists.

```
(forall (e e1 e2)
  (if (or' e e1 e2)
      (and (eventuality e) (eventuality e1) (eventuality e2)
           (iff (Rexist e)
                (or (Rexist e1) (Rexist e2))))))
```

4.7 The disjunction of a set really exists exactly when one of the members
of the set really exists.

```
(forall (e s)
  (if (disjunction e s)
      (and (eventuality e) (eventualities s)
           (iff (Rexist e)
                (exists (e1)
                  (and (member e1 s) (Rexist e1)))))))
```

4.8 Implication is defined similarly to `or'`, except that in addition to
a single eventuality as the antecedent, we will alow a set of
eventualities as well, which is interpreted as the conjunction.

```
(forall (e e1 e2)
  (if (imply' e e1 e2)
      (and (eventuality e) (eventuality e2)
           (or (eventuality e1) (eventualities e1)))))
```

4.9 The implication really exists provided the consequent really exists
whenever the antecedent really exists.

```
(forall (e e1 e2)
  (if (imply' e e1 e2)
      (iff (Rexist e)
           (if (Rexist e1) (Rexist e2)))))
```

4.10 Modus ponens:

```
(forall (e e1 e2)
  (if (and (imply' e e1 e2) (Rexist e) (Rexist e1))
      (Rexist e2)))
```

4.11 Implication is transitive.

```
(forall (e1 e2 e3 i1 i2 i3)
  (if (and (imply' i1 e1 e2) (imply' i2 e2 e3) (imply' i3 e1 e3)
           (Rexist i1) (Rexist i2))
      (Rexist i3)))
```

4.12 Two sets of eventualities are inconsistent if one implies an
eventuality and the other implies its negation.

```
(forall (s1 s2)
  (iff (inconsistent s1 s2)
       (and (eventualities s1) (eventualities s2)
            (exists (e1 e2)
              (and (imply s1 e1) (imply s2 e2) (not' e2 e1))))))
```

4.13 We can say that some set `s1` of eventualties minimally proves an
eventuality `e2` if `s1` implies `e2` but no proper subset
of `s1` proves `e2`, and furthermore `e2` is not itself a
member of `s1`.

```
(forall (s1 e2)
  (iff (minimallyProves s1 e2)
       (and (not (member e2 s1))
            (imply s1 e2)
            (not (exists (s2)
                   (and (properSubset s2 s1)
                        (imply s2 e2)))))))
```
