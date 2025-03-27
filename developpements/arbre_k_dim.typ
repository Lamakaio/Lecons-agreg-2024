#import "@preview/lovelace:0.3.0": *

#import "../utils.typtp": *
#import "dev_tplt.typtp": developpement

#show: developpement.with(
  titre: [Arbre k-dimensionnel], 
  niveau: [MPI], 
  prerequis: [ABR], 
)
\
= Introduction
Rechercher les 𝑘 plus proches voisins par une exploration exhaustive parmi n points de $RR^K$ données peut être coûteux. $O(n²)$. \
On peut effectuer un pré-traitement qui construit un arbre binaire de recherche pour que l’on puisse rapidement trouver les k plus proches voisins d’un point $x ∈ RR^K$
\
\
= Construction

== Algorithme
Un arbre K-dimensionnel de n points de $RR^K$ est un arbre binaire de recherche sur K dimension avec :
- chaque noeud comporte un point
- pour un noeud de profondeur i contenant le point x :
  - pour y contenu dans le sous-arbre gauche, $y_(i%K)<=x_(i%K)$
  - pour y contenu dans le sous-arbre droit, $y_(i%K)>=x_(i%K)$
- les sous-arbres gauche et droit d'un noeud ont à peu près la même taille
\
#image("../img/k_dim_ex.png")

Entrées : 
- P : liste des points à classer dans l'arbre k-dimensionnel 
- i : profondeur de l'arbre 
Sortie : 
- Arbre k-dimensionnel contenant les éléments de P

#pseudocode-list(hooks: .5em, booktabs: true)[
  *Construction(P, i):*
  + *Si* len(P) = 0 :
    + *Retourner* l'arbre vide
  + axe = i mod K;
  + median = point médiant de P sur axe
  + g = éléments de P inférieurs à médiant sur axe
  + d = éléments de P supérieures à médiant sur axe
  + noeud.point = médian
  + noeud.filsGauche = Construction(i+1, g)
  + noeud.filsDroit = Construction(i+1, d)
  + *Retourner* noeud
]


== Complexité
$C(n) = C(ceil((n − 1)/2)) + C(floor((n − 1)/2)) + "Mediane"(n)$ \
Donc si la médiane est fait en temps linéaire : C(n) = O(n log(n))

= Recherche

== Algorithme
Une fois notre arbre k-dimensionnel construit, comment trouver les k plus proche voisins d'un point $x$ ?

#image("../img/k_dim_recherche.png")


#pseudocode-list(hooks: .5em, booktabs: true)[
  *Visite(noeud, p, i, k, pq) :*
  + *Si* noeud n'est pas vide :
    + axe = i mod K
    + *Si* p[axe] < noeud.point[axe] :
      + Visite(noeud.filsGauche, p, i+1, k, pq)
    + *Sinon* :
      + Visite(noeud.filsDroit, p, i+1, k, pq)
    + r = distance entre p et sommet de pq
    + c = distance entre p et noeud.point
    + *Si* len(pq) < k ou r >= c :
      + Ajouter noeud.point à pq
      + *Si* len(pq) > k :
        + extraire min de pq
      + *Si* p[axe] < noeud.point[axe] :
        + Visite(noeud.filsDroit, p, i+1, k, pq)
      + *Sinon* :
        + Visite(noeud.filsGauche, p, i+1, k, pq)
]

#pseudocode-list(hooks: .5em, booktabs: true)[
  *Recherche(racine, k, p) :*
  + pq = file de priorité vide
  + Visite(racine, p, 0, k, pq)
  + *Retourner* pq sous forme de tableau
]

== Complexité
Dans le pire des cas $O(n)$
En moyenne $O(log n)$