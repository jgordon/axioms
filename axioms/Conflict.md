# Conflict

Jonathan Gordon, Jerry Hobbs, Katya Ovchinnikova, Alicia Sagae

This is a less developed theory than some of the others, which was
constructed for use in the Metaphor project.


## Predicates

- `(conflict c x y g h)`: c is a conflict between x and y with goals g
  and h respectively.
- `(adversary e x y c)`: x and y are adversaries in the conflict c.
- `(attack e x y)`: x attacks y
- `(goal e g x)`: g is a goal of x.
- `(win e x y c)`: x wins over y in conflict c.
- `(victory e x y c)`: in victory, x wins over y in conflict c.
- `(lose e y x c)`: y loses to x in conflict c.
- `(weapon w)`: w is a weapon
- `(slap e x y)`: x slaps y
- `(aim e x w y)`: x aims weapon w at y
- ...


## Axioms

### Conflict

A conflict has two adversaries.

```
(forall (c x y g h)
  (if (conflict c x y g h)
      (exists (e)
        (adversary e x y c))))
```


In conflict, adversaries attack each other.

```
(forall (c x y g h e)
  (if (and (conflict c x y g h) (adversary e x y c))
      (attack e x y)))
```


Adversaries have contradictory goals.

```
(forall (e g x)
  (if (goal e g x)
      (exists (y h)
        (conflict c x y g h))))
```

```
(forall (e1 e2 x y c g)
  (if (and (adversary e1 x y c) (goalNot e2 g y))
      (exists (e3)
        (goal e3 g x))))
```


The adversary relation is symmetric.

```
(forall (e x y c)
  (if (adversary e x y c)
      (exists (e1)
        (adversary e1 y x c))))
```


TODO: Adversaries have degrees of strength.


To win is to achieve the goal.

```
(forall (e e1 e2 e3 c x y g h)
  (if (and (conflict c x y g h) (adversary e x y c) (goal e1 g x)
           (goal e2 h y) (accomplish-goal e3 g x))
      (win e x y c)))
```


Victory is winning.

```
(forall (c x y g h e)
  (if (and (conflict c x y g h) (adversary e x y c) (win e x y c))
      (victory e x y c)))
```


To lose is for your adversary to win.

```
(forall (e x y c)
  (if (win e x y c)
      (lose e y x c)))
```


Adversaries use weapons in attacks.

```
(forall (e1 x y)
  (if (attack e1 x y)
      (exists (w z)
        (and (use e1 x w y z) (weapon w)))))
```


A slap is an attack.

```
(forall (e1 x y)
  (if (attack e1 x y)
      (slap e1 x y)))
```


Aiming is preparation for attack.

```
(forall (e x y a)
  (if (and (prepare e x a) (attack e x y))
      (exists (w)
        (aim e x w y))))
```


### War

TODO: Adversaries in war are groups to which members are loyal.

TODO: A flank is a part of a group adversary that is not strong.

TODO: A frontline is a part of a group adversary that attacks.

TODO: Members of groups sometimes defect.

TODO: Subgroups of groups sometimes revolt.


### Sports

TODO: Sport is conflict constrained by rules of behavior.

TODO: In some sports, the adversaries are teams of persons.


#### Boxing

A boxing match is a conflict.

```
(forall (c x y g h)
  (if (and (conflict c x y g h) (etc))
      (boxing-match c)))
```


TODO: Boxing is a sport.

TODO: A blow is an attack in boxing.

TODO: A low blow is a blow against the rules.

TODO: Adversaries are in the same weight class.

TODO: Heavyweight is the highest weight class.

TODO: A round is a part of a boxing match.


#### Racing

TODO: Racing is a sport.

TODO: A marathon is a race.

TODO: A race has stages.


#### Wrestling

TODO: Wrestling is a sport.


#### Card games

TODO: A card game is a sport.

TODO: A hand is a weapon in an attack.


### Politics

A nation is a dynamic functional composite entity with the goal of
having its citizens thrive.

```
(forall (x f s)
  (if (and (dFCompEnt x) (function f x) (thrive f s)
           (citizens s x))
      (nation x)))
```


A union is an organization with the goal of having its members thrive.

```
(forall (e1 e2 m1 u)
  (if (and (thrive e1 m1) (members m1 u) (goal e2 e1 u))
      (union u)))
```


TODO: Political parties:

```
(forall (e x y g1 g2)
  (if (conflict e x y g1 g2)
      (politicalParty x)))
```

```
(forall (x y f)
  (if (and (dFCompEnt x) (function f x) (lead' f x y))
      (politicalParty x)))
```


## Lexical Axioms

### Conflict

#### Conflict Nouns

```
(forall (e x y g h)
  (if (conflict e x y g h)
      (exists (e1)
        (conflict-nn e1 e))))
```

```
(forall (e x y g h)
  (if (conflict e x y g h)
      (exists (e1)
        (struggle-nn e1 e))))
```

```
(forall (e x y g h)
  (if (conflict e x y g h)
      (exists (e1)
        (battle-nn e1 e))))
```

```
(forall (e x y g h)
  (if (conflict e x y g h)
      (exists (e1)
        (fight-nn e1 e))))
```

```
(forall (e x y g h)
  (if (conflict e x y g h)
      (exists (e1)
        (dispute-nn e1 e))))
```

```
(forall (e x y g h)
  (if (conflict e x y g h)
      (exists (e1)
        (war-nn e1 e))))
```

```
(forall (e x y g h)
  (if (conflict e x y g h)
      (exists (e1)
        (combat-nn e1 e))))
```

```
(forall (e x y g h)
  (if (conflict e x y g h)
      (exists (e1)
        (quarrel-nn e1 e))))
```

```
(forall (e x y g h)
  (if (conflict e x y g h)
      (exists (e1)
        (competition-nn e1 e))))
```

```
(forall (e x y g h)
  (if (conflict e x y g h)
      (exists (e1)
        (race-nn e1 e))))
```

```
(forall (e x y g h)
  (if (conflict e x y g h)
      (exists (e1)
        (revolt-nn e1 e))))
```


```
(forall (e)
  (if (boxing-match e)
      (exists (e1)
        (boxing-nn e1 e))))
```


#### Conflict Verbs

X combats Y.

```
(forall (e e1 x y g h)
  (if (and (conflict e x y g h) (adversary e1 x y e))
      (exists (u2)
        (combat-vb e x y u2))))
```


G and H are goals that conflict.

```
(forall (e x y g h)
  (if (conflict e x y g h)
      (exists (u1 u2)
        (conflict-vb e g u1 u2))))
```

```
(forall (e x y g h)
  (if (conflict e x y g h)
      (exists (e1 u1 u2)
        (and (conflict-vb e g u1 u2) (with-in e1 e y)))))
```


X struggles..

```
(forall (e e1 x y g h)
  (if (and (conflict e x y g h) (adversary e1 x y e))
      (exists (u1 u2)
        (struggle-vb e x u1 u2))))
```


X battles.

```
(forall (e e1 x y g h)
  (if (and (conflict e x y g h) (adversary e1 x y e))
      (exists (u1 u2)
        (battles-vb e x u1 u2))))
```


X fights.

```
(forall (e e1 x y g h)
  (if (and (conflict e x y g h) (adversary e1 x y e))
      (exists (u1 u2)
        (fight-vb e x u1 u2))))
```


X disputes.

```
(forall (e e1 x y g h)
  (if (and (conflict e x y g h) (adversary e1 x y e))
      (exists (u1 u2)
        (dispute-vb e x u1 u2))))
```


X quarrels.

```
(forall (e e1 x y g h)
  (if (and (conflict e x y g h) (adversary e1 x y e))
      (exists (u1 u2)
        (quarrel-vb e x u1 u2))))
```


X opposes Y.

```
(forall (e e1 x y g h)
  (if (and (conflict e x y g h) (adversary e1 x y e))
      (exists (u2)
        (oppose-vb e x y u2))))
```


X confronts Y.

```
(forall (e e1 x y g h)
  (if (and (conflict e x y g h) (adversary e1 x y e))
      (exists (u2)
        (confront-vb e x y u2))))
```


X resists Y.

```
(forall (e e1 x y g h)
  (if (and (conflict e x y g h) (adversary e1 x y e))
      (exists (u2)
        (resist-vb e x y u2))))
```


X withstands attack W.

```
(forall (e e1 x y g h)
  (if (and (conflict e x y g h) (attack e1 x y))
      (exists (w u2)
        (withstand-vb e x w u2))))
```


X competes.

```
(forall (e e1 x y g h)
  (if (and (conflict e x y g h) (adversary e1 x y e))
      (exists (u1 u2)
        (compete-vb e x u1 u2))))
```


X revolts.

```
(forall (e e1 x y g h)
  (if (and (conflict e x y g h) (adversary e1 x y e))
      (exists (u1 u2)
        (revolt-vb e x u1 u2))))
```


#### Conflict Prepositional Phrases

```
(forall (e e1 x y)
  (if (adversary e1 x y e)
      (exists (e2 u g h)
        (and (conflict e x u g h) (with-in e2 e y)))))
```

```
(forall (e e1 x y)
  (if (adversary e1 x y e)
      (exists (e2 u g h)
        (and (conflict e x u g h) (against-in e2 e y)))))
```

```
(forall (e e1 x y)
  (if (adversary e1 x y e)
      (exists (e2 e3 u1 u2 g h)
        (and (conflict e u1 u2 g h) (between-in e2 e x) (between-in e3 e y)))))
```

```
(forall (e e1 x y)
  (if (adversary e1 x y e)
      (exists (e2 u h)
        (and (conflict e x y u h) (for-in e2 e g)))))
```

```
(forall (e e1 x y)
  (if (adversary e1 x y e)
      (exists (e2 u h)
        (and (conflict e x y u h) (over-in e2 e g)))))
```

```
(forall (e e1 x y)
  (if (adversary e1 x y e)
      (exists (e2 u h)
        (and (conflict e x y u h) (of-in e2 e g)))))
```


### Adversary

#### Adversary Nouns

Y's adversary, X.

```
(forall (e e1 x y g h)
  (if (and (conflict e x y g h) (adversary e1 x y e))
      (adversary-nn e1 x)))
```


Y's enemy, X.

```
(forall (e e1 x y g h)
  (if (and (conflict e x y g h) (adversary e1 x y e))
      (enemy-nn e1 x)))
```


Opponent X.

```
(forall (e e1 x y g h)
  (if (and (conflict e x y g h) (adversary e1 x y e))
      (opponent-nn e1 x)))
```


Rival X.

```
(forall (e e1 x y g h)
  (if (and (conflict e x y g h) (adversary e1 x y e))
      (rival-nn e1 x)))
```


Antagonist X.

```
(forall (e e1 x y g h)
  (if (and (conflict e x y g h) (adversary e1 x y e))
      (antagonist-nn e1 x)))
```


Competitor X.

```
(forall (e e1 x y g h)
  (if (and (conflict e x y g h) (adversary e1 x y e))
      (competitor-nn e1 x)))
```


Contestant X.

```
(forall (e e1 x y g h)
  (if (and (conflict e x y g h) (adversary e1 x y e))
      (contestant-nn e1 x)))
```


Opposition X.

```
(forall (e e1 x y g h)
  (if (and (conflict e x y g h) (adversary e1 x y e))
      (opposition-nn e1 x)))
```


Player X.

```
(forall (e e1 x y g h)
  (if (and (conflict e x y g h) (adversary e1 x y e))
      (player-nn e1 x)))
```


Team X.

```
(forall (e e1 x y g h)
  (if (and (dFCompEnt x) (conflict e x y g h) (adversary e1 x y e))
      (exists (e2)
        (team-nn e2 x))))
```


Band X.

```
(forall (e e1 x y g h)
  (if (and (dFCompEnt x) (conflict e x y g h) (adversary e1 x y e))
      (exists (e2)
        (band-nn e2 x))))
```


Gang X.

```
(forall (e e1 x y g h)
  (if (and (dFCompEnt x) (conflict e x y g h) (adversary e1 x y e))
      (exists (e2)
        (gang-nn e2 x))))
```


```
(forall (e e1 x y g h)
  (if (and (dFCompEnt x) (conflict e x y g h) (adversary e1 x y e))
      (exists (e2 u)
        (defection-nn e2 u))))
```


```
(forall (e e1 x y)
  (if (adversary e1 x y e)
      (exists (e2)
        (flank-nn e2 x))))
```


#### Adversary Verbs

```
(forall (e e1 x y g h)
  (if (and (conflict e x y g h) (adversary e1 x y e))
      (exists (e2 u1 u2)
        (defect-vb e2 x u1 u2))))
```


#### Adversary Prepositional Phrases

x adversary of y

```
(forall (e e1 e2 x y u)
  (if (adversary e1 x y e)
      (and (adversary e1 x u e) (of-in e2 x y))))
```


x adversary in conflict e

```
(forall (e e1 e2 x y u)
  (if (adversary e1 x y e)
      (and (adversary e1 x y u) (in-in e2 x e))))
```


### Goals

```
(forall (e1 g x)
  (if (goal e1 g x)
      (goal-nn e1 g)))
```


x wants g

```
(forall (e1 x g u)
  (if (goal e1 g x)
      (want-vb e1 x g u)))
```


g, goal of x

```
(forall (e1 e2 g x)
  (if (goal e1 g x)
      (and (goal-nn e1 g) (of-in e2 g x))))
```


An adversary has a strategy
The relationship between the plan and the goals is unclear, but one is
evidence for the other.

```
(forall (e e1 g x u1)
  (if (goal e1 g x)
      (plan-nn e u1)))
```

```
(forall (e1 g x u1)
  (if (goal e1 g x)
      (strategy-nn e u1)))
```


### Attack

#### Attack Nouns

an attack

```
(forall (e1 x y)
  (if (attack e1 x y)
      (exists (e0)
        (attack-nn e0 e1))))
```

```
(forall (e1 x y)
  (if (attack e1 x y)
      (exists (e0)
        (assault-nn e0 e1))))
```

```
(forall (e1 x y)
  (if (attack e1 x y)
      (exists (e0)
        (onrush-nn e0 e1))))
```

```
(forall (e1 x y)
  (if (attack e1 x y)
      (exists (e0)
        (onset-nn e0 e1))))
```

```
(forall (e1 w y)
  (if (attack e1 w y)
      (exists (e0)
        (barrage-nn e0 e1))))
```

```
(forall (e1 w y)
  (if (attack e1 w y)
      (exists (e0)
        (insult-nn e0 e1))))
```

```
(forall (e1 w y)
  (if (attack e1 w y)
      (exists (e0)
        (blitz-nn e0 e1))))
```

```
(forall (e1 x y)
  (if (attack e1 x y)
      (exists (e0)
        (blow-nn e0 e1))))
```

A low blow is an illegal attack.

```
(forall (e1 x y)
  (if (and (illegal e1) (attack e1 x y))
      (exists (e0 e4)
        (and (blow-nn e0 e1) (low-adj e4 e1)))))
```

aggressor x

```
(forall (e1 x y)
  (if (attack e1 x y)
      (exists (e0)
        (aggressor-nn e0 x))))
```

sniper x

```
(forall (e1 x y)
  (if (attack e1 x y)
      (exists (e0)
        (sniper-nn e0 x))))
```

#### Attack Verbs

x attacks y

```
(forall (e1 x y)
  (if (attack e1 x y)
      (exists (u)
        (attack-vb e1 x y u))))
```

x assails y

```
(forall (e1 x y)
  (if (attack e1 x y)
      (exists (u)
        (assail-vb e1 x y u))))
```

x charges at y

```
(forall (e1 x y)
  (if (attack e1 x y)
      (exists (e0 w u)
        (and (charge-vb e1 x w u) (at-in e0 e1 y)))))
```

x descends on y

```
(forall (e1 x y)
  (if (attack e1 x y)
      (exists (e0 w u)
        (and (descend-vb e1 x w u) (on-in e0 e1 y)))))
```

x advances on y

```
(forall (e1 x y)
  (if (attack e1 x y)
      (exists (e0 u)
        (and (advance-vb e1 x y u) (on-in e0 e1 y)))))
```

x insults y

```
(forall (e1 x y)
  (if (attack e1 x y)
      (exists (u)
        (insult-vb e1 x y u))))
```

x launches an attack

```
(forall (a x y)
  (if (attack a x y)
      (exists (e2 u u1)
        (and (launch-vb e2 x a u) (attack a u1 y)))))
```

```
(forall (a x y)
  (if (attack a x y)
      (exists (e1 e2 u)
        (and (launch-vb e2 x a u) (blitz-nn e1 a)))))
```

x blows y away

```
(forall (e1 x y)
  (if (attack e1 x y)
      (exists (e2 u1 u2)
        (and (blow-vb e1 x y u2) (away-in e2 e1 u1)))))
```


#### Attack Prepositional Phrases

```
(forall (e1 x y)
  (if (attack e1 x y)
      (exists (e2 u1)
        (and (attack e1 x u1) (on-in e2 e1 y)))))
```


```
(forall (e1 x y)
  (if (attack e1 x y)
      (exists (e2 u1)
        (and (attack e1 x u1) (at-in e2 e1 y)))))
```

```
(forall (e1 x y)
  (if (attack e1 x y)
      (exists (e2 u1)
        (and (attack e1 x u1) (of-in e2 e1 y)))))
```


#### Attack Adjectives

```
(forall (e x y)
  (if (attack e x y)
      (exists (e2 e1)
        (lethal-adj e2 e1))))
```


### Slap

```
(forall (e1 x y)
  (if (slap e1 x y)
      (exists (u)
        (slap-vb e1 x y u))))
```

```
(forall (e x y)
  (if (slap e x y)
      (exists (e1)
        (slap-nn e1 e))))
```


### Use a Weapon

X uses W (generally)
```
(forall (e1 x w y z)
  (if (use e1 x w y z)
      (exists (u)
        (use-vb e1 x w u))))
```


#### Weapon Nouns

E1 is a shot by X with W
```
(forall (e1 w x y z)
  (if (use-weapon e1 x w y z)
      (exists (e0)
        (shot-nn e0 e1))))
```

E1 is a stroke by X with W
```
(forall (e1 w x y z)
  (if (use-weapon e1 x w y z)
      (exists (e0)
        (stroke-nn e0 e1))))
```

E1 is a blast
```
(forall (e1 x y)
  (if (attack e1 x y)
      (exists (e0)
        (blast-nn e0 e1))))
```

E1 is an explosion
```
(forall (e1 x y)
  (if (attack e1 x y)
      (exists (e0)
        (explosion-nn e0 e1))))
```

E1 is gunfire
```
(forall (e1 x y)
  (if (attack e1 x y)
      (exists (e0)
        (gunfire-nn e0 e1))))
```


#### Weapon Verbs

```
(forall (e1 w x y z)
  (if (use-weapon e1 x w y z)
      (exists (u2)
        (shoot-vb e1 x y u2))))
```

```
(forall (e1 w x y z)
  (if (use-weapon e1 x w y z)
      (exists (u2)
        (hit-vb e1 x y u2))))
```

```
(forall (e1 w x y z)
  (if (use-weapon e1 x w y z)
      (exists (u2)
        (bomb-vb e1 x y u2))))
```

```
(forall (e1 w x y z)
  (if (use-weapon e1 x w y z)
      (exists (u2)
        (fire-vb e1 x y u2))))
```

```
(forall (e1 w x y z)
  (if (use-weapon e1 x w y z)
      (exists (u2)
        (blast-vb e1 x y u2))))
```

```
(forall (e1 w x y z)
  (if (use-weapon e1 x w y z)
      (exists (u2)
        (explode-vb e1 x y u2))))
```

```
(forall (e1 w x y z)
  (if (use-weapon e1 x w y z)
      (exists (u2)
        (slaughter-vb e1 x y u2))))
```

```
(forall (e1 w x y z)
  (if (use-weapon e1 x w y z)
      (exists (u2)
        (knife-vb e1 x y u2))))
```

```
(forall (e1 w x y z)
  (if (use-weapon e1 x w y z)
      (exists (u2)
        (stab-vb e1 x y u2))))
```


#### Weapon Prepositional Phrases

```
(forall (e1 w x y z)
  (if (use-weapon e1 x w y z)
      (exists (e2 u)
        (and (use-weapon e1 x u y z) (with-in e2 e1 w)))))
```

```
(forall (e1 w x y z)
  (if (use-weapon e1 x w y z)
      (exists (e2 u)
        (and (use-weapon e1 x u y z) (by-in e2 e1 w)))))
```

```
(forall (e1 w x y z)
  (if (use-weapon e1 x w y z)
      (exists (e2 u)
        (and (use-weapon e1 x u y z) (of-in e2 e1 w)))))
```

```
(forall (e1 w x y z)
  (if (use-weapon e1 x w y z)
      (exists (e2 u)
        (and (use-weapon e1 x u y z) (at-in e2 e1 w)))))
```


#### Weapon Expansion Axioms

```
(forall (e1 w x y z)
  (if (and (use e1 x w y z) (weapon w))
      (use-weapon e1 x w y z)))
```

```
(forall (e1 w x y z)
  (if (use-weapon e1 x w y z)
      (exists (u)
        (and (use-weapon e1 w u y z) (weapon w)))))
```


### Aim

Aim a weapon at a target.

x aims w at y

```
(forall (e1 w x y)
  (if (aim e1 x w y)
      (exists (u)
        (aim-vb e1 x w u))))
```


x targets y

```
(forall (e1 w x y)
  (if (aim e1 x w y)
      (target-vb e1 x y w)))
```


```
(forall (e1 w x y)
  (if (aim e1 x w y)
      (crosshairs-nn e1 w)))
```


To train a weapon on a target is to aim at the target.

x trains w on y

```
(forall (e1 w x y)
  (if (aim e1 x w y)
      (exists (e2 u)
        (and (train-vb e1 x w u) (on-in e2 e1 y)))))
```

```
(forall (e1 x w y)
  (if (aim e1 x w y)
      (exists (e2 u)
        (and (aim-vb e1 x w u) (at-in e2 e1 y)))))
```


### Weapon

```
(forall (w)
  (if (weapon w)
      (exists (e1)
        (weapon-nn e1 w))))
```

```
(forall (w)
  (if (weapon w)
      (exists (e1)
        (arm-nn e1 w))))
```

```
(forall (w)
  (if (weapon w)
      (exists (e1)
        (gun-nn e1 w))))
```

```
(forall (w)
  (if (weapon w)
      (exists (e1)
        (knife-nn e1 w))))
```

```
(forall (w)
  (if (weapon w)
      (exists (e1)
        (missile-nn e1 w))))
```

```
(forall (w)
  (if (weapon w)
      (exists (e1)
        (stick-nn e1 w))))
```

```
(forall (w)
  (if (weapon w)
      (exists (e1)
        (pike-nn e1 w))))
```

```
(forall (w)
  (if (weapon w)
      (exists (e1)
        (projectile-nn e1 w))))
```

```
(forall (w)
  (if (weapon w)
      (exists (e1)
        (spear-nn e1 w))))
```

```
(forall (w)
  (if (weapon w)
      (exists (e1)
        (bomb-nn e1 w))))
```

```
(forall (w)
  (if (weapon w)
      (exists (e1)
        (sword-nn e1 w))))
```

```
(forall (w)
  (if (weapon w)
      (exists (e1)
        (artillery-nn e1 w))))
```

```
(forall (w)
  (if (weapon w)
      (exists (e1)
        (revolver-nn e1 w))))
```

```
(forall (w)
  (if (weapon w)
      (exists (e1)
        (pistol-nn e1 w))))
```

```
(forall (w)
  (if (weapon w)
      (exists (e1)
        (shotgun-nn e1 w))))
```

```
(forall (w)
  (if (weapon w)
      (exists (e1)
        (firearm-nn e1 w))))
```


### Sports

```
(forall (c e x y)
  (if (and (boxing-match c) (adversary e x y c))
      (exists (e1)
         (heavyweight-adj e1 x))))
```

```
(forall (c g h r x y)
  (if (and (subevent r c) (conflict c x y g h))
      (exists (e1)
        (round-nn e1 r))))
```

```
(forall (c g h r x y)
  (if (and (subevent r c) (conflict c x y g h))
      (exists (e1)
        (stage-nn e1 r))))
```


### Build-Destroy

To decrease structure is to damage.

```
(forall (x)
  (if (decreaseStruct x)
      (exists (e y u)
        (damage-vb e y x u))))
```


One way of decreasing structure is to destroy.

```
(forall (x)
  (if (decreaseStruct x)
      (exists (e y u)
        (destroy-vb e y x u))))
```


One way of decreasing structure is to demolish.

```
(forall (x)
  (if (decreaseStruct x)
      (exists (e y u)
        (demolish-vb e y x u))))
```


One way of decreasing structure is to be a cataclysm.
x is cataclysmic.

```
(forall (e1 x)
  (if (decreaseStruct' e1 x)
      (exists (e)
        (cataclysmic-adj e e1))))
```


One way of decreasing structure is to be a cataclysm.
e1 is a cataclysm that harms x

```
(forall (x)
  (if (decreaseStruct x)
      (exists (e e1)
        (cataclysm-nn e e1))))
```


```
(forall (x)
  (if (and (dFCompEnt x) (decreaseStruct x))
      (exists (e e1)
        (meltdown-nn e e1))))
```


One way of increasing structure is to build.

```
(forall (x)
  (if (increaseStruct x)
    (exists (e z u)
      (build-vb e z x u))))
```


One way of increasing structure is to forge.

```
(forall (x)
  (if (and (dFCompEnt x) (increaseStruct x))
      (exists (e y u)
        (forge-vb e y x u))))
```


z paralyzes x

```
(forall (x)
  (if (and (dFCompEnt x) (decreaseFct x))
      (exists (e z u)
        (paralyze-vb e z x u))))
```


z incapacitates x

```
(forall (x)
  (if (and (dFCompEnt x) (decreaseFct x))
      (exists (e z u)
        (incapacitate-vb e z x u))))
```


z facilitates x

```
(forall (y)
  (if (and (dFCompEnt y) (increaseFct y))
      (exists (e x z u)
        (facilitate-vb e z x u))))
```


z assists x

```
(forall (x)
  (if (and (dFCompEnt x) (increaseFct x))
      (exists (e z u)
        (facilitate-vb e z x u))))
```


z hums

```
(forall (x)
  (if (and (dFCompEnt x) (increaseFct x))
      (exists (e u1 u2)
        (hum-vb e x u1 u2))))
```

```
(forall (y)
  (if (and (dFCompEnt y) (increaseFct y))
      (exists (e x)
        (hum-nn e x))))
```


z rebuilds x

```
(forall (x)
  (if (and (dFCompEnt x) (increaseStruct x))
      (exists (e u z)
        (rebuild-vb e z x u))))
```


z detonates x

```
(forall (x)
  (if (and (dFCompEnt x) (decreaseFct x))
      (exists (e u z)
        (detonate-vb e z x u))))
```


z injures x

```
(forall (x)
  (if (and (dFCompEnt x) (decreaseFct x))
      (exists (e u z)
        (injure-vb e z x u))))
```


x falls apart

```
(forall (x)
  (if (and (dFCompEnt x) (decreaseStruct x))
      (exists (e e1 y u)
        (and (fall-vb e x y u) (apart-adv e1 e)))))
```


z cracks x

```
(forall (x)
  (if (and (dFCompEnt x) (decreaseStruct x))
      (exists (e u z)
        (crack-vb e z x u))))
```


x grows

```
(forall (x)
  (if (and (dFCompEnt x) (increaseStruct x))
      (exists (e u y)
        (grow-vb e x y u))))
```


x grows y

```
(forall (x y)
  (if (and (dFCompEnt x) (increaseStruct y))
      (exists (e u)
        (grow-vb e x y u))))
```


z strengthens x

```
(forall (x)
  (if (and (dFCompEnt x) (increaseStruct x))
      (exists (e u z)
        (strengthen-vb e z x u))))
```


scorched x

```
(forall (x)
  (if (and (dFCompEnt x) (decreaseStruct x))
      (exists (e)
        (scorched-adj e x))))
```


### Governance DFCEs

```
(forall (x)
  (if (nation x)
      (exists (e)
        (nation-nn e x))))
```


```
(forall (c g1 g2 x y)
  (if (conflict c x y g1 g2)
      (nation x)))
```


```
(forall (x)
  (if (nation x)
      (exists (e)
        (mexico-nn e x))))
```


```
(forall (x)
  (if (nation x)
      (exists (e)
        (russia-nn e x))))
```


```
(forall (x)
  (if (nation x)
      (exists (e)
        (iran-nn e x))))
```


```
(forall (x)
  (if (nation x)
      (exists (e)
        (america-nn e x))))
```


```
(forall (f s x)
  (if (and (dFCompEnt x) (function f x) (thrive f s) (citizens s x))
      (exists (e)
        (country-nn e x))))
```


```
(forall (f s x)
  (if (and (dFCompEnt x) (function f x) (thrive f s) (citizens s x))
      (exists (e)
        (state-nn e x))))
```


```
(forall (f s x)
  (if (and (dFCompEnt x) (function f x) (thrive f s) (citizens s x))
      (exists (e)
        (government-nn e x))))
```


```
(forall (f s x)
  (if (and (dFCompEnt x) (function f x) (thrive f s) (citizens s x))
      (exists (e)
        (administration-nn e x))))
```


```
(forall (f s x z)
  (if (and (dFCompEnt x) (function f x) (control f x s) (citizens s z))
      (exists (e)
        (law-nn e x))))
```


```
(forall (f s x)
  (if (and (dFCompEnt x) (function f x) (lead' f s x) (citizens s x))
      (exists (e)
        (democracy-nn e x))))
```


```
(forall (f s x)
  (if (and (dFCompEnt x) (function f x) (control f x s) (citizens s z))
      (exists (e)
        (authoritarianism-nn e x))))
```


```
(forall (f x)
  (if (and (dFCompEnt x) (function f x) (commerce f))
      (exists (e)
        (economy-nn e x))))
```


```
(forall (f x)
  (if (and (dFCompEnt x) (function f x) (commerce f))
      (exists (e)
        (economic-adj e x))))
```


```
(forall (f x)
  (if (and (dFCompEnt x) (function f x) (commerce f))
      (exists (e)
        (sector-nn e x))))
```


```
(forall (f x)
  (if (and (dFCompEnt x) (function f x) (commerce f))
      (exists (e)
        (transportation-nn e x))))
```


```
(forall (f x)
  (if (and (dFCompEnt x) (function f x) (commerce f))
      (exists (e)
        (financial-adj e x))))
```


```
(forall (f x)
  (if (and (dFCompEnt x) (function f x) (commerce f))
      (exists (e)
        (fiscal-adj e x))))
```


```
(forall (f x)
  (if (and (dFCompEnt x) (function f x) (commerce f))
      (exists (e)
        (business-nn e x))))
```


```
(forall (f x)
  (if (and (dFCompEnt x) (function f x) (commerce f))
      (exists (e)
        (market-nn e x))))
```


```
(forall (f x)
  (if (and (dFCompEnt x) (function f x))
      (exists (e)
        (system-nn e x))))
```


```
(forall (f x)
  (if (and (dFCompEnt x) (function f x))
      (exists (e)
        (body-nn e x))))
```


```
(forall (f x)
  (if (and (dFCompEnt x) (function f x) (sharedPlan f x))
      (exists (e)
        (organization-nn e x))))
```


```
(forall (f x)
  (if (and (dFCompEnt x) (function f x))
      (exists (e)
        (program-nn e x))))
```


```
(forall (f x)
  (if (and (dFCompEnt x) (function f x))
      (exists (e)
        (class-nn e x))))
```


```
(forall (f x)
  (if (and (dFCompEnt x) (function f x))
      (exists (e)
        (progress-nn e x))))
```


```
(forall (f x y z)
  (if (and (dFCompEnt x) (function f x) (respect' f y z x))
      (exists (e)
        (reputation-nn e x))))
```


### Politics

```
(forall (e e1 g x y)
  (if (and (persuade e x y g) (goal e1 g x))
      (exists (e0 u1)
        (lobby-vb e0 x y u1))))
```

```
(forall (e e1 g x y)
  (if (and (persuade e x y g) (goal e1 g x))
      (exists (e0)
        (lobbying-nn e0 e))))
```


```
(forall (e e1 g x y)
  (if (and (persuade e x y g) (goal e1 g x))
      (exists (e0)
        (lobby-nn e0 x))))
```


```
(forall (x)
  (if (voter x)
      (exists (e y)
        (voter-nn e y))))
```


```
(forall (a b g1 g2 x)
  (if (conflict x a b g1 g2)
      (exists (e)
        (election-nn e x))))
```


```
(forall (a b g1 g2 x)
  (if (conflict x a b g1 g2)
      (exists (e y)
        (elect-vb e x y g1))))
```


x votes

```
(forall (a b e1 g1 g2 x)
  (if (and (conflict e1 a b g1 g2) (members x a))
      (exists (e u)
        (vote-vb e x a u))))
```


x votes for y

```
(forall (a b e1 g1 g2 x)
  (if (and (conflict e1 a b g1 g2) (members x a))
      (exists (e e2 u)
        (and (vote-vb e x a u) (for-in e2 e g1)))))
```


```
(forall (c g h x y z)
  (if (and (conflict c x y g h) (lead' g z c))
      (exists (e)
        (politics-nn e c))))
```


```
(forall (c g h x y z)
  (if (and (conflict c x y g h) (lead' g z c))
      (exists (e)
        (politician-nn e x))))
```


```
(forall (e p p5 x5)
  (if (and (politics-nn e p5) (nn p x5))
      (exists (e1)
        (political-adj e1 x))))
```


```
(forall (x)
  (if (politicalParty x)
      (exists (e)
        (contributor-nn e x))))
```


```
(forall (x)
  (if (politicalParty x)
      (exists (e)
        (democratic-adj e x))))
```


```
(forall (x)
  (if (politicalParty x)
      (exists (e)
        (democrat-nn e x))))
```


```
(forall (x)
  (if (politicalParty x)
      (exists (e)
        (republican-nn e x))))
```


```
(forall (x)
  (if (politicalParty x)
      (exists (e)
        (republican-adj e x))))
```


```
(forall (x)
  (if (politicalParty x)
      (exists (e)
        (gop-nn e x))))
```


```
(forall (x)
  (if (politicalParty x)
      (exists (e)
        (right-winger-nn e x))))
```


```
(forall (x)
  (if (politicalParty x)
      (exists (e e1 e2 y)
        (and (tea-nn e1 y) (nn e2 y x) (party-nn e x)))))
```


```
(forall (x)
  (if (politicalParty x)
      (exists (e)
        (pri-nn e x))))
```


```
(forall (x)
  (if (politicalParty x)
      (exists (e)
        (movement-nn e x))))
```


```
(forall (x)
  (if (politicalParty x)
      (exists (e)
        (effort-nn e x))))
```


```
(forall (x)
  (if (politicalParty x)
      (exists (e e1)
        (and (political-adj e1 x) (party-nn e x)))))
```


```
(forall (x)
  (if (politicalParty x)
      (exists (e)
        (party-nn e x))))
```


```
(forall (c g1 g2 x y)
  (if (conflict c x y g1 g2)
      (exists (e)
        (and (democratic-adj e x) (attack c x y)))))
```


```
(forall (c g1 g2 x y)
  (if (conflict c x y g1 g2)
      (exists (e)
        (and (republican-adj e x) (attack c x y)))))
```


y is vulnerable

```
(forall (c g1 g2 x y)
  (if (conflict c x y g1 g2)
      (exists (e)
        (vulnerable-adj e y))))
```


```
(forall (c e1 g1 g2 x y)
  (if (and (conflict c x y g1 g2) (adversary e1 x y c))
      (exists (e)
        (side-nn e x))))
```


### Lead

#### Lead Nouns

```
(forall (e6 x y)
  (if (lead' e6 x y)
      (exists (e)
        (president-nn e x))))
```


```
(forall (e6 x y)
  (if (lead' e6 x y)
      (exists (e)
        (leader-nn e x))))
```


```
(forall (e6 x y)
  (if (lead' e6 x y)
      (exists (e)
        (governor-nn e x))))
```


```
(forall (e6 x y)
  (if (lead' e6 x y)
      (exists (e)
        (mayor-nn e x))))
```


```
(forall (e6 x y)
  (if (lead' e6 x y)
      (exists (e)
        (speaker-nn e x))))
```


```
(forall (e6 x y)
  (if (lead' e6 x y)
      (exists (e)
        (chairman-nn e x))))
```


```
(forall (e6 x y)
  (if (lead' e6 x y)
      (exists (e)
        (king-nn e x))))
```


```
(forall (e6 x y)
  (if (lead' e6 x y)
      (exists (e)
        (queen-nn e x))))
```


```
(forall (e6 x y)
  (if (lead' e6 x y)
      (exists (e)
        (emir-nn e x))))
```


```
(forall (e6 x y)
  (if (lead' e6 x y)
      (exists (e e0)
        (and (prime-adj e0 x) (minister-nn e x)))))
```


```
(forall (e6 x y)
  (if (lead' e6 x y)
      (exists (e)
        (minister-nn e x))))
```


```
(forall (e6 x y)
  (if (lead' e6 x y)
      (exists (e)
        (chief-nn e x))))
```


```
(forall (e6 x y)
  (if (lead' e6 x y)
      (exists (e)
        (boss-nn e x))))
```


```
(forall (e6 x y)
  (if (lead' e6 x y)
      (exists (e)
        (captain-nn e x))))
```


```
(forall (e6 x y)
  (if (lead' e6 x y)
      (exists (e)
        (commander-nn e x))))
```


```
(forall (e6 x y)
  (if (lead' e6 x y)
      (exists (e)
        (general-nn e x))))
```


```
(forall (e6 x y)
  (if (lead' e6 x y)
      (exists (e)
        (ruler-nn e x))))
```


```
(forall (e6 x y)
  (if (lead' e6 x y)
      (exists (e)
        (head-nn e x))))
```


```
(forall (e6 x y)
  (if (lead' e6 x y)
      (exists (e)
        (manager-nn e x))))
```


```
(forall (e6 x y)
  (if (lead' e6 x y)
      (exists (e)
        (shah-nn e x))))
```


```
(forall (e6 x y)
  (if (lead' e6 x y)
      (exists (e)
        (sheikh-nn e x))))
```


```
(forall (e6 x y)
  (if (lead' e6 x y)
      (exists (e)
        (principal-nn e x))))
```


```
(forall (e6 x y)
  (if (lead' e6 x y)
      (exists (e)
        (ringleader-nn e x))))
```


leader of y
```
(forall (e6 x y)
  (if (lead' e6 x y)
      (exists (e u y)
        (and (lead' e x u) (of-in e1 e y)))))
```


#### Lead Verbs

```
(forall (e6 x y)
  (if (lead' e6 x y)
      (exists (e u2)
        (lead-vb e x y u2))))
```


```
(forall (e6 x y)
  (if (lead' e6 x y)
      (exists (e u2)
        (drive-vb e x y u2))))
```


```
(forall (e6 x y)
  (if (lead' e6 x y)
      (exists (e u2)
        (guide-vb e x y u2))))
```


```
(forall (e6 x y)
  (if (lead' e6 x y)
      (exists (e u2)
        (manage-vb e x y u2))))
```


```
(forall (e6 x y)
  (if (lead' e6 x y)
      (exists (e u2)
        (rule-vb e x y u2))))
```


```
(forall (e6 x y)
  (if (lead' e6 x y)
      (exists (e u2)
        (head-vb e x y u2))))
```


```
(forall (e6 x y)
  (if (lead' e6 x y)
      (exists (e u2)
        (direct-vb e x y u2))))
```


### Other English Lexical Axioms

```
(forall (x)
  (if (union x)
      (exists (w)
        (union-nn w x))))
```


```
(forall (g m)
  (if (members m g)
      (exists (e1)
        (member-nn e1 m))))
```


m is a member of g

```
(forall (g m)
  (if (members m g)
      (exists (e1 e2)
        (and (member-nn e1 m) (of-in e2 m g)))))
```


u is part of w

```
(forall (u w)
  (if (part u w)
      (exists (e1 e2 x)
        (and (part-nn e1 x) (of-in e2 x w)))))
```


m thrives

```
(forall (e1 m)
  (if (thrive e1 m)
      (exists (e2 u y)
        (thrive-vb e2 m y u))))
```
