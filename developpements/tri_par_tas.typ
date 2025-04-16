#import "@preview/lovelace:0.3.0": *

#import "../utils.typtp": *
#import "dev_tplt.typtp": developpement

#show: developpement.with(
  titre: [Tri par tas], 
  niveau: [MP2I], 
  prerequis: [Structure de tas], 
)

\
= Rappel + implémentation 

Définition de tas-max :
- Arbre binaire complet à gauche
- Definition inductive :
  - Cas de base : l'arbre vide est un tas, une feuille est un tas
  - Cas inductif : un noeud contenant la valeur $v$ et contenant deux sous-arbres $g$ et $d$ est un tas si $g$ et $d$ sont des tas et si $v>=v_g "et" v>=v_d$

#image("../img/tas_ex.png", width: 80%, )

On implémente la structure de tas à l’aide d’un tableau indexé à partir de 1.
Pour un nœud en case i :
- son fils gauche est case 2i
- son fils droit est case 2i+1
- son père est case  $floor$i/2$floor.r$
\
\

= Écriture de Entasse(T, i)

== Algorithme
\ 
#underline[Entasse(T,i)]\
Entrées :
 - T : un arbre binaire complet à gauche sous forme de tableau
 - i : l'indice d'un nœud de l'arbre, les sous-arbres de ce nœud sont des tas-max
Sortie : 
 - T modifié en un tas-max contenant les mêmes éléments initiaux

#image("../img/tas_entasse.png")


_On compare l’élément d’indice i avec ses deux enfants, on place le maximum des trois éléments à l’indice i en l’échangeant avec l’ancien élément qui était en i et ensuite on entasse de nouveau à partir de l’indice du fils qui a été modifié._
\


#pseudocode-list(hooks: .5em, booktabs: true)[
  *Entasse (T, i) :*
  + max = i
  + g = 2i
  + d = 2i+1
  + *Si* g $<=$ T.taille et T.tab[g] $>$ T.tab[max] :
    + max = g
  + *Si* d $<=$ T.taille et T.tab[d] $>$ T.tab[max] :
    + max = d
  + *Si* max $!=$ i :
    + Echanger T.tab[i] et T.tab[max]
    + Entasse (T, max)
]


== Correction

#underline("Terminaison :")\
Variant : h(i), la hauteur de l'arbre enraciné en i

#underline("Correction :")\
Montrons que Entasse renvoie bien un tas-max. \
Récurrence sur h(i).\
Soit G, D les sous-arbres gauche et droits enracinés en 2i et 2i + 1.\
- Cas max = i :\
  G et D sont inchangés donc tas-max, et T.tab[i] > max(T.tab[2i], T.tab[2i + 1]) donc T enraciné en i est un tas-max
- Cas max = 2i+1 :\
  - On échange T.tab[i] et T.tab[2i + 1] \
    G reste un inchangé et donc reste un tas-max.\
    Les sous-arbres de D reste inchangé et donc des tas-max. Les préconditions de _Entasse(T, 2i + 1)_ sont remplies \
  - On _Entasse_ sur D :
    $h(2i + 1) < h(i)$, donc par hypothèse de   récurrence _Entasse(T, 2i + 1)_ transforme D en tas.\
    La nouvelle racine de D est présent initialement dans D, il est donc inférieur à T.tab[2i + 1]. \
- Cas max = 2i : cas symétrique
Ainsi, l’arbre enraciné en i est bien un tas. 

== Complexité
Cet algorithme effectue seulement des opérations en $O(1)$ puis effectue de nouveau l’algorithme sur un seul de ses fils au pire des cas, donc la complexité est en $O(h(i))$.\
Or on a $h(i) ⩽ h =floor log(n) floor.r$ car le tas est quasi-complet. Ainsi la complexité de
_Entasse_ est au pire en $O(log n)$.

= Écriture de Construit(tab)

== Algorithme

Entrée : tab un tableau à trier\
Sortie : T un tas-max contenant les éléments de tab\

_On va commencer par construire des tas à partir des feuilles et remonter petit à petit jusqu’à la racine en utilisant les tas déjà fabriqués et la fonction _Entasse_._

_Peut etre ne pas écrire le code et juste faire l'exemple si on fait la correction de entasse_
#pseudocode-list(hooks: .5em, booktabs: true)[
  *Construit (tab) :*
  + T.taille = len(tab)
  + T.tab = tab
  + *Pour* i de $floor$T.taille/2$floor.r$ à 1 :
    + Entasse(T,i)
]
#image("../img/tas_construit_1.png")
#image("../img/tas_construit_2.png", width:70%)

== Correction
#underline("Terminaison :") \
_Entasse_ termine et on prend comme variant i. \

#underline("Correction :") \
Les éléments enracinés en i pour i allant de T.taille à $floor$T.taille/2$floor.r$+1 sont des feuilles et donc sont déjà des tas. \
Un invariant de boucle est « l’arbre issu de i est un tas ». \
On entasse pour chaque i,pris dans l’ordre décroissant, un arbre dont les deux fils sont des tas. Comme _Entasse_ rencoie un tas-max _Construit_ est correct.


== Complexité
_dire que on peut calculer en $O(n)$ mais ne pas faire le calcul l'avoir sur papier si question_

#text(fill: gray)[
\
La complexité de Construit est naïvement en $O(n log(n))$ car pour chaque élément on appelle Entasse, mais on peut calculer plus finement pour avoir une complexité linéaire.\

Chaque nœud qui est de profondeur $p$ s’entasse en $O(h−p)$ et il y a au plus $2p$ nœuds de profondeur $p$ dans le tas. \

La complexité de Construit est en $O(n)$ car \

$sum_(p=0)^(h-1) 2^p (h-p) = sum_(k=1)^(h) 2^(h-k)k = 2^h sum_(k=1)^(h) (1/2)^k k <= n sum_(k=1)^(+infinity) (1/2)^k k = O(n)$ \ 

(_car $sum_(k=1)^(+infinity) (1/2)^k k$ tend vers 2_)

Ainsi la complexité de _Construit_ est en $O(n)$
]
= Écriture de Tri_tas(tab)

== Algorithme 
Dans l’algorithme _Tri_tas(T)_, on va:
- construire notre tas
- échanger l’élément maximum et le dernier élément du tas
- diminuer la taille du tas de 1
- faire  redescendre la racine dans le tas avec la fonction _Entasse_
Ainsi à la fin de l’algorithme les éléments seront triés par ordre croissant.

#image("../img/tas_tri.png")

#pseudocode-list(hooks: .5em, booktabs: true)[
  *Tri_tas (tab) :*
  + T = Construit(tab)
  + *Pour* i de T.taille à 2 :
    + Echanger T.tab[1] et T.tab[i]
    + T.taille - -
    + Entasse(T,i)
  + *Retourner* T.tab
]
#text(fill: gray)[
== Correction
#underline("Terminaison :") \
_Entasse_ termine et on prend comme variant i. \

#underline("Correction :") \
Grâce à la correction de _Construit_, on part d’un tas.\
On appelle L la longueur du tableau initial. Un invariant de boucle est « les éléments entre L−i+1 et L sont les éléments les plus grands du tableau initial et sont rangés dans l’ordre croissant ». \
En effet, à l’étape i on place l’élément maximal du tas en position L−i+1, par invariant de boucle, il est plus petit que les éléments entre L−(i−1)+1 et L, donc à la fin de l’étape i, l’invariant de boucle est vérifié.\
Ainsi, à l’étape L, le tableau contient tous les éléments rangés dans l’ordre croissant, donc l’algorithme du tri par tas est correct.\

La complexité du tri par tas est en $O(n)+n×O(log n) = O(n log n)$.
]