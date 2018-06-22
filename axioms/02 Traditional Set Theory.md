# 2 Traditional Set Theory

## Predicates

- `(set s)`: s is a set.
- `(member x s)`: x is a member of s.
- `(equal x y)`: x is equal to y.
- `(nequal x y)`: x is not equal to y.
- `(null s)`: s is the null set or empty set.
- `(addElt s s1 x)`: s is obtained from s1 by adding x.
- `(singleton s x)`: s consists of the single element x.
- `(doubleton s x y)`: s consists of the two elements x and y.
- `(deleteElt s s1 x)`: s is obtained from s1 by deleting x.
- `(replaceElt s s1 x y)`: s is obtained from s1 by replacing x with y.
- `(union s s1 s2)`: s is the union of s1 and s2.
- `(union3 s s1 s2 s3)`: s is the union of s1, s2 and s3.
- `(setdiff s s1 s2)`: s is the set difference of s1 and s2.
- `(subset s1 s2)`: s1 is a subset of s2.
- `(properSubset s1 s2)`: s1 is a proper subset of s2.
- `(disjoint s1 s2)`: s1 and s2 are disjoint.
- `(powerSet s0 s)`: s0 is the set of all of s's subsets.
- `(card n s)`: n is the cardinality of s.
- `(eventualities s)`: s is a set of eventualities.


## Axioms

2.1 A set is completely defined by its members.

```
(forall (s1 s2)
  (if (set s1)
      (iff (equal s1 s2)
           (and (set s2)
                (forall (x)
                  (iff (member x s1)
                       (member x s2)))))))
```

2.2 A member is a member of a set.

```
(forall (x s)
  (if (member x s)
      (set s)))
```

The `equal` relation includes reflexivity, symmetricity, and transitivity:

2.3
```
(forall (x) (equal x x))
```

2.4
```
(forall (x y) (iff (equal x y) (equal y x)))
```

2.5
```
(forall (x y z)
  (if (and (equal x y) (equal y z))
      (equal x z)))
```

2.6 The `nequal` relation holds for pairs of entities that are not equal.

```
(forall (x y)
  (iff (nequal x y)
       (not (equal x y))))
```

2.7 The null set is the set with no members.

```
(forall (s)
  (iff (null s)
       (and (set s)
            (forall (x)
              (not (member x s))))))
```

2.8 Sets can be constructed recursively by adding one element at a time.

```
(forall (s s1 x)
  (iff (addElt s s1 x)
       (and (set s) (set s1)
            (forall (y)
              (iff (member y s)
                   (or (equal y x) (member y s1)))))))
```

2.9 A singleton set consists of one entity.

```
(forall (s x)
  (iff (singleton s x)
       (exists (s1)
         (and (addElt s s1 x) (null s1)))))
```

2.10 A `doubleton` set has exactly two members.

```
(forall (s x y)
  (iff (doubleton s x y)
       (exists (s1)
         (and (nequal x y)
              (addElt s s1 x)
              (singleton s1 y)))))
```

2.11 The predication `(deleteElt s s1 x)` says that the set s is obtained
from set s1 by deleting an element x.

```
(forall (s s1 x)
  (iff (deleteElt s s1 x)
       (and (set s) (set s1)
            (forall (y)
              (iff (member y s)
                   (and (member y s1) (nequal y x)))))))
```

2.12 The predication `(replaceElt s s1 x y)` says that set s is obtained
from set s1 by replacing element x with element y.

```
(forall (s s1 x y)
  (iff (replaceElt s s1 x y)
       (exists (s2)
         (and (deleteElt s2 s1 x)
              (addElt s s2 y)))))
```

2.13 The union of two sets is defined in the standard way.

```
(forall (s s1 s2)
  (iff (union s s1 s2)
       (and (set s) (set s1) (set s2)
            (forall (x)
              (iff (member x s)
                   (or (member x s1) (member x s2)))))))
```

2.14 The union of three sets.

```
(forall (s s1 s2 s3)
  (iff (union3 s s1 s2 s3)
       (exists (s4)
         (and (union s s1 s4) (union s4 s2 s3)))))
```

2.15 Set difference is defined similarly to union.

```
(forall (s s1 s2)
  (iff (setdiff s s1 s2)
       (and (set s) (set s1) (set s2)
            (forall (x)
              (iff (member x s)
                   (and (member x s1)
                        (not (member x s2))))))))
```

2.16 The intersection of two sets is defined in the standard way.

```
(forall (s s1 s2)
  (iff (intersection s s1 s2)
       (and (set s) (set s1) (set s2)
            (forall (x)
              (iff (member x s)
                   (and (member x s1) (member x s2)))))))
```

Subsets and proper subsets:

2.17
```
(forall (s1 s2)
  (iff (subset s1 s2)
       (and (set s1) (set s2)
            (forall (x)
              (if (member x s1)
                  (member x s2))))))
```

2.18
```
(forall (s1 s2)
  (iff (properSubset s1 s2)
       (and (subset s1 s2) (nequal s1 s2))))
```

2.19 Two sets are disjoint if they have no members in common.

```
(forall (s1 s2)
  (if (and (set s1) (set s2))
      (iff (disjoint s1 s2)
           (not (exists (x)
                  (and (member x s1) (member x s2)))))))
```

2.20 The power set of a set is the set of all its subsets.

```
(forall (s0 s)
  (iff (powerSet s0 s)
       (forall (s1)
         (iff (member s1 s0)
              (subset s1 s)))))
```

2.21 We recursively define the cardinality of sets using addElt.

```
(forall (n s)
  (iff (card n s)
       (and (nonNegInteger n) (set s)
            (or (and (null s) (equal n 0))
                (exists (s1 x m)
                  (and (addElt s s1 x)
                       (not (member x s1))
                       (card m s1)
                       (sum n m 1)))))))
```

2.22 We can have sets of eventualities.

```
(forall (s)
  (iff (eventualities s)
       (and (set s)
            (forall (e)
              (if (member e s)
                  (eventuality e))))))
```
