#import "../utils.typtp": *
#import "dev_tplt.typtp": developpement
#import "@preview/syntree:0.2.0": tree

#show: developpement.with(
  titre: [3-SAT est NP-complet], 
  niveau: [MPI], 
  prerequis: [NP-complétude, SAT])

= SAT est NP
C'est assez trivial : on prend comme certificat une valuation qui satisfait la formule, et la vérification est polynomiale. 

= SAT est NP-difficile
On va réduire SAT à 3-SAT. Ainsi, on se donne une instance de SAT, à savoir une formule propositionelle $Phi$ sur l'ensemble de variables $V$.

== Elimination des négations
On peut, en appliquant les lois de De Morgan récursivement, faire descendre toutes les négations jusqu'aux variables. Plus précisément, on applique la transformation $h$ telle que
- $"si" x in V, h(x) = x "et" h(not x) = not x$
- $h(phi_1 and phi_2) = h(phi_1) and h(phi_2)$, de même pour $or$
- $h(not (phi_1 and phi_2)) = h(not phi_1) or h(not phi_2)$, de même pour $or$
- $h(not not phi) = h(phi)$

On a clairement $h(phi) eq.triple phi$, et la transformation $h$ ajoute au plus un symbole pour chaque symbole consommé, c'est à dire double le nombre de symbole. 

Donc la transformation est polynomiale.

Ainsi, on peut considérer que notre formule ne contient que des $and$ et des $or$, sauf au niveau des cas de bases où on s'autorise des littéraux. 

== Construction de la formule 3-SAT depuis l'arbre syntaxique

On ne va pas construire une formule équivalente à $Phi$, mais plutôt une formule equisatisfiable. 

Pour cela, on va encoder l'arbre syntaxique de $Phi$ dans une formule 3-SAT. Pour cela, on introduit de nouvelles variables $(alpha_0, ..., alpha_n)$ pour chaque noeud interne de l'arbre syntaxique. (exemple en @fig1)

#figure(caption: [Arbre syntaxique de $(a or b) and (not c or b)$])[
  #tree($and, alpha_0$, 
    tree($or, alpha_1$, $a$, $b$),
    tree($or, alpha_2$, $not c$, $b$),
  )
]<fig1>

On va encoder les dépendances entres ces variables sous formes de clauses. 

Soit $i in [|0, n|]$. On prend $~^i$ l'opérateur correspondant à $alpha_i$, et $d_i, g_i$ ses fils droits et gauches.

On ajoute alors la contrainte : $alpha_i <-> d_i ~^i g_i$. 

Cela nous donne $n$ contraintes $c_1, ..., c_n$, que l'on va réécrire sous forme de clauses de 3-SAT. 

Si a, b, c sont des formules, on a :
- $a <-> b and c &eq.triple (a and b and c) or (not a and not (b and c))\
  &eq.triple cancel((a or not a)) and (a or not b or not c) and (b or not a) and cancel((b or not b or not c)) and (c or not a) and cancel((c or not b or not c))\
  &eq.triple (a or not b or not c) and (b or not a) and (c or not a)$

- $a <-> b or c &eq.triple (a and (b or c)) or (not a and not (b or c))\
  &eq.triple cancel((a or not a)) and (a or not b) and (a or not c) and (b or c or not a) and cancel((b or c or not b)) and cancel((b or c or not c))\
  &eq.triple (a or not b) and (a or not c) and (b or c or not a)$


On peut donc transformer ces $n$ contraintes en $3n$ clauses de 3-SAT, que l'on va nommer $C_1, ..., C_(3n)$. 

Notre formule 3-SAT équisatisfiable à $Phi$ est alors : 
$Psi = and.big_(i=1)^(3n) C_i and alpha_0$

== Preuve de l'equisatifiabilité
On a montré que $Psi eq.triple psi = and.big_(i=1)^n c_i and alpha_0$ : les contraintes sont équivalentes aux clauses. On va donc faire la preuve avec $psi = and.big_(i=1)^n c_i and alpha_0$, c'est à dire directement avec les contraintes plutôt qu'avec les clauses. 
=== $->$ 
Supposons que $Phi$, notre formule de base, soit satisfiable, et soit $sigma$ une valuation qui la satisfasse. Montrons que $psi$ est satifiable.

On va construire $sigma'$ une sur-valuation de $sigma$, qui a la même valeur que $sigma$ sur $V$ l'ensemble des variables de $Phi$, et qui satisfait $psi$

Pour chaque variable supplémentaire $alpha_i in {alpha_1, ..., alpha_n}$, on prend la sous formule $Phi|_i$ de $Phi$ associée au noeud $i$, et on pose $sigma'(alpha_i) = [Phi|_i]_(sigma)$.

Montrons que, $forall i in [|1, n|], "si" C_("i")$ est la clause associée à $alpha_i$, alors $[C_("i1") and C_("i2") and C_("i3")]_sigma' = 1$

Soit $d_i$ et $g_i$, des littéraux, les fils droit et gauches de $alpha_i$. On a $C_i = alpha_i <-> d_i ~^i g_i$, avec $~^i$ qui est  $or "ou" and$.

Soit $f_i$ la sous formule de $Phi$ associée au noeud $i$ de l'arbre. Soit $f_("di")$ et $f_("gi")$ ses fils droit et gauches (des formules). 

On a, par définition : $[f_("di")]_sigma = [d_i]_sigma'$ et de même à gauche. 

$"Donc :" [d_i ~^i g_i]_sigma' &= [f_("di") ~^i f_("gi")]_sigma \
 &=[f_i]_sigma\
 &=[alpha_i]_sigma' \
"Et donc" [C_i]_sigma = 1$ 

De plus, par définition, $[alpha_0]_sigma' = [Phi]_sigma = 1$, et donc $[psi]_sigma' = 1$
=== $<-$

Supposons $psi$ satisfiable par une valuation $sigma$. Montrons que $[Phi]_sigma = 1$ (cette fois, on a le même $sigma$, car les variables de $Phi$ son inclues dans celle de $psi$).

On note $Phi|^k$ la formule obtenue en "coupant" l'abre syntaxique au niveau $k$, et en écrivant la formule correspondant à l'arbre découpé, avec les feuilles étant soit des littéraux de $Phi$, soit des $alpha_i$.

Par exemple, dans le cas de la @fig1, $Phi|^0 = alpha_0$, $Phi|^1 = alpha_1 and alpha_2 "et" Phi|^3 = (a or b) and (not c or b) = Phi$

On remarque que si $k$ est plus grand que la hauteur de $Phi$, alors $Phi|^k = Phi$. 

Maintenant, montrons par récurrence sur $k$ que $[Phi|^k]_sigma = 1$.

- [Cas de base] : $[Phi|^0]_sigma = [alpha_0]_sigma = 1$, car $alpha_0$ est une clause de $psi$.

- [Récurrence] : Supposons que $[Phi|^k]_sigma = 1$. On pose $Alpha$ l'ensemble des $alpha_i$ qui sont des feuilles de $Phi|^k$. Alors, on pose pour $a in Alpha$, $d$ et $g$ ses fils droits et gauches, et $~$ l'opérateur correspondant. On va appliquer le remplacement $Phi|^k [a -> d ~ g]$ pour chacun de ces $a$, ce qu'on note $Phi|^k [A -> D ~ G]$.

On remarque déjà que $Phi|^k [A -> D ~ G] = Phi|^(k+1)$. 

De plus, montrons qu'aucun des remplacements ne change la valeur de vérité de la formule. 

Par définition de $psi$, elle contient la clause $a <-> d ~ g$. Donc $[a]_sigma = [d ~ g]_sigma$. Donc pour toute formule $f$, $[f]_sigma = [ f[a -> d ~ g] ]_sigma$. 

En appliquant cette relation pour chaque élément de $A$, on a 

$[Phi|^(k+1)]_sigma = [Phi|^k [A -> D ~ G]]_sigma = [Phi|^k]_sigma = 1$