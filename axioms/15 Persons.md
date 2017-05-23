# 15 Persons

## Predicates

- `(person p)`: p is a person.
- `(body b p)`: b is p's body.
- `(mind m p)`: m is p's mind.
- `(bodyPart x p)`: x is one of p's body parts.
- `(bodyPartsOf s p)`: s is the set of p's body parts.
- `(perceive a x)`: Agent a perceives x.
- `(senseOrgan o p)`: o is one of p's sense organs.

## Axioms

15.1 A person is a kind of agent.

```
(forall (p)
  (if (person p)
      (agent p)))
```

15.2 A person is also a kind of physical object.

```
(forall (p)
  (if (person p)
      (physobj p)))
```

15.3 A person has a body and a mind.

```
(forall (p)
  (if (person p)
      (exists (b m)
        (and (body b p) (mind m p)))))
```

15.4 The mind is a composite entity.

```
(forall (m p)
  (if (mind m p)
      (compositeEntity m)))
```

15.5 A body is a physical object.

```
(forall (b p)
  (if (body b p)
      (physobj b)))
```

15.6 A body is a composite entity whose components are body parts.
In fact, it's a spatial system, since all the body parts are physical
objects.

```
(forall (b p)
  (if (body b p)
      (and (spatialSystem b)
           (exists (s)
             (and (componentsOf s b)
                  (forall (x)
                    (iff (member x s) (bodyPart x p))))))))
```

15.7 A person `p` has a set of body parts, namely, the components of the
body.

```
(forall (p s)
  (iff (bodyPartsOf s p)
       (exists (b)
         (and (person p) (body b p) (componentsOf s b)))))
```

15.8 The predicate `perceive` is a relation between an agent and an entity
or eventuality external to the mind.

```
(forall (a x m)
  (if (and (perceive a x) (mind m a))
      (and (agent a) (externalTo x m))))
```

15.9 Something being near a person is an enabling condition for perceiving
it.

```
(forall (p x e2)
  (if (perceive' e2 p x)
      (exists (e1 s)
        (and (near' e1 x p s) (enable e1 e2)))))
```

15.10 The sense organs are a subset of the body parts.

```
(forall (p x)
  (if (and (person p) (bodyPartsOf s1 p))
      (exists (s2)
        (and (subset s2 s1)
             (forall (o)
               (iff (member o s2) (senseOrgan o p)))))))
```

15.11 Sense organs are body parts.

```
(forall (o p)
  (if (senseOrgan o p)
      (bodyPart o p)))
```

15.12 When something is perceived, there is a sense organ whose intact-ness
enables the perception.

```
(forall (p x e2)
  (if (and (person p) (perceive' e2 p x))
      (exists (o e1)
        (and (senseOrgan o p) (intact' e1 o) (enable e1 e2)))))
```

15.13 Another subset of body parts can be directly controlled by a person's
will. That is, the person's willing an event is the direct cause of the
motion of the body part.

```
(forall (p s1)
  (if (and (person p) (bodyPartsOf s1 p))
      (exists (s2)
        (and (subset s2 s1)
             (forall (x)
               (if (member x s2)
                   (exists (e1 e2 y z)
                     (and (move' e2 x y z) (will' e1 p e2)
                          (dcause e1 e2)))))))))
```

15.14 Example of an axiom for a more detailed account of human physical
control: A person can voluntarily lift his or her arm.

```
(forall (p)
  (if (person p)
      (exists (e1 e2 x)
        (and (lift' e2 p x) (arm x p) (will' e1 p e2)
             (dcause e1 e2)))))
```
