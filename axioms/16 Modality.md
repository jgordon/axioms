# 16 Modality

## Predicates

- `(Now t)`: t is an instant stipulated to be Now.
- `(PosMod e p)`: The positive modality p holds of eventuality e.
- `(possible e c)`: e is possible with respect to a set of constraints c.
- `(necessary e c)`: e is necessary with respect to a set of constraints c.
- `(impossible e c)`: e is impossible with respect to a set of
  constraints c.
- `(likelihood d e c)`: d is the likelihood of e really existing, given
  constraints c.
- `(likelihoodScale s)`: s is a scale of likelihoods.
- `(lowerLikelihood d1 d2)`: d1 is a lower likelihood than d2.
- `(alsoRequired s e c)`: s is a set of eventualities which when added
  to constraints c entails e.
- `(moreLikely e1 e2 c)`: e1 is more likely than e2 given constraints c.
- `(likely e c)`: e is likely, given constraints c.

## Axioms

16.1 is a repeat of schema 1.1.

16.2 is a schema, given at the beginning.

16.3 Example: If someone smiles, they are happy.

```
(forall (x)
  (if (smile x) (happy x)))
```

There is a time called "now", which exists and is unique.

16.4
```
(exists (t) (Now t))
```

16.5
```
(forall (t2 t2)
  (if (and (Now t1) (Now t2))
      (equal t1 t2)))
```

16.6 For something to really exist is for it to happen or hold Now.

```
(forall (e t)
  (if (Now t)
      (iff (Rexist e) (atTime e t))))
```

16.7 The predicate `PosMod` is a cover term for all positive modalities.
Its second argument will be a predicate that labels the modality.

```
(forall (e p) (if (PosMod e p) (predicate p)))
```

16.8 `Rexist` is a positive modality.

```
(forall (e) (if (Rexist e) (PosMod e Rexist)))
```

16.9 The principal property of positive modalities is that Modus Ponens
can be applied within the modality.

```
(forall (e1 e2 m)
  (if (and (PosMod e1 m) (imply e1 e2))
      (PosMod e2 m)))
```

16.10 The predicate `possible` has two arguments, an eventuality and a set
of constraints.

```
(forall (e c)
  (if (possible e c)
      (and (eventuality e) (eventualities c))))
```

16.11 An eventuality is possible iff the constraints do not imply a
negation of the eventuality.

```
(forall (e c)
  (iff (possible e c)
       (forall (e1)
         (if (not' e1 e)
             (not (imply c e1))))))
```

16.12 Possibility is a positive modality.

```
(forall (e c)
  (if (possible e c)
      (PosMod e possible)))
```

16.13 An eventuality is necessary if the set of constraints implies it.
The predicate `necessary` has two arguments, an eventuality and a set
of constraints.

```
(forall (e c)
  (if (necessary e c)
      (and (eventuality e) (eventualities c))))
```

16.14 An eventuality `e` is necessary with respect to a set of constraints
`c` iff `c` implies `e`.

```
(forall (e c)
  (iff (necessary e c)
       (imply c e)))
```

16.15 Necessity is a positive modality because of the transitivity of
`imply`.

```
(forall (e c)
  (if (necessary e c)
      (PosMod e necessary)))
```

16.16 It is a theorem that if an eventuality is possible, its negation is
not necessary.

```
(forall (e c e1)
  (if (and (possible e c) (not' e1 e))
      (not (necessary e1 c))))
```

16.17 Impossibility is the negation of possibility.

```
(forall (e c)
  (iff (impossible e c)
       (and (eventuality e) (eventualities c) (not (possible e c)))))
```

16.18 The predicate `likelihood` will express a relation between
likelihoods and eventualities. Likelihood is with respect to an implicit
set of constraints that in a sense defines the sample space. Making the
constraints an argument allows us to relate likelihood to possibility and
to entailment.

```
(forall (d e c)
  (if (likelihood d e c)
      (and (eventuality e) (eventualities c))))
```

16.19 The `likelihoodScale` has likelihoods as its elements and the
`lowerLikelihood` relation as its partial ordering.

```
(forall (s)
  (iff (likelihoodScale s)
       (exists (s1 e r d1 d2)
         (and (forall (d)
                (iff (member d s1) (exists (e c) (likelihood d e c))))
              (lowerLikelihood' r d1 d2)
              (scaleDefinedBy s s1 r)))))
```

16.20 Given an eventuality `e` and a set of constraints `c`, we can
ask what other set `s` of eventualities would have to obtain in order
to entail that `e` also obtains. The expression `(alsoRequired s e c)`
says that `s` is a set of eventualities that will entail the real
existence of `e`, over and above `c`.

```
(forall (s e c)
  (if (eventuality e)
      (iff (alsoRequired s e c)
           (and (eventualities s) (eventualities c)
                (exists (s1 c1)
                  (and (union s1 c1 s) (subset c1 c)
                       (minimallyProves s1 e)))))))
```

16.21 The more we have to assume will happen, the less likely it is.

```
(forall (s1 e1 d1 s2 e2 d2 c s)
  (if (and (alsoRequired s1 e1 c) (alsoRequired s2 e2 c) (subset s2 s1)
           (likelihood d1 e1 c) (likelihood d2 e2 c) (likelihoodScale s))
      (leqs d1 d2 s)))
```

16.22 The likelihood of the conjunction `e` of two eventualities `e1`
and `e2` is less than or equal to the likelihood of each of them.

```
(forall (s e e1 e2 d d1 d2 c)
  (if (and (likelihoodScale s) (likelihood d1 e1 c) (likelihood d2 e2 c)
           (and' e e1 e2) (likelihood d e c))
      (and (leqs d d1 s) (leqs d d2 s))))
```

16.23 The likelihood of the disjunction `e` of two eventualities `e1`
and `e2` is greater than or equal to the likelihood of either of them.

```
(forall (s e e1 e2 d d1 d2 c)
  (if (and (likelihoodScale s) (likelihood d1 e1 c) (likelihood d2 e2 c)
           (or' e e1 e2) (likelihood d e c))
      (and (leqs d1 d s) (leqs d2 d s))))
```

16.24 If the likelihood of an eventuality is the top of the likelihood
scale given constraints `c`, then it is entailed by `c`.

```
(forall (d e c s)
  (if (and (likelihood d e c) (likelihoodScale s))
      (iff (top d s) (necessary e c))))
```

16.25 If the likelihood of an eventuality is the bottom of the likelihood
scale, then it is impossible given the constraints.

```
(forall (d e c s)
  (if (and (likelihood d e c) (likelihoodScale s))
      (iff (bottom d s)
           (impossible e c))))
```

16.26 If something has a likelihood above the bottom of the likelihood
scale with respect to a set of constraints, it is possible with
respect to those constraints.

```
(forall (d e c s)
  (if (and (likelihood d1 e c) (likelihoodScale s) (bottom d s))
      (iff (lts d d1 s) (possible e c))))
```

16.27 A likelihood scale consists of elements that are all likelihoods
and hence have a common property; the scale can then be a potential
ground.

```
(forall (s) (if (likelihoodScale s) (ground s)))
```

16.28 If the likelihood of an eventuality `e` is `d`, we can say that
`e` is at `d` on the likelihood scale, if `c` holds.

```
(forall (d e c s e1)
  (if (and (likelihood d e c) (likelihoodScale s) (at' e1 e d s))
      (imply c e1)))
```

16.29 The likelihood scale is conceptually vertical. We talk about
likelihoods being higher or lower.

```
(forall (s) (if (likelihoodScale s) (vertical s)))
```

16.30 One eventuality is more likely than another with respect to a set
of constraints if its likelihood is higher.

```
(forall (e1 e2 c)
  (iff (moreLikely e1 e2 c)
       (exists (s d1 d2)
         (and (likelihoodScale s)
              (likelihood d1 e1 c) (likelihood d2 e2 c)
              (lts d2 d1 s)))))
```

16.31 An eventuality is `likely` with respect to constraints `c` if
its likelihood `d` is on the high end of the scale of likelihoods.

```
(forall (e c)
  (iff (likely e c)
       (exists (s d s1)
         (and (likelihood d e c) (likelihoodScale s) (Hi s1 s)
              (inScale d s1)))))
```

16.32 If an eventuality is likely, its negation is not likely.

```
(forall (e e1 c)
  (if (and (likely e c) (not' e1 e))
      (not (likely e1 c))))
```

16.33

```
(forall (d1 d2)
  (iff (leqLikelihood d1 d2)
       (or (lowerLikelihood d1 d2) (equal d1 d2))))
```
