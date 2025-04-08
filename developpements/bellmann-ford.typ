#import "@preview/cetz:0.3.0"
#import "@preview/syntree:0.2.1": tree
#import "@preview/lovelace:0.3.0": *
#import "../utils.typtp": *
#import "dev_tplt.typtp": developpement

#show: developpement.with(
  titre: [Présentation et terminaison de l'algorithme de Bellmann-Ford], 
  niveau: [MPI], 
  prerequis: [Graphes])

= Présentation et Motivations
#text(fill:red)[à adapter en fonction de la lecon]

Modélisation d'un réseau par un graphe où les routeurs sont des noeuds et les liens sont des arcs. 

Le protocole RIP est un protocole à vecteur de distance.
_Peut-être rajouter blabla réseau si leçon réseau_
_En pratique très peut utilisé, que sur des réseau autonome (LAN)_

On a des contraintes supplémentaires du protocole RIP :
- Un seul noeud ne dois pas connaître toute la topologie du réseau, pour des raisons de sécurité et de stockage
- Internet est par nautre un réseau décentralisé : Il n'y a pas d'autorité centrale. Qui doit alors se charger de calculer les chemins ? 

L'avantage de l'algorithme de Bellmann-Ford est qu'il est possible de le faire de manière décentralisée, c'est à dire que chaque noeud fait la partie des calculs qui le concerne directement. 


* Et comment on le décentralise ? *

On remarque, dans l'algorithme ci-dessus, que, à chaque tour de boucle, chaque noeud `u` modifie seulement ses tables, et seulement en utilisant la table `D` de ses voisins. 

= Algorithme + exemple
_Écrire le code en même temps que faire sur l'exemple d'abord init puis event_

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

*Exemple :*
#image("../img/bellman-ford-ex.jpg")

= Preuve de terminaison, correction et complexité (de la version centralisé)

#text(fill:red)[À REVOIR]


// FINALEMENT PAS TOP SI POIDS DES ARCS DANS REEL ET ON LE REPROUVE APRES
// 
// == Terminaison

// On dit que l'algorithme de Bellmann-Ford _converge_ si plus aucune table n'est modifiée sur le réseau. 

// Les tables ne peuvent être modifées que de deux façons : 
// - soit une entrée est ajoutée
// - soit une entrée est modifiée, et la distance *diminue*.

// Comme le nombre d'entrées totales possibles est bornée, et que la distance de chaque entrée est positive, l'algorithme termine ! 

On aimerais savoir combien d'itérations l'algorithme prend pour converger ! 

On va pour cela montrer un résultat intermédiaire : 
#blk3[Lemme][
  En notant $D^i$ le tableau après la i-ème itération de la boucle, on a : 

  $P(i) : quote D^i (u, s) "est le plus court chemin (pcc) de" u " à" s "avec au plus" i  "sauts." quote$
]

*Démonstration :*\
- $P(0)$ est vrai car le seul endroit où on peut aller en 0 sauts, c’est sur soi-même, qui est à distance 0
- Soit $i in N$ tel que $P(i)$. \
  Alors, $D^(i+1)(u,s) = min (D^i (u,s), min_(v in V(u)) D^i (v, s) + w(u, v))$\
  Or, le pcc de $u$ à $s$ de au plus $i + 1$ sauts est :
  - soit de au plus $i$ sauts
  - soit commence par aller vers un voisin $v$ de $u$ puis est un pcc de $v$ à $s$ de au plus $i$ sauts.
  Or, tous ces chemins sont valides, et par $P(i)$, on prend bien le minimum de tout ça. D’où, $P(i+1)$.
Ainsi, par principe de récurrence, $forall i in N, P(i)$


*Compléxité :* \
De plus, un pcc ne passe pas deux fois par le même sommet (car on suppose les poids des arcs positif) donc un pcc est de longueur au plus |S|. Ainsi, P(|S|) et P(|S| + 1) impliquent que la |S|-ième et la |S| + 1-ième itérations sont les mêmes. On a donc au plus |S| itérations.

Ainsi cet algorithme est en $O(|S|²|A|)$

= Changement sur le réseau

_Préparer au cas où on est du temps un exemple de lien qui pète_