# English Lexical Axioms

```
(forall (x)
  (if (business x)
      (exists (e)
        (business-nn e x))))
```

```
(forall (x)
  (if (car x)
      (exists (e)
        (car-nn e x))))
```

```
(forall (x)
  (if (building x)
      (exists (e)
        (building-nn e x))))
```

```
(forall (x)
  (if (door x)
      (exists (e)
        (door-nn e x))))
```

```
(forall (x)
  (if (foundation x)
      (exists (e)
        (foundation-nn e x))))
```

```
(forall (x)
  (if (scaffolding x)
      (exists (e)
        (scaffolding-nn e x))))
```

```
(forall (x)
  (if (lubricant x)
      (exists (e)
        (lubricant-nn e x))))
```

```
(forall (x)
  (if (wheel x)
      (exists (e)
        (wheel-nn e x))))
```

```
(forall (x)
  (if (engine x)
      (exists (e)
        (engine-nn e x))))
```

```
(forall (x)
  (if (engine x)
      (exists (e)
        (motor-nn e x))))
```

```
(forall (x)
  (if (nuclearReactor x)
      (exists (e1 e2)
        (and (nuclear-adj e1 x) (reactor-nn e2 x)))))
```

```
(forall (e)
  (if (meltdown e)
      (exists (e1)
        (meltdown-nn e1 e))))
```

```
(forall (e)
  (if (future e)
      (exists (e1)
        (future-nn e1 e))))
```

```
(forall (e)
  (if (destiny e)
      (exists (e1)
        (destiny-nn e1 e))))
```
