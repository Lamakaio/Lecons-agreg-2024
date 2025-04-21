#import "../utils.typtp": *
#import "dev_tplt.typtp": developpement
#import "@preview/syntree:0.2.1": tree

#show: developpement.with(
  titre: [Indécidabilité de propriétés sur les grammaires], 
  niveau: [MPI], 
  prerequis: [Indécidabilité])

#rect[sources : le ellipse je crois ? le deuxième screen que m'a envoyé Félix en tout cas]
#text(fill: red)[à tester, mais faut probablement rajouter un truc à ce développement]

On admet dans ce developpement que le problème de correspondance de POST est indécidable. 

= Le problème de correspondance de POST (PCP)
#text(fill: red)[Partie à inclure si pas déjà dans le plan]

Le problème PCP est un problème de décision : \
#def[PCP][
- *entrée :* On se donne un alphabet $Sigma$, et un ensemble de tuiles $binom(u_1, v_1), dots, binom(u_n, v_n)$ ($n in NN$), où $u_i, v_i in Sigma^*$ sont des mots sur $Sigma$. 
- *sortie :* existe-il une suite d'indice $i_1, ..., i_p$ avec $p in NN$, tels que $u_(i_1) dots u_(i_p) = v_(i_1) dots v_(i_p)$

En français, est ce qu'on peut faire une suite de tuiles telles qu'il y ai écrit la même chose en bas et en haut. 
]
= Intersection indécidable
On veut montrer que le problème suivant est indécidable : 
#def[Problème de l'intersection][
- *entrée :* deux grammaires, $G_1$ et $G_2$
- *sortie :* peuvent-elles engendrer le même mot ? ie est ce que $L_(G_1) inter L_(G_2) = emptyset$
]


Pour cela, on va faire une réduction depuis une instance de PCP. Soit donc $u_1, ..., u_n$ et $v_1, ..., v_n$ une instance. 

On se donne un nouvel alphabet $Sigma' = Sigma union {a_1, ..., a_n}$ avec les $a_i$ de nouvelles lettres qui ne sont pas dans $Sigma$.

On défini les languages $L_u$ et $L_v$ sur $Sigma'$ par : 
- $L_u = {u_(i_1) dots u_(i_p) a_(i_1) dots a_(i_p) | (i_1, ..., i_p) in NN^p, p in NN}$
- $L_v = {v_(i_1) dots v_(i_p) a_(i_1) dots a_(i_p) | (i_1, ..., i_p) in NN^p, p in NN}$

#blk2[Propriété][Les languages $L_u$ et $L_v$ sont algébriques]

#blk2[Preuve][
On pose $G_u$ la grammaire définie par la règle : 

$S -> u_1 S a_1 | u_2 S a_2 | ... | u_n S a_n | epsilon$.

Cette grammaire engendre clairement le language $L_u$. On définit de même $G_v$.

Donc les languages $L_u$ et $L_v$ sont algébriques.
]


*Supposons qu'on ai $L_u inter L_v != emptyset$.*

Alors, on a un mot $m in L_u inter L_v$, et il est de la forme $m = u_(i_1) dots u_(i_p) a_(i_1) dots a_(i_p)$ _et_ $m = v_(i'_1) dots v_(i'_p') a_(i'_1) dots a_(i'_p')$ (à priori, avec des indices qui peuvent être différents). 

Mais, comme les $a_i$ ne sont pas présents dans $Sigma$, on a nécéssairement $a_(i_1) dots a_(i_p) = a_(i'_1) dots a_(i'_p')$ et donc $i_1 = i'_1, ..., i_p = i'_p'$

Donc on a : $u_(i_1) dots u_(i_p) = v_(i_1) dots v_(i_p)$, et l'instance de PCP est positive (il existe une solution).


*Inversement, supposons que l'instance de PCP aie une solution*.

On a donc des indices tels que $u_(i_1) dots u_(i_p) = v_(i_1) dots v_(i_p)$. 

Or, $m_u = u_(i_1) dots u_(i_p) a_(i_1) dots a_(i_p) in L_u$, et $m_v = v_(i_1) dots v_(i_p) a_(i_1) dots a_(i_p) in L_v$. 

De plus, $m_u = m_v$, et donc $m_u in L_u inter L_v$.

Donc l'instance de PCP a une solution si et seulement si $L_(G_u) inter L_(G_v) != emptyset$, et donc le problème de l'intersection des languages de deux grammaires est indécidable ! 

= Ambiguité indécidable

#def[Problème de l'ambiguité][
- *entrée* une grammaire G 
- *sortie* la grammaire G est-elle ambigue, c'est à dire, existe-il un mot qui a deux dérivations distinctes.
]

On va à nouveau partir d'une instance de PCP. 

On défini la grammaire G suivante : 

$S -> U | V$\
$U ->^u u_1 U a_1 | ... | u_n U a_n | epsilon$ \
$V ->^v v_1 V a_1 | ... | v_n V a_n | epsilon$ \

*Supposons que la grammaire G soit ambigue*

Alors, on peux prendre un mot $m$ qui aie deux dérivations distinctes. 

Les dérivations de G sont toutes de la forme : 
- soit $S -> U ->^u ... ->^u m$
- soit $S -> V ->^v ... ->^v m$

De plus, $m$ est de la forme $m = m' a_(i_1) ... a_(i_p)$ avec $m' in Sigma^*$, et donc, toutes les étapes de dérivation qui suivent la première sont forcées : il ne peut pas y avoir d'ambiguité. 

Donc l'ambiguité est forcément sur la première étape de la dérivation. 

Donc on a des indices tels que $m = u_(i_1) dots u_(i_p) a_(i_1) dots a_(i_p)$ _et_ $m = v_(i'_1) dots v_(i'_p') a_(i'_1) dots a_(i'_p')$, ce qui donne bien une solution au PCP. 

*Inversement, si on a une solution au PCP* 
On prend un mot $m' = u_(i_1) dots u_(i_p) = v_(i_1) dots v_(i_p)$ qui est solution, et alors on a bien $m = u_(i_1) dots u_(i_p) a_(i_1) dots a_(i_p) = v_(i_1) dots v_(i_p) a_(i_1) dots a_(i_p)$. 

On a donc deux dérivations de $m$, une en passant par les $v_i$ et une par les $u_i$. 

Donc l'instance de PCP a une solution si et seulement si la grammaire G est ambigue. 

Donc le problème de l'ambiguité d'une grammaire est indécidable