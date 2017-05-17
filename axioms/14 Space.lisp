;; 14 Space

;; Predicates:
;;
;; (physobj x):                x is a physical object.
;; (spatialSystem s):          s is a composite entity whose components
;;                                are  physical objects related by
;;                                distance.
;; (distance d x1 x2 u s):     d is the distance in units u between x1
;;                                and x2 in spatial system s.
;; (spatialUnit u):            u is a spatial unit.
;; (shorterDistance d1 d2 s):  d1 and d2 are distances between components
;;                                of spatial system s, and d1 is less
;;                                than d2.
;; (nearnessScale s1 s):       s1 is a scale whose components are
;;                                distances between pairs of entities in
;;                                spatial system s.
;; (near x1 x2 s):             x1 is near x2 in s.
;; (atLoc x y s):              x is at y in spatial system s.

;; 14.1 A spatial system is a composite entity whose components are physical
;; objects and among whose relations is a `distance` relation.

(forall (s)
  (iff (spatialSystem s)
       (and (compositeEntity s)
            (exists (s1)
              (and (componentsOf s1 s)
                   (forall (x)
                     (if (member x s1) (physobj x)))))
            (exists (s2 s3)
              (and (relationsOf s2 s) (subset s3 s2)
                   (forall (e)
                     (if (member e s3)
                         (exists (d x1 x2 u)
                           (distance' e d x1 x2 u s)))))))))

;; 14.2 Constraints on the arguments of `distance`.

(forall (d x1 x2 u s)
  (if (distance d x1 x2 u s)
      (and (nonNegInteger d) (spatialSystem s)
           (componentOf x1 s) (componentOf x2 s)
           (spatialUnit u))))

;; 14.3 The distance between an entity and itself is zero.

(forall (x u s)
  (if (and (componentOf x s) (spatialUnit u) (spatialSystem s))
      (distance 0 x x u s)))

;; 14.4 The distance between two entities is symmetric.

(forall (d x1 x2 u s)
  (iff (distance d x1 x2 u s)
       (distance d x2 x1 u s)))

;; 14.5 The triangle inequality holds.

(forall (d1 d2 d3 d4 x1 x2 x3 u s)
  (if (and (distance d1 x1 x2 u s) (distance d2 x2 x3 u s)
           (distance d3 x1 x3 u s) (sum d4 d1 d2))
      (leq d3 d4)))

;; 14.6 A distance `d1` is a shorter distance than `d2` in a spatial system
;; `s` under the obvious conditions.

(forall (d1 d2 s)
  (iff (shorterDistance d1 d2 s)
       (exists (u x1 x2 x3 x4)
         (and (distance d1 x1 x2 u s) (distance d2 x3 x4 u s)
              (lt d1 d2)))))

;; 14.7 A scale for near-ness is the reverse of a scale whose elements are
;; the distances between elements of s and whose ordering function is
;; `shorterDistance`. Shorter distances end up in the `Hi` region.

(forall (s1 s)
  (iff (nearnessScale s1 s)
       (exists (u s2 s3 e d1 d2)
         (and (scaleDefinedBy s2 s3 e)
              (forall (d)
                (if (member d s3)
                    (exists (x1 x2) (distance d x1 x2 u s))))
              (shorterDistance' e d1 d2 s) (reverse s1 s2)))))

;; 14.8 For `x1` to be near `x2` is for the distance between them to be in
;; the `Hi` region of a near-ness scale.

(forall (x1 x2 s)
  (if (and (componentOf x1 s) (componentOf x2 s))
      (iff (near x1 x2 s)
           (exists (s1 s2 d u)
             (and (nearnessScale s1 s) (Hi s2 s1) (distance d x1 x2 u s)
                  (inScale d s2))))))

;; 14.9 A spatial system is a possible ground by virtue of the fact that all
;; its components are physical objects. This is the common property they have
;; that makes a unitary interpretation of the `at` relation possible.

(forall (s)
  (if (spatialSystem s)
      (ground s)))

;; 14.10 The predicate `atLoc` for at a location is `at` where `s` is
;; specialized to spatial systems.

(forall (x y s)
  (if (atLoc x y s)
      (and (spatialSystem s) (at x y s))))

;; 14.11 Two entities that are at locations in a spatial system are near if
;; their locations are near.

(forall (s y1 y2 x1 x2)
  (if (and (componentOf y1 s) (componentOf y2 s)
           (atLoc x1 y1 s) (atLoc x2 y2 s))
      (iff (near x1 x2 s) (near y1 y2 s))))
