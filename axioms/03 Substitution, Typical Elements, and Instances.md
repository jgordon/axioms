# 3 Substitution, Typical Elements, and Instances

## Predicates

- `(subst x e1 y e2)`: x plays the same role in e1 that y plays in e2.
- `(subst2 x1 x2 e1 y1 y2 e2)`: The pair <x1,x2> plays the same role in e1
  that the pair <y1,y2> plays in e2.
- `(typelt x s)`: x is a typical element of s.
- `(dset s x e)`: s is the set with typical element x defined by the
  property e.
- `(noSubstTypelt x e1 y e2)`:  It is not the case that e1 is a typical
  element relation between x and some set s and y is a member of s; this
  blocks using “subst” when e1 is a typical element property.
- `(notSubsetTypelt y s)`: y is not a typical element of a subset
  of s; this blocks problematic applications of Axiom 6.
- `(fd y x e)`: y is functionally dependent on x by a function described
  by e.
- `(skfct y1 y x1 x e)`: y1 is the value of the function corresponding
  to the functional dependency of y on x with respect to e when applied
  to x1.
- `(rangeFd s y x e)`: s is the range of the values of the entity y that
  is functionally dependent on x with respect to e.
- `(nonspecific x)`: x is a typical element or functionally dependent on
  a typical element.
- `(specific x)`: x is not nonspecific.
- `(parameters s e)`: s is the set of typical elements that appear
  somewhere in e as arguments.
- `(partialInstance e1 e)`: e1 is a partial instantiation of e;
  nonspecific arguments are either instantiated or specialized.
- `(patternInstance e1 e)`: e1 is a complete instantiation of e; all
  nonspecific arguments are instantiated.
- `(holdsFor e1 y x)`: The eventuality type e1 holds for entity y;
  substituting y for a nonspecific argument x of e1 yields an eventuality
  that really exists.

## Axioms

3.1 Two entities are subsitutable in their respective events if they play
the same role.

```
(forall (x e1 y e2)
  (iff (subst x e1 y e2)
       (exists (p n)
         (and (pred p e1) (pred p e2) (arity n e1) (arity n e2)
              (noSubstTypelt x e1 y e2)
              (forall (i z1 z2)
                (if (and (posInteger i) (leq i n)
                         (argn z1 i e1) (argn z2 i e2))
                    (and (iff (eventuality z1)
                              (eventuality z2))
                         (if (not (eventuality z1))
                             (and (if (nequal z1 x)
                                      (equal z2 z1))
                                  (if (equal z1 x)
                                      (equal z2 y))))
                         (if (eventuality z1)
                             (subst x z1 y z2)))))))))
```

3.7 "Surgery" on the definition of subst for the cases that will cause
trouble for typical elements -- when e1 itself is a typical element
relation between x and s and y is a member of s.

```
(forall (x e1 y e2)
  (iff (noSubstTypelt x e1 y e2)
       (exists (s) (and (typelt' e1 x s) (member y s)))))
```

3.2 Two substitutions can be done by doing one at a time.

```
(forall (x1 x2 e1 y1 y2 e2)
  (iff (subst2 x1 x2 e1 y1 y2 e2)
       (exists (e3)
         (and (subst x1 e1 y1 e3)
              (subst x2 e3 y2 e2)))))
```

3.3 Every set has a typical element.

```
(forall (s) (iff (set s)
                 (exists (x) (typelt x s))))
```

3.4 Real members of a set inherit all the properties of the typical
element.

```
(forall (x s y e1 e2)
  (if (and (typelt x s) (member y s) (subst x e1 y e2)
           (Rexist e1))
      (Rexist e2)))
```

A defined set consists only of elements for which a particular
eventuality really exists.

3.5
```
(forall (s x e)
  (if (dset s x e)
      (and (set s) (typelt x s) (arg* x e))))
```

3.6
```
(forall (s x e y e1)
  (if (and (dset s x e) (subst x e y e1) (Rexist e)
           (notSubsetTypelt y s))
      (iff (member y s) (Rexist e1))))
```

3.8 "Surgery" on the definition of "dset" to rule out problematic cases:

```
(forall (y s)
  (iff (notSubsetTypelt y s)
       (not (exists (s1)
              (and (typelt y s1) (subset s1 s))))))
```

3.9 Functional dependencies:

```
(forall (x y e)
  (if (fd y x e)
      (and (arg* x e) (arg* y e)
           (exists (s)
             (typelt x s)))))
```

3.10 The principal property of 'fd' is that when e holds and a real
entity instantiates x, then there is a real entity that instantiates y
and the corresponding eventuality holds.

```
(forall (x y e s)
  (if (and (fd y x e) (Rexist e) (typelt x s) (member x1 s))
      (exists (y1 e1)
        (and (subst2 x y e x1 y1 e1) (Rexist e1)))))
```

3.11 Corresponding to the functional dependency, there is a skolem
function that maps any element x1 of the set s into the corresponding
y1, and that function has a range.

```
(forall (x x1 y y1 e)
  (iff (skfct y1 y x1 x e)
       (and (fd y x e)
            (exists (e1)
              (and (subst2 x y e x1 y1 e1)
                   (if (Rexist e) (Rexist e1)))))))
```

3.12 The range of the functional dependency is then the set of all values
of the skolem function.

```
(forall (s1 x y e)
  (iff (rangeFd s1 y x e)
       (forall (y1)
         (iff (member y1 s1)
              (exists (x1) (skfct y1 y x1 x e))))))
```

3.13 Pass functional dependence relations down to partial instantiations.

```
(forall (c1 c x1 x y e e1)
  (if (and (skfct c1 c x1 x e) (fd c y e) (nequal x y)
           (subst2 c1 x1 e1 c x e))
      (fd c1 y e1)))
```

3.14 An entity that is a typical element of a set or functionally dependent
on a typical element of a set is nonspecific.

```
(forall (x)
  (iff (nonspecific x)
       (or (exists (s) (typelt x s))
           (exists (y s e)
             (and (typelt y s) (fd x y e))))))
```

3.15 An entity is specific iff it is not nonspecific:

```
(forall (x)
  (iff (specific x)
       (not (nonspecific x))))
```

3.16 Define the set of parameters in an abstract eventuality:

```
(forall (s e)
  (iff (parameters s e)
       (forall (x)
         (iff (member x s)
              (exists (s1)
                (and (arg* x e) (typelt x s1)))))))
```

3.17 A partial instantiation of an abstract eventuality:

```
(forall (e1 e)
  (iff (partialInstance e1 e)
       (forall (s x)
         (if (and (member x s) (parameters s e))
             (exists (x1 s1)
               (and (subst x e x1 e1) (typelt x s1)
                    (or (member x1 s1)
                        (exists (s2)
                          (and (typelt x1 s2)
                               (subset s2 s1))))))))))
```

3.18 A complete instantiation is a partial instantiation with no remaining
parameters:

```
(forall (e1 e)
  (iff (instance e1 e)
       (and (partialInstance e1 e)
            (forall (s1)
              (if (parameters s1 e1)
                  (null s1))))))
```

3.19 An eventuality type e1 holds for an entity y as its x parameter if,
when the entity is substituted for x in the eventuality type, the
resulting instantiation really exists.

```
(forall (e1 y x)
  (iff (holdsFor e1 y x)
       (exists (s e2)
         (and (subst y e2 x e1) (typelt x s) (member y s)
              (Rexist e2)))))
```
