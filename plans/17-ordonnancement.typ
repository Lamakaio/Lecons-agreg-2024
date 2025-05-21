#import "@preview/cetz:0.3.0"
#import "@preview/syntree:0.2.1": tree
#import "@preview/lovelace:0.3.0": *
#import "@preview/codly:1.1.1": *
#import "@preview/codly-languages:0.1.1": *

#import "../utils.typtp": *
#import "lecon_tplt.typtp": lecon

#show: codly-init.with()
#show: lecon.with(
  titre: [Leçon 17 : Algorithmes d’ordonnancement de tâches et de gestion de ressources.], 
  niveau: [Terminal, MPI], 
  prerequis: [Architecture des ordinateurs, Graphe])

#rect[sources : Tortue 1er + ]

= Gestion de plusieurs tâche par le système d'exploitation

#blk3("Système d'exploitation")[
  Lorsqu'on utilise un ordinateur on va exécuter plusieurs programme en "même temps". Exemple : musique, traitement de texte et navigateur en simultané. Pourtant le nombre de processeur dans un ordinateur est limité. Comment le système d'exploitation gère cela ?
]

#def[Processus][
  Programme en cours d'éxecution, identifié par un identifiant PID.
]

#def[Exécution concurrente][
  On dit que 2 processus s'exécutent de manière concurrente si les intervalles de temps entre le début et la fin de leur ecécution ont une partie commune. On a donc à un moment t, une liste de processus en cours d'exécutions.
]

#def("Ordonnanceur")[
  L'ordonnanceur gère la file d'attente des processus et décide lequel sera le prochain à être exécuté. 
]

#blk2("État d'un processus")[
  Un processus possède plusieurs états :
  #image("../img/processus.png", width: 60%)
]

#def[Dispatcher][
  Le passage de l'exécution d'un processus à un autre est géré par le dispatcher. Il va effectuer le changement de contexte, c'est à dire il va stocker la configuration actuelle du processus courrant, restaurer la configuration du processus qui va s'exécuter ensuite (indiqué par l'ordonnanceur). Puis sauter vers l'emplacement du code à exécuter.
]

#def[Intéruption et préemption][
  Une intéruptions va arrêter l'exécution d'un certain processus par le processeur en remettant le processus dans la file d'attent. Exemple : on appuie sur une touche du clavier.\
  Pour pouvoir avoir les exécutions les plus parrallèle entre plusieurs processus, il existe une intéruption appelé préemption qui va tout les x cycle d'horloge lever une interruption.
]

#ex[
  P1 s'exécute.\
  La préemption lève une interruption.\
  L'ordonnancer indique que le prochain processus à s'exécuter est P2.\
  Le dispatcher stocke le contexte de P1, restaure celui de P2, saute au code de P2.
  P1 est remis dans la file d'attente par l'ordonnanceur.
]

#blk2("Problème")[
  Comment l'ordonnanceur gère la file d'attente des processus ?
]

= Algorithmes d'ordonnancement

== Du système d'exploitation

#blk2("Algorithme")[
  Grâce à la préemption et au fait que les tâches sont indépendantes dans un ordinateur on peut gérer la file d'attente comme une file FIFO (first in first out). Cette algorithme s'appelle le tourniquet ou Round-Robin. Si un nouveau processus est créé, il va à la fin de la file d'attente.
]

#image("../img/tourniquet.png", width: 30%)

#blk2("Propriétés")[
  Cette algorithme garanti l'équité et le manque de famine.
]

#blk2("Remarque")[
  Il existe des algorithmes qui ont des notions de priorités, si un processus est plus urgent que les autres il sera replacer au début de la file d'attente, le problème est qu'on peut avoir de la famine.]

== Cas plus généraux

Les algorithmes d'ordonnancement ne sont pas seulement utile pour la gestion des tâches dans un ordinateur.

=== Tâches non indépendantes

#ex[
  Les lutins du père noël doivent faire les cadeaux, les emballé, noter le nom de l'enfant, et les places dans le bon sac pour le père noël. On a donc certaines tâches qui doivent être effectuer en avant d'autres.
]

#blk3("Modélisation")[
  On modélise une instance au problème d'ordonnancement par un graphe orienté. On a un sommet par tâches à éxecuter. Si une tâche $v$ nécessite la fin de l'éxécution d'une tâche $u$ alors, on a un sommet $u->v$. Chaque sommet possède un poids qui est sont temps d'exécution.
]

#blk1("Spécification", "Algorithme d'ordonnancement")[
  Ordo(G,d,p):
  Entrée : 
  - $G(S,A)$ un graphe orienté modélisant une instance
  - $d : S -> NN$ : durée des tâches
  - $p$ le nombre d'exécution parrallèle qu'on peut effectuer
  Sortie : 
  - $sigma : S -> NN$ : l'ordre dans le quel effectuer les tâches
  - $"alloc" : S -> [|1:p|]$ : sur quelle machine s'exécute les tâches
]

#ex[
  #image("../img/dessin_ordo.png", width: 80%)
]

#blk3("Théorème")[
  _Ordo(G,d,p)_ admet une solution ssi G est acyclique.
]

#def("Tri topologique")[
  Soit G un graphe orienté acyclique. Un tri topologique est une liste ordonnée de ses sommets telle que, pour tout arc $u ->v$ dans le graphe, le sommet $u$ apparait avant le sommet $v$ dans la liste.
]

#blk2("Algorithme")[
  On utilise l'ordre postfixe d'un parcours en profondeur pour avoir le tri topologique d'un graphe.
  Cette algorithme est linéaire mais ne renvoie pas forcément un résultat optimal.
]

#blk2("Remarque")[
  Si $p = 1$ ou $p = +infinity$ le tri topologique est optimal.
]

=== Tâches indépendantes
On peut maintenant se poser la question de dans quelle ordre effectuer des tâches si celles ci ne dépendent pas d'autres tâches.

#blk2("Problème")[
  Indep(d,p). 
  On se retrouve dans le problème Ordo(G,d,p) mais avec un graphe sans arrête.
]

#blk1("Théorème", "Indep(d,p)")[
  Indep(d,p) est NP-Complet pour $p in [2:+infinity]$
]

#dev[
  Approximations gloutonnes de Indep pour p = 2
]

= Accès à une ressource partagé

Plusieurs processus peuvent accèder à la même donnée. Lorsque plusieurs processus s'exécutent de manière concurrentes celà peut poser problème si la donnée est modifié.

#def[Data Race][

]

#ex[

]

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

#dev[Implémentation et correction de Peterson]
