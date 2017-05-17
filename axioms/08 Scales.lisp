;; 8 Scales

;; Predicates:
;;
;; (scale s):                 s is a scale.
;; (partialOrdering e x y s): e is a partial ordering on the components
;;                               of s, where x is less than y.
;; (inScale y s):             y is a component of the scale s.
;; (lts x y s):               x is less than y in the partial ordering
;;                               for scale s.
;; (gts x y s):               x is greater than y in the partial ordering
;;                               for scale s.
;; (onScale x s):             x is a point on scale s or at a point on s.
;; (leqs x y s):              x is less than or equal to y in the partial
;;                               ordering for scale s.
;; (geqs x y s):              x is greater than or equal to y in the
;;                               partial ordering for scale s.
;; (top x s):                 x is the highest element in the scale s.
;; (bottom x s):              x is the lowest element in the scale s.
;; (subscale s1 s):           s1 is a subscale of scale s.
;; (reverse s1 s):            s1 is the reverse of scale s.
;; (disjoint s1 s2):          The component sets of scales s1 and s2 are
;;                               disjoint.
;; (totalOrdering e x y s):   e, the partial ordering on the components
;;                               of s, where x is less than y, is in fact
;;                               total.
;; (function f s1 s2):        f is a function from a set or scale s1 onto
;;                               a set or scale s2.
;; (monotoneIncreasing f):    Function f is monotone-increasing
;;                               scale-to-scale function preserving the
;;                               scales' “less than” ordering.
;; (functionInto f s1 s2):    f is a function from a set or scale s1 into
;;                               a set or scale s2.
;; (scaleDefinedBy s s1 e):   s is the scale with components s1 and
;;                               partial ordering defined by relation e.
;; (subsetConsistent s e):    s is a scale whose ordering is consistent
;;                               with the subset ordering among sets
;;                               associated by the relation e with
;;                               entities placed at points in s.
;; (compositeScale s s1 s2):  s is a composite scale with the same
;;                               components as scales s1 and s2 and a
;;                               partial ordering consistent with the
;;                               partial orderings of s1 and s2.
;; (Hi s1 s):                 s1 is the high region of scale s.
;; (Md s1 s):                 s1 is the middle region of scale s.
;; (Lo s1 s):                 s1 is the low region of scale s.
;; (scaleFor s e):            The property e corresponds to being in the
;;                               Hi region of scale s.

;; 8.1 A scale is a partially ordered set.

(forall (s)
   (if (scale s)
       (and (compositeEntity s)
            (exists (s1 e x y s2 s3)
               (and (componentsOf s1 s)
                    (partialOrdering e x y s)
                    (subset s2 s3) (relationsOf s3 s)
                    (forall (e1)
                       (if (member e1 s2)
                           (exists (x1 y1)
                              (and (member x1 s1) (member y1 s1)
                                   (subst2 x1 y1 e1 x y e))))))))))

;; 8.2 Conditions on the arguments of `partialOrdering`:

(forall (e x y s)
   (if (partialOrdering e x y s)
       (and (scale s) (arg* x e) (arg* y e))))

;; 8.3 `inScale` is an abbreviation for being a component of a scale.

(forall (y s)
   (iff (inScale y s)
        (and (scale s) (componentOf y s))))

;; 8.4 We define a less-than relation relative to a particular scale:

(forall (e x1 y1 s)
   (iff (lts' e1 x1 y1 s)
        (exists (e x y e1)
           (and (partialOrdering e x y s)
                (subst2 x y e x1 y1 e1)))))

;; 8.5 The partial ordering is antireflexive.

(forall (x s)
  (not (lts x x s)))

;; 8.6 It is antisymmetric.

(forall (x y s)
  (if (lts x y s)
      (not (lts y x s))))

;; 8.7 It is transitive.

(forall (x y z s)
   (if (and (lts x y s) (lts y z s))
       (lts x z s)))

;; 8.8 The opposite of being less-than on a scale is being greater-than:

(forall (x y s)
  (iff (gts y x s)
       (lts x y s)))

;; We can apply `lts` and `gts` either to points on the scale or to
;; entities that are at those points.

;; 8.9 Original:
;; (forall (x y s)
;;    (if (lts x y s)
;;        (and (or (inScale x s)
;;                 (exists (x1) (and (at x x1 s) (inScale x1 s))))
;;             (or (inScale y s)
;;                 (exists (y1) (and (at y y1 s) (inScale y1 s)))))))
;; Rewritten to use `onScale`:
(forall (x y s)
   (if (lts x y s)
       (and (onScale x s) (onScale y s))))

;; 8.10 The `at` relation preserves the partial ordering.

(forall (x1 x2 y1 y2 s)
   (and (if (at x1 y1 s)
            (iff (lts x1 y2 s) (lts y1 y2 s)))
        (if (at x2 y2 s)
            (iff (lts y1 x2 s) (lts y1 y2 s)))
        (if (and (at x1 y1 s) (at x2 y2 s))
            (iff (lts x1 x2 s) (lts y1 y2 s)))))

;; 8.11 It is convenient to have a predicate `onScale` for both points on a
;; scale and for entities at points in a scale.

(forall (x s)
   (iff (onScale x s)
        (or (inScale x s)
            (exists (y)
               (and (inScale y s) (at x y s))))))

;; 8.12 Less-than or equal:

(forall (x y s)
   (iff (leqs x y s)
        (or (lts x y s)
            (and (onScale x s) (equal x y)))))

;; 8.13 Greater-than or equal:

(forall (x y s)
   (iff (geqs x y s)
        (or (gts x y s)
            (and (onScale x s) (equal x y)))))

;; 8.14 `leqs` is antisymmetric:

(forall (x y s)
   (if (and (leqs x y s) (leqs y x s))
       (equal x y)))

;; 8.15 The top of a scale is the highest point in the scale.

(forall (x s)
   (iff (top x s)
        (and (inScale x s)
             (forall (y)
               (if (inScale y s) (leqs y x s))))))

;; 8.16 The bottom of a scale is the lowest point in the scale.

(forall (x s)
   (iff (bottom x s)
        (and (inScale x s)
             (forall (y)
               (if (inScale y s) (leqs x y s))))))

;; 8.17 A subscale of a scale has as its components a subset of the
;; components of the scale and its partial ordering relation is the partial
;; ordering of the scale restricted to that subset.

(forall (s1 s)
   (iff (subscale s1 s)
        (and (scale s1) (scale s)
             (forall (x) (if (inScale x s1) (inScale x s)))
             (forall (x y)
                (iff (lts x y s1)
                     (and (inScale x s1) (inScale y s1)
                          (lts x y s)))))))

;; 8.18 The reverse of a scale is one in which the partial ordering is
;; reversed.

(forall (s1 s)
   (iff (reverse s1 s)
        (and (scale s1) (scale s)
             (forall (x y)
                (and (iff (inScale x s) (inScale x s1))
                     (iff (lts x y s) (lts y x s1)))))))

;; 8.19 Two scales are disjoint if their sets of components are disjoint.

(forall (s1 s2)
   (if (and (scale s1) (scale s2))
       (iff (disjoint s1 s2)
            (exists (s3 s4)
               (and (componentsOf s3 s1) (componentsOf s4 s2)
                    (disjoint s3 s4))))))

;; 8.20 A total ordering is a partial ordering in which of any two elements,
;; one is either less than, equal to, or greater than the other.

(forall (e x y s)
   (if (lts' e x y s)
       (iff (totalOrdering e x y s)
            (forall (x1 y1)
               (if (and (inScale x1 s) (inScale y1 s))
                   (or (lts x1 y1 s) (equal x1 y1)
                       (lts y1 x1 s)))))))

;; 8.21 A scale is potentially a ground, and very frequently we speak of
;; entities being located at some point on a scale.

(forall (s)
  (if (scale s) (ground s)))

;; 8.22 For a scale to be the domain or range of a function is for its set of
;; components to be the domain or range.

(forall (f s1 s2)
   (iff (function f s1 s2)
        (exists (s3 s4)
           (and (if (set s1) (equal s3 s1))
                (if (scale s1) (componentsOf s3 s1))
                (if (set s2) (equal s4 s2))
                (if (scale s2) (componentsOf s4 s2))
                (function0 f s3 s4)))))

;; 8.23 A scale-to-scale function is monotone-increasing if the mapping
;; preserves the domain scale's less-than ordering.

(forall (f s1 s2)
   (if (and (function f s1 s2) (scale s1) (scale s2))
       (iff (monotoneIncreasing f)
            (forall (x1 x2 y1 y2)
               (if (and (map f x1 y1) (map f x2 y2) (lts x1 x2 s1))
                   (lts y1 y2 s2))))))

;; 8.24 A function f is "into" a set or scale s3 if there is a subset or
;; subscale s2 for which fi is a function "onto".

(forall (f s1 s3)
   (iff (functionInto f s1 s3)
        (exists (s2)
          (and (or (subset s2 s3) (subscale s2 s3))
               (function f s1 s2)))))

;; 8.25 We define a scale by the set of its components and the relation that
;; is the partial ordering of the scale.

(forall (s s1 e)
   (iff (scaleDefinedBy s s1 e)
        (and (scale s) (componentsOf s1 s)
             (exists (x y)
               (partialOrdering e x y s)))))

;; 8.26 A sequence is a scale whose partial ordering is the `beforeInSeq`
;; relation.

(forall (s s1 e x y)
   (if (and (sequence s) (componentsOf s1 s)
            (beforeInSeq' e x y s))
       (and (scaleDefinedBy s s1 e)
            (forall (z)
              (if (first z s)
                  (bottom z s))))))

;; 8.27 A set of sets under the `subset` relation is a scale.

(forall (s1 e x y)
  (if (and (forall (s2)
             (if (member s2 s1)
                 (set s2)))
            (subset' e x y))
       (exists (s)
          (and (scaleDefinedBy s s1 e)
               (forall (z)
                 (if (and (member z s1) (null z))
                     (bottom z s)))))))

;; 8.28 If the entities on a scale are associated with sets, then we'd like
;; the ordering on the scale to be consistent with the subset relation on
;; those associated sets. (E.g., if two tasks both have obstructions A and B,
;; but one of the tasks also has obstruction C, that's the harder task.)

(forall (s e)
   (iff (subsetConsistent s e)
        (and (scale s) (eventuality e)
             (forall (s0) (if (argn s0 1 e) (set s0)))
             (forall (x) (if (argn x 2 e) (exists (y) (at x y s))))
             (forall (e1 e2 s1 s2 x1 x2)
                (if (and (instance e1 e) (argn s1 1 e1)
                                         (argn x1 2 e1)
                         (instance e2 e) (argn s2 1 e2)
                                         (argn x2 2 e2)
                         (subset s1 s2))
                    (leqs x1 x2 s))))))

;; 8.29
(forall (s1 s2 x1 x2 s)
  (if (and (subset s1 s2) (r s1 x1) (r s2 x2))
      (leqs x1 x2 s)))

;; 8.30 We can construct composite scales out of existing scales.

(forall (s s1 s2)
   (if (compositeScale s s1 s2)
       (and (exists (s3)
               (and (componentsOf s3 s1) (componentsOf s3 s2)
                    (componentsOf s3 s)))
            (forall (x y)
               (if (and (lts x y s1) (leqs x y s2))
                   (lts x y s)))
            (forall (x y)
               (if (and (leqs x y s1) (lts x y s2))
                   (lts x y s))))))

;; The `Hi`, `Md`, and `Lo` regions of a scale are subscales.

;; 8.31
(forall (s1 s) (if (Hi s1 s) (subscale s1 s)))
;; 8.32
(forall (s1 s) (if (Md s1 s) (subscale s1 s)))
;; 8.33
(forall (s1 s) (if (Lo s1 s) (subscale s1 s)))

;; 8.34 The top of the scale is in the `Hi` region of the scale and is the
;; top of the `Hi` region.

(forall (s1 s)
   (if (Hi s1 s)
       (forall (x)
         (iff (top x s) (top x s1)))))

;; 8.35 The bottom of a scale is the bottom of its `Lo` region.

(forall (s1 s)
   (if (Lo s1 s)
       (forall (x)
         (iff (bottom x s) (bottom x s1)))))

;; 8.36 If a point is in the `Lo` region, then it is less than all the points
;; in the `Hi` region.

(forall (s s1 s2 x y)
   (if (and (Hi s1 s) (Lo s2 s) (inScale x s1) (inScale y s2))
       (lts y x s)))

;; 8.37 The `scaleFor` predicate relates a scale and the absolute form of its
;; adjective (e.g., 'tall').

(forall (s e)
   (iff (scaleFor s e)
        (exists (s1)
           (and (Hi s1 s)
                (forall (e1 x y)
                   (if (and (at' e1 x y s1) (argn x 1 e))
                       (iff (Rexist e) (Rexist e1))))))))

;; 8.38 If something is in the `Hi` region of a scale, then that property plays
;; a causal or enabling role in some agent's goal being achieved or not
;; achieved.

(forall (e x y s1 s)
   (if (and (at' e x y s1) (Hi s1 s) (etc))
       (exists (c a g g1)
          (and (member e c) (goal g a)
               (or (causalComplex c g)
                   (and (not' g1 g) (causalComplex c g1)))))))
