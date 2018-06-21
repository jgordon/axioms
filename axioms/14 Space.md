# 14 Space

## Topology

- `(point x)`: x is a point, a 0-dimensional entity.
- `(curve c)`: c is a curve, a 1-dimensional entity.
- `(region r)`: r is a region, a 2-dimensional entity.
- `(volume v)`: v is a volume, a 3-dimensional entity.

Each of these can be embedded in a space of the same or higher dimension.

They are all figures:

```
(forall (x) (if (point x) (figure x)))

(forall (c) (if (curve c) (figure c)))

(forall (r) (if (region r) (figure r)))

(forall (v) (if (volume v) (figure v)))
```


- `(endpoint x c)`: Point x is an endpoint of curve c.

A (2-dimensional) curve can have (0-dimensional) endpoints.

```
(forall (x c)
  (if (endpoint x c)
      (and (point x) (curve c))))
```


- `(border c r)`: Curve c is the border of region r.

A (2-dimensional) region can have a border, which is a (1-dimensional) curve.

```
(forall (c r)
  (if (border c r)
      (and (curve c) (region r))))
```

Some regions, such as the surface of a sphere, do not have borders.


- `(surface r v)`: Region r is the surface of volume v.

A (3-dimensional) volume can have a surface, which is a (2-dimensional)
region.

```
(forall (r v)
  (if (surface r v)
      (and (region r) (volume v))))
```

An infinite universe would be a volume without a surface.


A figure can be inside a figure of the same or higher dimension. We will
assume we know what it means for a point to be inside another figure, and
define "inside" for higher dimensions in terms of this.

- `(inside x c)`: Figure f1 is inside figure f2.

```
(forall (f1 f2)
  (if (and (point f1) (inside f1 f2))
      (or (curve f2) (region f2) (volume f2))))
```


If f1 is inside f2 and f1 is not a point, then there is at least one point
the figures share, and figure f1's points are inside f2.

```
(forall (f1 f2)
  (if (not (point f1))
      (iff (inside f1 f2)
           (and (exists (x) (and (point x) (inside x f1)))
                (forall (x)
                   (if (and (point x) (inside x f1))
                       (inside x f2)))))))
```

The ontology is silent on whether endpoints are inside their curves,
borders inside their regions, or surfaces inside their volumes. It is
generally safest to proceed as if they are not. We introduce the
predicate `subfigure` to cover the case where they are.

A figure can be on the boundary (endpoint/border/surface) of a figure of
higher dimension.

```
(forall (f1 f2)
  (iff (onBoundary f1 f2)
       (or (and (point f1) (curve f2) (endpoint f1 f2))
           (exists (b) (and (region f2) (border b f2) (inside f1 b)))
           (exists (b)
             (and (volume f2) (surface b f2) (inside f1 b))))))
```

If one figure is inside or on the boundary of another, we will call it a
`subfigure`.

```
(forall (f1 f2)
  (iff (subfigure f1 f2)
       (or (inside f1 f2) (onBoundary f1 f2))))
```

RCC8 "tangential proper part", for 2- and 3-dimensional figures:

```
(forall (r1 r2)
  (iff (tpp r1 r2)
       (and (forall (x)
              (if (inside x r1) (inside x r2)))
            (forall (x)
              (if (onBoundary x r1)
                  (or (inside x r2) (onBoundary x r2))))
            (exists (x)
              (and (onBoundary x r1) (onBoundary x r2))))))
```

(Other RCC8 relations are not defined here, though they could be.)


Three important kinds of curves are lines, rays, and line segments.

- `(line c)`: c is a line.
- `(ray c)`: c is a ray.
- `(lineSegment c)`: c is a line segment.


A line does not have endpoints.

```
(forall (c)
  (if (line c)
      (not (exists (x)
             (endpoint x c)))))
```

A ray has exactly one endpoint.

```
(forall (c)
  (if (ray c)
      (exists (x)
        (and (endpoint x c)
             (forall (x1)
               (if (endpoint x1 c) (equal x1 x)))))))
```

A line segment has two distinct endpoints.

```
(forall (c)
  (if (lineSegment c)
      (exists (x1 x2)
        (and (endpoint x1 lc (endpoint x2 c)
             (nequal x1 x2)))))
```

All three are linear.

```
(forall (c)
  (iff (linear c)
       (or (line c) (ray c) (lineSegment c))))
```

All three are curves.

```
(forall (c)
  (if (linear c)
      (curve c)))
```

If a curve is closed, it has no endpoints.

```
(forall (c)
  (if (closed c)
      (not (exists (x)
             (endpoint x c)))))
```

Any linear entity has a line it is a subfigure of.

```
(forall (c)
  (if (linear c)
      (and (exists (c1) (and (line c1) (subfigure c c1)))
           (forall (c1 c2)
             (if (and (line c1) (line c2)
                      (subfigure c c1) (subfigure c c2))
                  (equal c1 c2))))))
```

It is often convenient to characterize a line segment by its endpoints.

```
(forall (c)
  (iff (lineSegmentFromTo c x1 x2)
       (and (lineSegment c)
            (endpoint x1 c) (endpoint x2 c)
            (nequal x1 x2))))
```

A plane is a region such that if a line passes through any two points in the
region, it is inside the region.

```
(forall (r)
  (iff (plane r)
       (forall (c x1 x2)
         (if (and (line c) (inside x1 c) (inside x2 c)
                  (inside x1 r) (inside x2 r))
             (inside c r)))))
```

A figure is planar if it is inside a plane.

```
(forall (r)
  (iff (planar r)
       (exists (r1) (and (plane r1) (inside r r1)))))
```

A planar figure is convex if every point on a line segment between any
two points on the boundary is inside the region.

```
(forall (r)
  (if (and (region r) (planar r))
      (iff (convex r)
           (forall (c x x1 x2)
             (if (and (onBoundary x1 r) (onBoundary x2 r)
                      (lineSegmentFromTo c x1 x2) (inside x c))
                 (subfigure x r))))))`
```

A planar region is concave if it is not convex.

```
(forall (r)
  (if (and (region r) (planar r))
      (iff (concave r) (not (convex r)))))
```

Thus something that is convex and planar is a plane.

Two figures are coplanar if there is a plane that they are both
inside.

```
(forall (f1 f2)
  (iff (coplanar f1 f2)
       (exists (p)
         (and (plane p) (inside f1 p) (inside f2 p)))))
```

Two lines are parallel if they are coplanar and they have no points
in common.

```
(forall (c1 c2)
  (if (and (line c1) (line c2))
      (iff (parallel c1 c2)
           (and (coplanar c1 c2)
                (not (exists (f)
                       (and (inside f c1) (inside f c2))))))))
```

Two figures are parallel if they are inside two parallel lines.

```
(forall (f1 f2)
  (iff (parallel f1 f2)
       (exists (c1 c2)
         (and (line c1) (line c2) (inside f1 c1) (inside f2 c2)))))
```


## Polygons

We first describe what it is to join two curves and then specialize
that to vertices. We define what it is to be the side of a polygon
and then we will define a polygon itself. Quadrilaterals are a
specialization of polygons.

The first step toward defining polygons is to define the figure formed by
joining two curves at an endpoint of each. We can call these figures
"joined curves". We join two curves with endpoints by stipulating that
one endpoint of one coincides with one endpoint of the other. This only
covers the case where the two curves are joined at a single point; more
complicated combinations would require further definitions.

```
(forall (c c1 c2 x)
  (iff (joinedCurves c c1 c2 x)
       (and (curve c1) (curve c2) (nequal c1 c2)
            (endpoint x c1) (endpoint x c2)
            (forall (y)
              (iff (inside y c)
                   (or (inside y c1) (inside y c2)
                       (equal y x))))
            (forall (z)
              (iff (endpoint z c)
                   (and (nequal z x)
                        (or (endpoint z c1) (endpoint z c2))))))))
```

Here, c is the curve formed by attaching curve c1 to curve c2
at their shared endpoint x. Lines 5-8 say the points inside
c are just the points inside c1 or c2, plus x. Lines 9-12 say that
the endpoints of c are the other endpoints of c1 and c2.

The figure formed by joining curves is a curve.

```
(forall (c c1 c2 x)
   (if (joinedCurves c c1 c2 x)
       (curve c)))
```

Note that we can join two rays, but we cannot join two lines since
lines, being infinite, have no endpoints.

When the joined constituent curves are linear and do not constitute a
straight line, the point at which they meet is called a `vertex`.

```
(forall (v c1 c2 x)
  (iff (vertex v c1 c2 x)
       (and (linear c1) (linear c2) (not (linear v))
            (joinedCurves v c1 c2 x))))
```

A vertex thus consists of the angle and two sides, which are line
segments or rays.

Note that with this definition vertices are symmetric with respect to
their sides c1 and c2.

```
(forall (v c1 c2 x)
  (iff (vertex v c1 c2 x)
       (vertex v c2 c1 x)))
```

As an intermediate step toward defining polygons, we will say a line
segment is a side of a figure if there are vertices at its two
endpoints that lie inside the figure.

```
(forall (c p)
  (iff (sideOf c p)
       (exists (c1 c2 v1 v2 x1 x2)
         (and (vertex v1 c1 c x1) (vertex v2 c c2 x2)
              (nequal x1 x2)
              (subfigure v1 p) (subfigure v2 p)))))
```

A polygon is then a closed curve that is made up of n sides.

```
(forall (p n)
  (iff (polygon p n)
       (exists (s)
         (and (forall (c)
                (iff (member c s) (sideOf c p)))
              (forall (x)
                (if (inside x p)
                    (exists (c)
                      (and (member c s)
                        (or (inside x c) (endpoint x l))))))
              (closed p) (planar p)
              (card n s)))))
```

Lines 4-5 say that the set s is the set of sides of the polygon.
Lines 6-10 say that every point in the polygon is either in a side or
is a vertex. Line 11 says the polygon is a closed planar curve, and
line 12 says n is the cardinality of the set of sides.

We have defined polygons as one-dimensional curves. The term is also
used to describe the two-dimensional region they enclose. We will use
the predicate `polygon2` for this concept.

```
(forall (r)
  (iff (polygon2 r)
       (exists (c) (and (border c r) (polygon c)))))
```

If n is 4, we have a quadrilateral.

```
(forall (p)
  (iff (quadrilateral p) (polygon p 4)))
```


## Frameworks and Coordinate Systems


At https://www.isi.edu/~hobbs/bgt-composite-entities.text, we define a
composite entity as a collection of entities called components and a
set of relations among the components and the whole. When the components
are sufficiently similar as to admit of a single interpretation for the
figure-ground, or "at" relation, the composite entity can serve as a
ground in the figure-ground relation.

At https://www.isi.edu/~hobbs/bgt-scales.text
we define a scale as a composite entity among whose relations are a partial
ordering among components. A complex or composite scale can be constructed
out of two or more other scales, where its partial ordering is consistent
with the partial orderings of the constituent scales. Two predicates
introduced there that we use in developing the notion of coordinate
systems are as follows:

- `(compositeScale s s1 s2)`: Scale s is a composite scale whose
  constituent scales are s1 and s2.
- `(lts x y s)`: x is less than y on scale s.
- `(leqs x y s)`: x is less than or equal to y on scale s.

Among the constraints on the arguments of "lts" and "leqs" is the constraint
that x and y are components of s.

By defining frameworks only in terms of scales, or partial orderings, rather
than assuming numeric scales, we characterize the concepts in a more general
way. We can, for example, talk about one person being "above" another in
an org chart.

We first need the notion of "independent" scales. Two scales are independent
if their components overlap and if you can't predict the relation between two
elements on one scale from their relation on the other. That is, for some
pairs of elements the order is preserved when we go from one scale to the
other, and for other pairs the order is reversed.

```
(forall (s1 s2)
  (iff (independentScales s1 s2)
       (exists (x1 x2 y1 y2)
         (and (lts x1 x2 s1) (lts x1 x2 s2)
              (lts y1 y2 s1) (lts y2 y1 s2)))))
```

In line 4 x1 and x2 are a pair where the order is preserved, and in line 5
y1 and y2 constitute a pair where it isn't.

In the interests of remaining maximally abstract or noncommital for as
long as possible, so that our definitions apply as broadly as possible,
we define a "framework" assuming no more about the constituent scales
than that they are partial orderings. They need not be numerical, or
even linear. We then define a coordinate system as a framework whose
constituent scales are numeric.

For the remainder of this development we will refer to the two partial
orderings as "rightOf" and "above". But first we have to discuss an
ambiguity. The relation "above" has two interpretations. In the
two-dimensional case, it means farther away from the observer. We'll
call this relation "above2". In the three-dimensional case, it means
farther away from the Earth. We'll call this "above3". There is a similar
ambiguity in the terms "horizontal" and "vertical". In the
two-dimensional case, the y-axis is vertical. In the three-dimensional
case, it is horizontal.

We define two- and three-dimensional frameworks, but not more.

We assume we have two relations, `above2` and `rightOf`. They are
relative to a framework f. `(above2 y2 y1 f)` says that y2 is above y1
(in the two-dimensional sense) in framework f. We can't yet say that
our two axes are orthogonal, because we have not yet dealt with
angles. But we can say they are independent in the sense that we
cannot predict one relation from the other.

A framework has a set of entities we will call its domain. The
entities can participate in the `above2` and `rightOf` relations, but
we postpone axiomatizing that til the end of this section.

```
(forall (f)
  (if (framework f)
      (exists (s)
        (and (set s) (domain s f)))))
```

A non-null subset of the domain is horizontal if no element is `above2`
any other element. We use the predicate `horizontal2` because as stated
above, the two- and three-dimensional cases differ. The next two axioms
refer to the `above3` relation. In the two-dimensional case, this is
vacuous since nothing is `above3` anything else. But it will greatly
simplify our treatment of three-dimensional frameworks to include it here.

```
(forall (s1 f)
  (iff (horizontal2 s1 f)
       (exists (s)
         (and (domain s f) (subset s1 s) (not (null s1))
              (not (exists (x1 x2)
                     (and (member x1 s1) (member x2 s1)
                          (or (above2 x1 x2 f)
                              (above3 x1 x2 f)))))))))
```

A similar axiom defines `vertical2` in terms of `rightOf`.

```
(forall (s1 f)
  (iff (vertical2 s1 f)
       (exists (s)
         (and (domain s f) (subset s1 s) (not (null s1))
              (not (exists (x1 x2)
                     (and (member x1 s1) (member x2 s1)
                          (or (rightOf x1 x2 f)
                              (above3 x1 x2 f)))))))))
```

Horizontal and vertical sets are independent scales.

```
(forall (s1 s2 f)
  (if (and (framework f) (horizontal2 s1 f) (vertical2 s2 f))
      (independentScales s1 s2)))
```

Now we can pick a unique horizontal subset of the domain to be the
x-axis and a unique vertical subset to be the y-axis, where their
intersection is a unique element we can call the origin.

```
(forall (a1 f)
  (if (xAxis a1 f)
      (and (framework f) (horizontal2 a1 f))))
```

```
(forall (a2 f)
  (if (yAxis a2 f)
      (and (framework f) (vertical2 a2 f))))
```

```
(forall (f)
  (if (framework f)
      (exists (a1 a2)
        (and (xAxis a1 f) (yAxis a2 f)
             (forall (a)
               (and (if (nequal a a1) (not (xAxis a f)))
                    (if (nequal a a2) (not (yAxis a f)))))))))
```

```
(forall (f a1 a2 s)
  (if (and (framework f) (xAxis a1 f) (yAxis a2 f))
      (exists (s o)
        (and (intersection s a1 a2) (singleton s o)
             (origin o f)))))
```

A two-dimensional framework thus consists of a domain, two independent
relations and two unique corresponding axes that intersect in a single
element called the origin.

Any element in the domain can have an x-coordinate and a y-coordinate. An
element of the domain has an x-coordinate if there is a vertical subset
that contains both the element and an element of the x-axis.

```
(forall (x1 x f)
  (iff (xCoordinate x1 x f)
       (exists (v a1)
         (and (vertical2 v f) (member x v) (xAxis a1 f)
              (member x1 v) (member x1 a1)))))
```

A y-coordinate can be defined similarly.

```
(forall (y1 x f)
  (iff (yCoordinate y1 x f)
       (exists (h a2)
         (and (horizontal2 h f) (member x h) (yAxis a2 f)
              (member y1 h) (member y1 a2)))))
```

We should point out that frameworks are often observer-based and
hence volatile. Moving around a table changes what counts as
`above` and `rightOf`.

To construct a three-dimensional framework, we introduce another
relation `above3`, which is independent from `above2` and `rightOf`.

We define a subset of the domain to be `vertical3` if no element of it
is above2 or rightOf any other.

```
   (forall (s1 f)
      (iff (vertical3 s1 f)
           (exists (s)
              (and (domain s f) (subset s1 s) (not (null s1))
                   (not (exists (x1 x2)
                           (and (member x1 s1) (member x2 s1)
                                (or (rightOf x1 x2 f)
                                    (above2 x1 x2 f)))))))))
```

A subset of the domain is horizontal3 if it is either `horizontal2`
or `vertical2`.

```
   (forall (s f)
      (iff (horizontal3 s f)
           (or (horizontal2 s f) (vertical2 s f))))
```

Horizontal3 and vertical3 sets are independent scales.

```
   (forall (s1 s2 f)
      (if (and (framework f) (horizontal3 s1 f) (vertical3 s2 f))
          (independentScales s1 s2)))
```

We can stipulate a vertical3 set to be the z-axis of a framework.

```
    (forall (a3 f)
      (if (zAxis a3 f)
          (and (framework f) (vertical3 a3 f))))
```

The z-axis, if it exists, is unique.

```
   (forall (f a3)
      (if (and (framework f) (zAxis a3 f))
          (forall (a)
             (if (nequal a a3) (not (zAxis a f))))))
```

The z-axis contains the origin.

```
   (forall (f a1 a2 s)
      (if (and (framework f) (zAxis a3 f) (origin o f))
          (member o a3)))
```

We can define the z-coordinate of an element in a framework just
as we defined x- and y-coordinates.

```
   (forall (z1 x f)
      (iff (zCoordinate z1 x f)
           (exists (v a1)
              (and (vertical3 v f) (member x v) (zAxis a3 f)
                   (member z1 v) (member z1 a3)))))
```

Every framework has an x-axis and a y-axis. It is two-dimensional
if and only if it lacks a z-axis. We condition this on f being a
framework to preserve the predicate 2D for other uses as well.

```
   (forall (f)
      (if (framework f)
         (iff (2D f)
              (not (exists (a3) (zAxis a3 f))))))
```

If a framework is three-dimensional, it has a z-axis.

```
   (forall (f)
      (if (and (framework f) (3D f))
          (exists (a3) (zAxis a3 f))))
```

We steer clear of dealing with higher dimensions.

Finally, we can define a coordinate system as a framework in which all
the axes are numeric and the partial ordering is "greater than".

```
   (forall (f)
      (iff (coordinateSystem f)
           (and (framework f)
                (forall (a1) (if (xAxis a1 f) (numeric a1)))
                (forall (a2) (if (yAxis a2 f) (numeric a2)))
                (forall (a3) (if (zAxis a3 f) (numeric a3)))
                (forall (o) (if (origin o f) (equal o 0)))
                (forall (x1 x2) (iff (rightOf x1 x2 f) (gt x1 x2)))
                (forall (y1 y2) (iff (above2 y1 y2 f) (gt y1 y2)))
                (forall (z1 z2) (iff (above3 z1 z2 f) (gt z1 z2))))))
```


## Distance

We take distance to be a predicate with four arguments -- a nonnegative
number, two points, and a unit.

```
(forall (d x1 x2 u)
  (if (distance d x1 x2 u)
      (and (nonNegativeNumber d) (point x1) (point x2)
           (spatialUnit u))))
```

The expression `(distance d x1 x2 u)` says that the distance between
points x1 and x2 is d units u.

The predicate `distance` has the usual mathematical properties. The
distance between an entity and itself is zero.

```
(forall (x u) (distance 0 x x u))
```

The distance between two entities is symmetric.

```
(forall (d x1 x2 u)
  (iff (distance d x1 x2 u) (distance d x2 x1 u)))
```

The triangle inequality holds.

```
(forall (d1 d2 d3 d4 x1 x2 x3 u)
  (if (and (distance d1 x1 x2 u) (distance d2 x2 x3 u)
           (distance d3 x1 x3 u) (sum d4 d1 d2))
      (leq d3 d4)))
```

A straight line is the shortest distance between two points. We state
this in terms of the endpoints and an inside point of a line segment.

```
(forall (c x1 x2 x3 d1 d2 d3 u)
  (if (and (lineSegmentFromTo c x1 x3)
           (inside x2 c) (distance d1 x1 x2 u)
           (distance d2 x2 x3 u) (distance d3 x1 x3 u))
       (sum d3 d1 d2)))
```

The length of a line segment is the distance between its endpoints.

```
(forall (d c u)
  (iff (lineSegment c)
       (iff (length d c u)
            (exists (x1 x2)
              (and (lineSegmentFromTo c x1 x2)
                   (distance d x1 x2 u))))))
```

A rhombus is a quadrilateral whose sides are all equal.

```
(forall (p)
  (iff (rhombus p)
       (and (quadrilateral p)
            (exists (d u)
              (forall (c)
                (if (sideOf c p) (length d c u)))))))
```

A circle c around a center x is a figure in which every line segment
from the center to a point inside the circle is constant.

```
   (forall (c r x u)
      (iff (circle c x)
           (exists (r d)
              (and (border c r) (planar r) (inside x r)
                   (forall (c1 x1)
                      (if (and (inside x1 c) (lineSegmentFromTo c1 x x1))
                          (length d c1 u)))))))
```

We are now in a position to give one characterization of a closed curve.
It has no endpoints and can be covered by a large enough circle.

```
   (forall (c)
      (if (curve c)
          (iff (closed c)
               (and (not (exists (x) (endpoint x c)))
                    (exists (r c1 x1)
                       (and (circle c1 x1) (boundary c r)
                            (inside c r)))))))
```

We can define qualitative terms like "near" and "far" as outlined in
Gordon and Hobbs, Chapter 12, and exemplified numerous times in the rest
of the book. We first define the partial ordering "nearer".

```
   (forall (x y z)
      (iff (nearer x y z)
           (exists (d1 d2)
              (and (distance d1 x z u) (distance d2 y z u)
                   (lt d1 d2)))))
```

The expression `(nearer x y z)` says that x is nearer than y is to z.

Then "nearness" scale is a scale whose partial ordering is `nearer`.

```
   (forall (s z)
      (iff (nearnessScale s z)
           (exists (s0 e x y u)
              (and (nearer' e x y z u) (scaleDefinedBy s s0 e)))))
```

The expression `(nearnessScale s z)` says that s is the scale for
nearness to z. In Line 4, e is the partial ordering, and s0 is an
arbitrary set, the domain of the scale.

Then `near` and `far` are defined as the Lo and Hi regions of the
nearness scale, respectively.

```
   (forall (x z)
      (iff (near x z)
           (exists (s s1)
              (and (nearnessScale s z) (Lo s1 s) (onScale x s1)))))
```

```
   (forall (x z)
      (iff (far x z)
           (exists (s s2)
              (and (nearnessScale s z) (Hi s2 s) (onScale x s2)))))
```

As described in Chapter 12 of Gordon and Hobbs (2017), there are
two principal classes of inference that can be drawn about something
in the Hi region of a scale -- the distributional and the functional.

A rather crude example of a distributional inference is that an entity
in the Hi region is defeasibly higher on the scale than the median
of a comparison set. That is, there are more things smaller than larger.

```
   (forall (x s0 s1)
      (if (and (onScale x s1) (Hi s1 s0) (etc))
          (exists (s2 s3 s4 n3 n4)
             (and (componentsOf s2 s0) (union s2 s3 s4)
                  (forall (y) (iff (member y s3) (lts y x s0)))
                  (forall (z) (iff (member z s4) (lts x z s0)))
                  (card n3 s3) (card n4 s4) (lt n4 n3)))))
```

In this axiom x is the entity in the Hi region, s0 is the scale,
s1 is its Hi region, s2 is the domain of scale s0, s3 is the set of
elements of s2 lower on the scale than x, s4 is the set of elements
of s2 higher on the scale than x, and the cardinality n3 of s3 is
larger than the cardinality n4 of s4. The conjunct `(etc)` in line 2
is an indication of defeasibility.

There would be a similar axiom for `Lo`.

The principal functional inference is given in Axiom 12.38 of Gordon
and Hobbs (2017). If something is in the high region of a scale, then
defeasibly that property is causally involved in the achievement or
nonachievement of some agent's goal. The fact that it is in the Hi
region does not tell us what that goal is, but frequently the relevant
goal is explicit or implicit in the surrounding text, and this axiom
gives us a way to link the goal and the scalar judgment. In the
case of `near` and `far`, most actions have locational enabling
conditions and that's what the adjective is telling us about. To
pound a nail, you must have a hammer near at hand.


## Angles

We can already get a rudimentary notion of direction without a notion
of "distance". Consider a research program that can focus on a variety
of theoretical and practical issues. We can take our x-axis to be the
lattice of subset relations between sets of theoretical issues, and
similarly the y-axis for practical issues. The mix between theoretical
issues and practical issues defines the direction of the program, and
adding some practical issues and eliminating some theoretical issues
changes the direction of the program. But we cannot say whether two
such changes are equal or one is bigger than the other. A more powerful
concept of "direction" requires a notion of distance.

We would like to be able to talk about an angle at a vertex being
greater than, equal to, or less than the angle at some other vertex,
and about specific kinds of angles, such as acute, right, and obtuse,
and 45-degree angles. We develop these ideas in two steps. First we
define what it is for two angles to be equal regardless of where they
are located. We do this in terms of isosceles triangles. Then we
anchor the vertex at the origin of a framework, with a designated side
along the x-axis, and define the various concepts in terms of x- and
y- coordinates. In all this we assume we have a distance metric, but
the axes of the framework are not necessarily numeric until we reach
some of the concepts at the end.

We are formalizing an everyday notion of "angle", where all angles are
greater than 0 degrees and less than 180 degrees, and an angle is equal
to the angle we get by flipping it over.

We construct an isosceles triangle whose apex is a given vertex, by
identifying a point a unit distance out on each leg from the vertex.

```
   (forall (c v u)
      (iff (baseOfAngle c v u)
           (exists (c1 c2 x0 x1 x2)
              (and (vertex v c1 c2 x0) (nequal x1 x2)
                   (endpoint x1 c1) (distance 1 x0 x1 u)
                   (endpoint x2 c2) (distance 1 x0 x2 u)
                   (lineSegmentFromTo c x1 x2)))))
```

We have constructed an isosceles triangle whose apex at x0 is the vertex
of interest, whose two equal sides are c1 and c2, whose base is c, and
whose base angles are at x1 and x2.

Now we can say that two vertices are equal whenever the bases of their
angles are of equal length. (Most quantities we measure in everyday life
we measure by translating them into distance, and size of angles is no
exception.)

```
(forall (v1 v2)
  (iff (equalAngle v1 v2)
       (exists (c1 c2 d u)
         (and (baseOfAngle c1 v1 u) (baseOfAngle c2 v2 u)
              (length d c1 u) (length d c2 u)))))
```

This is an equivalence relation. It is easy to show that it is
reflexive, symmetric, and transitive.

```
(forall (v) (equalAngle v v))
```

```
(forall (v1 v2)
  (iff (equalAngle v1 v2) (equalAngle v2 v1)))
```

```
(forall (v1 v2 v3)
  (if (and (equalAngle v1 v2) (equalAngle v2 v3))
      (equalAngle v1 v3)))
```

A "greater than" relation can be defined in a similar manner.

```
   (forall (v1 v2)
      (iff (gtAngle v1 v2)
           (exists (c1 c2 d1 d2 u)
              (and (baseOfAngle c1 v1 u) (baseOfAngle c2 v2 u)
                   (length d1 c1 u) (length d2 c2 u) (gt d1 d2)))))
```

It is easy to show this relation is anti-reflexive, anti-symmetric,
and transitive.

```
   (forall (v) (not (gtAngle v v)))
```

```
   (forall (v1 v2)
      (iff (gtAngle v1 v2) (not (gtAngle v2 v1))))
```

```
   (forall (v1 v2 v3)
      (if (and (gtAngle v1 v2) (gtAngle v2 v3))
          (gtAngle v1 v3)))
```

To be able to talk about the size of an angle in more detail,
we posit a framework (not necessarily a coordinate system) whose
x-axis contains one of the sides of the angle and whose origin
coincides with the vertex. Then the size of the angle can be
correlated with the y-coordinate. We call this framework an "anchor
framework" for the vertex.

```
   (forall (f v c1 c2 o)
      (iff (anchorFramework f v c1 c2 o)
           (and (framework f) (vertex v c1 c2 o)
                (forall (a1) (if (xAxis a1 f) (subfigure c1 a1)))
                (origin o f))))
```

We pick an arbitrary point on the side c2 of the vertex -- let's again
pick a point that is one distance unit out from the origin. This will be
our "anchor point".

```
(forall (x v f c1 c2 o u)
  (iff (anchorPoint x v f c1 c2 o u)
       (and (anchorFramework f v c1 c2 o)
            (inside x c2) (distance 1 o x u))))
```

The expression `(anchorPoint x f v c1 c2 o u)` says that x is an anchor
point in framework f whose origin is o, v is a vertex at o whose side c1
lies along f's x-axis, and x is a point in v's other side c2 one
distance unit u from the origin.

It's possible that c2 is a line segment shorter than one unit, implying
there is no anchor point. In that case pick a longer c2 or a smaller u.

Properties and relations among angles are defined by finding an equal angle
in an anchor framework and referring to the x- and y- coordinates of the
anchor point.

An angle is a right angle if the anchor point of an equal angle lies on the
y-axis.

```
   (forall (v)
      (iff (rightAngle v)
           (exists (v0 f c1 c2 o u)
              (and (equalAngle v v0) (anchorPoint x v0 f c1 c2 o u)
                   (xCoordinate o x f)))))
```

The anchor point lies on the y-axis since its x-coordinate is the
origin o of f. This definition admits both 90-degree and 270-degree
directed angles. This will be the most useful concept.

An angle is acute if the x- and y-coordinates of the anchor point of an
equal anchored angle are both greater than the origin.

```
   (forall (v)
      (iff (acuteAngle v)
           (exists (v0 x f c1 c2 o u)
              (and (equalAngle v v0) (anchorPoint x v0 f c1 c2 o u)
                   (xCoordinate x1 x f) (yCoordinate y1 x f)
                   (xAxis a1 f) (yAxis a2 f)
                   (gts x1 o a1) (gts y1 o a2)))))
```

An angle is obtuse if the y-coordinate of the anchor point of an equal
anchored angle is greater than the origin and the x-coordinate is less
than the origin.

```
   (forall (v)
      (iff (obtuseAngle v)
           (exists (v0 x f c1 c2 o u)
              (and (equalAngle v v0) (anchorPoint x v0 f c1 c2 o u)
                   (xCoordinate x1 x f) (yCoordinate y1 x f)
                   (xAxis a1 f) (yAxis a2 f)
                   (gts o x1 a1) (gts y1 o a2)))))
```

In daily life and absent precise measuring instruments, we don't judge
the size of angles down to the degree. But we do make rough judgments
in two ways that are more fine-grained than the four cardinal
directions, and these can be characterized here. The first augments
the north-east-south-west system with the four intermediate directions
northeast, southeast, southwest and northwest. This system is based
on angles of 45 degrees. A 45-degree angle is one whose anchor point's
x- and y-coordinates are equal.

```
   (forall (v)
      (iff (45Degrees v)
           (exists (v0 x f c1 c2 o u d)
              (and (equalAngle v v0) (anchorPoint x v f c1 c2 o u)
                   (xCoordinate x1 x f) (yCoordinate y1 x f)
                   (distance d o x1 u) (distance d o y1 u)))))
```

The second fine-grained system is based on angles of 30 degrees and is
visualized as a clock -- "incoming at 2 o'clock," "exit the traffic
circle at 11 o'clock." A 30-degree angle is one in which the distance
from the origin to the anchor point is twice the y-coordinate.

```
   (forall (v)
      (iff (30Degrees v)
           (exists (v0 x f c1 c2 o u d1 d2)
              (and (equalAngle v v0) (anchorPoint x v f c1 c2 o u)
                   (xCoordinate x1 x f) (yCoordinate y1 x f)
                   (distance d1 o y1 u) (distance d2 o x u)
                   (product d2 d1 2)))))
```

From here we could back into measurements of angles in terms of
degrees via sine and cosine, but we won't, because we are trying to
capture an ontology of space that underlies how we talk about it in
everyday life, not how it is formalized in science.

Now we can define a rectangle as a quadrilateral whose vertices are
all right angles.

```
(forall (p)
  (iff (rectangle p)
       (and (quadrilateral p)
            (forall (v) (iff (vertexOf v p) (rightAngle v))))))
```

A square is a rhombus that is a rectangle.

```
(forall (p)
  (iff (square p)
       (and (rhombus p) (rectangle p))))
```

The diagonal of a square is a line segment from one vertex to an opposite
vertex.

```
   (forall (p d)
      (if (square p)
          (iff (diagonal d p)
               (exists (v1 v2 x1 x2 c1 c2 c3 c4)
                  (and (vertex v1 c1 c2 x1) (vertexOf v1 p)
                       (vertex v2 c3 c4 x2) (vertexOf v2 p)
                       (nequal c1 c3) (nequal c1 c4)
                       (lineSegmentFromTo d x1 x2))))))
```

It can be shown that a diagonal of a square makes a 45-degree angle
with any side of the square.

```
   (forall (p d c v x)
      (if (and (square p) (sideOf c p) (diagonal d p) (vertex v c d x))
          (45Degrees v)))
```

A direction with respect to a framework is a ray whose endpoint is the
origin of the framework.

```
   (forall (d f)
      (iff (direction d f)
           (exists (o)
              (and (ray d) (endpoint o d) (origin o f)))))
```

The direction of a linear object with respect to a framework is a ray that
is parallel to the object.

```
   (forall (d c f)
      (iff (directionOf d c f)
           (and (direction d f) (parallel c f))))
```

Note that a line segment will have two directions, 180 degrees apart.


## Polyhedrons

A polyhedron is a volume whose surface consists of polygons, which are
called faces.

```
   (forall (p s)
      (iff (polyhedron p s)
           (exists ( r)
              (and (surface r p) (closed r)
                   (forall (f)
                      (if (member f s) (and (polygon2 f) (inside f r))))
                   (forall (x)
                      (if (and (point x) (inside x r))
                          (exists (f)
                             (and (member f s) (subfigure x f)))))
                   (forall (x)
                      (if (and (point x) (member f1 s) (member f2 s)
                               (inside x f1) (inside x f2))
                          (equal f1 f2)))))))
```

The expression `(polyhedron p s)` says that p is a polyhedron with
set s of faces. Lines 5-6 says that the members of s are polygons
contained within the surface of the polyhedron. Lines 7-10 say that
the faces account for the entire surface. Lines 11-14 say that the
polygons overlap only at their boundaries.

A face of a polyhedron is one of the faces.

```
   (forall (p s f)
      (if (polyhedron p s)
          (iff (face f p) (member f s))))
```

An edge of a polyhedron is a side of one of the faces.

```
   (forall (c p s)
      (if (polyhedron p s)
          (iff (edge c p)
               (exists (f) (and (face f p) (sideOf c f))))))
```

A vertex of a polyhedron is an endpoint of one of the edges. We
will call this relation `vertex3` (vertex of a 3-dimensional entity)
since we already have a predicate `vertex`.

```
   (forall (x p s)
      (if (polyhedron p s)
          (iff (vertex3 x p)
               (exists (c) (and (edge c p) (endpoint x c)))))
```

We have taken a polyhedron to be a 3-dimensional volume. We can
also refer to its 2-dimensional surface as a polyhedron; we will
call this predicate `polyhedron2`.

```
   (forall (p2 s)
      (iff (polyhedron2 p2 s)
           (exists (p) (and (polyhedron p s) (surface p2 p)))))
```

A rectangular parallelepiped is a polyhedron all of whose faces are rectangles.

```
   (forall (p s)
      (iff (rectangularParallelepiped p s)
           (and (polyhedron p s)
                (forall (f)
                   (if (member f s) (rectangle f))))))
```

A cube is a polyhedron all of whose faces are squares.

```
   (forall (p s)
      (iff (cube p s)
           (and (polyhedron p s)
                (forall (f)
                   (if (member f s) (square f))))))
```

A sphere p around a center x is a volume in which every line segment
from the center to a point inside the surface is constant.

```
   (forall (c r x u)
      (iff (sphere p x)
           (exists (r d)
              (and (boundary r p) (inside x p)
                   (forall (c1 x1)
                      (if (and (inside x1 r) (lineSegmentFromTo c1 x x1))
                          (length d c1 u)))))))
```

A volume is convex if every point on a line segment between any
two points on its surface is inside the volume.

```
   (forall (p)
      (if (volume p)
          (iff (convex p)
               (forall (c x x1 x2)
                  (if (and (onBorder x1 p) (onBorder x2 p)
                           (lineSegmentFromTo c x1 x2) (inside x c)
                      (subfigure x p))))))
```

A volume is concave if it is not convex.

```
   (forall (p)
      (if (volume p)
          (iff (concave p) (not (convex p)))))
```
