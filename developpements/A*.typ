#import "../utils.typtp": *
#import "dev_tplt.typtp": developpement
#import "@preview/syntree:0.2.1": tree

#show: developpement.with(
  titre: [Algorithme A\*], 
  niveau: [MPI], 
  prerequis: [])

= Problème

*Problème* : 
On a une source _src_ et une destination _dst_, on se restreint à un plan en 2D. On possède les informations des coordonnées de _src_ et _dst_
On cherche le plus court chemin entre la source et la destination par un chemin possible. 

*Objectif* : Ne pas explorer toutes les possibilités mais tout de même trouver le chemin le plus court. \

*Exemple :*
Par exemple prenons le problème d'un labyrinthe, où l'on doit trouver le chemin le plus court jusqu'à la sortie. \

*Modélisation :* On modélise le labyrinthe avec un graphe, ici toutes les arrêtes ont un poids de 1.

#figure(caption: "Modélisation de notre labyrinthe")[
  #image("../img/a__1.png")
]

= 1ère essaie : Dijkstra

_Dérouler Dijkstra au tableau_

#figure(caption: "Recherche du plus court chemin via Dijkstra")[
  #image("../img/a__2.png")
]

Avec Dijkstra on se rend compte qu'on parcourt tous les sommets, et qu'on tente d'aller dans une direction qui n'est pas optimal (vers le bas alors que la sortie est en haut à droite.

On cherche donc à prendre en compte la position de la sortie.

= A\*

== Heuristique
Pour prendre en compte la position de la destination on va ajouter une heuristique. Mais comment la choisir ?

*Heuristique admissible* : \
La fonction d'heuristique h est dite admissible si, pour tout sommet $v$ tel qu'il existe un chemin de $v$ à _dst_ de longueur $d$, alors $h(v)<=d.$ _Autrement dit une heuristique admissible ne surestime jamais la distance à la destination._ On note l'hypothèse $h($_dst_$)=0$.

*Choix de l'heuristique* : \
On pourrait prendre la  distance euclidienne entre un sommet et _dst_, cependant ici on ne peut pas couper à travers les murs. On va donc prendre la distance de Manathan. La distane de Manathan est calculé par : $d(a,b) = |x_b-x_a|+|y_b-y_a|$

_Maintenant qu'on a notre fonction pour calculé la distance entre deux sommets on définit l'heuristique._

*Heuristique monotone*

On applique A\* qui est Dijkstra mais avec heuristique à la place de distance pour la file de priorité.

#figure(caption: "Recherche du plus court chemin via A*")[
  #image("../img/a__3.png")
]
_Expliquer les valeurs distance src + distance de Manathan de dst et tout et tout_

*Heuristique monotone est admissible :*
Montrons que heuristique monotone est admissible

_Parler de la compléxité qui n'est pas forcément mieux_