#import "../utils.typtp": *
#import "@preview/lovelace:0.3.0": *
#import "dev_tplt.typtp": developpement
#import "@preview/syntree:0.2.1": tree

#show: developpement.with(
  titre: [Preuve du théorème de Rice], 
  niveau: [MPI], 
  prerequis: [])

#rect[source: le livre language, calculabilité, complexité]

= Enoncé du théorème

#def[Equivalence d'algorithmes][
  Soit $A_1$, $A_2$ deux algorithmes. On dit qu'ils sont equivalents, noté $A_1 ~ A_2$, si, quelque soit $e$ une entrée, soit $A_1(e)$ et $A_2(e)$ ne terminent pas, soit ils terminent tous les deux et $A_1(e) = A_2(e)$.
]

#def[Problème trivial][
  Soit P un problème de décision. 
  - On dit qu'il est _trivial_ si, quelque soit l'instance de son entrée, la réponse est la même.
]

#def[Problème sémantique][
  Soit P un problème de décision sur les algorithmes. On dit qu'il est sémantique si, pour $A_1$, $A_2$ deux algorithmes, $A_1 ~ A_2 => P(A_1) = P(A_2)$
]

#blk1[Théorème][de Rice][
  Si P est un problème de décision sur les algorithmes, sémantique et non trivial, alors P est indécidable.
]

= Lemme : indécidabilité de la simulation

#blk1[Lemme][Simulation][
  Le problème $P_epsilon$ suivant est indécidable :
  - *entrée :* un algorithme $A$ et une entrée $e$ 
  - *sortie :* est ce que $A(e) = "vrai"$ ? 
]

*Preuve :* 
Par l'absurde, on prend $M$ un algorithme, tel que \
$M(A, e) =$ 
- vrai si $A(e)=$ vrai
- faux sinon

On pose alors un algorithme $Q$ : 
#block(breakable:false)[
#pseudocode-list(hooks: .5em, title: smallcaps[Q ( A )], booktabs: true)[
  #underline()[Entrée] : A un algorithme à valeur booléenne
  + *Si* $M(A, A) =$ vrai 
    + renvoyer faux
  + *Sinon* 
    + renvoyer vrai
]]

Et on va appliquer $Q$ à $Q$ ! 
- *Si $Q(Q) = $ vrai :* \
    - alors $M(Q, Q) =$ faux
    - donc $Q(Q) !=$ vrai, *absurde !*
- *Si $Q(Q) = $ faux :* \
    - alors $M(Q, Q) =$ vrai
    - donc $Q(Q) =$ vrai, *absurde !*

Donc $P_epsilon$ est indécidable.

= Preuve du théorème de Rice

Soit P un problème de décision sur les algorithmes, sémantique et non trivial. On va réduire P à $P_epsilon$.

On pose $bot$ l'algorithme qui renvoie toujours "faux".

Quitte à prendre le complémentaire de $P$, on suppose que $P(bot)$ n'est pas vérifié. 

De plus, comme $P$ n'est pas trivial, on peux prendre $M_0$, tel que $P(M_0)$ est vérifié. 

On définit alors, pour $M$ un algorithme et $w$ une entrée, 

#block(breakable:false)[
#pseudocode-list(hooks: .5em, title: smallcaps[$M_w$ ( u )], booktabs: true)[
  #underline()[Entrée] : u un mot
  + *Si* $M(w) =$ vrai 
    + renvoyer $M_0(u)$
  + *Sinon* 
    + renvoyer faux
]]


Alors : si $M(w) = $ vrai, $M_w ~ M_0$, et donc $P(M_w)$ est vérifié, et si $M(w) = $ faux, $M_w ~ bot$, et donc $P(M_w)$ n'est pas vérifié (car P est sémantique).

Donc $P_epsilon (M, w) <=> P(M_w)$. La fonction qui associe $M_w$ à $M, w$ étant décidable, on a bien trouvé une réduction de P à $P_epsilon$, et donc $P$ est indécidable.