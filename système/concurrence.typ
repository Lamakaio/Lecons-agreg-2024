#import "@preview/cetz:0.3.0"
#import "@preview/syntree:0.2.0": tree
#import "@preview/lovelace:0.3.0": *
#import "@preview/codly:1.1.1": *
#import "@preview/codly-languages:0.1.1": *
#import "../utils.typtp": *
#import "../developpements/dev_tplt.typtp": developpement


#show: developpement.with(
  titre: [Concurrence], 
  niveau: [Euh jsp], 
  prerequis: [Multitache])
= Introduction
blabla c'est pratique la concurrence.
== Les Data Race 
Dans un programme concurrent, on peut avoir des _data race_, c'est à dire des accès non protégés à la même adresse mémoire depuis différent fils d'executions (thread ou processus).

Il y a plusieurs types de _data race_ : 
- _read after read_ : deux fils lisent la même adresse. En général, cette _data race_ n'est pas un problème. 
- _write after write_ : deux fils écrivent à la même adresse. 
- _read after write_ : un fil écrit à une adresse, et un autre fil lit la même adresse. 

D'après la spécification du C et du C++, ces deux dernières sont `undefined behavior`, et donc à éviter à tout prix. 

== Modèle de consitence mémoire pour le multiprocessus
Pour parler de concurrence et de problèmes de synchronisation, il faut déjà savoir ce qui peut arriver. Pour ça, on a un *modèle* qui définit des règles d'executions pour les instructions. Ce modèle dépend de l'architecture du processeur ! 

Cela correspond principalement au réordonnement des instructions dans les architecture "out-of-order"

On définit classiquement trois types de modèles : 
- Modèle Séquentiel : les instructions mémoires sont executés dans l'ordre au sein de chaque thread. 
- Modèle Relaxé : certaines instructions mémoires peuvent être réordonnées. 
- Modèle Faible : Aucune garantie sur l'ordre des instructions mémoires, sauf à travers de barrières mémoires. 

#blk2[Exemple][
  #grid(
  columns: (1fr, 1fr, 1fr),
  gutter: 3pt,
  [processus 1 : 
  #codly(languages: codly-languages, fill: red.lighten(80%), zebra-fill: none)
```C
y1 = *x + 2; 
z1 = *x + *x;
```]
, 
[processus 2 : 
#codly(languages: codly-languages, fill: green.lighten(80%), zebra-fill: none)
```C
y2 = *x;
z2 = *x;
```], 
[processus 3 :
#codly(languages: codly-languages, fill: green.lighten(80%), zebra-fill: none)
```C
*x = 0;
*x = 1;
```])]

Les thread suivent un modèle mémoire séquentiel. Les processus ont un modèle mémoire relaxé (x86), voir faible (ARM, RISC-V).

= Algorithmes pour éviter les courses en mono-coeur

== Notion de section critique
On appelle _section critique_ la partie du code qui travaille sur la mémoire partagée. On veut qu'un seul fil puisse être dans sa section critique (pour une zone de mémoire partagée donnée) à chaque instant ! 


== Algorithme de Peterson
L'algorithme de Peterson est permet de gérer la synchronisation de plusieurs _thread_ autour d'une section critique, sans aucune primitive spécifique. 

(Attention, l'algorithme de Peterson ne fonctionne pas en multicoeur en général !)

L'algorithme est le suivant : 

Initialisation : 
  #codly(languages: codly-languages, fill: red.lighten(80%), zebra-fill: none)
```C
bool flag[2] = {false, false};
int turn = 0;
```
#grid(
  columns: (1fr, 1fr),
  gutter: 3pt,
  [thread 1 : 
  #codly(languages: codly-languages, fill: red.lighten(80%), zebra-fill: none)
```C
flag[0] = true;
turn = 1;
while (flag[1] && turn == 1) {
  //attente active
}

// section critique 
...
// fin de la section critique
flag[0] = false;

```]
, 
[thread 2 : 
#codly(languages: codly-languages, fill: green.lighten(80%), zebra-fill: none)
```C
flag[1] = true;
turn = 0;
while (flag[0] && turn == 0) {
  //attente active
}

// section critique 
...
// fin de la section critique
flag[1] = false;

```])



=== Preuve d'exclusion mutuelle
On aimerait prouver qu'un seul thread peut être dans la section critique à un moment donnée (ce qu'on appelle l'exclusion mutuelle). On se place dans le cas d'un modèle mémoire séquentiel, c'est à dire qu'on peut supposer que les instructions sont exécutés dans l'ordre dans chaque thread. 

Si le thread 1 est dans sa section critique, alors flag[0] est nécéssairement vrai. De plus, soit flag[1] est faux, soit turn vaut 0. 

Symmétriquement, si le thread 2 est dans sa section critique, alors flag[1] est vrai, et soit flag[0] est faux, soit turn vaut 1. 

Si on combine ces conditions, pour que les deux soit dans la section critique, on doit avoir flag[0] et flag[1] soient vrais, et turn = 1, et turn = 0. Absurde ! 

=== Preuve d'absence de famine
On aimerais prouver que, sous l'hypothèse que les sections critiques terminent toujours en un temps fini, alors chaque thread executera sa section critique après un temps fini.

Supposons (par symmétrie) que le thread 1 reste bloqué à l'infini dans sa boucle d'attente active. Cela veut dire qu'on a, à chaque test de la condition, flag[1] = true et turn = 1. De plus, comme seul le thread 1 écrit dans flag[0], flag[0] = true.

Donc, pour que le thread 2 entre dans la section critique, il faut qu'on aie turn = 1.

Or, le thread 2 place turn à 0 à chaque fois qu'il essaye d'entrer dans la section critique, et ne le place jamais à 1. Donc turn reste perpétuellement à 0. Absurde, car on a dit précédemment que turn reste à 1 ! 

== Algorithme de la boulangerie de Lamport

=== Intuition
L'intuition de l'algorithme est celle d'une salle d'attente : chaque client prend un ticket en entrant, et quand un client a le plus petit ticket existant, alors il sait que c'est son tour ! 

=== L'algorithme 

Chaque thread / processus a le code suivant : 

#codly()
```C
// variables partagées
int entering[NUM_THREAD];
int number[NUM_THREAD];

void lock(int i) {
  //calcul du numéro du fil
  entering[i] = true;
  number[i] = 0;
  for (int j = 0; j < NUM_THREAD; j++) number[i] = max(number[i], number[j]);
  number[i] += 1;
  entering[i] = false;

  // On attend d'avoir le plus petit numéro
  for (int j = 0; j < NUM_THREAD; j++) {
    while (entering[j]) //attente active

    while (number[j] != 0 &&
     (number[i] < number[j] || 
              (number[i] == number[j] && i < j)
      )) //attente active
  }
}

void unlock(int i) {
  number[i] = 0;
}

void execute(int i) {
  while(true) {
    lock(i);
    //section critique
    unlock(i);
  }
}



```

Sans le montrer, cet algorithme garantie l'absence de famine et l'exclusion mutuelle _dans le cas d'un modèle mémoire séquentiel_.
= Primitives pour la concurrence 
== Atomicité 
Le processeur fournit des instructions spéciales, qui sont garanties d'avoir un accès exclusif à leur zone mémoire. 

Ainsi, une addition atomique garantie qu'aucune instruction n'accèdera à la mémoire entre la lecture des opérandes et l'écriture du résultat. 

L'instruction atomique "classique", qui permet de créer toutes les autres, est `compare-and-swap`, qui correspond au pseudo code suivant :
#codly(languages: codly-languages, fill: green.lighten(80%), zebra-fill: none)
```
int cas(int* p, int new, int old) {
      if *p ≠ old
        return false;

    *p ← new;

    return true;
}

```

== Mutex

Un autre méchanisme de protection de la mémoire, plus haut niveau, sont les Mutex. (Ou exclusion mutuelle).

Ils font office de "verrou", qui peuvent être vérouillés atomiquement, ce qui empèche un autre thread d'accéder au verrou jusqu'au dévérouillage du mutex. 

En C, on les utilise ainsi : 

#codly(languages: codly-languages, fill: green.lighten(80%), zebra-fill: none)
```C
pthread_mutex_t    mutex;

int main() {
  pthread_mutex_init(&mutex, NULL);

  pthread_mutex_lock(&mutex);

  // Do smth

  pthread_mutex_unlock(&mutex);
}
```

 Si la _section critique_ n'est executée que lorsque le mutex associé est vérouillé par le thread, alors on a pas de _data race_. 

=== Interblocages avec les Mutex

Prenons l'exemple suivant : 

#grid(
  columns: (1fr, 1fr),
  gutter: 3pt,
  [processus 1 : 
  #codly(languages: codly-languages, fill: red.lighten(80%), zebra-fill: none)
```C
pthread_mutex_t    mutex1;
pthread_mutex_t    mutex2;

...

pthread_mutex_lock(&mutex1);
pthread_mutex_lock(&mutex2);

...


```]
, 
[processus 2 : 
#codly(languages: codly-languages, fill: green.lighten(80%), zebra-fill: none)
```C
pthread_mutex_t    mutex1;
pthread_mutex_t    mutex2;

...

pthread_mutex_lock(&mutex2);
pthread_mutex_lock(&mutex1);

...

```])

Le processus 1 attend que le processus 2 débloque le mutex 2 pour continuer, et le processus 2 attend que le processus 1 débloque le mutex 1 pour continuer : on est bloqué ! 


Il est assez courant dans un programme qui utilise beaucoup de concurrence, d'avoir à vérouiller plusieurs mutex pour travailler (par exemple pour déplacer des données d'une zone partagée vers une autre, toutes deux protégées par leur mutex).

=== Construction d'un Mutex à l'aide d'une instruction atomique

On va utiliser l'instruction `test-and-set`, qui est une instruction similaire à `compare-and-swap`, mais plus faible : Elle place une case mémoire à `true` et renvoie son ancienne valeur. Elle a le pseudo-code suivant : 

#codly()
```C
bool test_and_set(bool* p) {
  bool ret = *p;
  *p = true; 
  return ret;
}
```

On peut alors construire un verrou ainsi : 

#codly()
```C

void init_lock(bool* lock) {
  *lock = false;
}

void lock(bool* lock) {
  while (test_and_set(lock)) //attente active
}

void unlock(bool* lock) {
  *lock = false;
}
```


== Les barrières mémoire, ou "fence"

Les barrières mémoires sont des instructions qui permettent de rétablir un modèle mémoire séquentiel temporairement dans un programme qui a un modèle mémoire relaxé ou faible. 

En C, on a par exemple une fonction `__sync_synchronize()`, qui sera traduite par les instuctions assembleurs correspondantes lorsque la primitive est gérée par le CPU. 

Une barrière mémoire garantie que les instruction mémoires avant la barrière, seront exécutées celles présentes après la barrière. 

Il existe des barrières plus faibles dans certaines architecture (par exemple, qui n'offrent des garanties que sur certains types d'instructions)