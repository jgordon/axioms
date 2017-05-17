;; 5 Functions and Sequences

;; Predicates:
;;
;; (pair0 p):               p is an ordered pair.
;; (pair p x y):            p is the ordered pair $<$x,y$>$.
;; (first x p):             x is the first element of a pair or sequence.
;; (second y p):            y is the second element of a pair.
;; (function0 f s1 s2):     f is a function from s1 onto s2.
;; (domain s1 f):           s1 is the domain of function f.
;; (range s2 f):            s2 is the range of function f.
;; (map f x y):             The function f maps x to y; f(x)=y.
;; (ints s n1 n2):          s is the set of positive integers from n1 to
;;                             n2, including n1 and n2.
;; (sequence s):            s is a sequence.
;; (length n s):            n is the length of the sequence s.
;; (nth y i s):             y is the ith element of sequence s.
;; (rest s1 s):             s1 is the rest of the sequence s after the
;;                             first element of s.
;; (last y s):              y is the last element of sequence s.
;; (inSeq y s):             y is an element of the sequence s.
;; (beforeInSeq x y s):     x comes before y in the sequence s.

;; If `pair0`, it's an ordered pair, which has two elements.

;; 5.1
(forall (p)
  (iff (pair0 p)
       (exists (x y) (pair p x y))))
;; 5.2
(forall (p x y)
  (if (pair p x y)
      (and (first x p) (second y p))))

;; 5.3 Pairs are equal when their first elements are equal and their second
;; elements are equal.

(forall (p1 x1 y1 p2 x2 y2)
  (if (or (pair p1 x1 y1) (pair p2 x2 y2))
      (iff (equal p1 p2)
           (and (pair p1 x1 y1) (pair p2 x2 y2)
                (equal x1 x2) (equal y1 y2)))))

;; 5.4 The first and second elements of a pair are unique.

(forall (p x1 x2 y1 y2)
  (if (and (pair p x1 y1) (pair p x2 y2))
      (and (equal x1 x2) (equal y1 y2))))

;; 5.5 A function `f` from a set `s1` onto a set `s2` is a set of pairs where
;; each element of `s1` occurs exactly once as the first element in a pair,
;; and every element of `s2` occurs as a second element of at least one pair.
;; (This is `function0` since it is later extended to functions from scales
;; to scales.)

(forall (f s1 s2)
  (iff (function0 f s1 s2)
       (and (set s1) (set s2) (set f)
            ;; A function is a set of pairs where the first elements
            ;; come from s1 and the second elements come from s2.
            (forall (p)
              (if (member p f)
                  (exists (x y)
                    (and (member x s1) (member y s2)
                         (pair p x y)))))
            ;; There is a value of the function for every element of
            ;; s1.
            (forall (x)
              (if (member x s1)
                  (exists (p)
                    (and (member p f) (first x p)))))
            ;; The value is unique.
            (forall (p1 p2 x)
              (if (and (first x p1) (first x p2)
                       (member p1 f) (member p2 f))
                  (equal p1 p2)))
            ;; Every element of s2 is the value of a member of s1 under
            ;; the function f.
            (forall (y)
              (if (member y s2)
                  (exists (p)
                    (and (member p f) (second y p))))))))

;; `s1` is the domain of the function and `s2` the range.

;; 5.6
(forall (f s1 s2) (if (function0 f s1 s2) (domain s1 f)))

;; 5.7
(forall (f s1 s2) (if (function0 f s1 s2) (range s2 f)))

;; 5.8 If `f` is a function from `s1` to `s2`, we say it maps an element `x`
;; of `s1` to an element `y` of `s2` when the pair `<x, y>` is a member of
;; `f`.

(forall (f x y)
  (iff (map f x y)
       (exists (s1 s2 p)
         (and (function0 f s1 s2) (member p f)
              (first x p) (second y p)))))

;; 5.9 When we have a Skolem function or a functional dependency, we have a
;; corresponding function.

(forall (y1 y x1 x e s1 s2)
  (if (and (skfct y1 y x1 x e) (typelt x s1) (rangeFd s2 y x e))
      (exists (f)
        (and (function0 f s1 s2)
             (forall (p)
               (iff (pair p x1 y1) (member p f)))))))

;; 5.10 The expression `(ints s n1 n2)` says that `s` is the set of all
;; positive integers from `n1` to `n2`, including `n1` and `n2`.

(forall (s n1 n2)
  (iff (ints s n1 n2)
       (and (posInteger n1) (posInteger n2) (set s)
            (forall (n)
              (iff (member n s)
                   (and (posInteger n) (leq n1 n) (leq n n2)))))))

;; 5.11 A sequence of length `n` is a function whose domain is the first
;; `n` positive integers. There are no constraints on `s2`.

(forall (s)
  (iff (sequence s)
       (exists (s1 s2 n)
         (and (function0 s s1 s2) (ints s1 1 n)))))

;; 5.12 The length of a sequence is the number that defines its domain of
;; consecutive integers.

(forall (n s)
  (if (sequence s)
      (iff (length n s)
           (exists (s1 s2)
             (and (function0 s s1 s2) (ints s1 1 n))))))

;; 5.13 The `nth` element in a sequence is the entity in the range of the
;; function that `n` is mapped into.

(forall (s n y)
  (if (sequence s)
      (iff (nth y n s) (map s n y))))

;; 5.14 The `first` element is the `nth` where `n` is 1. This is the same
;; predicate used for the first element of a pair, but the axioms are
;; avoid confusion by conditioning on the second element being either
;; a sequence or a pair (which is isomorphic to the set of sequences of
;; length two).

(forall (s y)
  (if (sequence s)
      (iff (first y s) (nth y 1 s))))

;; 5.15 The `rest` of a sequence is what remains after the first element is
;; removed. The expression `(rest s1 s)` says that `s1` is the rest of
;; `s` after the first is removed.

(forall (s1 s)
  (iff (rest s1 s)
       (and (sequence s) (sequence s1)
            (forall (i x)
              (iff (map s1 i x)
                   (exists (j)
                     (and (posInteger i) (successor j i)
                          (map s j x))))))))

;; 5.16 The last element of a sequence is the `nth` element where `n` is the
;; length of the sequence.

(forall (s y n)
  (if (and (sequence s) (length n s))
      (iff (last y s) (nth y n s))))

;; 5.17 An entity is in a sequence if it is the `nth` element of the sequence
;; for some `n`.

(forall (x s)
  (iff (inSeq x s)
       (exists (n) (nth x n s))))

;; 5.18 If one element's `n` is less than another's, it is before the other
;; in the sequence.

(forall (x y s)
  (iff (beforeInSeq x y s)
       (exists (n1 n2)
         (and (sequence s) (nth x n1 s) (nth y n2 s)
              (lt n1 n2)))))

;; 5.19

(forall (x1 x2 s)
  (iff (successiveElts x1 x2 s)
       (exists (n1 n2)
         (and (successor n2 n1) (nth x1 n1 s) (nth x2 n2 s)))))
