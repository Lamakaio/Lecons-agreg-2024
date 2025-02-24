#import "@preview/cetz:0.3.0"
#import "@preview/syntree:0.2.1": tree
#import "@preview/lovelace:0.3.0": *
#import "@preview/codly:1.1.1": *
#import "@preview/codly-languages:0.1.1": *

#import "../utils.typtp": *
#import "lecon_tplt.typtp": lecon


#show: codly-init.with()
#show: lecon.with(
  titre: [Leçon 18 : Gestion et coordination de multiples fils d'execution], 
  niveau: [Terminale, Prépa], 
  prerequis: [])

= Gestion par la machine (Terminale)
Lorsqu'on utilise une machine, des dizaines de programmes d'executent "en même temps", sur un nombre limité de processeurs. Comment est-ce possible ? 

== Execution concurrente 
#def[processus][
  Un processus est un programme en cours d'execution. Il dispose de son propre espace mémoire, et est identifié par un numéro : le PID. 
]

#def[Concurrence][
  Deux processur d'executent en concurrence si ils sont tous deux présents à un même instant
]

#blk2[Principe][
C'est le système qui décide quel processus s'execute. A tout instant, il peut donner ou reprendre la main. L'interruption de l'execution d'un processus par le système est appelé préemption. 
]

== L'ordonnanceur 
#def[ordonnanceur][
  L'ordonnanceur est le programme qui décide quel processus s'execute à quel instant. Il satisfait en général les propriétés suivantes :
  - abscence de famine : aucun processus n'attend indéfiniment 
  - équité : aucun processus n'est favorisé
]

#blk1[Algorithme][du tourniquet][
Les processus sont placés dans une file. Quand une place est disponible, le premier processus de la file est retiré, et exécuté pendant un temps $tau$ prédéfini, puis il est remis à la fin. 
]

#ex[
Exemple d'utilisation d'un processeur executant 3 processus.
#image("../img/filsdexec.png")
]

#blk2[Propriété][
  L'algorithme du tourniquet garantie l'abscence de famine et l'équité. 
]

#blk2[Améliorations][
  En pratique, il est souhaitable de pouvoir donner une priorité différentes aux processus, et d'avoir des processus qui rendent la main eux-même après un temps $t < tau$. Il faut alors adapter l'algorithme, et de nombreuses solutions existent. 
]

= Gestion par l'utilisateur 
== Fils d'execution
#def[Fil d'execution][
  Un fil d'execution (thread) est un sous-processus qui partage sa mémoire avec les autres _thread_ du processus. 
]

#blk2[Syntaxe][
  En C, un programme peut lancer et gérer d'autres fils d'execution avec le _header_ `<pthread.h>` et la fonction `pthread_create`. \
  En OCaml, on utilise le module `Thread`.
]

#blk2[Remarque][
  Pour créer un processus, on utilise l'appel système `fork`. 
]
#dev[Fonctionnement de `fork` et du _Copy-on-Write_ ]

Comment coordonner les différents fils d'execution ? Il y a plusieurs primitives de synchronisation rendues disponibles par le système. 

== Les verrous 
#def[Exclusion mutuelle][
  Le problème de l'exclusion mutuelle consiste à garantir que deux fils d'execution n'executent pas simultanément une *section critique*, c'est à dire un morceau de code sensible. 
]

#def[verrou][
  Un verrou (_mutex_) est une structure de synchronsation avec deux opérations : 
  - `verrouiller()` : verrouille le mutex, et bloque tant qu'un autre fil l'a déjà verouillé. 
  - `liberer()` : Libère le verrou, ce qui permet à un autre fil de le verrouiller si besoin. 
Une implémentation d'un verrou doit avoir les propriétés suivantes : 
- Exclusion mutuelle
- Abscence de famine : `verrouiller` termine toujours
- Equité : aucun fil n'est favorisé
]

#blk1[Algorithme][de Peterson][
  L'algotithme de Peterson est une implémentation d'un verrou pour deux fils. 
]

#dev[Construction de l'algorithme de Peterson]

#blk1[Algorithme][de la boulangerie de Lamport][
  Intuition : prendre un ticket dans une file d'attente, puis attendre son tour. 
  #pseudocode-list(hooks: .5em, title: smallcaps[Boulangerie de Lamport (N fils)], booktabs: true)[

  #underline[Variables partagées] : 
  Tableaux acq et num d'entiers de taille N.
  
  + *def* verouiller (int i)
    + Obtention d'un numéro
      + acq[i] = 1
      + int t = $max("num")$
      + num[i] = t + 1
      + acq[i] = 0
    + Attentre son tour
      + *Pour* j de 0 à N
        + *Attendre* que acq[j]==0
        + *Attendre* que 
          + *soit* num[i] > num[i]
          + *soit* num[i] == num[j] *et*  i < j
    
  + *def* liberer (int id)
    + num[i] = 0
]
]

#blk2[Syntaxe][
  En C, les verrous sont dans la bibliothèque `<pthread>` : 
  - `pthread_mutex_init` pour l'initialisation 
  - `pthread_mutex_lock` et `pthread_mutex_unlock` pour les opérations. 
]

#blk2[Remarque][
  Attention, lorsqu'on a plusieurs verrous, il y a un risque d'interblocage !
]

== Les sémaphores
Idée : Comment adapter les mutex si on a plusieurs exemplaires de la ressources ? (Ex : une librairie a 5 exemplaires d'un manuel)

#def[Sémaphore][
  Un sémaphore est une structure de synchronisation contenant un compteur, avec les opérations suivantes : 
  - `initialiser` à une valeur entière
  - `decrementer` : décrémente le compteur si il est positif, sinon bloque d'abord jusqu'à ce qu'il le soit. 
  - `incrementer` : incrémente le compteur, ce qui libère possiblement un autre fil. 
]

#blk2[Remarque][Un sémaphore initialisé à 1 est un verrou.]

#blk2[Syntaxe][
  En C, on retrouve le sémaphore dans le _header_ `<semaphore.h>`, et les fonctions `sem_init`, `sem_wait` et `sem_post`. 
]

#blk1[Application][Problème du Rendez-vous][
On a n fils qui veulent se synchroniser. On a deux phases : 
+ Chaque fil travaille indépendamment
+ Ne peux commencer que lorsque tous les fils ont terminé la première phase. 
]

#blk2[Solution][
  On utilise un compteur `count` protégé par un verrou, et un sémaphore `sem` initialisé à 0. Le code entre la phase 1 et 2 est le suivant : 
  ```C
  atomic_incr(count)
  if (count == n) sem_post(sem);
  sem_wait(sem);
  sem_post(sem);
  ```
  L'arrivée du dernier fil provoque une libération en chaine !
]

#blk1[Application][Producteur/ Consommateur][
  On dispose d'un tampon de taille N, et de deux types de fils 
  - des producteurs, qui placent les données dans le tampon 
  - des consommateurs, qui consomment ces données
  L'enjeu est alors de s'assurer que 
  - Les producteurs ne fassent pas déborder le tampon 
  - Les consommateurs ne consomment que des données valides
]
#blk2[Travaux pratiques][Implémentation guidée de la solution. ]

