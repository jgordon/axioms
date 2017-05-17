;; 6 Composite Entities

;; Predicates:
;;
;; (compositeEntity x):     x is a composite entity.
;; (componentsOf s1 x):     s1 is the set of components of composite
;;                             entity x.
;; (componentOf y x):       y is a component of x.
;; (aggregate x y z):       x is a composite entity whose components are y
;;                             and z.
;; (componentOrWhole y x):  y is either a component of x or x itself.
;; (externalTo y x):        Neither y nor any of its components is equal
;;                             to x or one of its components.
;; (onlyarg* y e):          y is the only arg* of e, after recursing
;;                             through all the eventuality arguments.
;; (propertiesOf s2 x):     s2 is the set of properties of composite
;;                             entity x.
;; (relationsOf s3 x):      s3 is the set of relations of composite
;;                             entity x.
;; (relationOf e x):        e is one of the relations of x.
;; (propOrRelOf e x):       e is one of the properties or relations of x.
;; (at x y s):              x is at component y in composite entity s.
;; (ground s):              The components of s are sufficiently similar
;;                             for it to be a potential ground in an at
;;                             relation.
;; (pattern x):             x is a pattern.
;; (patternParameters s x): s is the set of parameters of x
;; (instance x1 x):         Composite entity x1 is an instance of
;;                                pattern x in which all parameters of x
;;                                are instantiated.
;; (incompleteInstance x1 x): Composite entity x1 is a partial instance
;;                               of pattern x in which not all
;;                               parameters of x are instantiated.

;; 6.1 A composite entity is characterized by a set of components, a set of
;; properties, and a set of relations.

(forall (x)
  (iff (compositeEntity x)
       (exists (s1 s2 s3)
         (and (componentsOf s1 x) (propertiesOf s2 x)
              (relationsOf s3 x)))))

;; Make `compEnt` a synonym for compositeEntity since it is used in the
;; previous treatment of composite entities for use in Henry.

(forall (x) (iff (compositeEntity x) (compEnt x)))

;; 6.2 The set of components of a composite entity is nonempty.

(forall (s1 x)
  (if (componentsOf s1 x)
      (and (set s1) (compositeEntity x) (not (null s1)))))

;; 6.3 The predicate `componentOf` gives us a quick way to say a single
;; entity is a component.

(forall (y x)
  (iff (componentOf y x)
       (and (compositeEntity x)
            (exists (s)
              (and (componentsOf s x) (member y s))))))

;; 6.4 An aggregate of two entities is a composite entity with those two
;; entities as its components.

(forall (x y z)
  (iff (aggregate x y z)
       (and (compositeEntity x)
            (exists (s)
              (and (componentsOf s x) (doubleton s y z))))))

;; 6.5 We define a predicate `componentOrWhole` as the disjunction of
;; `componentOf` and being equal to the whole.

(forall (x1 x)
  (iff (componentOrWhole x1 x)
       (or (equal x1 x) (componentOf x1 x))))

;; 6.6 An entity `y` is external to a composite entity `x` if neither it nor
;; any of its components is equal to `x` or one of `x`'s components.

(forall (y x)
  (iff (externalTo y x)
       (not (exists (y1 x1)
              (and (componentOrWhole y1 y)
                   (componentOrWhole x1 x)
                   (equal y1 x1))))))

;; 6.7 The predicate `onlyarg*` recurses through eventuality arguments and
;; bottoms out in a single entity y.

(forall (y e)
  (iff (onlyarg* y e)
       (and (eventuality e) (nequal y e)
            (forall (y1)
              (if (arg y1 e)
                  (or (equal y1 y)
                      (onlyarg* y y1)))))))

;; 6.8 All the elements in the properties of a composite entity have an
;; `onlyarg*` that is either a component of the composite entity or the
;; whole.

(forall (s2 x)
  (if (propertiesOf s2 x)
      (and (set s2) (compositeEntity x)
           (forall (e)
             (if (member e s2)
                 (exists (y)
                   (and (componentOrWhole y x)
                        (onlyarg* y e))))))))

;; 6.9 The set of relations of a composite entity are relations between a
;; component or the whole, and something else.

(forall (s3 x)
  (if (relationsOf s3 x)
      (and (set s3) (compositeEntity x)
           (forall (e)
             (if (member e s3)
                 (exists (y z)
                   (and (componentOrWhole y x) (arg* y e)
                        (nequal z y) (arg* z e))))))))

;; 6.10 A relation is a relation of a composite entity if it is in the
;; `relationsOf` set.

(forall (e x)
  (iff (relationOf e x)
       (exists (s)
         (and (relationsOf s x) (member e s)))))

;; 6.11 It will be useful to be able to say something is a property or a
;; relation of a composite entity.

(forall (e x)
  (iff (propOrRelOf e x)
       (exists (s)
         (and (member e s)
              (or (propertiesOf s x) (relationsOf s x))))))

;; 6.12 Sets are composite entities whose components are members and whose
;; only property is being set.

(forall (e s s1 s2 s3)
  (if (and (set' e s) (Rexist e) (not (null s))
           (singleton s2 e) (null s3))
      (and (compositeEntity s) (componentsOf s s)
           (propertiesOf s2 s) (relationsOf s3 s))))

;; 6.13 Ordered pairs are composite entities where the components are the
;; first and second elements, there are no properties other than the whole
;; being a pair, and the relations are the `first` and `second` relations
;; between the components and the whole.

(forall (p x y e1 e2 e3)
  (if (and (pair0' e1 p) (first' e2 x p) (second' e3 y p)
           (Rexist e1) (Rexist e2) (Rexist e3))
      (exists (s1 s2 s3)
        (and (compositeEntity p)
             (doubleton s1 x y) (componentsOf s1 p)
             (singleton s2 e1) (propertiesOf s2 p)
             (doubleton s3 e2 e3) (relationsOf s3 p)))))

;; 6.14 A sequence can be viewed as a composite entity whose components are
;; the elements of the sequence and whose relations are the ordering
;; relations in the sequence.

(forall (e s)
  (if (and (sequence' e s) (Rexist e)
           (exists (x) (inSeq x s)))
      (exists (s1 s2 s3)
        (and (compositeEntity s)
             (forall (x) (iff (member x s1) (inSeq x s)))
             (componentsOf s1 s)
             (singleton s2 e) (propertiesOf s2 s)
             (forall (e1)
               (iff (member e1 s3)
                    (exists (x y)
                      (and (beforeInSeq' e1 x y s)
                           (Rexist e1)))))
             (relationsOf s3 s)))))

;; 6.15 If `x` is at `y` in `s`, then `y` must be a component of `s` and `x`
;; must be external to `s`.

(forall (x y s)
  (if (at x y s)
      (and (componentOf y s) (externalTo x s))))

;; 6.16 A ground in a figure-ground relation is a composite entity whose
;; parts are all uniform in that they all share some property.

(forall (s)
  (iff (ground s)
       (and (compositeEntity s)
            (exists (e y)
              (and (arg* y e)
                   (forall (y1)
                     (if (componentOf y1 s)
                         (exists (e1)
                           (and (subst y e y1 e1)
                                (if (Rexist s)
                                    (Rexist e1)))))))))))

;; 6.17 This can also be written as:

(forall (s)
  (iff (ground s)
       (and (compositeEntity s)
            (exists (e y s1)
              (and (componentsOf s1 s) (typelt y s1) (arg* y e)
                   (if (Rexist s) (Rexist e)))))))

;; 6.18 The third argument of an `at` relation must be a potential ground.

(forall (x y s)
  (if (at x y s)
      (ground s)))


;; 6.19 A pattern is a composite entity which contains type elements among
;; its components.

(forall (x)
  (iff (pattern x)
       (exists (y s1)
              (and (componentOf y x) (typelt y s1)))))

;; 6.20 The parameters of a pattern are the components that are type elements.

(forall (x)
  (if (pattern x)
      (iff (patternParameters s x)
           (forall (y)
             (iff (member y s)
                  (exists (s1)
                         (and (componentOf y x)
                              (typelt y s1))))))))

;; 6.21 An instance of a pattern is a composite entity in which all
;; parameters have been replaced by entities that are members of the set
;; the parameter is the type element of.

(forall (x x1 s)
  (if (and (pattern x) (patternParameters s x))
      (iff (patternInstance x1 x)
           (forall (y s1)
             (if (and (member y s) (typelt y s1))
                 (exists (y1)
                        (and (member y1 s1) (componentOf y1 x1)
                             (forall (p)
                               (if (and (propOrRelOf p x)
                                        (arg* y p))
                                   (exists (p1)
                                          (and (subst y1 p1 y p)
                                               (propOrRelOf p1 x1))))))))))))

;; 6.21 We can define an incomplete instance to be a composite entity in
;; which at least one parameter is instantiated and some but not all of the
;; properties and relations are instantiated.

(forall (x x1 s)
  (if (and (pattern x) (patternParameters s x))
      (iff (incompleteInstance x1 x)
           (and (exists (y y1 s1 p p1)
                  (and (member y s) (typelt y s1)
                       (componentOf y1 x1) (member y1 s1)
                       (propOrRelOf p x) (arg* y p)
                       (subst y1 p1 y p) (propOrRelOf p1 x1)))
                (exists (p y)
                  (and (propOrRelOf p x) (arg* y p)
                       (forall (y1 p1)
                         (if (subst y1 p1 y p)
                             (not (propOrRelOf p1 x1))))))))))

;; Henry axioms:

;; A composite entity has a set of components.
;;
;; (B (name compEnt1)
;;    (=> (compEnt x :1.2)
;;        (^ (componentsOf s x) (typelt y s)
;;           (componentOf y x))))

;; A composite entity has a component.
;;
;; (B (name compEnt1a) (=> (compEnt x :1.2) (componentOf y x)))

;; A composite entity has a set of structural relations among its
;; components.
;;
;; (B (name compEnt2)
;;    (=> (compEnt x :1.2)
;;        (^ (relationsOf s1 x) (typelt r s1)
;;           (componentOf y1 x) (componentOf y2 x)
;;           (argstar y1 r) (argstar y2 r))))

;; A composite entity has relations/structure.
;;
;; (B (name compEnt2a)
;;    (=> (compEnt x :1.2) (relationsOf s1 x)))

;; The primed version of relationsOf.
;;
;; (B (name compEnt2b)
;;    (=> (^ (relationsOfP e s x :0.6) (Rexist e :0.6)) (relationsOf s1 x)))

;; To be in a composite entity is to be a component or to be at a
;; component.
;;
;; (B (name compEnt6a)
;;    (=> (^ (compEnt x :0.6) (componentOf y x :0.6))
;;        (in y x)))

;; (B (name compEnt6b)
;;    (=> (^ (compEnt x :0.4) (componentOf z x :0.4) (at y z x :0.4))
;;        (in y x)))

;; The primed version of in.
;;
;; (B (name compEnt6c)
;;    (=> (^ (inP e x y :0.6) (Rexist e :0.6))
;;        (in x y)))
