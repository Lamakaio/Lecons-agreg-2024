#import "@preview/cetz:0.3.0"
#import "@preview/syntree:0.2.1": tree
#import "@preview/lovelace:0.3.0": *
#import "../utils.typtp": *
#import "dev_tplt.typtp": developpement

#show: developpement.with(
  titre: [Bellmann-Ford décentralisé], 
  niveau: [Term, MP2I], 
  prerequis: [Graphes])

= Présentation et Motivations

Modélisation d'un réseau par un graphe où les routeurs sont des noeuds et les liens sont des arcs. 

Le protocole RIP est un protocole à vecteur de distance.
_En pratique très peut utilisé, que sur des réseau autonome (LAN)_

On a des contraintes supplémentaires du protocole RIP :
- Un seul noeud ne dois pas connaître toute la topologie du réseau, pour des raisons de sécurité et de stockage
- Internet est par nautre un réseau décentralisé : Il n'y a pas d'autorité centrale. Qui doit alors se charger de calculer les chemins ? 

Bellmann-Ford se décentralise bien. Comment ?
On remarque, dans l'algorithme, que, à chaque tour de boucle, chaque noeud `u` modifie seulement ses tables, et seulement en utilisant la table `D` de ses voisins. 

= Algorithme + exemple
_Écrire le code en même temps que faire sur l'exemple d'abord init puis event_


*Exemple :*
#image("../img/bellman-ford-ex.jpg")


#figure(caption: [Algorithme de Bellmann-Ford décentralisé], kind: "algorithme", supplement: [Algorithme])[
#pseudocode-list(hooks: .5em, title: smallcaps[BELLMANN-FORD-DECENTRALISE ( u, V, w )], booktabs: true)[
  #underline()[Entrée] : $u in S$ un sommet, $V$ la liste de ses voisins, et $w$ les poids des arrètes vers ses voisins.
  
  + #underline()[Initialisation]
    + `prochain-saut` = []
    + `D` = []
    + *Pour* $v in V$ *:*
      + `prochain-saut[v]` = `v`
      + `D[v]` = `w(v)`
    + Envoyer `D` à ses voisins

  + #underline()[Evénement : on reçoit une table `D'` d'un voisin]
    + changement = Faux
    + *Pour* $s in D'$ *:*
      + *Si* $s in.not D $ *ou* $ D'[s] + w(v) < D[s]$ *alors*
        + `prochain-saut[s]` = `v`
        + `D[s]` = `D'[s]` + `w(v)`
        + changement = Vrai
    + *Si* changement *alors*
      + Envoyer `D` à ses voisins
]
]

= Changement sur le réseau

_A faire en dessin au tableau_

A--1--B--1--C--1--D\
Le lien A-B coupe, on peut avoir un bouclage à l'infini : \
B envoie à C (A en 16), et D envoie à D (A en 4) donc C màj (A en 16) puis (A en 5) et renvoie à B (A en 5) ... 
On remonte 1 par 1 jusqu'à 16.

Solution : 
On n'envoie pas les routeurs qui viennent du routeur auquel on envoie.
Pas de boucle.

= Preuve de terminaison, correction et complexité (de la version décentralisé)

Invariant de boucle : \
$P(i) : quote D^i (t) "est la distance d'un plus court chemin (pcc) de" s" à" t "avec au plus" i "sauts." quote$

*Démonstration :*\
- $P(0)$ est vrai car le seul endroit où on peut aller en 0 sauts, c’est sur soi-même, qui est à distance 0
- Soit $i in N$ tel que $P(i)$. \
  Alors, $D^(i+1)(t) = min (D^i (t), min_(u-t) D^i (u) + w(u, t))$\
  Or, le pcc de $s$ à $t$ de au plus $i + 1$ sauts est :
  - soit de au plus $i$ sauts
  - soit commence par aller vers un voisin $u$ de $t$, or par $P(i)$ on a un pcc de $s$ à $u$ de au plus $i$ sauts.
  Tous ces chemins sont valides, on prend bien le minimum des deux possibilités. D’où, $P(i+1)$.
Ainsi, par principe de récurrence, $forall i in NN, P(i)$


*Compléxité et Terminaison:* \
De plus, un pcc ne passe pas deux fois par le même sommet (car on suppose les poids des arcs positif) donc un pcc est de longueur au plus |S|. Ainsi, P(|S|) et P(|S| + 1) impliquent que la |S|-ième et la |S| + 1-ième itérations sont les mêmes. On a donc au plus |S| itérations.

Ainsi cet algorithme est en $O(|S|*|A|)$ 
