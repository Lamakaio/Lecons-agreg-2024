#import "@preview/lovelace:0.3.0": *

#import "../utils.typtp": *
#import "dev_tplt.typtp": developpement

#show: developpement.with(
  titre: [Algorithme d'analyse syntaxique descendant par retour sur trace], 
  niveau: [MPI], 
  prerequis: [Grammaire], 
)
\
= Objectif : \
implémenter un algorithme d'analyse syntaxique descendant pour vérifier l'appartenance d'un mot à un langage défini par une grammaire.

Entrée : G une grammaire, $u$ le mot d'entrée , $v$ le mot en court (pouvant contenir des symboles non terminaux), #text(fill:red)[$l$ la longueur restante de la dérivation autorisée]

Sortie : Vrai ssi il existe une dérivation $v->^*u$ #text(fill:red)[de longueur inférrieur à l]

_Essayer de dérouler l'algo en même temps que l'exemple_
\

#grid(columns: (1fr, 1fr),
grid.cell[
= Exemple 
Soit $G = (V, Σ, R, S)$ avec : \
$V={S,T}$
$Sigma = {a,b,c}$\

$R: &S -> a S b | a T b\
&T -> c | T c$\
On alors $L(G) = {a^n c^m b^n, n,m > 0}$\
On cherche à savoir si $u = $aacbb $in L(G)$

#image("../img/analyse_s_1.png", width: 80%)
],

grid.cell[

= Algorithme 
#pseudocode-list(hooks: .5em, booktabs: true)[
  *Analyse(G,u,v, #text(fill:red)[l])* :
  + #text(fill:red)[*Si* l < 0 :]
    + #text(fill:red)[*retourner* Faux]
  + *Si* v est vide :
    + *retourner* u est vide
  + a, v2 = dépiler(v) //première lettre de v
  + *Si* a $in V$ :
    + *Pour* chaque règle a -> x : 
      + *Si* Analyse(G, u, x+v2, #text(fill:red)[l-1]) :
        + *Retourner* Vrai
    + *Retourner* Faux
  + *Sinon* :
    + *Si* u est vide : 
      + *Retourner* Faux
    + b, u2 = dépiler(u)
    + *Si* a $!=$ b :
      + *Retourner* Faux
    + *Retourner* Analyse(G, u2, v2, #text(fill:red)[l])
]
]
)
\

Il suffit d'appeler Analyse(G, u, S, #text(fill:red)[l_max]) pour déterminer si  $u in L(G)$ #text(fill:red)[avec l_max la longeur maximal de dérivation]\

*Remarque :*\
Si on arrive dans une règle qui contient une dérivation gauche comme la règle $T -> T c$, alors notre algorithme ne termine pas. \
#text(fill:red)[Pour résoudre ça on ajoute une longeur maximal de dérivation.]
Maintenant l'algorithme termine avec comme variant l.

*Choisir l_max* :
#blk2("Théorème")[
  Soit G une grammaire et $m in Sigma^*$ . Les deux assertions suivantes sont équivalentes :
  — m ∈ L(G)
  — il existe une dérivation reconnaissant $m$ dont la longueur est inférieure à $a^(|m| times r)$
  où a est le nombre maximum de symbole à droite d’une règle, et r le nombre de non-terminaux.
]
On prend l_max = $a^(|m| times r)$.

= Correction
P : "Analyse(G, u, v, l) renvoie vrai ssi" il existe une dérivation $v->^*u$ de longeur maximum l"\

Cas de base :
- Si l < 0 : on ne peut pas dériver avec une longueur négative
- Si v est vide :
  - si u est vide v dérive en u en longueur 0, donc P vrai
  - sinon v ne peut dériver en u, donc P vrai 

Cas inductif :
- Si a est un non-terminal :
  $v ->^l u <=> exists a -> x "tq" x v_2 ->^(l−1) u$ \
- Sinon : $forall w in (Sigma union V )^* , v ->^l a w <=> v 2 ->^l w$ \  

Par induction P est vrai

