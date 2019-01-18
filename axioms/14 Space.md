# 14 Space

## Topology

- `(point x)`: x is a point, a 0-dimensional entity.
- `(curve c)`: c is a curve, a 1-dimensional entity.
- `(region r)`: r is a region, a 2-dimensional entity.
- `(volume v)`: v is a volume, a 3-dimensional entity.

Each of these can be embedded in a space of the same or higher dimension.


A point is a figure.

```
(forall (x) (if (point x) (figure x)))
```

A curve is a figure.

```
(forall (c) (if (curve c) (figure c)))
```

A region is a figure.

```
(forall (r) (if (region r) (figure r)))
```

A volume is a figure.

```
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
`subfigure`. The `subfigure` relation is reflexive, antisymmetric, and
transitive.

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

A line segment has exactly two distinct endpoints.

```
(forall (c)
   (if (lineSegment c)
       (exists (x1 x2)
          (and (endpoint x1 c) (endpoint x2 c) (nequal x1 x2)
               (forall (x)
                  (if (endpoint x c)
                      (or (equal x x1) (equal x x2))))))))
```

Lines, rays, and line segments are linear.

```
(forall (c)
  (iff (linear c)
       (or (line c) (ray c) (lineSegment c))))
```

Lines, rays, and line segments are curves.

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

We postpone giving a definition of "closed" as a finite curve with no
endpoints until we introduce the notion of "distance".

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

A plane is a region such that if a line passes through any two points in
the region, it is inside the region.

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
                 (subfigure x r))))))
```

A planar region is concave if it is not convex.

```
(forall (r)
  (if (and (region r) (planar r))
      (iff (concave r)
           (not (convex r)))))
```

Two figures are coplanar if there is a plane that they are both inside.

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
         (and (line c1) (line c2) (parallel c1 c2)
              (inside f1 c1) (inside f2 c2)))))
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
straight line, the point at which they meet is called a "vertex". We
use the predicate `vertex` to refer to the figure consisting of
the two line segments and the point where they meet.

```
(forall (v c1 c2 x)
  (iff (vertex v c1 c2 x)
       (and (linear c1) (linear c2) (not (linear v))
            (joinedCurves v c1 c2 x))))
```

A vertex thus consists of the angle and two sides, which are line
segments or rays.

Vertices are symmetric with respect to their sides c1 and c2.

```
(forall (v c1 c2 x)
  (iff (vertex v c1 c2 x)
       (vertex v c2 c1 x)))
```

As an intermediate step toward defining polygons, we say a line
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


A polygon is a closed curve that is made up of n sides. Lines 4-5 say that
the set s is the set of sides of the polygon. Lines 6-10 say that every
point in the polygon is either in a side or is a vertex. Line 11 says the
polygon is a closed planar curve, and line 12 says n is the cardinality of
the set of sides.

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


We have defined polygons as one-dimensional curves. The term is also used
to describe the two-dimensional region they enclose. We use the predicate
`polygon2` for this concept.

```
(forall (r)
  (iff (polygon2 r)
       (exists (c) (and (border c r) (polygon c)))))
```

A polygon with n = 4 is a quadrilateral.

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

At https://www.isi.edu/~hobbs/bgt-scales.text,
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

Among the constraints on the arguments of `lts` and `leqs` is the constraint
that x and y are components of s.

By defining frameworks only in terms of scales, or partial orderings, rather
than assuming numeric scales, we characterize the concepts in a more general
way. We can, for example, talk about one person being "above" another in
an org chart. Standard coordinate systems are then specializations of
frameworks thus characterized.

We first need the notion of "independent" scales.

Two scales are independent if their components overlap and if you can't
predict the relation between two elements on one scale from their relation
on the other. That is, for some pairs of elements the order is preserved
when we go from one scale to the other, and for other pairs the order is
reversed. In line 4, x1 and x2 are a pair where the order is preserved,
and in line 5 y1 and y2 constitute a pair where it isn't.

```
(forall (s1 s2)
  (iff (independentScales s1 s2)
       (exists (x1 x2 y1 y2)
         (and (lts x1 x2 s1) (lts x1 x2 s2)
              (lts y1 y2 s1) (lts y2 y1 s2)))))
```

In the interests of remaining maximally abstract or noncommital for as
long as possible, so that our definitions apply as broadly as possible,
we define a "framework" assuming no more about the constituent scales
than that they are partial orderings. They need not be numerical, or
even linear. We then define a coordinate system as a framework whose
constituent scales are numeric.

For the remainder of this development we will refer to the two partial
orderings as `rightOf` and `above`. But first we have to discuss an
ambiguity. The relation "above" has two interpretations. In the
two-dimensional case, it means farther away from the observer. We'll
call this relation `above2`. In the three-dimensional case, it means
farther away from the Earth. We'll call this "above3". There is a similar
ambiguity in the terms "horizontal" and "vertical". In the
two-dimensional case, the y-axis is vertical. In the three-dimensional
case, it is horizontal.

It is most convenient to define frameworks for the three-dimensional case,
but we will do it in a way that allows the z-axis to be optional, so that
the the definitions cover the two-dimensional case as well.  We define
two- and three-dimensional frameworks, but not more.

We assume we have two relations, `above2` and `rightOf`. They are
relative to a framework f. `(above2 y2 y1 f)` says that y2 is above y1
(in the two-dimensional sense) in framework f. We can't yet say that
our two axes are orthogonal, because we have not yet dealt with
angles. But we can say they are independent in the sense that we
cannot predict one relation from the other.

A framework has a set of entities we will call its domain.

```
(forall (f)
  (if (framework f)
      (exists (s)
        (and (set s) (domain s f)))))
```


Next we define the analogs of horizontal and vertical lines and planes
in frameworks.


A non-null subset of the domain is "horizontal" if no element is `above2`
or `above3` any other element. If there is no `above3` relation, then
`(above3 x1 x2 f)` will always be false, so the definition covers the
two-dimensional case as well.

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


A non-null subset of the domain is `vertical2` if no element is `rightOf`
or `above3` any other element.

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


A non-null subset of the domain is `vertical3` if no element is `rightOf`
or `above2` any other element. In the two-dimensional case, a `vertical3`
set has no ordering relations among its elements.

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



A horizontal plane is a set in which no element is `above3` any other. In
the two-dimensional case any subset of the domain is a horizontal plane.

```
(forall (s1 f)
   (iff (horizontalPlane s1 f)
        (exists (s)
           (and (domain s f) (subset s1 s) (not (null s1))
                (not (exists (x1 x2)
                        (and (member x1 s1) (member x2 s1)
                             (above3 x1 x2 f))))))))
```



A `vertical2` plane is a set in which no element is `rightOf` any other.
In the two-dimensional case, a `vertical2` plane is a `vertical2` set.

```
(forall (s1 f)
   (iff (vertical2Plane s1 f)
        (exists (s)
           (and (domain s f) (subset s1 s) (not (null s1))
                (not (exists (x1 x2)
                        (and (member x1 s1) (member x2 s1)
                             (rightOf x1 x2 f))))))))
```


A `vertical3` plane is a set in which no element is `above2` any other. In
the two-dimensional case, a `vertical3` plane is a horizontal set.

```
(forall (s1 f)
   (iff (vertical3Plane s1 f)
        (exists (s)
           (and (domain s f) (subset s1 s) (not (null s1))
                (not (exists (x1 x2)
                        (and (member x1 s1) (member x2 s1)
                             (above2 x1 x2 f))))))))
```


We can pick a unique horizontal subset of the domain to be the
x-axis.

```
(forall (a1 f)
  (if (xAxis a1 f)
      (and (framework f) (horizontal2 a1 f))))
```


We can pick a unique vertical subset of the domain to be the y-axis.

```
(forall (a2 f)
  (if (yAxis a2 f)
      (and (framework f) (vertical2 a2 f))))
```


There may be a unique `vertical3` set which is the z-axis, intersecting
the x-axis and the y-axis at the origin.

```
(forall (a3 f)
   (if (zAxis a3 f)
       (and (framework f) (vertical3 a3 f))))
```


The x-, y-, and z-axes of a framework are unique. Lines 5-7 stipulate the
uniqueness of the x- and y-axes. Lines 8-10 stipulate the uniqueness of
the z-axis, if there is one.

```
(forall (f)
   (if (framework f)
       (exists (a1 a2)
          (and (xAxis a1 f) (yAxis a2 f)
               (forall (a)
                  (and (if (xAxis a f) (equal a a1))
                       (if (yAxis a f) (equal a a2))))
               (forall (a3 a)
                  (if (and (zAxis a3 f) (zAxis a f))
                      (equal a a3)))))))
```


The intersection of the x-, y-, and z-axes is a unique element we call
the `origin`.

```
(forall (f a1 a2)
   (if (and (framework f) (xAxis a1 f) (yAxis a2 f))
       (and (exists (s o)
               (and (intersection s a1 a2) (singleton s o)
                    (origin o f))
                    (forall (a3)
                       (if (zAxis a3 f)
                           (and (intersection s a1 a3)
                                (intersection s a2 a3))))))))
```


The x-, y-, and z-axes are independent scales. Lines 2-3 take care of the
two-dimensional case; lines 4-7 the three-dimensional case.

```
(forall (f a1 a2)
   (if (and (framework f) (xAxis a1 f) (yAxis a2 f))
       (and (independentScales a1 a2)
            (forall (a3)
               (if (zAxis a3 f)
                   (and (independentScales a1 a3)
                        (independentScales a2 a3))))))))
```


A framework thus consists of a domain, two or three independent
relations and two or three unique corresponding axes that intersect
in a single element called the origin.

Any element in the domain can have an x-coordinate and a y-coordinate.

An element of the domain has an x-coordinate if there is a vertical subset
that contains both the element and an element of the x-axis.

```
(forall (x1 x f)
  (iff (xCoordinate x1 x f)
       (exists (v a1)
         (and (vertical2 v f) (member x v) (xAxis a1 f)
              (member x1 v) (member x1 a1)))))
```

An element of the domain has a y-coordinate if there is a horizontal subset
that contains both the element and an element of the y-axis.

```
(forall (y1 x f)
  (iff (yCoordinate y1 x f)
       (exists (h a2)
         (and (horizontal2 h f) (member x h) (yAxis a2 f)
              (member y1 h) (member y1 a2)))))
```

When there is a z-axis, an element of the domain has a z-coordinate if there
is a horizontal plane that contains both the element and element of the
z-axis.

```
(forall (z1 x f)
   (iff (zCoordinate z1 x f)
        (exists (h a3)
           (and (horizontalPlane h f) (member x h) (zAxis a3 f)
                (member z1 h) (member z1 a3)))))
```

We should point out that frameworks are often observer-based and
hence volatile. Moving around a table changes what counts as
`above` and `rightOf`.


A subset of the domain is `horizontal3` if it is either `horizontal`
or `vertical2`.

```
(forall (s f)
   (iff (horizontal3 s f)
        (or (horizontal s f) (vertical2 s f))))
```


`horizontal3` and `vertical3` sets are independent scales.

```
(forall (s1 s2 f)
   (if (and (framework f) (horizontal3 s1 f) (vertical3 s2 f))
       (independentScales s1 s2)))
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

We can define a coordinate system as a framework in which all the axes are
numeric and the partial ordering is "greater than".

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
number, two points, and a unit. The expression `(distance d x1 x2 u)` says
that the distance between points x1 and x2 is d units u.

```
(forall (d x1 x2 u)
  (if (distance d x1 x2 u)
      (and (nonNegativeNumber d) (point x1) (point x2)
           (spatialUnit u))))
```


The predicate `distance` has the usual mathematical properties.


The distance between an entity and itself is zero.

```
(forall (x u) (distance 0 x x u))
```


The distance between two entities is symmetric.

```
(forall (d x1 x2 u)
  (iff (distance d x1 x2 u) (distance d x2 x1 u)))
```


The triangle inequality holds for distance.

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


A circle is a curve. We use the predicate `circle2` to describe the
two-dimensional region whose border is a circle.

```
(forall (r x)
   (iff (circle2 r x)
        (exists (c)
           (and (circle c x) (border c r)))))
```


A closed planar curve has no endpoints and can be covered by a large
enough circle.

```
(forall (c)
   (if (and (curve c)(planar c))
       (iff (closed c)
            (and (not (exists (x) (endpoint x c)))
                 (exists (r x1)
                    (and (circle2 r x1) (subfigure c r)))))))
```


A spherical surface r around a center x is a region in which
every line segment from the center to a point inside the region is
constant.

```
(forall (r x)
   (iff (sphere r x)
        (exists (v d u)
           (and (boundary r v) (inside x v)
                (forall (c1 x1)
                   (if (and (inside x1 r) (lineSegmentFromTo c1 x x1))
                       (length d c1 u)))))))
```


We use the predicate `sphere3` for the three-dimensional volume whose
surface is a sphere.

```
(forall (v x)
   (iff (sphere3 v x)
        (exists (r)
           (and (boundary r v) (sphere r x)))))
```


A closed curve in general can be surrounded by a sufficiently large sphere,
as can a closed region.

```
(forall (c)
   (if (or (curve c)(region c))
       (iff (closed c)
            (and (not (exists (x) (or (endpoint x c) (border x c))))
                 (exists (v x1)
                    (and (sphere3 v x1) (subfigure c v)))))))
```


We can define qualitative terms like "near" and "far" as outlined in
Gordon and Hobbs, Chapter 12, and exemplified numerous times in the rest
of the book.


"Nearer" is a partial ordering. The expression `(nearer x y z)` says that
x is nearer than y is to z.

```
(forall (x y z)
   (iff (nearer x y z)
        (exists (d1 d2)
           (and (distance d1 x z u) (distance d2 y z u)
                (lt d1 d2)))))
```


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

`near` is defined as the `Lo` region of the nearness scale.

```
(forall (x z)
   (iff (near x z)
        (exists (s s1)
           (and (nearnessScale s z) (Lo s1 s) (onScale x s1)))))
```

`far` is defined as the `Hi` region of the nearness scale.

```
(forall (x z)
   (iff (far x z)
        (exists (s s2)
           (and (nearnessScale s z) (Hi s2 s) (onScale x s2)))))
```

As described in Chapter 12 of Gordon and Hobbs (2017), there are
two principal classes of inference that can be drawn about something
in the `Hi` region of a scale -- the distributional and the functional.

A rather crude example of a distributional inference is that an entity
in the `Hi` region is defeasibly higher on the scale than the median
of a comparison set. That is, there are more things smaller than larger.
In this axiom x is the entity in the `Hi` region, s0 is the scale,
s1 is its `Hi` region, s2 is the domain of scale s0, s3 is the set of
elements of s2 lower on the scale than x, s4 is the set of elements
of s2 higher on the scale than x, and the cardinality n3 of s3 is
larger than the cardinality n4 of s4. The conjunct `(etc)` in line 2
is an indication of defeasibility.

```
(forall (x s0 s1)
   (if (and (onScale x s1) (Hi s1 s0) (etc))
       (exists (s2 s3 s4 n3 n4)
          (and (componentsOf s2 s0) (union s2 s3 s4)
               (forall (y) (iff (member y s3) (lts y x s0)))
               (forall (z) (iff (member z s4) (lts x z s0)))
               (card n3 s3) (card n4 s4) (lt n4 n3)))))
```

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

We can say that two vertices are equal whenever the bases of their angles
are of equal length. (Most quantities we measure in everyday life we
measure by translating them into distance, and size of angles is no
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

The equality of angles is reflexive.

```
(forall (v) (equalAngle v v))
```

The equality of angles is symmetric.

```
(forall (v1 v2)
  (iff (equalAngle v1 v2) (equalAngle v2 v1)))
```

The equality of angles is transitive.

```
(forall (v1 v2 v3)
  (if (and (equalAngle v1 v2) (equalAngle v2 v3))
      (equalAngle v1 v3)))
```

A "greater than" relation can be defined in a similar manner.

We say the angle of vertex v1 is greater than the angle of vertex v2
whenever the base of the angle of v1 is greater than the base of the angle
of v2.

```
(forall (v1 v2)
   (iff (gtAngle v1 v2)
        (exists (c1 c2 d1 d2 u)
           (and (baseOfAngle c1 v1 u) (baseOfAngle c2 v2 u)
                (length d1 c1 u) (length d2 c2 u) (gt d1 d2)))))
```

It is easy to show this relation is anti-reflexive, anti-symmetric,
and transitive.

An angle being greater is anti-reflexive.

```
(forall (v) (not (gtAngle v v)))
```

An angle being greater is anti-symmetric.

```
(forall (v1 v2)
   (iff (gtAngle v1 v2) (not (gtAngle v2 v1))))
```

An angle being greater is transitive.

```
(forall (v1 v2 v3)
   (if (and (gtAngle v1 v2) (gtAngle v2 v3))
       (gtAngle v1 v3)))
```

To be able to talk about the size of an angle in more detail, we posit a
framework (not necessarily a coordinate system) whose x-axis contains one
of the sides of the angle and whose origin coincides with the vertex. Then
the size of the angle can be correlated with the y-coordinate. We call
this framework an "anchor framework" for the vertex.

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

The expression `(anchorPoint x f v c1 c2 o u)` says that x is an anchor
point in framework f whose origin is o, v is a vertex at o whose side c1
lies along f's x-axis, and x is a point in v's other side c2 one
distance unit u from the origin.

```
(forall (x v f c1 c2 o u)
  (iff (anchorPoint x v f c1 c2 o u)
       (and (anchorFramework f v c1 c2 o)
            (inside x c2) (distance 1 o x u))))
```

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
directions, and these can be characterized here.

An everyday way of describing angles is to augment the north-east-south-west
system with the four intermediate directions northeast, southeast, southwest
and northwest. This system is based on angles of 45 degrees. A 45-degree
angle is one whose anchor point's x- and y-coordinates are equal.

```
(forall (v)
   (iff (45Degrees v)
        (exists (v0 x f c1 c2 o u d)
           (and (equalAngle v v0) (anchorPoint x v f c1 c2 o u)
                (xCoordinate x1 x f) (yCoordinate y1 x f)
                (distance d o x1 u) (distance d o y1 u)))))
```

An everyday fine-grained system of describing angles is based on angles of
30 degrees and is visualized as a clock -- "incoming at 2 o'clock,"
"exit the traffic circle at 11 o'clock." A 30-degree angle is one in which
the distance from the origin to the anchor point is twice the y-coordinate.

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

We define a rectangle as a quadrilateral whose vertices are all right
angles.

```
(forall (p)
  (iff (rectangle p)
       (and (quadrilateral p)
            (forall (v)
              (iff (vertexOf v p)
                   (rightAngle v))))))
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


A diagonal of a polygon in general is a line segment from a vertex
to a nonadjacent vertex.


## Directions

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


The positive half of the x-axis of a framework is a direction.

```
(forall (d f)
   (iff (posXAxis d f)
        (exists (a o)
           (and (xAxis a f) (origin o f)
                (forall (x)
                   (iff (member x d)
                        (and (member x a) (leqs o x a))))))))
```

The negative half of the x-axis of a framework is a direction.

```
(forall (d f)
   (iff (negXAxis d f)
        (exists (a o)
           (and (xAxis a f) (origin o f)
                (forall (x)
                   (iff (member x d)
                        (and (member x a) (leqs x o a))))))))
```

The positive half of the y-axis of a framework is a direction.

```
(forall (d f)
   (iff (posYAxis d f)
        (exists (a o)
           (and (yAxis a f) (origin o f)
                (forall (x)
                   (iff (member x d)
                        (and (member x a) (leqs o x a))))))))
```

The negative half of the y-axis of a framework is a direction.

```
(forall (d f)
   (iff (negYAxis d f)
        (exists (a o)
           (and (yAxis a f) (origin o f)
                (forall (x)
                   (iff (member x d)
                        (and (member x a) (leqs x o a))))))))
```

The positive half of the z-axis of a framework is a direction.

```
(forall (d f)
   (iff (posZAxis d f)
        (exists (a o)
           (and (zAxis a f) (origin o f)
                (forall (x)
                   (iff (member x d)
                        (and (member x a) (leqs o x a))))))))
```

The negative half of the z-axis of a framework is a direction.

```
(forall (d f)
   (iff (negZAxis d f)
        (exists (a o)
           (and (zAxis a f) (origin o f)
                (forall (x)
                   (iff (member x d)
                        (and (member x a) (leqs x o a))))))))
```


## Polyhedrons

A polyhedron is a volume whose surface consists of polygons, which are
called faces. The expression `(polyhedron p s)` says that p is a
polyhedron with set s of faces. Lines 5-6 says that the members of s are
polygons contained within the surface of the polyhedron. Lines 7-10 say
that the faces account for the entire surface. Lines 11-14 say that the
polygons overlap only at their boundaries.

```
(forall (p s)
   (iff (polyhedron p s)
        (exists (r)
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


A rectangular parallelepiped is a polyhedron all of whose faces are
rectangles.

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


## Qualitative Faces

It is easy to say what a face is in the case of a polyhedron, and when
combined with orientation, what fronts, backs and sides are. It is much
more difficult in the case of amorphous physical objects like human
beings, animals, cars, odd-shaped buildings, and so on. We will begin by
taking seriously the relational nature of "face" -- x faces y. Then we
define a loose notion of a point being central in a region or volume.
This will allow us to tighten the characterization of “face” somewhat. We
then characterize in terms of these concepts the orientation of an object
and its faces designated the front, back, sides, top and bottom.

A face is defined in terms of a reference point. It is a subregion
of the surface of a volume that faces the reference point.
The expression `(face0 r v p)` says that subregion r of volume v
faces external point p. Recall that a point is a subfigure of a
region or volume if it is inside it or in its boundary. Lines 3-4
say that p is external to v and r is a subfigure of v. Lines 5-8
say that any line segment from p to a point in r will not cross v
before arriving at r. In other words, no part of the volume v
blocks a straight path between the point p and the face r.

```
(forall (r v p)
   (if (face0 r v p)
       (and (volume v) (point p) (not (subfigure p v))
            (region r) (subfigure r v)
            (forall (p0 c)
               (if (and (subfigure p0 r)
                        (lineSegmentFromTo c p p0))
                   (not (exists (p1)
                           (and (inside p1 c)
                                (subfigure p1 v)))))))))
```

It is easy to see that the face of a convex polyhedron, e.g., a
cube, is a face with respect to any point beyond the plane of the
face.

This concept leaves something to be desired, however, which is
why we called it `face0`. This axiom will allow v to be
a square building, r to be its front as normally understood, and
p to be a point miles away to the side but one inch in front of
the building. To get a tighter notion of "face". we can introduce
the idea of a point being "central in" a figure.

It is straightforward to define the center of a regular figure,
such as a sphere or a cube.  It is not so easy for an irregular
region or volume, like a person, a country, or a random artifact,
where we lack a precise specification of shape.  But we know, for
example, that Kansas City is in the central part of the United
States, and that the stomach is more centrally located in the body
than the throat is.

We introduce a loose notion of "central" based on half orders of
magnitude. We will say that a point in a region or volume is central if
whenever a straight line is drawn through the point and intersects the
boundary in two points, the distances from the central point to the two
boundary points are of the same half order of magnitude.
In this axiom, c is any line segment from p1 to p2, points on the
boundary of f, passing through p. Line 7 says that p divides the
line segment into roughly equal parts.  We use "if" rather than
"iff" because this is a strong sufficient condition, not a necessary
condition for centrality. There will surely be odd-shaped figures where
this condition won't hold and yet we'll want to call the point central.

```
(forall (p f)
   (if (point p)
       (if (forall (c p1 p2 b d1 d2)
              (if (and (lineSegmentFromTo c p1 p2) (inside p c)
                       (boundary b f) (inside p1 b) (inside p2 b)
                       (distance d1 p1 p) (distance d2 p2 p))
                  (sameHOM d1 d2)))
           (centralIn0 p f))
```


`centralIn` extends the concept of `centralIn0` to higher-dimensional figures.

```
(forall (f1 f2)
   (iff (centralIn f1 f2)
        (or (and (point f1) (centralIn0 f1 f2))
            (and (figure f1) (figure f2)
                 (forall (p) (if (inside p f1)
                                 (centralIn0 p f2)))))))
```


We can stipulate that region r is a face of volume v with respect to
exterior point p if a line segment from a central point in v through a
central point in r ending at p does not pass through any point in v
between r and p. Lines 2-3 constrain the arguments of “face”.  In lines
5-7 c is a line segment from a central point in volume v to the exterior
point p, passing through a central point p1 in region r. Lines 8-10 say
that there is no point p2 between p1 and p that is also in v.

```
(forall (v r p)
   (if (and (volume v) (region r) (subfigure r v)
            (point p) (not (subfigure p v)))
       (iff (face r v p)
            (forall (c p0 p1)
               (if (and (lineSegmentFromTo c p0 p) (centralIn p0 v)
                        (centralIn p1 r) (subfigure p1 c))
                   (not (exists (p2 c1)
                           (and (subfigure p2 v) (inside p2 c1)
                                (lineSegmentFromTo c1 p1 p)))))))))
```


It will be useful to have a name for a ray going from p0 through p1 and p.
We will call this a "quill", after the quills of porcupines.

```
(forall (c v r)
   (iff (quill c v r)
        (exists (p0 p1 p)
           (and (volume v) (face r v p) (ray c) (inside p c)
                (endpoint p0 c) (centralIn p0 v)
                (centralIn p1 r) (inside p1 c))))))
```


The orientation of a volume v with a designated face r in a framework f is
the direction of a ray c from a central point in v passing through a central
point in r, i.e., the direction of a quill.

```
(forall (d v r f)
   (iff (orientation0 d v r f)
        (exists (c)
           (and (quill c v r) (directionOf d c f)))))
```


We named this `orientation0` to save `orientation` for volumes (or physical
objects) with fronts.

The term "front" is an imprecise term. We cannot define it precisely with
necessary and sufficient conditions. But we can constrain its possible
meanings with two necessary conditions and several defeasible sufficient
conditions.

The front of a volume is a face with respect to some external point. 

```
(forall (r v)
   (if (front r v)
       (exists (p) (face r v p))))
```

Fronts are defeasibly unique.

```
(forall (r1 r2 v)
   (if (and (front r1 v) (disjoint r1 r2) (etc))
       (not (front r2 v))))
```

If a face of an entity has a part whose function is to enable
motion into and/or out of the entity, then defeasibly the face is a
front of the entity.
Lines 3-4 says that part x of face r has the function of enabling
motion e2 of something a. Eventuality e1 is the property of x that
enables e2. Lines 5-6 say the motion is either into or out of v.
Line 7 indicates defeasibility. Thus, a door x in the face r of a
building v has the function of its being open (e1) enabling people
(a) to move into or out of the building. Of course, many times
there will be more than one such face, but the defeasible
uniqueness of fronts in the previous rule will usually force us to
choose the primary one.

```
(forall (r v)
   (if (exists (p x e e1 e2 a b c)
          (and (face r v p) (part x r) (function e x) (arg* x e1)
               (enable' e e1 e2) (move' e2 a b c)
               (or (and (inside c v) (externalTo b v))
                   (and (inside b v) (externalTo c v)))
               (etc))
       (front r v))
```


We didn't specify what a is -- what is being moved in or out. It could
be information. Thus a block with writing on one side could be said
to have that side as its front.


If the volume is mobile, the leading face is often considered the
front. That is, defeasibly, if the volume moves from one point to
another, the front reaches the destination before any other face.
In lines 2-3 p1 is a point in the face r, and p2 is another point in v
not in the face. Lines 5-7 say that if there is moving from b to c,
then defeasibly p1 will get there before p2. Line 8 says under these
conditions, the face is a front.

```
(forall (r v p p1 p2)
   (if (and (face r v p) (subfigure p1 r) (subfigure p2 v)
            (not (subfigure p2 r))
            (forall (b c e1 e2)
               (if (and (move v b c) (at' e1 p1 c) (at' e2 p2 c)
                        (etc))
                   (before e1 e2))))
       (front r v)))
```


We can now define "orientation".

```
(forall (d v f)
   (iff (orientation d v f)
        (exists (r)
           (and (front r v) (orientation0 d v r f)))))
```


Once we identify the direction of the quill through the front of the
volume with the positive y-axis, we can define the back, sides, top
and bottom of the volume.


The expression `(back r v f)` says that region r is the back of volume v
in framework f. In lines 4-7 the orientation of v is anchored to the
positive y-axis, and the back is a face the direction of whose quill
is the negative y-axis.

```
(forall (r v f)
   (iff (back r v f)
        (exists (r1 c c1 a a1)
           (and (front r1 v f) (face r v p)
                (quill c1 r1 v) (quill c r v)
                (directionOf a1 c1 f) (directionOf a c f)
                (posYAxis a1 f) (negYAxis a f)))))
```


The sides, top and bottom can be defined similarly.


The expression `(rightSide r v f)` says that region r is the right side of
volume v in framework f.

```
(forall (r v f)
   (iff (rightSide r v f)
        (exists (r1 c c1 a a1)
           (and (front r1 v f) (face r v p)
                (quill c1 r1 v) (quill c r v f)
                (directionOf a1 c1 f) (directionOf a c f)
                (posYAxis a1 f) (posXAxis a f)))))
```


The expression `(leftSide r v f)` says that region r is the left side of
volume v in framework f.

```
(forall (r v f)
   (iff (leftSide r v f)
        (exists (r1 c c1 a a1)
           (and (front r1 v f) (face r v p)
                (quill c1 r1 v) (quill c r v f)
                (directionOf a1 c1 f) (directionOf a c f)
                (posYAxis a1 f) (negXAxis a f)))))
```


```
(forall (r v f)
   (iff (side r v f)
        (or (rightSide r v f) (leftSide r v f))))
```


The expression `(top r v f)` says that region r is the top of volume v in
framework f.

```
(forall (r v f)
   (iff (top r v f)
        (exists (r1 c c1 a a1)
           (and (front r1 v f) (face r v p)
                (quill c1 r1 v) (quill c r v f)
                (directionOf a1 c1 f) (directionOf a c f)
                (posYAxis a1 f) (posZAxis a f)))))
```


The expression `(bottom r v f)` says that region r is the bottom of volume
v in framework f.

```
(forall (r v f)
   (iff (bottom r v f)
        (exists (r1 c c1 a a1)
           (and (front r1 v f) (face r v p)
                (quill c1 r1 v) (quill c r v f)
                (directionOf a1 c1 f) (directionOf a c f)
                (posYAxis a1 f) (negZAxis a f)))))
```


## Standard Frameworks

Standard frameworks are characterized by two classes of facts, first,
the relations of the various directions to each other or, equivalently,
to the framework, and second, the relation of the framework to something
in the external world. The latter axioms anchor the framework, generally
by reaching out of the spatial ontology to other commonsense theories.
For the cardinal directions, we need to know from a theory of geography
that there is an Earth and it has a North Pole.

- `(Earth e)`: e is the Earth.
- `(NorthPole x e)`: x is the Earth's North Pole.

The Earth is a sphere.

```
(forall (e) (if (Earth e) (sphere e)))
```


The expression `(tangent t c x)` says that linear entity t is
tangent to circle c at point x.

```
(forall (t c x)
   (iff (tangent t c x)
        (and (point x) (circle c) (linear t) (coplanar c t)
             (exists (s)
                (and (singleton s x) (intersection s c t))))))
```


We can now define the standard north-east-south-west framework
as one whose origin is on the surface of the Earth and whose
positive y-axis is a tangent pointing toward the North Pole.

```
(forall (f)
  (iff (neswFramework f)
    (exists (d p e x o)
       (and (framework f) (posYAxis d f) (origin o f)
            (vertical2Plane p f) (subfigure d p)
            (NorthPole x e) (subfigure x p)
            (Earth e) (circumference c s) (tangent d c o)))))
```


We can now define the cardinal directions.


North is the positive half of the y-axis in the N-E-S-W framework.

```
(forall (d)
   (iff (north d)
        (exists (f) (and (neswFramework f) (posYAxis d f)))))
```


South is the negative half of the y-axis in the N-E-S-W framework.

```
(forall (d)
   (iff (south d)
        (exists (f) (and (neswFramework f) (negYAxis d f)))))
```


East is the positive half of the x-axis in the N-E-S-W framework.

```
(forall (d)
   (iff (east d)
        (exists (f) (and (neswFramework f) (posXAxis d f)))))
```


West is the negative half of the x-axis in the N-E-S-W framework.

```
(forall (d)
   (iff (west d)
        (exists (f) (and (neswFramework f) (negXAxis d f)))))
```


Up is the positive half of the z-axis in the N-E-S-W framework.

```
(forall (d)
   (iff (up d)
        (exists (f) (and (neswFramework f) (posZAxis d f)))))
```


Down is the negative half of the z-axis in the N-E-S-W framework.

```
(forall (d)
   (iff (down d)
        (exists (f) (and (neswFramework f) (negZAxis d f)))))
```


Directions like "northeast" are a little more complicated to define.

```
(forall (d)
   (iff (northeast d)
        (exists (f o d1 d2 v1 v2)
           (and (neswFramework f) (origin o f)
                (posYAxis d1 f) (posXAxis d2 f)
                (vertex v1 d1 d o) (vertex v2 d d2 o)
                (45Degrees v1) (45Degrees v2)))))
```

There would be similar axioms for "southeast", "southwest", and "northwest".


In a self-anchored framework the anchor in the external world is the entity’s
orientation.

```
(forall (f v)
  (iff (selfAnchoredFramework f v)
    (exists (d)
       (and (framework f) (posYAxis d f) (orientation d v)))))
```


The four horizontal directions "forward", "backward", "rightward",
and "leftward" can be defined.


Forward is the positive half of the y-axis in a self-anchored framework.

```
(forall (d)
   (iff (forward d)
        (exists (f) (and (selfAnchoredFramework f) (posYAxis d f)))))
```


Backward is the negative half of the y-axis in a self-anchored framework.

```
(forall (d)
   (iff (backward d)
        (exists (f) (and (selfAnchoredFramework f) (negYAxis d f)))))
```


Rightward is the positive half of the x-axis in a self-anchored framework.

```
(forall (d)
   (iff (rightward d)
        (exists (f) (and (selfAnchoredFramework f) (posXAxis d f)))))
```


Leftward is the negative half of the x-axis in a self-anchored framework.

```
(forall (d)
   (iff (leftward d)
        (exists (f) (and (selfAnchoredFramework f) (negXAxis d f)))))
```


Generally up and down will be the same direction as in the cardinal
directions framework. However it is possible to be lying on the
ground and have something be on the ground "above" your head.

From these rules one can conclude that if you are facing north, east is
to your right.


A vehicle-anchored framework is a self-anchored framework where the
self is a boat or airplane.

```
(forall (f v)
   (iff (vehicleAnchoredFramework f v)
        (and (selfAnchoredFramework f v)
             (or (boat v) (airplane v)))))
```

Then terms like "port" and "starboard" can be defined in a similar
manner to the cardinal directions above.

The fourth kind of framework in common use is the force-anchored
framework. A theory of force would associate a direction with a
force, and that would be aligned with the axes of a framework.
We could then define terms like "windward", "upwind", and "upriver".


## Physical Objects in Space: Location and Motion

So far, we have constructed our spatial ontology in terms of disembodied
portions of space, whether or not something occupies that space. Now
we introduce physical objects in space. We do not attempt to define
what it is to be a physical object, but we do constrain the concept
with properties from two theories. The first is a theory of space, and
that we explicate here.  The second is a commonsense theory of material,
or matter, and that will have to await future development.


A physical object at any given time occupies a volume in space.

```
(forall (x)
   (if (physobj x)
       (exists (v) (and (volume v) (occupy x v)))))
```


The predicate "occupy" is a relation between physical objects and
volumes.

```
(forall (x v)
   (if (occupy x v) (and (physobj x) (volume v))))
```


The parts of the physical object occupy volumes that are subfigures
of the volume occupied by the whole.

```
(forall (x y v1)
   (if (and (physobj x) (occupy x v1) (part y x))
       (exists (v2) (and (occupy y v2) (subfigure v2 v1)))))
```

Physical objects can move, but we don't need to specify the time with
the predicate "occupy" because the use of unprimed predicates ensures
that the predications are all anchored to the same time (cf. Gordon
and Hobbs, 2017, ch. 20).


We could extend the concept of "occupy" from physical objects in
3-dimensional space to events in space x time (or 4-dimensional
space-time), by defining a mapping from times in the interval during
which the event occurs, to the aggregate of the volumes the arguments
of the event occupy at that time, and introduce a predicate "occupy4D"
that takes such a mapping as its argument. A weaker but simpler
approach is to say that at any given (implicit) time, an event occupies
the volume its arguments occupy.

```
(forall (x e v)
   (if (and (arg x e) (occupy x v))
       (exists (v1) (and (subfigure v v1) (occupy e v1)))))
```


It will be convenient to say that physical objects not only occupy
volumes; they also are volumes. This will allow us to apply to
physical objects all the predicates we have introduced for abstract
volumes, without having to coerce the physical object into the volume
it occupies.

```
(forall (x) (if (physobj x) (volume x)))
```


Thus, for a physical object x, if x occupies volume v1, there is the
volume it is — x — and there is the volume it occupies — v1. When
the object moves, the volume it occupies changes — v1 to v2 — but
the volume it is stays the same — x. Thus, we can talk about a
physical object being a cube or a polyhedron, and we can talk about
its surface, its faces, and its vertices. Every property of v carries
over to x.


The figure-ground relation "at" places an external entity at an
element in a ground. A ground is a composite entity whose
components are similar enough that the "at" relation can be given a
uniform interpretation.

If the components of s are all figures (possibly physical objects,
since volumes are figures), then s is called a `spatialSystem`.

```
(forall (x)
   (iff (spatialSystem s)
        (forall (x) (if (componentOf x s) (figure x)))))
```


The relation "atLoc" is a specialization of the figure-ground
relation, relating a physical object to a component in a spatial
system.

```
(forall (x y)
   (if (atLoc x y)
       (exists (s)
          (and (physobj x) (componentOf y s) (spatialSystem s)
               (at x y s)))))
```

In axiomatizing location, we use the predicate `at` where the
property holds for metaphorical interpretations and the predicate
`atLoc` where the property is peculiar to physical space.

If a physical object occupies a volume, then it is at all the points that
are subfigures of the volume.

```
(forall (x v p)
   (if (and (occupy x v) (point p) (subfigure p v))
       (atLoc x p)))
```

Thus the structure of space constitutes a ground against which
physical objects can be placed as figures.

A physical object lies along a curve if it is at every point in the curve.

```
(forall (x c)
   (if (and (physobj x) (curve c))
       (iff (along x c)
            (forall (p)
               (if (and (point p) (inside p c))
                   (atLoc x p))))))
```

A physical objects lies over a region if it is at every point in the region.

```
(forall (x r)
   (if (and (physobj x) (region r))
       (iff (over x c)
            (forall (p)
               (if (and (point p) (inside p r))
                   (atLoc x p))))))
```

If two physical objects are in contact, there is a point they are both at.

```
(forall (x y)
   (if (contact x y)
       (exists (p) (and (at x p) (at y p)))))
```

Contact is symmetric.

```
(forall (x y) (iff (contact x y) (contact y x)))
```

Body position verbs are often used simply to indicate location.

```
(forall (x p) (if (rest x p) (atLoc x p)))
```

```
(forall (x p) (if (lie x p) (atLoc x p)))
```

```
(forall (x p) (if (sit x p) (atLoc x p)))
```

```
(forall (x p) (if (stand x p) (atLoc x p)))
```

For a physical object to move (or be moved) is for it to change
from being at one point to being at another point.

```
(forall (x a b)
   (iff (move x a b)
        (exists (e1 e2) (and (change e1 e2) (at' e1 x a) (at' e2 x b)))))
```


This defines a predicate "move" corresponding to the intransitive verb.
For a predicate corresponding to the transitive verb, we need to augment
it with the causality of an agent.

```
(forall (a x d1 d2)
   (iff (move2 a x d1 d2)
        (exists (e) (and (cause a e) (move' e x d1 d2)))))
```


To place something at a location is to cause it to move there.

```
(forall (z x b)
   (iff (placeAt z x b)
        (exists (e1) (and (cause z e1) (move' e1 x a b)))))
```


In physical space when we move a physical object from one point to
another, there is a curve -- its path -- such that the object is at
every point in the path along the way. First we define "path".

```
(forall (c e x a b)
   (if (move' e x a b)
       (iff (path c e)
            (forall (p)
               (if (and (point p) (inside p c))
                   (exists (e1 e2)
                      (and (move' e1 x a p) (move' e2 x p b)
                           (subevent e1 e) (subevent e2 e))))))))
```


Every moving of a physical object has a path.

```
(forall (e x a b)
   (if (and (move' e x a b) (physobj x))
       (exists (c) (path c e))))
```


If e is a moving event of x from y1 to y2, then y1 is the source
of the move.

```
(forall (e x y1 y2) (if (move' e x y1 y2) (sourceOf y1 e)))
```


If e is a moving event of x from y1 to y2, then y2 is the destination of
the move.

```
(forall (e x y1 y2) (if (move' e x y1 y2) (destinationOf y2 e)))
```


A point x is "between" two points y1 and y2 on a curve c if x is
inside a subcurve c1 whose endpoints are y1 and y2.

```
(forall (x y1 y2 c)
   (iff (between x y1 y2 c)
        (exists (c1)
           (and (curve c1) (subfigure c1 c) (endpoint y1 c1)
                (endpoint y2 c1) (inside x c1)))))
```


If c is the path of a moving event e, then e is "along" c.

```
(forall (e x y1 y2 c)
   (if (and (move' e x y1 y2) (path c e))
       (along e c)))
```


If the path of a moving event is a closed curve, the event is "around" the
points (and other figures) enclosed by the path.

```
(forall (e x y1 y2 c)
   (if (and (move' e x y1 y2) (path c e))
       (iff (around c z)
            (exists (r)
               (and (region r) (boundary c r)
                    (inside z r))))))
```


To move into a region or volume is to move to a point inside it.

```
(forall (e x y1 y2)
   (if (move' e x y1 y2)
       (iff (into e v)
            (inside y2 v))))
```


The definitions of "on" and "onto" will have to wait till we
deal with force and support.


To move through a figure is for point in the figure to be between
the source and destination on the path of the motion.

```
(forall (e x y1 y2 c z)
   (if (and (move' e x y1 y2) (path c e))
       (iff (through e z)
            (exists (p)
               (and (subfigure p z) (between p y1 y2 c))))))
```


To move toward something is to become closer to it.

```
(forall (e x a b b1)
   (if (move' e x a b)
       (iff (toward e b1)
            (exists (d1 d2 u)
               (and (distance d1 a b1 u) (distance d2 b b1 u)
                    (lt d1 d2))))))
```


For a curve to go toward something is for it to be the path of
a motion toward it.

```
(forall (c z)
   (if (curve c)
       (iff (toward c z)
            (exists (e x y1 y2)
               (and (move' e x y1 y2) (toward e z)))))))
```

The words "inbound" and "incoming" mean that the motion is toward
a point of reference but not yet at the destination. The words
"outbound" and "outgoing" are defined similarly.



## Shape and Size

Physical objects have shapes and sizes. The shape of a physical object can
be extremely complicated. But we commonly approximate complex shapes with
simpler shapes for which we can define various aspects of size that are
relatively easy to characterize and measure. One such approximation is a
rectangular parallelepiped enclosing the physical object, which we can
call a "bounding box". Line 3 says that the box encloses the physical
object. Lines 4-6 say that no smaller box also encloses it. As defined,
bounding boxes are not unique.

```
(forall (b x)
   (iff (boundingBox b x)
        (and (rectangularParallelepiped b) (physobj x) (subfigure x b)
             (not (exists (b1)
                     (and (rectangularParallelepiped b1)
                          (subfigure x b1) (subfigure b1 b)))))))
```


For a given bounding box we can define the primary, secondary, and
tertiary dimensions of the physical object. In this axiom c1, c2, and c3
are three non-parallel sides in decreasing order of length, and d1, d2 and
d3 are their respective lengths, measured in units u. The predicate "dimi"
picks out the ith longest side.

```
(forall (c1 c2 c3 d1 d2 d3 u b x)
   (if (and (boundingBox b x) (edge c1 b) (edge c2 b) (edge c3 b)
            (not (parallel c1 c2)) (not (parallel c2 c3))
            (not (parallel c1 c3))
            (length d1 c1 u) (length d2 c2 u) (length d3 c3 u))
       (and (iff (dim1 c1 b x)
                 (and (lt d2 d1) (lt d3 d1)))
            (iff (dim2 c2 b x)
                 (and (leq d2 d1) (leq d3 d2)))
            (iff (dim3 c3 b x)
                 (and (lt d3 d1) (lt d3 d2))))))
```


We are already using the predicate `length` for the length of a line segment,
so for the length of a 3-dimensional physical object, we'll use the
predicate `length3`. The length of a physical object is the length of the
longest side of its bounding box.

```
(forall (n x u)
   (iff (length3 n x u)
        (exists (b)
           (and (boundingBox b x) (dim1 c b x) (length n c u)))))
```


The width of a physical object is the length of the second longest side of
its bounding box.

```
(forall (n x u)
   (iff (width n x u)
        (exists (b)
           (and (boundingBox b x) (dim2 c b x) (length n c u)))))
```


The thickness of a physical object is the length of the third longest side
of its bounding box.

```
(forall (n x u)
   (iff (thickness n x u)
        (exists (b)
           (and (boundingBox b x) (dim3 c b x) (length n c u)))))
```


Length, width and thickness depend only on the relative dimensions of the
object. Height depends also on a framework that fixes a particular
direction as up. That vertical dimension is the height.

```
(forall (n x u f)
   (iff (height n x u f)
        (exists (b c d)
           (and (bounding box b x) (edge c b) (directionOf d c)
                (posZAxis d f) (length n c u)))))
```


Depth may seem also to specify a vertical dimension, as in "the depth of
the lake". But one can also talk about "the depth of the safe" referring
to how far back one can reach into it. On the other hand, one wouldn't
talk about the depth of a floor, referring to the distance from the carpet
to the ceiling of the room below. The condition for "depth" probably
involves a real or imagined movement into the object. Moreover, the entry
into the object can be through the top, as in the lake example, or through
the front or one of the sides, as in the safe example. But apparently the
movement can't be through the bottom of the object. Here r is the face of
physical object x through which entry is effected in real or imagined
motion e of something y from z1 to z2. Ray c is a "quill" from a central
point in x through a central point in r, and it is parallel to an edge c1
of a bounding box b of x. The length of that edge is the depth of the object.

```
(forall (n x u)
   (iff (depth n x u)
        (exists (c r e y z1 z2 b c1)
           (and (quill c x r) (not (bottom r x))
                (move' e y z1 z2) (into e x) (through e r)
                (boundingBox b x) (edge c1 b) (parallel c c1)
                (length n c1 u)))))
```


"Wider" is defined in terms of `width` as follows:

```
(forall (x1 x2)
   (iff (wider x1 x2)
        (exists (n1 n2 u)
           (and (width n1 x1 u) (width n1 x2 u) (lt n2 n1)))))
```


The expression `(widthScale s s1 e)` says that s is a scale whose
elements are a set s1 and whose ordering relation is e. Lines
5-6 say that the elements of s1 are widths of things; just which
things must be determined contextually. Line 7 says the relation
e is the "wider than" relation; x1 and x2 are parameters in this
relation.

```
(forall (s s1 e)
   (iff (widthScale s s1 e)
        (exists (u x1 x2)
           (and (scaleDefinedBy s s1 e)
                (forall (n)
                   (if (member n s1) (exists (x) (width n x u)))
                       (wider' e x1 x2)))))
```


To be wide is to be in the `Hi` region of a width scale. The chief
inferences one can defeasibly draw from something being in the `Hi` region
of a scale are distributional -- e.g., wider than average -- and
functional -- wide enough or too wide for some purpose.

```
(forall (x)
   (iff (wide x)
        (exists (s s0 s1)
           (and (widthScale s s1 e) (Hi s0 s) (inScale x s0)))))
```


The comparative relation "narrower" is just the inverse of "wider".

```
(forall (x1 x2)
   (iff (narrower x1 x2)
        (wider x2 x1)))
```


The adjective "narrow" picks out the `Lo` region of a width scale, just as
"wide" picks out the `Hi` region.

```
(forall (x)
   (iff (narrow x)
        (exists (s s0 s1)
           (and (widthScale s s1 e) (Lo s0 s) (inScale x s0)))))
```


Secondary shape/size terms, such as "plump", "skinny", "slender", and
"slim", can often be partially characterized in terms of basic adjectives.

```
(forall (x)
   (if (plump x)
       (and (wide x) (thick x))))
```


"Breadth" is a synonym of "width".

```
(forall (n x u)
   (iff (breadth n x u)
        (width n x u)))
```


If a book is standing on a table, its greatest dimension is vertical.

```
(forall (x p)
   (if (stand x p)
       (exists (c b x d f)
          (and (boundingBox b x) (dim1 c b x)
               (posZAxis d f) (directionOf d c)))))
```

If a book is lying or resting on a table, its greatest dimension is not
vertical.

```
(forall (x p)
   (if (lie x p)
       (exists (c b x d f)
          (and (boundingBox b x) (dim1 c b x)
               (posZAxis d f) (not (directionOf d c))))))
```


## Orientation and Rotation

Physical objects have a front have an intrinsic orientation, and that
orientation can change. This is called turning.

```
(forall (r x)
   (if (front r x)
       (iff (turn x d1 d2)
            (exists (e1 e2 f)
               (and (change e1 e2) (orientation' e1 d1 x f)
                    (orientation' e2 d2 x f))))))
```


Any physical object can turn, and we know it has if we can find an
external point p, a face r of the object facing p, and a framework f, such
that the `orientation0` of the object with respect to that face and
framework changes.

```
(forall (x d1 d2)
   (iff (turn x d1 d2)
        (exists (r p e1 e2 f)
           (and (face r x p)
                (change e1 e2) (orientation0' e1 d1 x r f)
                (orientation0' e2 d2 x r f)))))
```


For a predicate corresponding to the transitive verb "turn", we define
`turn2` that augments `turn` with the causality of an agent

```
(forall (a x d1 d2)
   (iff (turn2 a x d1 d2)
        (exists (e)
           (and (cause a e) (turn' e x d1 d2)))))
```


We won’t go very wrong if we take "turn" and "rotate" to mean the same thing.

```
(forall (x d1 d2)
   (iff (rotate x d1 d2)
        (turn x d1 d2)))
```


If the orientation of something changes from d1 to d2 and then changes
from d2 to d3, a composite change from d1 to d3 has occurred.

```
(forall (x d1 d2 d3)
   (if (and (turn x d1 d2)
            (turn x d2 d3))
       (turn x d1 d3)))
```


It will be useful to have a predicate for turning through an angle. Here v
is the angle formed by x's from- and to-orientations.

```
(forall (e x v)
   (iff (turnThru' e x v)
        (exists (d1 d2 o)
           (and (turn' e x d1 d2) (atLoc x o) (vertex v d1 d2 o)))))
```


We define a very restricted version of the composition of two angles.

```
(forall (v v1 v2 dk1 d2 d3 o)
   (if (vertex v1 d1 d2 o) (vertex v2 d2 d3 o)
       (iff (addVertex v v1 v2 o)
            (vertex v d1 d3 o))))
```


Two `turnThru` actions compose into a single `turnThru`.

```
(forall (e1 e2 x v1 v2)
   (if (and (turnThru' e1 x v1) (turnThru' e2 x v2))
       (exists (v e)
          (and (addVertex v v1 v2) (turnThru' e x v)))))
```


In a two-dimensional world you can turn in one of two ways -- clockwise
or counterclockwise. But it's not easy to define these concepts. You
can change from one orientation to another by turning either way. You
can do a right turn or three lefts. To get around this problem, we
define "clockwise" for acute angles in terms of `anchorPoint`s and then
define the general concept recursively by decomposing a large turn into an
acute angle turn plus a smaller clockwise turn. That is, e is `clockwise0`
exactly when e is a turn by x from direction d1 to direction d2 with
respect to framework f, object x is located at the origin of f, direction
d1 lies along the x-axis of f, directions d1 and d2 are the sides of a
vertex v, which is an acute angle, y is a point one unit u out from the
origin o on ray d2, and y1 is its y-coordinate -- so far we're just
drawing the picture; here comes the essential condition -- y1 is less than
the origin on the y-axis. Since angle v is acute, y is in the first or
fourth quadrant, so if y’s y-coordinate is lower than the origin on the
y-axis, y must be in the fourth quadrant, and so is the target direction
d2 of the turn.

```
(forall (e)
   (iff (clockwise0 e)
        (exists (x d1 d2 y f v o u y y1 a)
           (and (turn' e x d1 d2) (anchorPoint y f v d1 d2 o u)
                (atLoc x o) (acuteAngle v)
                (yCoordinate y1 y) (yAxis a f) (lts y1 o a)))))
```


The definition of `counterclockwise0` differs from `clockwise0` only in
the reversal of the arguments in the `lts` condition.

```
(forall (e)
   (iff (counterclockwise0 e)
        (exists (x d1 d2 y f v o u y y1 a)
           (and (turn' e x d1 d2) (anchorPoint y f v d1 d2 o u)
                (atLoc x o) (acuteAngle v)
                (yCoordinate y1 y) (yAxis a f) (lts o y1 a)))))
```


The general definition of `clockwise`: If it is a turn through an acute
angle only, it reduces to `clockwise0`. Otherwise we decompose the large
turning event into two smaller clockwise turns, one of which is an acute
angle turn.

```
(forall (e)
   (iff (clockwise e)
        (exists (v)
           (and (turnThru' e v)
                (or (and (acuteAngle v) (clockwise0 e))
                    (exists (e1 e2 v1 v2)
                       (and (turnThru' e1 v1) (turnThru' e2 v2)
                            (eventSequence e e1 e2) (addVertex v v1 v2)
                            (acuteAngle v1) (clockwise v1)
                            (clockwise v2))))
                 (not (exists (e0 v0)
                         (and (turnThru' e0 v0) (subevent e0 e)
                              (counterclockwise e0))))))))
```


The definition of `counterclockwise` is almost identical to `clockwise`.

```
(forall (e)
   (iff (counterclockwise e)
        (exists (v)
           (and (turnThru' e v)
                (or (and (acuteAngle v) (counterclockwise0 e))
                    (exists (e1 e2 v1 v2)
                       (and (turnThru' e1 v1) (turnThru' e2 v2)
                            (eventSequence e e1 e2) (addVertex v v1 v2)
                            (acuteAngle v1) (counterclockwise e1)
                            (counterclockwise e2))))
                 (not (exists (e0 v0)
                         (and (turnThru' e0 v0) (subevent e0 e)
                              (clockwise e0))))))))
```


## Composite Entities in Space

A composite entity is along a curve if its components are at points on
the curve.

```
(forall (z c s)
   (iff (along z c s)
        (and (compositeEntity z) (curve c) (subset c s)
             (forall (x)
                (if (componentOf x z)
                    (exists (y)
                       (and (inside y c) (at x y s))))))))
```


A composite entity can be over a region.

```
(forall (z  s)
   (iff (over z r s)
        (and (compositeEntity z) (region r) (subset r s)
             (forall (x)
                (if (componentOf x z)
                    (exists (y)
                       (and (inside y r) (at x y s))))))))
```


A line is a concrete entity that lies along a line.

```
(forall (x)
   (if (lineObj x)
       (exists (c)
          (and (lineSegment c) (along x c)))))
```
