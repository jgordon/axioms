# Schemata that need to be handled by special mechanisms

Unprimed predicates imply the `Rexist`-ence of an eventuality:

```
   [for all predicates p and corresponding preds p':
     (forall (x)
        (iff (p x)
             (exists (e) (and (p' e x) (Rexist e)))))]
```


Relate arguments to their `argn` positions:

```
   [for all primed predicates p' of arity 1:
     (forall (x)
        (if (p' e x) (argn x 1 e)))]
   [for all unprimed predicates p of arity 1:
     (forall (x)
        (if (p e x) (argn e 0 e)))]
   and so forth.
```


The arity of predicates or eventualities can be described by
axiom schemas like those for `argn` and `pred`:

```
   [for all pred p' with unprimed arity 3:
     (forall (e x y z)
             (if (p' e x y z) (arity 3 e)))]
   and so forth for all positive, non-negative arities.
```


The predicate indexing scheme of Hobbs (1995) to deal with properties
of typical elements of sets vs real entities, discussed in B3:

```
   [for all pred p:
     (forall (x s)
        (if (typelt x s)
            (iff (p-s x)
                 (forall (y) (if (member y s) (p-0 y))))))]

   [for all pred p:
     (iff (p x)
        (exists (i) (p-i x))))]
```


The introduction of unique `etc` conditions for defeasible axioms,
discussed in B7. This is currently handled by the script that processes
these axioms into the input to Henry.


Suppose p' is a predicate taking an eventuality argument `e` and some
sequence of other arguments `x` -- `(p' e x)` -- and `p-t` is a
corresponding predicate with no eventuality argument but with an extra
time argument `t`, saying that `p` is true of `x` at time `t`. This
schema gives the equivalence:

```
  [for all pred p:
     (forall (x t)
       (iff (exists (e)
               (and (p' e x) (atTime e t)))
            (p-t x t)))]
```
