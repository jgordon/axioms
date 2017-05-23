# 1 Eventualities and Their Structure

## Predicates

- `(eventuality e)`: e is an eventuality.
- `(Rexist e)`: e really exists in the real world.
- `(gen e1 e2)`: e1 generates or entails the existence of e2.
- `(argn x n e)`: x is the nth argument of e.
- `(arg x e)`: x is an argument of e.
- `(arg* x e)`: x is an argument of e or an arg* of an argument of e.
- `(pred p e)`: p is the predicate of e.
- `(predicate p)`: p is a predicate.
- `(arity n e)`: n is the arity or the number of arguments of e.

Formulas 1.1 through 1.6 are either meta-rules, listed above, or examples,
listed at the end of this section.

## Axioms

1.7 Restrictions on the arguments to 'argn'.

```
(forall (e x n)
  (if (argn x n e)
      (and (nonNegInteger n) (eventuality e))))
```

1.8 Every eventuality is its own 0th argument.

```
(forall (e)
  (iff (eventuality e)
       (argn e 0 e)))
```

1.9 Every argument is the argument of some eventuality.

```
(forall (e x)
  (iff (arg x e)
       (exists (n)
         (argn x n e))))
```

1.10 An 'arg*' is something that is an argument of the eventuality or the
argument of an argument of the eventuality or so on recursively.

```
(forall (x e1)
  (iff (arg* x e1)
       (or (arg x e1)
           (exists (e2)
             (and (arg e2 e1) (arg* x e2))))))
```

1.12 The 'pred' of an eventuality is a predicate.

```
(forall (e p)
  (if (pred p e)
      (and (predicate p) (eventuality e))))
```

1.14 The arity of an eventuality is a non-negative integer.

```
(forall (n e)
  (if (arity n e)
      (and (nonNegInteger n) (eventuality e))))
```

1.15 Eventualities all have a predicate p, an arity n, and arguments
1...n.

```
(forall (e)
  (iff (eventuality e)
       (exists (p n)
         (and (pred p e) (arity n e)
              (forall (i)
                (if (and (posInteger i)
                         (leq i n))
                    (exists (x)
                      (argn x i e))))))))
```

1.16 The 'gen' relation is between two eventualities, which are almost
identical but not quite, e.g., the same event under different
descriptions.

```
(forall (e1 e2)
  (if (gen e1 e2)
      (and (eventuality e1) (eventuality e2))))
```

1.17 The 'gen' relation is anti-reflexive.

```
(forall (e) (not (gen e e)))
```

1.18 'gen' obeys a kind of modus ponens rule with respect to 'Rexist'.

```
(forall (e1 e2)
  (if (and (gen e1 e2) (Rexist e1))
      (Rexist e2)))
```

1.19 'gen' is stronger than implication.

```
(exists (e1 e2)
  (and (imply e1 e2) (not (gen e1 e2))))
```

If (gen e1 e2) holds, then e1 and e2 occupy the same chunk of space-time:

1.20
```
(forall (e1 e2 t)
  (if (gen e1 e2)
      (iff (atTime e1 t)
           (atTime e2 t))))
```

1.21
```
(forall (e1 e2 x s)
  (if (gen e1 e2)
      (iff (atLoc e1 x s)
           (atLoc e2 x s))))
```

Examples:

1.2
```
(forall (e1 x)
  (if (run' e1 x)
      (exists (e2)
        (and (go' e2 x) (gen e1 e2)))))
```

The axioms that would be systematically generated for 'give':

1.3
```
(forall (e x y z)
  (if (give' e x y z)
      (argn x 1 e)))
```

1.4
```
(forall (e x y z)
  (if (give' e x y z)
      (argn y 2 e)))
```

1.5
```
(forall (e x y z)
  (if (give' e x y z)
      (argn z 3 e)))
```

1.6
```
(forall (e x y z)
  (if (give' e x y z)
      (argn e 0 e)))
```

1.11
```
(forall (e x y z)
  (if (give' e x y z)
      (pred give e)))
```

1.13
```
(forall (e x y z)
  (if (give' e x y z)
      (arity 3 e)))
```
