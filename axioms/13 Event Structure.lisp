;; 13 Event Structure

;; Predicates:
;;
;; (event e):                e is an event.
;; (subevent e1 e2):         Event e1 is a subevent of event e2.
;; (eventSequence e e1 e2):  Event e is a sequence consisting of event e1
;;                              followed by event e2.
;; (cond e e1 e2):           e is the conditional event of event e2
;;                              occurring if eventuality e happens or
;;                              holds.
;; (iteration e e1):         e is the event consisting of iterations of
;;                              event type e1.
;; (whileDo e e1 e2):        e is the event consisting of iterations of
;;                              event e2 as long as eventuality e1
;;                              happens or holds.
;; (repeatUntil e e1 e2):    e is the event consisting of iterations of
;;                              event type e1 happening until e2 happens
;;                              or holds.
;; (forAllOfSeq e s x e1):   e is the event consisting of iterations of
;;                              event type e1 where in successive
;;                              iterations the role of x is played by the
;;                              successive members of sequence s.

;; 13.1 The `subevent` relation is antisymmetric (and thus also
;; antireflexive).

(forall (e1 e2)
  (if (subevent e1 e2)
      (not (subevent e2 e1))))

;; 13.2 The `subevent` relation is transitive.

(forall (e1 e2 e3)
  (if (and (subevent e1 e2) (subevent e2 e3))
      (subevent e1 e3)))

;; 13.3 An `event` can (1) directly be a change of state, (2) generate
;; a change of state, or (3) have a subevent, which contains the change.

(forall (e)
   (iff (event e)
        (or (exists (e1 e2)
               (and (nequal e1 e2) (change' e e1 e2)))
            (exists (e0 e1 e2)
               (and (nequal e1 e2) (change' e0 e1 e2) (gen e e0)))
            (exists (e1)
              (subevent e1 e)))))

;; 13.4 Where an event `e` generates a change of state, `e` is an eventuality
;; because that's what the arguments of `gen` are.

(forall (e) (if (event e) (eventuality e)))

;; 13.5 The arguments of `subevent` are events.

(forall (e1 e2)
  (if (subevent e1 e2)
      (and (event e1) (event e2))))

;; 13.6 An aggregate, or conjunction, that has an event as a conjunct is
;; itself an event.

(forall (e e1 e2)
   (if (and (and' e e1 e2) (event e1))
       (and (subevent e1 e) (event e))))

;; 13.7 `and'` is essentially commutative.

(forall (e e1 e2)
  (if (and (and' e e1 e2) (event e2))
      (and (subevent e2 e) (event e))))

;; 13.8 Two events are in sequence if one is before the other, and the
;; aggregate of the two events is just their reified conjunction.

(forall (e e1 e2)
  (iff (eventSequence e e1 e2)
       (and (event e1) (event e2) (and' e e1 e2) (beforeOrMeets e1 e2))))

;; 13.9 From 13.6 and 13.7, we see that the components of an event sequence
;; are subevents and that the event sequence is itself an event.

(forall (e e1 e2)
  (if (eventSequence e e1 e2)
      (and (event e) (subevent e1 e) (subevent e2 e))))

;; 13.10 We will take a conditional event to be the implicational relation
;; between some eventuality -- a state or an event -- and an event, with a
;; further relation that the first eventuality must obtain at the beginning
;; of the second.

(forall (e e1 e2)
  (iff (cond e e1 e2)
       (and (imply' e e1 e2) (event e2)
            (forall (t)
              (if (begins t e2)
                  (atTime e1 t))))))

;; 13.11 The event `e2` is a subevent of `e` and hence `e` is also an event.

(forall (e e1 e2)
  (if (cond e e1 e2)
      (and (subevent e2 e) (event e))))

;; 13.12 A pure `iteration` is defined recursively for when there is no
;; termination condition and no set of entities the iteration is over.

(forall (e e1)
  (iff (iteration e e1)
       (exists (e2 e3)
         (and (eventSequence' e e2 e3) (instance e2 e1)
              (or (iteration e3 e1) (instance e3 e1))))))

;; 13.13 Some iterative processes have a termination condition, for which
;; we define a predicate `whileDo` that says one event type `e2` is
;; instantiated by successive instances as long as eventuality `e1` happens
;; or holds.

(forall (e e1 e2)
  (iff (whileDo e e1 e2)
       (exists (e3 e4 e5)
         (and (cond e e1 e3) (eventSequence' e3 e4 e5) (instance e4 e2)
              (or (whileDo e5 e1 e2) (instance e5 e2))))))

;; 13.14 A `repeatUntil` can be defined similarly, but an instance `e3` of
;; the body `e1` occurs before the condition `e2` is checked.

(forall (e e1 e2)
  (iff (repeatUntil e e1 e2)
       (exists (e3 e4 e5)
         (and (eventSequence' e e3 e4) (instance e3 e1) (cond e4 e2 e5)
              (or (repeatUntil e5 e1 e2) (instance e5 e1))))))

;; 13.15 The same event type happening to all the elements of a sequence
;; in turn.

(forall (e s e1)
  (iff (forAllOfSeq e s x e1)
       (exists (y e2 l e3 s1)
         (or (and (length 1 s) (first y s) (subst y e2 x e1) (equal e e2))
             (and (length l s) (gt l 1) (first y s) (subst y e2 x e1)
                  (eventSequence e e2 e3) (forAllOfSeq e3 s1 x e1)
                  (rest s1 s))))))

;; 13.16 A complex event is a composite entity whose components are its
;; subevents, among whose properties are the `event` properties, and among
;; whose relations are the `subevent` relations.

(forall (e1 e)
   (if (subevent e1 e)
        (exists (s1 s2 s3)
          (and (compositeEntity e)
               (componentsOf s1 e) (propertiesOf s2 e)
               (relationsOf s3 e)
               (forall (e2)
                 (iff (member e2 s1) (subevent e2 e)))
               (forall (e2)
                 (if (member e2 s1)
                     (exists (e3)
                       (and (event' e3 e2) (member e3 s2)))))
               (forall (e2)
                 (if (member e2 s1)
                     (exists (e3)
                       (and (subevent' e3 e2 e)
                            (member e3 s3)))))))))
