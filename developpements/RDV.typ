#import "@preview/lovelace:0.3.0": *

#import "../utils.typtp": *
#import "dev_tplt.typtp": developpement

#show: developpement.with(
  titre: [Problème du rendez-vous], 
  niveau: [MP2I], 
  prerequis: [Fils d'exécutions])

= Introduction
Objectifs : Synchroniser n fils d'exécutions. On a donc n fils d'éxecutions qui ont chacun deux phases à exéxuter, donc deux parties de code. On veut que, pour chaque fils,  la phase 2 se lance lorsque toutes les phase 1 sont terminées.

#image("../img/rdv_1.png")

= Pistes pour la solution
== Solution naïve
#rect[
```c 
int cpt = 0;

Fi:
//phase 1
cpt++;
while(cpt<n);
//phase 2 
```
]

On attend que pour tout i, Fi est terminé la phase 1 pour lancer la phase 2.

On a deux problèmes : 
- On a un problème d'accès concurrent au compteur cpt
- On a de l'attente active

On peut résoudre l'accès concurrent facilement avec un verrou, mais pour l'attente active c'est plus compliqué.

== 1er cas facile
Voyons le cas où on a seulement deux fils et où l’on sait que c’est F1 qui finit en premier.
On peut alors considérer que F2 n’a pas de phase 1.

#image("../img/rdv_2.png", width: 60%)

#rect[
  #grid(columns: (1fr,2fr),
    grid.cell()[
      ```c 
      sem s initialisé à 0;

      F1:
      //phase 1
      incrementer(&s);
      //phase 2 
      ```
    ], 
    grid.cell()[
      ```c 


      F2:

      decrementer(&s);
      //phase 2 
      ```
    ], 
  )
]

== 2eme cas
F1 fini en premier mais on a n fils

#image("../img/rdv_3.png", width: 60%)

#rect[
  #grid(columns: (1fr,2fr),
    grid.cell()[
      ```c 
      sem s initialisé à 0;

      F1:
      //phase 1
      incrementer(&s);
      //phase 2 
      ```
    ], 
    grid.cell()[
      ```c 


      Fi:
      decrementer(&s);
      incrementer(&s);
      //phase 2 
      ```
    ], 
  )
]

On a une libération en cascade des fils Fi avec i $!=$ 1 lorsque F1 fini la phase 1.

== Retour au cas général
On reprend la même idée mais en essayant de bloquer que les fils qui ne sont pas les derniers.

On a maintenant besoin de savoir qui termine en dernier. Pour cela, comme chaque
fil, attend d’être libéré, on va faire en sorte que seul le dernier fil puisse être libéré. On a qu’a pour cela
avoir un sémaphore initialement négatif, qui ne passera positif que pour le dernier fil.

#rect[
```c 
sem s initialisé à -n+1;

Fi:
  //phase 1
1 incrementer(&s);
2 decrementer(&s);
3 incrementer(&s);
  //phase 2 
```
]

Dès que le dernier fils aura fini la phase 1 le sémaphore va passer dans le positif et une libération en cascade des fils aura lieu.

Imaginons que l’on ait 3 fils qui exécute ce code
#image("../img/rdv_4.png", width: 20%)

Attention ! On ne peut cependant pas initialisé un sémaphore avec une valeur négative.

= Solution 
On mélange la solution précédente avec la solution naïve.

#rect[
```c 
sem s initialisé à 0;
int cpt = 0;
mutex m;

Fi:
//phase 1
lock(&m);
cpt++;
if(cpt==n){
  incrementer(&s);
}
unlock(&m);
decrementer(&s);
incrementer(&s);
//phase 2 
```
]

Lorsque notre compteur arrive au nombre n de fils, on déclanche une libération en cascade.\
Nous n'avons donc plus d'attente active grâce aux sémaphores et plus d'accès concurrent grâce au verrou.

Remarque :
Ici notre sémaphore termine avec comme valeur 1. On pourrait vouloir le réutiliser pour
pouvoir faire une nouvelle barrière. On peut alors remplacer la libération en cascade par seulement le
premier fil qui libère tout le monde :
```c
for(int i=0; i<n−1; i++) incrementer(&s);
``` 

_peut être ajouter la libération en arborescence si temps restant_

= Application 
Minimum d'un tableau de n éléments avec k fils d'éxecutions.\

#table(columns: 9, " ", "O", " ","O"," "," "," "," ","O",)
On découpe en sous tableau de $n/k$. Qui font la phase 1 qui consiste à calculer le minimaux de leur sous-tableau.
On attend que les k threads aient trouvé leurs éléments minimaux, puis on peut lancer la phase 2, qui fait le minimaux de ces k éléments.

$O(n/k + k)$ optimal pour $k = sqrt(n) => O(sqrt(n))$

