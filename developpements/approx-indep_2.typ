#import "@preview/lovelace:0.3.0": *

#import "../utils.typtp": *
#import "dev_tplt.typtp": developpement

#show: developpement.with(
  titre: [Approximations gloutonnes de Indep(2)], 
  niveau: [MPI], 
  prerequis: [], 
) 

#rect[source: livre de Bob (2-PARTITION) 8.1.5]

= Problème 

Instance : n tâches de durée {$d_1, d_2, ..., d_n$} = D

Problème : On cherche à exécuter toutes les tâches sur 2 processeurs $P_1$ et $P_2$ en minimisant le temps d'éxecution total. \ 
On cherche donc un ordonancement qui minimise $T = max(T_1, T_2)$ où $T_1$ et $T_2$ sont les temps de fin d'éxecution de $P_1$ et $P_2$.

= Approche gloutonne n°1
== Algorithme
#pseudocode-list(booktabs: true, hooks :.5em)[
  *Glouton-1(D) :*
  + $T_1, T_2 <- 0$
  + *Pour* i de 1 à n :
    + *Si* $T_1 < T_2$ :
      + alloc[i] $=$ 1 
      + $T_1 += d_i$
    + *Sinon* 
      + \#idem pour $T_2$
  + *Retourner* $max(T_1, T,2)$
]

#blk3("Propotition")[
  Glouton-1 n'est pas optimal.
]

#blk2("Démonstration")[
On prend D = {1,1,2} on obtient alors :
#image("../img/indep_1.png", width: 30%)
Donc $T = T_1 = 3$ or on pourrait avoir T = 2 avec :
DESSIN
]

== 3/2 approximation Glouton-1 
#blk3("Théorème")[
  Glouton-1 est une $3/2$-approximation de Indep(2)
]

#blk2("Démonstration")[
  Glouton-1 est bien polynomial.\
  On note $T$ la réponse de Glouton-1, $T^*$ l’optimal.\
  Il faut alors montrer que $T<=3/2T^*$

  On pose $S = sum_(i=1)^n d_i$ \

  On a donc : \
  (1) $T^*>= S/2$ \
  (2) $T_1+T_2 = S$\
  (3) $T^* >= d_j | forall j in [1:n]$

  Considéront que $T = T_1$ et que la dernière tache de $P_1$ est $d_i$
  #image("../img/indep_2.png", width: 30%)

  $T&=T_1=1/2(T_1+(T_1-d_i)+d_i)\
        &<= 1/2(T_1+T_2+d_i) " car on a mit "d_i" dans "P_1" donc "T_2" était suppérieur à "T_1" avant "d_i\
        &=1/2(S+d_i) " par (2)"\
        &= S/2 + 1/2 d_i\
        &<= T^* + 1/2 T^* " par (1) et (3)"\
        => &T <= 3/2 T^*
  $ 
]

= Approche gloutonne 2 
== Algorithme
#pseudocode-list(booktabs: true, hooks :.5em)[
  *Glouton-2(D)*:
  + D' $<-$ D trié par taille décroissante
  + *Retourner* Glouton-1(D')
]

#blk3("Proposition")[
  Glouton-2 n'est pas optimal
]

#blk2("Démonstration")[
  On prend D' = {3,3,2,2,2}
  #image("../img/indep_3.png", width: 70%)
]

#blk2("Remarques")[
  Avec Glouton-2 on perd la propriété d'être online
]

== 7/6 approximation Glouton-2

#blk3("Théorème")[
  Glouton-2 est une $7/6$-approximation de Indep(2)
]

#blk2("Démonstration")[
  On reprend la preuve de 3/2 approx via glouton-1. \
  On cherche à améliorer (3) $T^* >= d_j | forall j in [1:n]$\
  On distingue 2 cas : \
  - $forall j in [1:4]$ :\
    Glouton-2 est optimal. $T = T^*$ #text(fill: red)[SAVOIR MONTER CA, PBM POUR j + 4 ?]
  - $forall j > 4 :$\
    Alors $1/3 T^* >= d_j$, car on aurait $P_1$ ou $P_2$ qui aurait au moins 3 tâches et que les tâches sont triées dans l'ordre décroissant donc suppérieur à $d_j$.\
    Donc $T <= T^* + 1/6 T^* <=> T <= 7/6 T^*$
]


#text(fill: red)[
  Si question sur la NP complétude de indep 2 regarder preuve par réduction SUBSETSUM dans bouquin de Bob. Ex 7.20.
]