;; 9 Arithmetic

;; Predicates:
;;
;; (nonNegInteger n):       n is a nonnegative integer.
;; (successor n1 n):        n1 is the successor of n; n1 = n+1.
;; (posInteger n):          n is a positive integer.
;; (sum n1 n2 n3):          n1 is the sum of n2 and n3; n1 = n2+n3.
;; (product n1 n2 n3):      n1 is the product of n2 and n3; n1 = n2*n3.
;; (lt n1 n2):              n1 is less than n2; n1 < n2.
;; (leq n1 n2):             n1 is less than or equal to n2.
;; (gt n1 n2):              n1 is greater than n2.
;; (geq n1 n2):             n1 is greater than or equal to n2.
;; (number n):              n is a number.
;; (fraction f a b):        f is the fraction whose numerator is a and
;;                             whose denominator is b; f = a/b.
;; (nonNegNumericScale s):  s is a scale whose elements are nonnegative
;;                             numbers, including 0, and whose partial
;;                             ordering is “lt”.
;; (measure m s):           m is a monotone increasing mapping from a
;;                             scale s into a nonnegative numeric scale,
;;                             mapping the bottom of s into 0.
;; (proportion f x y m):    f is the proportion or ratio of m(x) to m(y),
;;                             where m is a measure on the scale
;;                             containing x and y.
;; (identityFunction f s):  f is the function that maps every element of
;;                             s into itself.
;; (sameHOM x y s1 m):      Two elements x and y of a scale s1 are of the
;;                             same half order of magnitude under measure
;;                             m.

;; 9.1 Zero (a constant) is a non-negative integer.

(nonNegInteger 0)

;; 9.2 Every non-negative integer has a non-negative integer as a successor.

(forall (n)
   (if (nonNegInteger n)
       (exists (n1)
          (and (nonNegInteger n1) (successor n1 n)))))

;; 9.3 The arguments of `successor` are non-negative integers.

(forall (n1 n)
   (if (successor n1 n)
       (and (nonNegInteger n1) (nonNegInteger n))))

;; 9.4 Define the specific numbers we need (1, 2, 10) in terms of `successor`.
;; Defining 10 requires 1-9.

(and (successor 1 0) (successor 2 1) (successor 3 2)
     (successor 4 3) (successor 5 4) (successor 6 5)
     (successor 7 6) (successor 8 7) (successor 9 8)
     (successor 10 9))

;; 9.5 A positive integer is any non-negative integer except 0.

(forall (n)
   (iff (posInteger n)
        (and (nonNegInteger n) (nequal n 0))))

;; 9.6 No non-negative integer has 0 as its successor.

(not (exists (n) (and (nonNegInteger n) (successor 0 n))))

;; 9.7 Successors are unique.

(forall (n n1 n2)
   (if (and (successor n1 n) (successor n2 n))
       (equal n1 n2)))

;; 9.8 The sum of an integer n and 0 is n.

(forall (n)
   (if (nonNegInteger n) (sum n n 0)))

;; 9.9 Recursive definition of `sum`: n1 + S(n2) = S(n1 + n2)

(forall (n n1 n2 n3 n4)
   (if (and (successor n3 n2) (sum n4 n1 n2))
       (iff (sum n n1 n3) (successor n n4))))

;; 9.10 Non-negative integers are closed under addition.

(forall (n1 n2 n3)
   (if (and (nonNegInteger n2) (nonNegInteger n3) (sum n1 n2 n3))
       (nonNegInteger n1)))

;; 9.11 Addition is associative: n1 + (n2 + n3) = (n1 + n2) + n3

(forall (n n1 n2 n3 n4 n5)
   (if (and (sum n4 n2 n3) (sum n5 n1 n2))
       (iff (sum n n1 n4) (sum n n5 n3))))

;; 9.12 Addition is commutative: n1 + n2 = n2 + n1

(forall (n n1 n2)
   (iff (sum n n1 n2) (sum n n2 n1)))

;; 9.13 The product of a number n and 0 is 0.

(forall (n)
   (if (nonNegInteger n) (product 0 n 0)))

;; 9.14 Recursive definition of `product`: n1 * S(n2) = (n1 * n2) + n1

(forall (n n1 n2 n3 n4)
   (if (and (successor n3 n2) (product n4 n1 n2))
       (iff (product n n1 n3) (sum n n4 n1))))

;; 9.15 The non-negative integers are closed under multiplication.

(forall (n1 n2 n3)
   (if (and (nonNegInteger n2) (nonNegInteger n3)
            (product n1 n2 n3))
       (nonNegInteger n1)))

;; 9.16 The identity under multiplication is 1.

(forall (n)
   (if (nonNegInteger n) (product n n 1)))

;; 9.17 Multiplication is associative: n1 * (n2 * n3) = (n1 * n2) * n3

(forall (n n1 n2 n3 n4 n5)
   (if (and (product n4 n2 n3) (product n5 n1 n2))
       (iff (product n n1 n4) (product n n5 n3))))

;; 9.18 Multiplication is commutative: n1 * n2 = n2 * n1

(forall (n n1 n2)
   (iff (product n n1 n2) (product n n2 n1)))

;; 9.19 Multiplication and addition are related by the distributive law:
;; n1 * (n2 + n3) = n1 * n2 + n1 * n3

(forall (n n1 n2 n3 n4 n5 n6)
   (if (and (sum n4 n2 n3) (product n5 n1 n2) (product n6 n1 n3))
       (iff (product n n1 n4) (sum n n5 n6))))

;; A non-negative integer n1 is less than n2 iff there is some positive
;; integer n3 s.t. n2 is the sum of n1 and n3.

;; 9.20
(forall (n1 n2)
   (if (and (nonNegInteger n1) (nonNegInteger n2))
       (iff (lt n1 n2)
            (exists (n3) (and (posInteger n3) (sum n2 n1 n3))))))

;; 9.21
(forall (n1 n2)
  (iff (leq n1 n2)
       (or (lt n1 n2) (equal n1 n2))))

;; 9.22
(forall (n1 n2)
  (iff (gt n1 n2) (lt n2 n1)))

;; 9.23
(forall (n1 n2)
  (iff (geq n1 n2)
       (or (gt n1 n2) (equal n1 n2))))

;; 9.24 A non-negative integer is a number.

(forall (n) (if (nonNegInteger n) (number n)))

;; 9.25 Fractions will be characterized by a non-negative integer (the
;; numerator) and a positive integer (the denominator). The prediction
;; (fraction f a) says that f is the fraction a/b.

(forall (a b)
   (if (and (nonNegInteger a) (posInteger b))
       (exists (f) (fraction f a b))))

;; 9.26 Fraction equality: a1/b1 = a2/b2 when a1*b2 = a2*b1.

(forall (f1 f2 a1 a2 b1 b2 c1 c2)
   (if (and (fraction f1 a1 b1) (fraction f2 a2 b2)
            (product c1 a1 b2) (product c2 a2 b1))
       (iff (equal f1 f2) (equal c1 c2))))

;; 9.27 The non-negative integers are embedded in the set of rational
;; numbers: n = n/1

(forall (n) (if (nonNegInteger n) (fraction n n 1)))

;; 9.28 The `lt` relation can be extended to rational numbers:
;;     a1/b1 < a2/b2 when a1*b2 < a2*b1.
;; This also extends the other ordering relations, `leq`, `gt`, and `geq`.

(forall (f1 f2 a1 a2 b1 b2 c1 c2)
   (if (and (fraction f1 a1 b1) (fraction f2 a2 b2)
            (product c1 a1 b2) (product c2 a2 b1))
       (iff (lt f1 f2) (lt c1 c2))))

;; 9.29 The product of two fractions, f1=a1/b1 and f2=a2/b2 is
;;    (a1*a2)/(b1*b2).

(forall (f f1 f2 a1 a2 b1 b2 c1 c2)
   (if (and (fraction f1 a1 b1) (fraction f2 a2 b2)
            (product c1 a1 a2) (product c2 b1 b2))
       (iff (product f f1 f2) (fraction f c1 c2))))

;; 9.30 A fraction is a number.

(forall (f a b)
  (if (fraction f a b) (number f)))

;; 9.31 The arguments of `fraction` are a number and a non-zero number.

(forall (f a b)
  (if (fraction f a b)
      (and (number a) (number b) (nequal b 0))))

;; 9.32 If e is the `lt` relation between x and y and s1 is a set of numbers
;; containing 0 but no smaller number, then there is a non-negative
;; numeric scale s with s1 as its set and e as its partial ordering.

(forall (s1 e x y)
  (if (and (lt' e x y)
           (forall (n)
             (if (member n s1)
                 (and (geq n 0) (number n))))
           (member 0 s1))
      (exists (s)
        (and (scaleDefinedBy s s1 e) (nonNegNumericScale s)))))

;; 9.33 Conversely, a non-negative numeric scale has the `lt` relation for
;; its ordering and a set of numbers, including 0, as its set.

(forall (s)
  (if (nonNegNumericScale s)
      (exists (s1 e x y)
        (and (lt' e x y)
             (forall (n)
               (if (member n s1)
                   (and (geq n 0) (number n))))
             (member 0 s1)
             (scaleDefinedBy s s1 e)))))

;; 9.34 A measure is a monotone increasing function from a scale into a
;; non-negative numeric scale in which the bottom of the domain scale, if
;; there is one, maps into 0.

(forall (m s1)
  (iff (measure m s1)
       (exists (s2)
         (and (scale s1) (nonNegNumericScale s2)
              (functionInto m s1 s2)
              (monotoneIncreasing m)
              (forall (x) (if (bottom x s1) (map m x 0)))))))

;; 9.35 If s1 is the scale whose set is a set of sets including the null set
;; and whose partial ordering is `subset`, then cardinality is a measure.

(forall (e x y s1 s m n u)
  (if (and (forall (z)
             (if (member z s1) (set z)))
           (exists (w)
             (and (member w s1) (null w)))
           (subset' e x y)
           (scaleDefinedBy s s1 e)
           (card' m n u))
      (measure m s)))

;; 9.36 Suppose we have two points x and y on a scale s1 which has a measure.
;; Then the proportion of x to y is the fraction whose numerator and
;; denominator are the numbers the measure maps x and y into, respectively.

(forall (f x y m s1)
  (if (and (measure m s1) (inScale x s1) (inScale y s1))
      (iff (proportion f x y m)
           (exists (n1 n2)
             (and (map m x n1) (map m y n2)
                  (fraction f n1 n2))))))

;; 9.37 Constraints on the arguments of `proportion`:

(forall (f x y m)
  (if (proportion f x y m)
      (exists (s1)
        (and (measure m s1) (inScale x s1) (inScale y s1)))))

;; 9.38 The identity function is the function that maps every entity into
;; itself.

(forall (f s)
  (iff (identityFunction f s)
       (and (function f s s)
            (forall (x) (if (member x s) (map f x x))))))

;; 9.39 The identity function on a non-negative numeric scale is a measure.

(forall (f s)
  (if (and (nonNegNumericScale s) (identityFunction f s))
      (measure f s)))

;; 9.40 If an entity is mapped into a point by a measure, it is `at` that
;; point.

(forall (m s1 s2 x y)
  (if (and (measure m s1) (function m s1 s2) (disjoint s1 s2)
           (map m x y))
      (at x y s2)))

;; Are two entites the same half order of magnitude? (Is the proportion
;; of the smaller to the larger less than the square root of 10?)

;; 9.41
(forall (x y s1 m)
  (if (and (leqs x y s1) (measure m s1))
      (iff (sameHOM x y s1 m)
           (exists (f f2)
             (and (proportion f y x m) (product f2 f f)
                  (leq f2 10))))))

;; 9.42
(forall (x y s1 m)
  (if (and (gts x y s1) (measure m s1))
      (iff (sameHOM x y s1 m) (sameHOM y x s1 m))))

;; 9.43
(forall (x y s1 m)
  (if (sameHOM x y s1 m)
      (and (inScale x s1) (inScale y s1) (measure m s1))))
