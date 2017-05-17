;; 12 Time

;; This could be expanded with reference to Hobbs & Pan: An Ontology of Time
;; for the Semantic Web. A few axioms have been added from that paper (noted
;; with 'OWL-T:'.

;; Predicates:
;;
;; (instant t):              t is an instant of time.
;; (interval t):             t is an interval of time.
;; (temporalEntity t):       t is an instant or an interval.
;; (begins t1 t2):           Instant t1 is the beginning of t2.
;; (ends t1 t2):             Instant t1 is the end of t2.
;; (insideTime t1 t2):       Instant t1 is inside t2.
;; (intervalBetweeen t t1 t2): t is the interval between t1 and t2.
;; (posInfInterval t):       t is a positive infinite interval.
;; (properInterval t):       The beginning and end of interval t are
;;                              distinct.
;; (tseq s):                 s is a sequence of temporal entities.
;; (first t s):              t is the first temporal entity in temporal
;;                              sequence s.
;; (last t s):               t is the last temporal entity in temporal
;;                              sequence s.
;; (successiveElts t1 t2 s): t1 is immediately followed by t2 in
;;                              temporal sequence s.
;; (convexHull t s):         Interval t is the convex hull of temporal
;;                              sequence s.
;; (atTime e t):             Eventuality e is occurring at instant t.
;; (during e t):             Eventuality e is occurring at every instant
;;                              inside interval t.
;; (timeSpanOf t e):         Temporal entity or sequence t is all the
;;                              instants and intervals for which
;;                              eventuality e really exists or obtains.
;; (happensIn e t):          t subsumes the time span of e.
;; (posInfIntervalEv e):     e is a positive infinite interval or an
;;                             eventuality whose time span is a positive
;;                             infinite interval.
;; (properIntervalEv e):     e is a proper interval or an eventuality
;;                              whose time span is a proper interval.
;; (temporal e):             e is a temporal property, i.e.,
;;                             `atTime`, `during`,
;;                             `timeSpanOf`, `happensIn`,
;;                             `before`, or `durationOf`.
;; (nontemporal e):          e is not a temporal property.
;; (before t1 t2):           t1 is before t2.
;; (intMeets t1 t2):         Interval t1 meets interval t2.
;; (intOverlaps t1 t2):      Intervals t1 and t2 overlap.
;; (intFinishes t1 t2):      Interval t1 begins inside interval t2, and
;;                              their ends are the same.
;; (intDuring t1 t2):        Interval t1 begins after and ends before
;;                              interval t2.
;; (beforeOrMeets t1 t2):    The end of t1 is before or equal to the
;;                              beginning of t2.
;; (timeScale t):            t is a scale whose elements are temporal
;;                              entities and whose ordering is
;;                              `before`.
;; (sameDuration t1 t2):     Temporal entities t1 and t2 have the same
;;                              duration.
;; (temporalUnit u):         Interval u is a temporal unit.
;; (concatenation t s):      Interval t is the concatenation of the
;;                              intervals in the set s.
;; (durationOf d t u):       The duration of t is d units u.
;; (shorterDuration t1 t2):  Interval t1 has shorter duration than
;;                              interval t2.
;; (scaleOrderedByDuration s):  Scale s is a scale whose elements are
;;                              intervals ordered by duration.
;; (periodicTseq s):         Temporal sequence s is periodic, in that the
;;                              gaps between successive elements are all
;;                              equal.
;; (gapDuration d s u):      d is the duration of the equal gaps in
;;                              periodic temporal sequence s measured in
;;                              units u.
;; (roughlyPeriodicTseq s):  Temporal sequence s is roughly periodic, in
;;                              that the gaps between successive elements
;;                              are all the same half order of magnitude.
;; (rate n s t):             Eventualities in s occur n times in every
;;                              element of t, if t is a set of intervals,
;;                              or in every interval of duration t if t
;;                              is a temporal unit.
;; (rateScale s s0):         s is a scale whose elements are the sets of
;;                              eventualities in s0 and whose ordering is
;;                              the rate of the sets.
;; (frequent s1):            Set s1 of eventualities is in the high
;;                              region of a rate scale.

;; A temporal entity may be an instant or an interval.

;; 12.1
(forall (t) (if (instant t) (temporalEntity t)))
;; 12.2
(forall (t) (if (interval t) (temporalEntity t)))

;; OWL-T: These are the only two subclasses of temporal entities.
(forall (t)
  (if (temporalEntity t)
      (or (interval t) (instant t))))

;; The predicates `begins`, `ends`, and `insideTime` allow temporal sequences
;; and eventualities as well as temporal entities in their second argument
;; positions.

;; 12.3
(forall (t1 t2)
  (if (begins t1 t2)
      (and (instant t1)
           (or (temporalEntity t2) (tseq t2) (eventuality t2)))))

;; 12.4
(forall (t1 t2)
  (if (ends t1 t2)
      (and (instant t1)
           (or (temporalEntity t2) (tseq t2) (eventuality t2)))))

;; 12.5
(forall (t1 t2)
  (if (insideTime t1 t2)
      (and (instant t1)
           (or (temporalEntity t2) (tseq t2) (eventuality t2)))))

;; The beginning and end of an instant is itself.

;; 12.6
(forall (t1 t2)
  (if (and (instant t2) (begins t1 t2))
      (equal t1 t2)))

;; 12.7
(forall (t1 t2)
  (if (and (instant t2) (ends t1 t2))
      (equal t1 t2)))

;; OWL-T: The beginnings and ends of temporal entities, if they exist, are
;; unique.
(forall (t, t1, t2)
  (if (and (temporalEntity t) (begins t1 t) (begins t2 t))
      (equal t1 t2)))
(forall (t, t1, t2)
  (if (and (temporalEntity t) (ends t1 t) (ends t2 t))
      (equal t1 t2)))

;; 12.8 An interval t between two instants t1 and t2 is an interval that
;; begins at t1 and ends at t2. It will be useful to extend this to
;; intervals and define it as the interval from the end of t1 to the
;; beginning of t2.

(forall (t t1 t2)
  (iff (intervalBetween t t1 t2)
       (exists (t3 t4)
         (and (ends t3 t1) (begins t4 t2)
              (begins t3 t) (ends t4 t)))))

;; 12.9 A positive infinite interval is one that has no end. It may or may
;; not have a beginning.

(forall (t)
  (iff (posInfInterval t)
       (and (interval t)
            (not (exists (t2) (ends t2 t))))))

;; 12.10 When the beginning and end of an interval are distinct, we will
;; call it a proper interval. Positive infinite intervals are regarded as
;; proper intervals.

(forall (t)
  (iff (properInterval t)
       (or (exists (t1 t2)
             (and (begins t1 t) (ends t2 t) (nequal t1 t2)))
           (posInfInterval t))))

;; 12.11 A temporal sequence is a set of non-overlapping temporal entities.
;; Between any two distinct members of a temporal sequence, there is another
;; interval or instant that is not in the set.

(forall (s)
  (iff (tseq s)
       (and (forall (t) (if (member t s) (temporalEntity t)))
            (forall (t1 t2)
              (if (and (member t1 s) (member t2 s))
                  (and (or (equal t1 t2) (before t1 t2)
                           (before t2 t1))
                       (if (before t1 t2)
                           (exists (t3)
                             (and (not (member t3 s))
                                  (before t1 t3)
                                  (before t3 t2))))))))))

;; 12.12 If there is an element of the temporal sequence before all its other
;; elements, this is called the first element.

(forall (s t)
  (if (tseq s)
      (iff (first t s)
           (and (member t s)
                (forall (t1)
                  (if (member t1 s)
                      (or (equal t1 t) (before t t1))))))))

;; 12.13 If there is an element of the temporal sequence after all its other
;; elements, this is called the last element.

(forall (s t)
  (if (tseq s)
      (iff (last t s)
           (and (member t s)
                (forall (t1)
                  (if (member t1 s)
                      (or (equal t1 t) (before t1 t))))))))

;; 12.14 Two elements of a temporal sequence are successive elements if
;; there is no element between them.

(forall (s t1 t2)
  (iff (successiveElts t1 t2 s)
       (and (member t1 s) (member t2 s) (before t1 t2)
            (not (exists (t)
                   (and (member t s) (before t1 t)
                        (before t t2)))))))

;; 12.15 The predicate `before` is a partial ordering on the elements of a
;; temporal sequence.

(forall (e t1 t2 s)
  (if (and (tseq s) (before' e t1 t2))
      (partialOrdering e t1 t2 s)))

;; 12.16 A temporal sequence is a scale whose ordering relation is `before`.

(forall (s e t1 t1)
  (if (and (tseq s) (before' e t1 t2))
      (scaleDefinedBy s s e)))

;; 12.17 The convex hull of a temporal sequence is the smallest interval
;; spanning all the members of the temporal sequence.

(forall (s t1 t2 t3 t4)
  (if (and (tseq s) (first t1 s) (begins t3 t1)
           (last t2 s) (ends t4 t2))
      (forall (t)
        (iff (convexHull t s)
             (intervalBetween t t3 t4)))))

;; The three basic relations, `begins`, `ends`, and `insideTime`, can be
;; extended to cover temporal sequences as well as instants and intervals.

;; 12.18
(forall (t s)
  (if (tseq s)
      (iff (begins t s)
           (exists (t1) (and (first t1 s) (begins t t1))))))

;; 12.19
(forall (t s)
  (if (tseq s)
      (iff (ends t s)
           (exists (t1) (and (last t1 s) (ends t t1))))))

;; 12.20
(forall (t s)
  (if (and (tseq s) (insideTime t s))
      (and (not (begins t s)) (not (ends t s))
           (exists (t1)
             (and (member t1 s)
                  (or (equal t1 t) (insideTime t t1)
                      (begins t t1) (ends t t1)))))))

;; 12.21
(forall (t s)
  (if (tseq s)
      (if (exists (t1)
            (and (member t1 s)
                 (or (equal t1 t) (insideTime t t1))))
          (insideTime t s))))

;; 12.22 The predicate `atTime` relates an eventuality to an instant, saying
;; that the eventuality really exists or obtains at that instant. We constrain
;; its arguments but do not attempt to define it.

(forall (e t)
  (if (atTime e t) (and (eventuality e) (instant t))))

;; 12.23 The predicate `during` says that the eventuality really exists or
;; obtains throughout an interval.

(forall (e t)
  (iff (during e t)
       (and (eventuality e) (properInterval t)
            (forall (t1) (if (insideTime t1 t) (atTime e t1))))))

;; 12.24 The "time span of" an eventuality encompasses all the instants and
;; intervals for which it really exists or obtains. The time span may be
;; an instant, an interval, or a temporal sequence.

(forall (t e)
  (iff (timeSpanOf t e)
       (or (and (instant t) (atTime e t)
                (forall (t1)
                  (if (nequal t1 t) (not (atTime e t1)))))
           (and (interval t) (during e t)
                (forall (t1)
                  (if (atTime e t1)
                      (or (insideTime t1 t) (begins t1 t)
                          (ends t1 t)))))
           (and (tseq t)
                (forall (t1)
                  (if (and (member t1 t) (instant t1))
                      (atTime e t1)))
                (forall (t1)
                  (if (and (member t1 t) (interval t1))
                      (during e t1)))
                (forall (t1)
                  (if (and (instant t1) (atTime e t1))
                      (or (member t1 t)
                          (exists (t2)
                            (and (interval t2) (member t2 t)
                                 (or (begins t1 t2)
                                     (insideTime t1 t2)
                                     (ends t1 t2)))))))))))


;; 12.25 We will say that an eventuality happens in a temporal entity or
;; sequence if its time span is entirely included in the temporal entity
;; or sequence.

(forall (e t)
  (iff (happensIn e t)
       (exists (t1)
         (and (timeSpanOf t1 e)
              (forall (t2)
                (if (or (begins t2 t1) (insideTime t2 t1)
                        (ends t2 t1))
                    (or (begins t2 t) (insideTime t2 t)
                        (ends t2 t))))))))

;; The three basic relations, `begins`, `insideTime`, and `ends`, can now
;; be extended to eventualities as well.

;; 12.26
(forall (t e)
  (if (eventuality e)
      (iff (begins t e)
           (exists (t1) (and (timeSpanOf t1 e) (begins t t1))))))

;; 12.27
(forall (t e)
  (if (eventuality e)
      (iff (insideTime t e)
           (exists (t1)
             (and (timeSpanOf t1 e) (insideTime t t1))))))

;; 12.28
(forall (t e)
  (if (eventuality e)
      (iff (ends t e)
           (exists (t1) (and (timeSpanOf t1 e) (ends t t1))))))

;; 12.29 The predicate `posInfIntervalEv` says that its argument is either
;; a positive infinite interval or an eventuality whose time span is a
;; positive infinite interval.

(forall (e)
  (iff (posInfIntervalEv e)
       (or (posInfInterval e)
           (exists (t)
             (and (timeSpanOf t e) (posInfInterval t))))))

;; 12.30 The predicate `properIntervalEv` says that its argument is either a
;; proper interval or an eventuality whose time span is a proper interval.

(forall (e)
  (iff (properIntervalEv e)
       (or (properInterval e)
           (exists (t)
             (and (timeSpanOf t e) (properInterval t)))
           (posInfIntervalEv e))))

;; Temporal properties are ones that say something about when an
;; eventuality occurs, including `atTime`, `during`, `timeSpanOf`, and
;; `happensIn`.

;; 12.31
(forall (e0 e t) (if (atTime' e0 e t) (temporal e0)))

;; 12.32
(forall (e0 e t) (if (during' e0 e t) (temporal e0)))

;; 12.33
(forall (e0 e t) (if (timeSpanOf' e0 t e) (temporal e0)))

;; 12.34
(forall (e0 e t) (if (happensIn' e0 e t) (temporal e0)))

;; 12.35 A nontemporal eventuality is one that isn't temporal.

(forall (e) (iff (nontemporal e) (not (temporal e))))

;; 12.36 Instants are at least partially ordered by a `before` relation,
;; which will also be extended to intervals, temporal sequences, and
;; eventualities.

(forall (t1 t2)
  (if (before t1 t2)
      (and (or (temporalEntity t1) (tseq t1) (eventuality t1))
           (or (temporalEntity t2) (tseq t2) (eventuality t2)))))

;; 12.37 The beginning of a proper interval is before the instants inside,
;; which are before the end.

(forall (t1 t2 t3 t)
  (if (properIntervalEv t)
      (and (if (and (begins t1 t) (ends t3 t))
               (before t1 t3))
           (if (and (begins t1 t) (insideTime t2 t))
               (before t1 t2))
           (if (and (insideTime t2 t) (ends t3 t))
               (before t2 t3)))))

;; 12.38 The beginning of a positive infinite interval, if there is one,
;; is before all the instants inside it.

(forall (t1 t2 t)
  (if (and (posInfInterval t) (begins t1 t) (insideTime t2 t))
      (before t1 t2)))

;; 12.39 The `before` relation is antireflexive.

(forall (t) (not (before t t)))

;; 12.40 The `before` relation is antisymmetric.

(forall (t1 t2)
  (if (before t1 t2)
      (not (before t2 t1))))

;; 12.41 The `before` relation is transitive.

(forall (t1 t2 t3)
  (if (and (before t1 t2) (before t2 t3))
      (before t1 t3)))

;; 12.42 The predicate `intMeets` means that the end of one interval is the
;; beginning of the other.

(forall (t1 t2)
  (iff (intMeets t1 t2)
       (and (properIntervalEv t1) (properIntervalEv t2)
            (exists (t) (and (ends t t1) (begins t t2))))))

;; 12.43 Two intervals overlap if the beginning of one is inside the other.

(forall (t1 t2)
  (iff (intOverlap t1 t2)
       (and (properIntervalEv t1) (properIntervalEv t2)
            (exists (t)
              (or (and (begins t t1) (insideTime t t2))
                  (and (begins t t2) (insideTime t t1)))))))

;; 12.44 One interval finishes the other if it begins inside and ends the
;; same place. We have to complicate this relation a bit to accommodate
;; positive infinite intervals.

(forall (t1 t2)
  (iff (intFinishes t1 t2)
       (and (properIntervalEv t1) (properIntervalEv t2)
            (exists (t3 t4)
              (and (begins t3 t1) (begins t4 t2) (before t4 t3)))
            (or (exists (t)
                  (and (ends t t1) (ends t t2)))
                (and (posInfIntervalEv t1)
                     (posInfIntervalEv t2))))))

;; 12.45 One interval `t1` is during another `t2` if `t1` begins after `t2`
;; and ends before `t2`. The conditional in the last line of the definition
;; is to accommodate positive infinite intervals.

(forall (t1 t2)
  (iff (intDuring t1 t2)
       (and (properIntervalEv t1) (properIntervalEv t2)
            (exists (t3 t4)
              (and (begins t3 t1) (begins t4 t2) (before t4 t3)))
            (exists (t5)
              (and (ends t5 t1)
                   (forall (t6)
                     (if (ends t6 t2) (before t5 t6))))))))

;; 12.46 We can also extend the `before` relation from instants to intervals,
;; temporal sequences, and eventualities; one of them is before another
;; if the first's end is before the second's beginning.

(forall (t1 t2)
  (iff (before t1 t2)
       (exists (t3 t4)
         (and (ends t3 t1) (begins t4 t2) (before t3 t4)))))

;; 12.47 We will sometimes have occasion to talk about one temporal entity
;; being before or meeting another.  We will define the predicate
;; `beforeOrMeets` as follows:

(forall (t1 t2)
  (iff (beforeOrMeets t1 t2)
       (exists (t3 t4)
         (and (ends t3 t1) (begins t4 t2)
              (or (before t3 t4) (equal t3 t4))))))

;; 12.48 Time is a scale whose ordering relation is `before` and whose
;; components are instants and intervals.

(forall (t)
  (iff (timeScale t)
       (exists (s e t2 t3)
         (and (forall (t1)
                (iff (member t1 s)
                     (or (instant t1) (interval t1))))
              (before' e t2 t3)
              (scaleDefinedBy t s e)))))

;; 14.49 Since all the elements in a time scale are temporal entities, a time
;; scale can be viewed as a possible ground.

(forall (t) (if (timeScale t) (ground t)))

;; 12.50 And `atTime` can be viewed as an `at` relation.

(forall (s e t)
  (if (and (timeScale s) (atTime e t))
      (at e t s)))

;; 12.51 The constraint for change is that final states can't happen before
;; initial states.

(forall (e1 e2)
  (if (change e1 e2) (not (before e2 e1))))

;; 12.52 An effect cannot happen before its cause.

(forall (e1 e2)
  (if (cause e1 e2) (not (before e2 e1))))

;; 12.53 An eventuality cannot happen before an eventuality it enables.

(forall (e1 e2)
  (if (enable e1 e2) (not (before e2 e1))))

;; 12.54 If all the eventualities in a causal complex happen or hold, then
;; the effect will happen or hold. Moreover, the effect is not before
;; the elements of the causal complex.

(forall (s e t1)
  (if (and (causalComplex s e)
           (forall (e1) (if (member e1 s) (atTime e1 t1))))
      (exists (t2)
        (and (not (before t2 t1)) (atTime e t2)))))

;; 12.55 If e1 happens and e1 causes e2, then e2 (defeasibly) happens.

(forall (e1 e2 t1)
  (if (and (cause e1 e2) (atTime e1 t1) (etc))
      (exists (t2)
        (and (not (before t2 t1)) (atTime e2 t2)))))

;; 12.56 The relation `before` is temporal.

(forall (e t1 t2) (if (before' e t1 t2) (temporal e)))

;; The predicate `sameDuration` basically applies to intervals, but trivially
;; every instant is of the same duration, namely, zero.

;; 12.57
(forall (t1 t2)
  (if (sameDuration t1 t2)
      (and (temporalEntity t1) (temporalEntity t2))))

;; 12.58
(forall (t1 t2)
  (if (and (instant t1) (instant t2))
      (sameDuration t1 t2)))

;; The predicate `sameDuration` is reflexive, symmetric, and transitive.

;; 12.59
(forall (t)
  (if (temporalEntity t) (sameDuration t t)))

;; 12.60
(forall (t1 t2)
  (iff (sameDuration t1 t2) (sameDuration t2 t1)))

;; 12.61
(forall (t1 t2 t3)
  (if (and (sameDuration t1 t2) (sameDuration t2 t3))
      (sameDuration t1 t3)))

;; 12.62 A `temporalUnit` is an interval.

(forall (u)
  (if (temporalUnit u) (interval u)))

;; 12.63 A proper interval is a concatenation of a set of proper intervals
;; if every instant inside the interval is inside, the beginning, or the
;; end of some interval in the set, and the intervals in the set are
;; non-overlapping.

(forall (t s)
  (iff (concatenation t s)
       (and (properInterval t)
            (forall (t1) (if (member t1 s) (properInterval t1)))
            (exists (t1 t2)
              (and (begins t1 t) (member t2 s) (begins t1 t2)))
            (exists (t1 t2)
              (and (ends t1 t) (member t2 s) (ends t1 t2)))
            (forall (t1)
              (if (insideTime t1 t)
                  (exists (t2)
                    (and (member t2 s)
                         (or (insideTime t1 t2) (begins t1 t2)
                             (ends t1 t2))))))
            (forall (t1 t2)
              (if (and (member t1 s) (member t2 s))
                  (or (equal t1 t2) (not (intOverlap t1 t2))))))))

;; 12.64 The predication `(durationOf d t u)` says that t is made up of d
;; intervals having the same duration as u. We will allow the second
;; argument to be an instant, an interval, a temporal sequence, or an
;; eventuality.

(forall (d t u)
  (if (durationOf d t u)
      (and (nonNegInteger d) (temporalUnit u)
           (or (temporalEntity t) (tseq t) (eventuality t)))))

;; 12.65 The duration of an instant is zero.

(forall (d t u)
  (if (instant t) (durationOf 0 t u)))

;; 12.66 The duration of an interval is determined by concatenation.

(forall (d t u)
  (if (interval t)
      (iff (durationOf d t u)
           (exists (s)
             (and (concatenation t s)
                  (forall (t1)
                    (if (member t1 s) (sameDuration t1 u)))
                  (card d s))))))

;; The duration of a temporal sequence is the sum of the durations of its
;; members.

;; 12.67
(forall (s u)
  (if (null s) (durationOf 0 s u)))

;; 12.68
(forall (s s1 t u d d1 d2)
  (if (and (tseq s) (tseq s1) (not (member t s1)) (addElt s s1 t)
           (durationOf d1 s1 u) (durationOf d2 t u) (sum d d1 d2))
      (durationOf d s u)))

;; 12.69 The duration of an eventuality is the duration of its time span.

(forall (d e u)
  (if (eventuality e)
      (iff (durationOf d e u)
           (exists (t)
             (and (timeSpanOf t e) (durationOf d t u))))))

;; 12.70 The predicate `durationOf` is temporal.

(forall (e d t u)
  (if (durationOf' e d t u) (temporal e)))

;; 12.71 In terms of `durationOf`, we can define a `shorterDuration` partial
;; ordering.

(forall (t1 t2)
  (iff (shorterDuration t1 t2)
       (and (interval t1) (interval t2)
            (exists (d1 d2 u)
              (and (durationOf d1 t1 u) (durationOf d2 t2 u)
                   (lt d1 d2))))))

;; 12.72 Then we can define a `scaleOrderedByDuration`.

(forall (s)
  (iff (scaleOrderedByDuration s)
       (exists (s1 e t1 t2)
         (and (forall (t) (if (member t s1) (interval t)))
              (shorterDuration' e t1 t2)
              (scaleDefinedBy s s1 e)))))

;; 12.73 A temporal sequence is periodic if there is a constant duration
;; between any two successive temporal entities in the temporal sequence.

(forall (s)
  (iff (periodicTseq s)
       (and (tseq s)
            (exists (d u)
              (forall (t1 t2)
                (if (successiveElts t1 t2 s)
                    (exists (t)
                      (and (intervalBetween t t1 t2)
                           (durationOf d t u)))))))))

;; 12.74 The constant duration in a periodic temporal sequence can be called
;; the gap duration.

(forall (s d t1 t2 t n1 n2 u)
  (if (and (periodicTseq s) (successiveElts t1 t2 s)
           (temporalUnit u) (intervalBetween t t1 t2))
      (iff (gapDuration d s u) (durationOf d t u))))

;; 12.75 If the gap between two elements is roughly equal, the temporal
;; sequence is roughly periodic.

(forall (s)
  (iff (roughlyPeriodicTseq s u)
       (and (tseq s) (temporalUnit u)
            (exists (s0 d)
              (and (scaleOrderedByDuration s0)
                   (forall (t1 t2 t3 t4)
                     (if (and (successiveElts t1 t2 s)
                              (successiveElts t3 t4 s))
                         (exists (t12 t34 e d)
                           (and (intervalBetween t12 t1 t2)
                                (intervalBetween t34 t3 t4)
                                (durationOf' e d t12 u)
                                (sameHOM t12 t34 s0 e))))))))))

;; 12.76 The primitive case of a rate is when there is a set S of events, a
;; set T of time intervals, and a function mapping the intervals into a
;; subset of S, namely those events that occur during that interval. When
;; the concept of rate truly applies, the cardinalities of all these subsets
;; are the same.

(forall (s s0 t f n)
  (if (and (eventualities s) (set t) (powerSet s0 s)
           (forall (t1)
             (if (member t1 t) (interval t1)))
           (function f t s0)
           (forall (t1 s1)
             (if (map f t1 s1)
                 (and (forall (e)
                        (if (member e s1) (happensIn e t1)))
                      (card n s1)))))
      (rate n s t)))

;; 12.77 When the third argument of `rate` is a temporal unit, we assume that
;; the members of the set of time intervals all have a duration of one in
;; that unit.

(forall (n s t u)
  (if (and (eventualities s) (temporalUnit u)
           (forall (t1) (if (member t1 t) (durationOf 1 t1 u)))
           (rate n s t))
      (rate n s u)))

;; 12.78 We extend `rate` to units which are not the duration of the temporal
;; intervals in which the events were measured, e.g., going 60 mph for
;; 5 minutes.

(forall (r1 r2 s u1 u2 j)
  (if (and (rate r1 s u1) (product r2 j r1)
           (forall (t n1 n2)
             (iff (and (durationOf n1 t u1) (durationOf n2 t u2))
                  (product n1 j n2))))
      (rate r2 s u2)))

;; 12.79 Rate defines a scale whose elements are the set of events whose
;; rate is being measured and whose ordering is the less-than relation
;; between rates.

(forall (s s0)
  (iff (rateScale s s0)
       (and (forall (s1) (if (member s1 s0) (eventualities s1)))
            (exists (u e s1 s2)
              (and (temporalUnit u) (lts' e s1 s2 s0)
                   (forall (s3 s4)
                     (iff (and (lts' e s3 s4 s0) (Rexist e))
                          (exists (r1 r2)
                            (and (rate r1 s3 u) (rate r2 s4 u)
                                 (lt r1 r2)))))
                   (scaleDefinedBy s s0 e))))))

;; 12.80 A set of events is frequent if it is in the `Hi` region of a rate
;; scale.

(forall (s1)
  (iff (frequent s1)
       (exists (s s0 s2)
         (and (member s1 s0) (rateScale s s0) (Hi s2 s)
              (inScale s1 s2)))))
