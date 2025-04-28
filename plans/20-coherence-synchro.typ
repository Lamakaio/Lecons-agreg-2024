#import "@preview/cetz:0.3.0"
#import "@preview/syntree:0.2.1": tree
#import "@preview/lovelace:0.3.0": *
#import "../utils.typtp": *
#import "lecon_tplt.typtp": lecon

#show: lecon.with(
  titre: [Leçon 20. Problèmes et stratégies de cohérence et de synchronisation], 
  niveau: [MP2I/MPI], 
  prerequis: [])

= Introduction

#def[Processus][

]

#def[Fils d'exécutions (Threads)][
  
]

#def[Data Race][

]

#ex[

]

= Exclusion mutuelle et verrous
#def[Section critique][
  Une portion de code soumis à un data race.
]

#blk1("Objéctif", "Garantir l'exclusion mutuelle")[
  Au maximum un seul fils d'exécution accède en même temps à la section critique.
]

#blk3("Solution")[Les verrous]

#def[Verrou][
  Un verrou (mutex) est une primitive de synchronisation qui possède 2 opérations :
  - lock(v), pour blocker la section critique aux autres fils
  - unlock(v), pour débloquer celle-ci

]

#blk1[Propriété][Verrous][
  Un verrous efficace doit avoir les propriétés suivantes :
  - exclusion mutuelle : un thread à la fois 
  - abscence de famine : si un fils demande l'accès à la section critique il y accèdera en un temps fini 
  - équité : aucun fils n'est favorité
]

== Implémentation des verrous 
=== Pour 2 threads 

#dev[Implémentation et correction de Peterson]

=== Pour n threads
Algorithme de la boulangerie de Lamport

#blk2("Idée")[
  Chaque thread tire un numéro de passage. Le thread de plus petit numéro peut entrée en section critique.
]

#blk2("Algorithme")[
  #image("../img/lamport.png", width: 60%)
]

=== Avec instruction atomique 
#def[Instruction atomique][
  Une instruction qui ne peut être interrompue. (Une instruction en langage machine).
]

#blk2("Remarque")[
  Les verrous peuvent aussi s'implémenter avec des instructions atomique comme test-and-set, qui écrit une valeur dans une case mémoire et renvoie la valeur d'origine.
]

#blk2("Exercice")[
  Implémenter un verrou avec test-and-set.
]

#blk2("Remarque")[
  Les 3 solutions d'implémentations des verrous présenté font de l'attente active. C'est pourquoi il faut utiliser les mutex qui eux font de l'attente passive en passant le processus dans l'état bloqué tant que le verrou n'a pas été libéré.
]

= Synchronisation et sémaphore
== Sémaphore
#def("Sémaphore")[
  Un sémaphore est partager entre tous les fils d'exécutions, il est initialisé avec une valeur positive manipulable avec les 2 opérations suivantes : 
  - wait(s) : qui décrémente s si la valeur est strictement positive, sinon met le processus en attente active jusqu'à ce que s soit > 0.
  - post(s) : qui incrémente la valeur de s de 1.
]

#blk2("Remarque")[
  Un sémaphore initialiser à 1 peut implémenter un verrou.
]

== Cas d'utilisation 

=== Problème du rendez-vous 
#blk2("RDV")[
  Problème : chaque thread travaille en 2 phases, aucun thread ne peux commencer la phase 2 tant que tous les threads n'ont pas fini leur phase 1.
]
#dev[ Résolution du problème du rendez-vous et exemple d'utilisation]

=== Producteur-consomateur 
#blk2("Problème")[
  Il y a deux catégories de threads :
  - les producteurs qui produisent des ressources, avec un nombre de ressources produites maximum en même temps
  - les consomateurs qui consomme des ressources si il y en a 
]

#blk2("Algorithme")[
  #underline[_Initialisation :_]
  - créer un mutex machine
  - créer un sémaphore 'libre' initialisé à N, représentant les N emplacements libres pour les ressources
  - créer un sémaphore 'plein' init à 0 qui représentent les emplacements remplies par les producteurs.
]

#pseudocode-list()[
  #underline[_Producteurs :_]
    + Tant que vrai 
      + res = produire
      + wait(libre)
      + lock(m)
      + inserer res dans stockage
      + unlock(m)
      + post(plein)
  ]
  \
#pseudocode-list()[
  #underline[_Consomateurs :_]
    + Tant que vrai 
      + wait(plein)
      + lock(m)
      + prendre ressource dans stockage
      + unlock(m)
      + post(libre)
  ]

#ex[
  TP guidé pour écrire le code de lécteurs/rédacteurs en C
]

= Interblocage 
Lorsqu'il y a exclusion mutuelle, il peut y avoir des blocages.

#def("Interblocage")[
  #image("../img/interblocage.png", width: 40%)
]

#ex[
  $"F1 :              F2:"\
  "lock(m1)        lock(m2)  "\
  "lock(m2)        lock(m1)"
  $
]

#blk2("Problème du diner des philosophes")[
  5 philosophes sont autour d'une table, une baguette entre chaque. Quand un philosophe à faim, il doit prendre 2 baguettes pour pouvoir manger.
]

#blk2("Activité")[
  Essayer de résoudre ce problème, dans un premier temps en activité débrancher puis avec verrous et sémaphores.
]