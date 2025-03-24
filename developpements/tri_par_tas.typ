#import "@preview/lovelace:0.3.0": *

#import "../utils.typtp": *
#import "dev_tplt.typtp": developpement

#show: developpement.with(
  titre: [Tri par tas], 
  niveau: [MP2I], 
  prerequis: [Structure de tas], 
)

\
= Intro / Exemple

On implémente la structure de tas à l’aide d’un tableau indexé à partir de 1.
Ainsi le fils gauche (resp. droit) du nœud en case i est en case 2i (resp. 2i + 1) et le père d’un nœud i est en case  $floor$i/2$floor.r$.

#image("../img/tas_ex.png")

= Écriture de Entasse(T, i)

== Algorithme
L’algorithme Entasse(T, i) transforme le sous-arbre de racine i en un tas, en supposant que les deux fils de i sont bien des tas.
On compare l’élément d’indice i avec ses deux fils, on place le maximum des trois éléments à l’indice i en l’échangeant avec l’ancien élément qui était en i et ensuite on entasse de nouveau à partir de l’indice du fils qui a été modifié.

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
#image("../img/tas_entasse.png")


== Correction
L’algorithme termine car la hauteur de l’arbre est finie et que l’on appelle la fonction Entasse sur un sous-arbre dont la hauteur est strictement plus petite que l’arbre initial. Le variant est donc $h(i)$ où $h(i)$ désigne la hauteur du sous-arbre enraciné en i. \

On montre la correction par récurrence sur la hauteur de l’arbre enraciné en i.\
Soit G, D les sous-arbres gauche et droits enracinés en 2i et 2i + 1.\
- Si max = i, alors G et D sont inchangés, et le sous-arbre de T enraciné en i est un tas puisque G et D en sont et que T[i] > max(T[2i], T[2i + 1]).
- Sinon, par symétrie, on peut supposer max = 2i+1, c’est-à-dire qu’on échange T[i] et T[2i + 1] puis qu’on appelle _Entasse_ sur D. Le sous-arbre G ainsi que les sous-arbres gauche et droit de D ne sont pas affectés par cet échange, ce sont donc toujours des tas. De plus $h(2i + 1) < h(i)$, donc l’hypothèse de récurrence appliquée à D assure que _Entasse(T, 2i + 1)_ transforme D en tas. La nouvelle racine de D est un élément présent initialement dans D, il est donc inférieur à T[2i + 1]. Ainsi, l’arbre enraciné en i est bien un tas. 
Cela montre la correction de l’algorithme _Entasse_.\

== Complexité
Cet algorithme effectue seulement des comparaisons, des affectations ou des échanges (opérations en coût constant) puis effectue de nouveau l’algorithme sur un seul de ses fils au pire des cas, donc la complexité est en $O(h(i))$. Or on a $h(i) ⩽ h =floor log(n) floor.r$ car le tas est quasi-complet. Ainsi la complexité de
_Entasse_ est au pire en $O(log n)$.

= Écriture de Construit(tab)

== Algorithme
On va commencer par construire des tas à partir des feuilles et remonter petit à petit jusqu’à la racine en utilisant les tas déjà fabriqués et la fonction _Entasse_.

#pseudocode-list(hooks: .5em, booktabs: true)[
  *Construit (tab) :*
  + T.taille = len(tab)
  + T.tab = tab
  + *Pour* i de $floor$T.taille/2$floor.r$ à 1 :
    + Entasse(T,i)
]
#image("../img/tas_construit_1.png")
#image("../img/tas_construit_2.png")

== Correction
L’algorithme _Construit_ termine puisqu’il contient une boucle bornée dans laquelle on appelle la fonction Entasse qui termine. \

Les éléments enracinés en i pour i allant de T.taille à $floor$T.taille/2$floor.r$+1 sont des feuilles et donc sont déjà des tas. Ensuite un invariant de boucle est « l’arbre issu de i est un tas ». En effet, on entasse pour chaque i (pris dans l’ordre décroissant) un arbre dont les deux fils sont des tas par l’invariant de boucle. Ainsi l’algorithme _Construit_ est correct.


== Complexité
La complexité de Construit est naïvement en $O(n log(n))$ car pour chaque élément on appelle Entasse, mais on peut calculer plus finement pour avoir une complexité
linéaire.\

Chaque nœud qui est de profondeur $p$ s’entasse en $O(h−p)$ et il y a au plus $2p$ nœuds de profondeur $p$ dans le tas. \

La complexité de Construit est en $O(n)$ car \

$sum_(p=0)^(h-1) 2^p (h-p) = sum_(k=1)^(h) 2^(h-k)k = 2^h sum_(k=1)^(h) (1/2)^k k <= n sum_(k=1)^(+infinity) (1/2)^k k = O(n)$ \ 

(_car $sum_(k=1)^(+infinity) (1/2)^k k$ tend vers 2_)

Ainsi la complexité de _Construit_ est linéaire en le nombre d’éléments du tableau.

= Écriture de Tri_tas(tab)

== Algorithme 
Dans l’algorithme _Tri_tas(T)_, on va construire notre tas, échanger l’élément maximum et le dernier élément du tas, diminuer la taille du tas de 1, puis faire  redescendre la racine dans le tas avec la fonction _Entasse_. Ainsi à la fin de l’algorithme les éléments seront triés par ordre croissant.

#image("../img/tas_tri.png")

#pseudocode-list(hooks: .5em, booktabs: true)[
  *Tri_tas (tab) :*
  + T = Construit(tab)
  + *Pour* i de T.taille à 2 :
    + Echanger T.tab[1] et T.tab[i]
    + T.taille -= 1
    + Entasse(T,i)
  + *Retourner* T.tab
]

== Correction
L’algorithme du tri par tas termine puisqu’il possède une boucle bornée qui ne contient que des instructions qui terminent. \

Grâce à la correction de _Construit_, on part d’un tas. On appelle L la longueur du tableau initial. Un invariant de boucle est « les éléments entre L−i+1 et L sont les éléments les plus grands du tableau initial et sont rangés dans l’ordre croissant ». En effet, à l’étape i on place l’élément maximal du tas (qui contient les L−i+1 plus petits éléments du tableau) en position L−i+1, par invariant de boucle, il est plus petit que les éléments entre L−(i−1)+1 et L, donc à la fin de l’étape i, l’invariant de boucle est vérifié. Ainsi, à l’étape L, le tableau contient tous les éléments rangés dans l’ordre
croissant, donc l’algorithme du tri par tas est correct.\

La complexité du tri par tas est en $O(n)+n×O(log n) = O(n log n)$.