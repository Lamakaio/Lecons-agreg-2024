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

On aimerais calculer le chemin le plus court entre chaque paire de noeuds du graphe d'internet. Pour calculer ces chemins, on utilise habituellement l'algorithme de Floyd-Warshall ! 

Mais ici, on a des contraintes supplémentaires :
- Un seul noeud ne dois pas connaître toute la topologie du réseau, pour des raisons de sécurité et de stockage
- Internet est par nautre un réseau décentralisé : Il n'y a pas d'autorité centrale. Qui doit alors se charger de calculer les chemins ? 

L'avantage de l'algorithme de Bellmann-Ford est qu'il est possible de le faire de manière décentralisée, c'est à dire que chaque noeud fait la partie des calculs qui le concerne directement. 


= Détail de l'algorithme, centralisé et distribué

== L'algorithme centralisé
#figure(caption: [Algorithme de Bellmann-Ford centralisé], kind: "algorithme", supplement: [Algorithme])[
#pseudocode-list(hooks: .5em, title: smallcaps[BELLMANN-FORD ( G )], booktabs: true)[
  #underline()[Entrée] : $G = (S, V, w)$ un graphe pondéré non orienté avec $V$ le tableau des listes d'adjacence.
  
  #underline()[Sortie] : `prochain-saut`, un tableau indéxé par $(s_1, s_2) in S times S$, contenant le prochain noeud dans le chemin le plus court de $s_1$ à $s_2$.
  
  + `prochain-saut` $<-$ Tableau de taille $S times S$
  + `D` $<-$ Tableau de taille $S times S$
  + *for* $(u, v) in S$ *do*
    + `prochain-saut[u][v]` $<-$ None
    + `D[u][v]` $<-$ $+infinity$
  + *for* $u in S$ *do*
    + `D[u][u]` $<-$ 0
  + *do* 
    + *for* $u in S$ *do*
      + *for* $v in V[u]$ *do*
        + *for* $s in S$ *do*
          + *if* $D[v][s] + w(u, v) < D[u][s]$ *then*
            + `prochain-saut[u][s]` $<-$ `v`
            + `D[u][s]` $<-$ `D[v][s]` + `w(u, v)`
    + *loop while* Il y a eu une modification à la dernière itération.
]
]

== Et comment on le décentralise ? 
On va découper `prochain-saut` et `D` : chaque noeud garde en mémoire les trajets qui partent de lui. 

On remarque, dans l'algorithme ci-dessus, que, à chaque tout de boucle, chaque noeud `u` modifie seulement ses tables, et seulement en utilisant la table `D` de ses voisins. 

#figure(caption: [Algorithme de Bellmann-Ford décentralisé], kind: "algorithme", supplement: [Algorithme])[
#pseudocode-list(hooks: .5em, title: smallcaps[BELLMANN-FORD-DECENTRALISE ( u, V, w )], booktabs: true)[
  #underline()[Entrée] : $u in S$ un sommet, $V$ la liste de ses voisins, et $w$ les poids des arrètes vers ses voisins.
  
  + #underline()[Initialisation]
    + `prochain-saut` $<-$ Tableau associatif vide
    + `D` $<-$ Tableau associatif vide
    + *for* $v in V$ *do*
      + `prochain-saut[v]` $<-$ `v`
      + `D[v]` $<-$ `w(v)`
    + Envoyer `D` à ses voisins

  + #underline()[Evénement : on reçoit une table `D'` d'un voisin]
    + *for* $s in D'$ *do*
      + *if* $s in.not D $ *or* $ D'[s] + w(v) < D[s]$ *then*
        + `prochain-saut[s]` $<-$ `v`
        + `D[s]` $<-$ `D'[s]` + `w(v)`
    + Envoyer `D` à ses voisins
]
]

= Preuve de terminaison et complexité
== Terminaison

On dit que l'algorithme de Bellmann-Ford _converge_ si plus aucune table n'est modifiée sur le réseau. 

Les tables ne peuvent être modifées que de deux façons : 
- soit une entrée est ajoutée
- soit une entrée est modifiée, et la distance *diminue*.

Comme le nombre d'entrées totales possibles est bornée, et que la distance de chaque entrée est positive, l'algorithme termine ! 


== Complexité (de la version centralisée)
On aimerais savoir combien d'itérations l'algorithme prend pour converger ! 

On va pour cela montrer un résultat intermédiaire : 
#blk1[Lemme][][
  En notant $D^i$ le tableau après la i-ème itération de la boucle, on a : 

  $P(i) : quote D^i (u, s) "est le plus court chemin de" u " à" s "avec au plus" i  "sauts."$
]

