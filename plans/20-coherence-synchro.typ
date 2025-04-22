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

= Implémentation des verrous 
== Pour 2 threads 

#dev[Implémentation et correction de Peterson]

== Pour n threads
Algorithme de la boulangerie de Lamport

#blk2("Idée")[
  Chaque thread tire un numéro de passage. Le thread de plus petit numéro peut entrée en section critique.
]

#blk2("Algorithme")[

]

== Avec instruction atomique 
#def[Instruction atomique][


]
