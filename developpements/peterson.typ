#import "../utils.typtp": *
#import "@preview/codly:1.1.1": *
#import "@preview/codly-languages:0.1.1": *
#import "dev_tplt.typtp": developpement
#import "@preview/syntree:0.2.0": tree

#show: developpement.with(
  titre: [Construction de l'algorithme de Peterson], 
  niveau: [MP2I], 
  prerequis: [Concurrence, notions de C])


= Objectifs du développement
C'est un développement pédagogique, qui vise à présenter plusieurs idées pour réaliser l'exclusion mutuelle de deux fils d'executions, en présentant les problèmes de chaque solution pour finalement aboutir sur l'algorithme de Peterson. L'idée ici, est de donner aux éléves l'intuition derrière chaque élément de l'algorithme. 

Pour être plus précis, on cherche un algorithme de la forme suivante : 

#underline[Squelette de code #text(fill: red)[(les X symbolisent la place à laisser libre)]:] 
```C
X
X

void entree_section(int process) {
  X
  X
  X
  X
  X
}

void sortie_section(int process) {
  X
}
```

Qui vérifie les propriétés suivantes : 
- Exclusion mutuelle : Il y a au maximum un fil d'execution dans la section critique à tout instant. 
- Absence de famine : Si les fils restent toujours dans la section critique un temps fini, alors tout fil qui le souhaite accède à la section critique en temps fini. 

= Première idée : une variable d'occupation
Idée : on a un booléen global, et quand un thread va dans la section critique, il le passe à vrai, et l'autre attend. 
```C
bool entree = false; 

void entree_section(int process) {
  while (entree);
  entree = true; 
}

void sortie_section(int process) {
  entree = false;
}
```

Problème : 
- si les deux thread entrent en même temps, on a pas l'exclusion mutuelle ... Il faudrait écrire avant de lire ! 
- Si un thread sort puis rentre à nouveau avant que l'autre ai pu rentrer, il y a famine ! il faudrait un système de priorité ... 

= Deuxième idée : Deux variables d'occupation 
Idée : Pour éviter les conflits de lecture / écriture, on met deux variables booléenne. 
```C
bool entree[2] = {false, false}; 

void entree_section(int process) {
  int other = 1 - process; 

  entree[process] = true;

  while (entree[other]);
}

void sortie_section(int process) {
  entree[process] = false;
}
```
On  a l'absence d'interblocage ! \
Problèmes : 
- si les deux thread entrent en même temps, on peut avoir un interblocage, car chacun attend que l'autre aie terminé. 
- Le deuxième problème reste. 

= Troisième idée : Chacun son tour
Idée : Les thread passent chacun leur tour. Comme ça, on évite les famines ! 

```C
int turn = 0; 

void entree_section(int process) {
  while (turn != process);
}

void sortie_section(int process) {
  turn = 1 - process; 
}
```

Pas d'interblocage, et, si les thread essayent tous les deux d'accéder à la section critique, on a pas de famine non plus ! 

Problème : Si un seul thread accède à la section critique, il va rester bloqué... 

= L'algorithme de Peterson : on combine tout
#block(breakable: false)[
#underline[Algorithme de Peterson]
```C
int turn = 0;
bool entree[2] = {false, false} 

void entree_section(int process) {
  int other = 1 - process; 
  entree[process] = true; 
  turn = other; 

  while (entree[other] && turn == other);
}

void sortie_section(int process) {
  entree[process] = false; 
}
```
]

Explication rapide des propriétés : 
- Exclusion mutuelle : Si les deux étaient dans la section critique, on aurait
  - `entree[0]==true` et `entree[1]==true`
  - Les deux "while" dépassés, donc `turn==0` et `turn==1`
  Absurde !

- Absence de famine : Supposons qu'un processus reste bloqué (le 0 par exemple), on a alors, à chaque test : 
  - `entree[1]==true` 
  - `turn==1`
  Or, comme le processus 1 ne reste pas dans la section critique, ça veut dire qu'il ré-appelle `entree_section`, et donc qu'il place `turn` à `0` définitivement. Absurde ! 






