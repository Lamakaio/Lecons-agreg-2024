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
Par exemple on est à New York et on veut trouver le chemin le plus court pour aller à Central Park.

*Objectif* : Ne pas explorer toutes les possibilités mais tout de même trouver le chemin le plus court. \

*Modélisation :* On modélise le plan de NY avec un graphe, ici toutes les arrêtes ont un poids de 1.

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
_Pour prendre en compte la position de la destination on va ajouter une heuristique. Mais comment la choisir ?
_\
*Heuristique admissible* : \
La fonction d'heuristique $h$ est dite admissible si, pour tout sommet $v$ tel qu'il existe un chemin de $v$ à _dst_ de longueur $d$, alors $h(v)<=d.$ _Autrement dit une heuristique admissible ne surestime jamais la distance à la destination._ On note l'hypothèse $h($_dst_$)=0$.

*Choix de l'heuristique* : \
On pourrait prendre la  distance euclidienne entre un sommet et _dst_, cependant ici on ne peut pas couper à travers les bâtiments. On va donc prendre la distance de Manathan. La distane de Manathan est calculé par : _dm_$(a,b) = |x_b-x_a|+|y_b-y_a|$.\
On prend donc l'heuristique : \
$h(u) = $_dm_$(u,$_dst_$)$

*Heuristique monotone :*\
La fonction $h$ est dite monotone si pour tout arc $u->^d v$ du graphe, on a l'inégalité $h(u)<= d+h(v)$.
La distance de Manathan est monotone. 

*Résolution :*\
On pose l'heuristique total : _ht_$(u) = h(u) + d(u)$ avec $d(u)$ le poids du chemin parcouru depuis le sommet _src_ jusqu'à $u$.\
On applique A\* qui est l'algorithme de Dijkstra mais avec une file de priorité sur le résultat de l'heuristique total _ht_.

#figure(caption: "Recherche du plus court chemin via A*")[
  #image("../img/a__3.png")
]
_Expliquer les valeurs distance src + distance de Manathan de dst et tout et tout_
\
\
#blk3("Propriété")[
  Une fonction heuristique monotone est admissible
]

#blk2("Preuve")[
  On cherche à montrer que pour tout chemin \
  $v_O ->^(d_0)v_1 ->^(d_1)v_2 ... v_n->^(d_n)$ _dst_,   on a $h(v_0)<=d_0+d_1+...+d_n$. \
  On procède par récurrence sur $n$. 
  - Pour $n = 0$ : $h($_dst_$)=0$ par définition
  - Pour $n > 0$ : on a $h(v_0)<=d_0+h(v_1)$ car h est monotone. Par hypothèse de récurrence, on a $h(v_1)<=d_1+...+d_n$ et donc $h(v_0)<=d_0+d_1+...+d_n$ par transitivité.
]


*Compléxité :*
L'heuristique monotone assure une compléxité polynomial de l'algorithme A\*. \
Lorsqu'un sommet sort de la file de priorité, on connait sa distance à la source, s'il vient à ressortir plus tard sa distance ne sera pas améliorée et donc celle de ses voisins non plus, qui ne seront donc pas remis dans la file.\
Donc chaque sommet peut occasionnerl'insertion de tous ses voisins dans la file la première fois qu'il est considéré, pour un total de $O(|A|)=O(|S|²)$. La sortie de chacun de ses éléments occasionne de nouveau l'examen de tous ses voisins, soit $O(|S|³)$. Si l'insertion et l'extraction dans une file de prioritése fait en compléxité logarithmique, on a $O(|S|³log |S|)$ dans le pire cas.

_Cependant en général grâce à l'optimisation de A\* on parcours moins de sommet qu'avec Dijkstra comme montrer sur l'exemple_