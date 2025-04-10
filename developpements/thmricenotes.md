Trouver des lettres pour que ce soit clair. 
Possiblement faisable sans les Lp', troiver un meilleur gadget ? 



Terminaison : 
Pi_term = {p | p termine sur toute entrée}

Correction : 
Pi_cor = {p | pour toute entrée, p donne une sortie qui respecte une post condition}


Soit P ens des programmes. 


Un pb non trivial si Pi pas vide et Pi pas P



Deux prog A et B sont sémantiquement équivalents A~B si, pour toute entrée, soit A et B ne terminent pas, soit A et B terminent et ont la même sortie 

Un problème est sémantique si pour A, B deux programmes tels que A~B, A dans Lp ssi B 

Thm de Rice : tout problème sur les programmes, non trivial et sémantique, est indécidable 

Preuve : réduction à l'arrêt

On suppose Lp dzcisable, et donc il existe A qui décide lp 

p -> f -> instance de lp -> A -> accepte ou refuse 

entrée : P1, P2 
Question : l'un dans Lp, l'autre non 

P1 -> A -> 
            xor -> sortie 
P2 -> A -> 


On a bien une solution à Lp' 

f (p, q)
on pose A_1 un prog qui boucle à l'infini. 

Comme Lp' est non-trivial, il existe A_2 tq A'(A_1, A_2) accepte. 

On construit A3 : 
- executer P sur w 
- executer A2

P -> f -> A_1, A_3 -> A', qui va soit refuser soit accepter. 

Si P termine, alors A_3 ~ A_2. 

Donc A'(A_3, A_1) = A'(A_2, A_1) = 1. Donc P, w est accepté. 

Si P ne termine pas. Alors A_3 ne termine pas, et A_3 ~ A_1. 

A'(A_3, A_1) = A'(A_1, A_1). Donc p,w est refusé. 

absurde ! donc Lp est indécidable. 