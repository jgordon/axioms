# 17 Making Things

## Topology

We first introduce several topological predicates without attempting
to define them.

A point is a 0-dimensional entity. A curve is a 1-dimensional entity,
perhaps embedded in a higher dimensional space.

- `(point x)`: x is a point.
- `(curve c)`: c is a curve.

A point can be inside a curve or it can be an endpoint of a curve.

- `(inside x c)`: Point x is inside curve c.

```
(forall (x c)
  (if (inside x c)
      (and (point x) (curve c))))
```

`(endpoint x c)`: Point x is an endpoint of curve c.

```
(forall (x c)
  (if (endpoint x c)
      (and (point x) (curve c))))
```

The ontology is silent on whether endpoints are inside their curves.
It is generally safest to proceed as if they are not.

Three important kinds of curves are lines, rays, and line segments.

- `(line l)`: l is a line.
- `(ray l)`: l is a ray.
- `(lineSegment l)`: l is a line segment.

A line does not have endpoints.

```
(forall (l)
  (if (line l)
      (not (exist (x)
             (endpoint x l)))))
```

A ray has exactly one endpoint.

```
(forall (l)
  (if (ray l)
      (exist (x)
        (and (endpoint x l)
             (forall (x1)
               (if (endpoint x1 l) (equal x1 x)))))))
```

A line segment has two distinct endpoints.

```
(forall (l)
  (if (lineSegment l)
      (exist (x1 x2)
        (and (endpoint x1 l) (endpoint x2 l)
             (nequal x1 x2)))))
```

All three are linear.

```
(forall (l)
  (iff (linear l)
       (or (line l) (ray l) (lineSegment l))))
```

All three are curves.

```
(forall (l)
  (if (linear l)
      (curve l)))
```

If a curve is closed, it has no endpoints.

```
(forall (c)
  (if (closed c)
      (not (exist (x)
             (endpoint x c)))))
```

We could give a definition of "closed" as a finite curve with no
endpoints, but defining "finite" would take us too far afield.

One curve can be inside (an interior part of) another curve.

```
(forall (c1 c2)
  (iff (insideCurve c1 c2)
       (forall (x)
         (and (if (inside x c1)
                  (inside x c2))
              (if (endpoint x c1)
                  (inside x c2))))))
```

A line segment has a line it is part of.

```
(forall (l1)
  (if (lineSegment l1)
      (exist (l2)
        (and (line l2) (insideCurve l1 l2)))))
```

A region is a 2-dimensional entity embedded in a 2- or 3-dimensional
space.

- `(region r)`: r is a region.

Regions can have a boundary, which is a curve.

```
(forall (c r)
  (if (boundary c r)
      (and (curve c) (region r))))
```

Some regions, such as the surface of a sphere, do not have
boundaries.

For a point to be on the boundary of a region is for it to be inside
the boundary.

```
(forall (x r)
  (iff (onBoundary x r)
       (exist (c) (and (boundary c r) (inside x c)))))
```

A volume is a 3-dimensional entity. It can have a surface, which is a
region.

```
(forall (r v)
  (if (surface r v)
      (and (region r) (volume v))))
```

It is straightforward to define the RCC8 relations in terms of these
topological concepts. For example the definition of "tangential
proper part" is as follows:

```
(forall (r1 r2)
  (iff (tpp r1 r2)
       (and (forall (x)
              (if (inside x r1) (inside x r2)))
            (forall (x)
              (if (onBoundary x r1)
                  (or (inside x r2) (onBoundary x r2))))
            (exist (x)
              (and (onBoundary x r1) (onBoundary x r2))))))
```

The definitions of the other RCC8 relations are left as an exercise to
the reader.

It is also possible to define relations among volumes in terms of
these topological concepts.


## Polygons

We first describe what it is to join two curves and then specialize
that to vertices. We define what it is to be the side of a polygon
and then we will define a polygon itself. Quadrilaterals are a
specialization of polygons.

We join two curves with endpoints by stipulating that one endpoint of
one coincides with one endpoint of the other.

The first step toward defining polygons is to define the figure formed
by joining two curves at an endpoint of each. We can call these figures
"joined curves".

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
straight line, the point at which they meet is called a "vertex".

```
(forall (v l1 l2 x)
  (iff (vertex v l1 l2 x)
       (and (linear l1) (linear l2) (not (linear v))
            (joinedCurves v l1 l2 x))))
```

A vertex thus consists of the angle and two sides, which are line
segments or rays.

As an intermediate step toward defining polygons, we will say a line
segment is a side of a figure if there are vertices at its two
endpoints that lie inside the figure.

```
(forall (l p)
  (iff (sideOf l p)
       (exist (l1 l2 v1 v2 x1 x2)
         (and (vertex v1 l1 l x1) (vertex v2 l l2 x2)
              (nequal x1 x2)
              (insideCurve v1 p) (insideCurve v2 p)))))
```

A polygon is then a closed curve that is made up of n sides.

```
(forall (p n)
  (iff (polygon p n)
       (exist (s)
         (and (forall (l)
                (iff (member l s) (sideOf l p)))
              (forall (x)
                (if (inside x p)
                    (exist (l)
                      (and (member l s)
                        (or (inside x l) (endpoint x l))))))
              (closed p)
              (card n s)))))
```

Lines 4-5 say that the set s is the set of sides of the polygon.
Lines 6-10 say that every point in the polygon is either in a side or
is a vertex. Line 11 says the polygon is a closed curve, and line 12
says n is the cardinality of the set of sides.

If n is 4, we have a quadrilateral.

```
(forall (p)
  (iff (quadrilateral p) (polygon p 4)))
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

The predicate "distance" has the usual mathematical properties.  The
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
(forall (l x1 x2 x3 d1 d2 d3 u)
  (if (and (lineSegment l) (endpoint x1 l) (endpoint x3 l)
           (nequal x1 x3) (inside x2 l) (distance d1 x1 x2 u)
           (distance d2 x2 x3 u) (distance d3 x1 x3 u))
       (sum d3 d1 d2)))
```

The length of a line segment is the distance between its endpoints.

```
(forall (d l u)
  (iff (length d l u)
       (exist (x1 x2)
              (and (nequal x1 x2)(endpoint x1 l)(endpoint x2 l)
                   (distance d x1 x2 u)))))
```

A rhombus is a quadrilateral whose sides are all equal.

```
(forall (p)
  (iff (rhombus p)
       (and (quadrilateral p)
            (exist (d u)
              (forall (l)
                (if (sideOf l p) (length d l u)))))))
```


## Frameworks and Coordinate Systems

The relation "above" has two interpretations. In the two-dimensional
case, it means farther away from the observer. We'll call this
relation "above2". In the three-dimensional case, it means farther
away from the Earth. We'll call this "above3". There is a similar
ambiguity in the terms "horizontal" and "vertical". In the
two-dimensional case, the y-axis is vertical. In the
three-dimensional case, it is horizontal.

In this section, we first define two-dimensional coordinate systems.
We are trying to remain as noncommital as possible in our definitions,
so that they apply as broadly as possible. So until late in this
section we assume about the axes only that they are partial orderings.
They need not be numerical, or even linear.

At the end of the section, we discuss three-dimensional frameworks.

We assume we have two relations, "above2" and "rightOf". They are
relative to a framework f. "(above2 y2 y1 f)" says that y2 is above y1
(in the two-dimensional sense) in framework f. We can't yet say that
our two axes are orthogonal, because we have not yet dealt with
angles. But we can say they are independent in the sense that we
cannot predict one relation from the other.

```
(forall (f)
  (if (framework f)
      (exist (x1 x2 x3 y1 y2 y3)
        (and (above2 x1 x2 f) (above2 x1 x3 f)
             (rightOf x1 x2 f) (rightOf x3 x1 f)
             (rightOf y1 y2 f) (rightOf y1 y3 f)
             (above2 y1 y2 f) (above2 y3 y1 f)))))
```

Lines 4-5 say that an "above2" relation between two points does not
determine a "rightOf" relation. Lines 6-7 say that a "rightOf"
relation between two points does not determine an "above2" relation.

A framework has a set of entities we will call its domain. The
entities can participate in the "above2" and "rightOf" relations, but
we postpone axiomatizing that til the end of this section.

```
(forall (f)
  (if (framework f)
      (exist (s)
        (and (set s) (domain s f)))))
```

A non-null subset of the domain is horizontal if no element is
"above2" any other element. We use the predicate "horizontal2"
because as stated above, the two- and three-dimensional cases differ.

```
(forall (s1 f)
  (iff (horizontal2 s1 f)
       (exist (s)
         (and (domain s f) (subset s1 s) (not (null s1))
              (not (exist (x1 x2)
                     (and (member x1 s1) (member x2 s1)
                          (above2 x1 x2 f))))))))
```

A similar axiom defines "vertical2".

```
(forall (s1 f)
  (iff (vertical2 s1 f)
       (exist (s)
         (and (domain s f) (subset s1 s) (not (null s1))
              (not (exist (x1 x2)
                     (and (member x1 s1) (member x2 s1)
                          (rightOf x1 x2 f))))))))
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
      (exist (a1 a2)
        (and (xAxis a1 f)(yAxis a2 f)
             (forall (a)
               (and (if (nequal a a1) (not (xAxis a f)))
                    (if (nequal a a2) (not (yAxis a f)))))))))
```

```
(forall (f a1 a2 s)
  (if (and (framework f) (xAxis a1 f) (yAxis a2 f)
           (intersection s a1 a2))
      (exist (o)
        (and (singleton s o) (origin o f)))))
```

A framework thus consists of a domain, two independent relations and
two unique corresponding axes that intersect in a single element
called the origin.

Any element in the domain can have an x-coordinate and a
y-coordinate. An element of the domain has an x-coordinate if there
is a vertical subset that contains both the element and an element of
the x-axis.

```
(forall (x1 x f)
  (iff (xCoordinate x1 x f)
       (exist (v a1)
         (and (vertical2 v f) (member x v) (xAxis a1 f)
              (member x1 v) (member x1 a1)))))
```

A y-coordinate can be defined similarly.

```
(forall (y1 x f)
  (iff (yCoordinate y1 x f)
       (exist (h a2)
         (and (horizontal2 h f) (member x h) (yAxis a2 f)
              (member y1 h) (member y1 a2)))))
```

*** observer-based framework, f is volatile, change by moving around table

*** from here to end of section, under construction

To construct a three-dimensional framework, we introduce another
relation `above3`, which is independent from "above2" and "rightOf".

```
(forall (f)
   (if (and (framework f) (3D f))
       (exist (x1 x2 x3 y1 y2 y3 z1 z2 z3 w1 w2 w3)
          (and (above3 x1 x2 f) (above3 x1 x3 f)
               (rightOf x1 x2 f) (rightOf x3 x1 f)
               (rightOf y1 y2 f) (rightOf y1 y3 f)
               (above3 y1 y2 f) (above3 y3 y1 f)
               (above3 z1 z2 f) (above3 z1 z3 f)
               (above2 z1 z2 f) (above2 z3 z1 f)
               (above2 w1 w2 f) (above2 w1 w3 f)
               (above3 w1 w2 f) (above3 w3 w1 f)))))
```

```
(forall (s1 f)
   (iff (vertical3 s1 f)
        (exist (s)
           (and (domain s f) (subset s1 s) (not (null s1))
                (not (exist (x1 x2)
                        (and (member x1 s1) (member x2 s1)
                             (or (rightOf x1 x2 f)
                                 (above2 x1 x2 f)))))))))
```

```
(forall (a3 f)
   (if (zAxis az f)
       (and (framework f) (3D f) (vertical3 a3 f))))
```

```
(forall (f)
   (if (and (framework f) (3D f))
       (exist (a3)
          (and (zAxis a3 f)
               (forall (a)
                  (if (nequal a a3) (not (zAxis a f))))))))
```

```
(forall (f a1 a2 a3 s s1)
   (if (and (framework f) (3D f)
            (xAxis a1 f) (yAxis a2 f) (zAxis a3 f)
            (intersection s1 a1 a2) (intersection s s1 a3))
       (exist (o)
          (and (singleton s o) (origin o f)))))
```

```
(forall (z1 x f)
   (iff (xCoordinate z1 x f)
        (exist (v a1)
           (and (vertical3 v f) (member x v) (xAxis a1 f)
                (member x1 v) (member x1 a1)))))
```

need plane

```
(forall (f)
   (if (framework f)
       (iff (3D f) (exist (a3) (zAxis a3 f)))))
```

```
(forall (f)
   (if (framework f)
       (iff (2D f) (not (exist (a3) (zAxis a3 f))))))
```

above3, zAxis, horizontal3,

2D: no zAxis, (3D f)

not empty - 2D --> above2 x1 x2, sim 3D


coord sys: axes numerical, hence linear; relations >
   framework w numeric scales

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


## Angles

We would like to be able to talk about the angles at vertices being
greater than, equal to, or less than the angle at some other vertex,
and about specific kinds of angles, such as acute, right, and obtuse,
and 45-degree angles. We develop these idea in two steps. First we
define what it is for two angles to be equal regardless of where they
are located. We do this in terms of isoceles triangles. Then we
anchor the vertex at the origin of a framework and define the various
concepts in terms of x- and y- coordinates. In all this we assume we
have a distance metric, but the axes of the framework are not
necessarily numeric until we reach some of the concepts at the end.

We construct an isoceles triangle whose apex is a given vertex, by
identifying a point a unit distance out on each leg from the vertex.

```
(forall (l v u)
  (iff (baseOfAngle l v u)
       (exist (l1 l2 x0 x1 x2)
         (and (vertex v l1 l2 x0) (nequal x1 x2)
              (inside x1 l1) (distance 1 x0 x1 u) (endpoint x1 l)
              (inside x2 l2) (distance 1 x0 x2 u) (endpoint x2 l)
              (lineSegment l)))))
```

We have constructed an isoceles triangle whose apex at x0 is the vertex of
interest, whose two equal sides are l1 and l2, whose base is l, and
whose base angles are at x1 and x2.

Now we can say that two vertices are equal whenever the bases of their
angles are of equal length.

```
(forall (v1 v2)
  (iff (equalAngle v1 v2)
       (exist (l1 l2 d u)
         (and (baseOfAngle l1 v1 u) (baseOfAngle l2 v2 u)
              (length d l1 u) (length d l2 u)))))
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

To be able to talk about the size of an angle in more detail,
we posit a framework (not necessarily a coordinate system) whose
x-axis contains one of the sides of the angle and whose origin
coincides with the vertex. Then the size of the angle can be
correlated with the y-coordinate. We call this framework an "anchor
framework" for the vertex.

```
(forall (f v l1 l2 o)
  (iff (anchorFramework f v l1 l2 o)
       (and (framework f) (vertex v l1 l2 o)
            (forall (a1) (if (xAxis a1 f) (insideCurve l1 a1)))
            (origin o f))))
```

We pick an arbitrary point on the side l2 of the vertex -- let's again
pick a point that is one distance unit out from the origin.

```
(forall (x v f l1 l2 o u)
  (iff (anchorPoint x v f l1 l2 o u)
       (and (anchorFramework f v l1 l2 o)
            (inside x l2) (distance 1 o x u))))
```

Now we can characterize the size of angles in terms of the
y-coordinate of the anchor point. First we define the greater-than
relation on angles that are anchored in the same framework -- call
this relation `gtAngle0`.

```
(forall (v2 v3)
   (iff (gtAngle0 v2 v3)
        (exist (f x1 v f l1 l2 o u)
           (and (anchorPoint x2 v2 f l1 l2 o u)
                (anchorPoint x3 v3 f l1 l3 o u)
                (yCoordinate y2 x2) (yCoordinate y3 x3)
                (yAxis a f) (gts y2 y3 a)))))
```

Recall that `(gts y2 y3 a)` says that y2 is greater than y3 on scale
a. So this axiom says that one angle is greater than another when the
y-coordinate of its anchor point is greater than the y-coordinate of
the other.

More generally, one angle is greater than another if it is equal to an
angle with the same anchor framework and that angle is greater than
(`gtAngle0`) the other.

```
(forall (v1 v2)
   (iff (gtAngle v1 v2)
        (exist (v3)(and (equalAngle v1 v3) (gtAngle0 v3 v2)))))
```

An angle is a right angle if the anchor point lies on the y-axis.

```
(forall (v l1 l2 o)
   (iff (rightAngle v l1 l2 o)
        (exist (a)
           (and (anchorPoint x v f l1 l2 o u)
                (yAxis a f) (xCoordinate o x)))))
```

An angle is acute if the x- and y-coordinates are both greater than
the origin.

```
(forall (v)
   (iff (acuteAngle v)
        (exist (x f l1 l2 o u)
           (and (anchorPoint x v f l1 l2 o u)
                (xCoordinate x1 x f) (yCoordinate y1 x f)
                (xAxis a1 f) (yAxis a2 f)
                (gts x1 o a1) (gts y1 o a2)))))
```

In daily life and absent precise measuring instruments, we don't judge
the size of angles down to the degree.  But we do make rough judgments
in two ways that are more fine-grained than the four cardinal
directions, and these can be characterized here. The first augments
the north-east-south-west system with the four intermediate directions
northeast, southeast, southwest and northwest.  This system is based
on angles of 45 degrees.

```
(forall (v)
   (iff (45Degrees v)
        (exist (x f l1 l2 o u d)
           (and (anchorPoint x v f l1 l2 o u)
                (xCoordinate x1 x f) (yCoordinate y1 x f)
                (distance d o x1 u) (distance d o y1 u)))))
```

The second fine-grained system is based on angles of 30 degrees and is
visualized as a clock -- "incoming at 2 o'clock," "exit the traffic
circle at 11 o'clock."

```
(forall (v)
   (iff (30Degrees v)
        (exist (x f l1 l2 o u d1 d2)
           (and (anchorPoint x v f l1 l2 o u)
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

------------------------------

***  UNDER CONSTRUCTION

Cubes


cube, face, edge, front, back, top, bottom

-------------------------

object at point, along curve, over region

move,

rotate, clockwise

building a square

finishing a square

