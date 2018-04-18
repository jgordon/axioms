# 11 Causality

## Predicates

- `(causalComplex c e)`: The collection c of eventualities is a
  causal complex for effect e.
- `(cause0 e1 e2)`: Eventuality e1 causes eventuality e2.
- `(cause e1 e2)`: Eventuality or agent e1 causes eventuality e2.
- `(agent a)`: a is an agent.
- `(agentOf a e)`: Agent a is the agent or cause of eventuality e.
- `(do a e)`: Agent a does action e.
- `(objectOf x e)`: x is the entity undergoing change in e.
- `(instrumentOf x e)`: x is an instrument used in e.
- `(sourceOf x e)`: e is a change in an “at” relation and x is the
  location of the initial “at” relation.
- `(terminusOf x e)`: e is a change in an “at” relation and x is
  the location of the final “at” relation.
- `(collective s)`: s is a collective of agents.
- `(causallyInvolved e1 e2)`: e1 is in some causal complex for e2.
- `(enable0 e1 e2 s)`: Eventuality e1 is a member of a causal
  complex s for eventuality e2 but not the cause of e2.
- `(enable e1 e2)`: Eventuality e1 is a member of every causal
  complex for eventuality e2 but not the cause of e2.
- `(allow e1 e2)`: e1 doesn't cause not e2.
- `(prevent e1 e2)`: e1 causes not e2.
- `(partiallyCause e1 e2)`: e1 together with something else causes e2.
- `(tcause e1 e2)`: e1 tends to cause e2.
- `(tcauseq e1 e2 q)`: e1 tends to cause e2 with likelihood q.
- `(evsBeyondControl s1 s a)`: s1 is the subset of eventualities in s
  that are not under agent a's control.
- `(able a e c)`: Agent a is able to do e under constraints c.
- `(ability e1 a e c)`: e1 is agent a's ability to do e under
  constraints c.
- `(dcause e1 e2)`: Eventuality or agent e1 directly causes eventuality e2
  without any intermediate causes.
- `(enabled s e t)`: All the enabling conditions for causal complex s
  resulting in eventuality e hold at time t.
- `(executable e a c)`: Action e is executable by agent a under
  constraints c.
- `(difficultiesWith s e)`: s is the set of obstructions tending to
  prevent action e from being performed.
- `(difficultyScale s e)`: s is a scale for measuring the difficulty
  of actions of type e.
- `(difficult e a)`: Action e is difficult for agent a.

## Axioms

11.1 An eventuality or set of eventualities, s, can be a causal complex
for an effect e.

```
(forall (s e)
  (if (causalComplex s e)
      (and (eventuality e)
           (or (eventualities s)
               (eventuality s)))))
```

11.2 Each member of a causal complex is relevant: If it is removed from
the set, the remainder is not a causal complex for the effect.

```
(forall (s s1 e1 e)
  (if (and (causalComplex s e) (member e1 s) (deleteElt s1 s e1))
      (not (causalComplex s1 e))))
```

11.3 A `cause0` is an eventuality in a causal complex; a conjunction of
the nonpresumable eventualities in a causal complex.

```
(forall (e1 e2)
  (if (cause0 e1 e2)
      (exists (s)
        (and (causalComplex s e2) (member e1 s)))))
```

11.4 `cause0` is defeasibly transitive.

```
(forall (e1 e2 e3)
  (if (and (cause0 e1 e2) (cause0 e2 e3) (etc))
      (cause0 e1 e3)))
```

11.5 `cause` is like `cause0`, but it allows an agent as its first
argument. When the first argument of `cause` is an eventuality, it
reduces to `cause0`. When it's an agent, the agent's willing is the
`cause0` of the second argument.

```
(forall (a e2)
  (and (if (eventuality a)
           (iff (cause a e2) (cause0 a e2)))
       (if (agent a)
           (iff (cause a e2)
                (exists (e1)
                  (and (will' e1 a e2) (cause0 e1 e2)))))
       (if (not (or (eventuality a) (agent a)))
           (not (cause a e2)))))
```

11.6 The chief property of agents is that they, defeasibly, are capable of
causing some events.

```
(forall (a)
  (if (and (agent a) (etc))
      (exists (e) (cause a e))))
```

11.7 Case roles common in linguistics can be defined in terms of core
theories. In particular, the agent of an event is an agent that
causes it.

```
(forall (a e)
  (iff (agentOf a e)
       (and (agent a) (cause a e))))
```

11.8 An agent a has done an action e iff a is the agent of the action and
the action really takes place.

```
(forall (a e)
  (iff (do a e)
       (and (agentOf a e) (Rexist e))))
```

11.9 The object of an action is the entity that goes through a change in
the final stage of the causal chain.

```
(forall (x e)
  (iff (objectOf x e)
       (or (changeIn' e x)
           (exists (e1 e2)
             (and (and' e e1 e2) (cause e1 e2) (objectOf x e2))))))
```

11.10 An instrument is an entity that the agent causes to go through a
change of state, where this change plays an intermediate role in the
causal chain.

```
(forall (y e)
  (iff (instrumentOf y e)
       (exists (a e1)
         (and (agentOf a e1) (changeIn' e1 y)
              (or (cause e1 e)
                  (exists (e2)
                    (and (cause e1 e2) (and' e e1 e2))))))))
```

When the property that changes in the object is a real or
metaphorical `at` relation, say, from (at x z s) to (at x w s), for
some s, then we can call z the source and w the goal (called the
`terminusOf` to avoid clashing with our primary use of `goal`).

11.11
```
(forall (z e)
  (iff (sourceOf z e)
       (exists (x w e1 e2 s)
         (and (at' e1 x z s) (at' e2 x w s) (change' e e1 e2)))))
```

11.12
```
(forall (w e)
  (iff (terminusOf w e)
       (exists (x z e1 e2 s)
         (and (at' e1 x z s) (at' e2 x w s) (change' e e1 e2)))))
```

11.13 Collectives are sets of agents working together.

```
(forall (s)
  (if (collective s)
      (forall (a) (if (member a s) (agent a)))))
```

11.14 An eventuality e1 is causally involved in bringing about some
effect e2 if it is in some causal complex for e2.

```
(forall (e1 e2)
  (iff (causallyInvolved e1 e2)
       (exists (s) (and (causalComplex s e2) (member e1 s)))))
```

11.15 The expression (enable0 e1 e2 s) says that e1 is an enabling
condition for e2 provided it is in the causal complex s that will be
used to bring about e2, but is not the cause of e2.

```
(forall (e1 e2 s)
  (iff (enable0 e1 e2 s)
       (and (causalComplex s e2) (member e1 s)
            (not (cause e1 e2)))))
```

11.16 If an eventuality e1 is required for any way of bringing about e2,
then we can use the two-argument predicate `enable`.

```
(forall (e1 e2)
  (iff (enable e1 e2)
       (forall (s)
         (if (causalComplex s e2) (enable0 e1 e2 s)))))
```

11.17 If e1 enables e2, then (not e1) causes (not e2).

```
(forall (e1 e2)
  (iff (enable e1 e2)
       (forall (e3)
         (if (not' e3 e1)
             (exists (e4)
               (and (not' e4 e2) (cause e3 e4)))))))
```

11.18 An eventuality e1 allows an eventuality e2 if e1 does not cause
(not e2).

```
(forall (e1 e2)
  (iff (allow e1 e2)
       (forall (e4)
         (if (not' e4 e2) (not (cause e1 e4))))))
```

11.19

```
(forall (e1 e2)
  (iff (prevent e1 e2)
       (exists (e4)
         (and (not' e4 e2) (cause e1 e4)))))
```

11.20 An eventuality e1 partially causes another eventuality e2 if e1's
conjunction with another eventuality e3 causes e2.

```
(forall (e1 e2)
  (iff (partiallyCause e1 e2)
       (exists (e3 e4)
         (and (not (cause e1 e2)) (not (cause e3 e2))
              (and' e4 e1 e3) (cause e4 e2)))))
```

11.21 The expression (tcause e1 e2) means that e1 tends to cause e2. If
(tcause e1 e2) holds, the other eventualities in the causal complex for
e2 are likely but not guaranteed to hold. Both `cause` and `tcause` are
defeasible, but `tcause` is more likely to be defeated.

```
(forall (e1 e2)
  (iff (tcause e1 e2)
       (exists (s c)
         (and (causalComplex s e2) (member e1 s)
              (deleteElt s1 s e1) (likely s1 c)
              (if (Rexist s)
                  (cause e1 e2))))))
```

11.22 e1 tends to cause e2 with likelihood q if e1 is in a causal complex
for e2, if the likelihood of the rest of s is q, and if e1 would be singled
out as a cause of e2 provided the rest of s actually obtains.

```
(forall (e1 e2 q c)
  (iff (tcauseq e1 e2 q c)
       (exists (s)
         (and (causalComplex s e2) (member e1 s)
              (deleteElt s1 s e1) (likelihood q s1 c)
              (if (Rexist s1) (cause e1 e2))))))
```

11.23 The notion `cause` is stronger than the notion `tcause` in the sense
that if e1 causes e2 then it tends to cause e2.

```
(forall (e1 e2)
  (if (cause e1 e2)
      (tcause e1 e2)))
```

11.24 We define the eventualities beyond an agent a's control as the
subset s1 of eventualities in a set s that a cannot bring about by a's
efforts alone. That is, a is not the agent of actions in s1 nor the agent
of an action that causes events in s1.

```
(forall (s1 s a)
  (iff (evsBeyondControl s1 s a)
       (and (eventualities s) (subset s1 s) (agent a)
            (forall (e)
              (iff (member e s1)
                   (and (not (agentOf a e))
                        (not (exists (e1)
                               (and (agentOf a e1)
                                    (cause e1 e))))))))))
```

11.25 We can say that an agent a is able to do e, given a set of
constraints c, if the agent's causing e is possible with respect to c
whenever the set s1 of all the events in a causal complex s for e that
are beyond a's control really exists independently.

```
(forall (a e c)
  (iff (able a e c)
       (exists (s s1 e1)
         (and (causalComplex s e) (cause' e1 a e) (member e1 s)
              (evsBeyondControl s1 s a)
              (if (Rexist s1) (possible e1 c))))))
```

11.26 Ability is the state of being able.

```
(forall (e1 a e c)
  (iff (ability e1 a e c) (able' e1 a e c)))
```

11.27 We can posit a notion of directly causes (`dcause`) as a relation
between an agent or event and an event, that is true when there are no
intermediate, mediating events.

```
(forall (e1 e2)
  (iff (dcause e1 e2)
       (and (cause e1 e2)
            (not (exists (e3)
                   (and (cause e1 e3) (cause e3 e2)))))))
```

11.28 If an agent can will an event to happen, then this willing is a
direct cause of the event.

```
(forall (e1 a e)
  (if (and (will' e1 a e) (cause e1 e))
      (dcause e1 e)))
```

11.29 An agent directly causes an event iff the agent's willing it to
happen directly causes it.

```
(forall (a e)
  (if (agent a)
      (iff (dcause a e)
           (exists (e1)
             (and (will' e1 a e) (dcause e1 e))))))
```

11.30 We will say that a causal complex for an eventuality is enabled at
time t if all its preconditions hold at time t.

```
(forall (s e t)
  (iff (enabled s e t)
       (forall (e1)
         (if (enable0 e1 e s) (atTime e1 t)))))
```

11.31 If an agent can directly cause an action that is enabled, then it is
executable. Moreover, if the action can be caused by another executable
action, then it is executable.

```
(forall (e a c t)
  (iff (executable e a c t)
       (exists (s)
         (and (enabled s e t)
              (or (exists (e1)
                    (and (dcause' e1 a e) (possible e1 c)))
                  (exists (e2)
                    (and (cause e2 e)
                         (executable e2 a c t))))))))
```

11.32 If an action is difficult for an agent, it is because there are
states and events, i.e., eventualities, that tend to cause the action
not to happen. The expression (difficult e a) says action e is difficult
for agent a.

```
(forall (a e)
  (if (difficult e a)
      (and (agent a) (agentOf a e))))
```

11.33 We define the set of difficulties associated with an action as the set
of eventualities that tend to cause the action not to happen. The
predicate `difficultiesWith` is a relation between a set of eventualities
and an eventuality.

```
(forall (s e)
  (iff (difficultiesWith s e)
       (forall (e1)
         (iff (member e1 s)
              (exists (e2)
                (and (not' e2 e) (tcause e1 e2)))))))
```

11.34 If the set of difficulties associated with achieving e1 contains
the set of difficulties associated with achieving e2, then e1 is more
difficult than e2.

```
(forall (s s1 e)
  (if (and (difficultyScale s e) (difficultiesWith' e1 s e))
      (subsetConsistent s e1)))
```

11.35 Something is difficult if it is in the `Hi` region of a difficulty
scale.

```
(forall (e1 e a)
  (iff (difficult' e1 e a)
       (and (agent a) (agentOf a e)
            (exists (s)
              (and (difficultyScale s e) (scaleFor s e1))))))
```
