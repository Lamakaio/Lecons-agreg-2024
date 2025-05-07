#import "@preview/cetz:0.3.0"
#import "@preview/syntree:0.2.1": tree
#import "@preview/lovelace:0.3.0": *
#import "@preview/codly:1.1.1": *
#import "@preview/codly-languages:0.1.1": *

#import "../utils.typtp": *
#import "lecon_tplt.typtp": lecon

#show: codly-init.with()
#show: lecon.with(
  titre: [Leçon 10 : Arbres : représentations et applications], 
  niveau: [Terminal, MP2I, MPI], 
  prerequis: [], 
  motivations: [Manipuler des données hierarchiques])
\

= Généralités

#blk2("Propriétés")[
  Un arbre est une structure de données qui stocke des éléments de manière hierarchique. Dans un arbre, les données sont appelées noeuds. Chaque noeud a un parent, sauf l'élément du haut appelé racine. Un noeud à potentiellement des enfants. Une feuille est un noeud sans enfant.
]


== Arbre généraux

#def("Arbre généraux")[
  Un arbre est un ensemble de $n>=1$ noeuds structurés de la manière suivante : 
  - un noeud particulier $r$ est appelé la racine de l'arbre
  - les $n-1$ noeuds restants sont partitionnés en $k>=0$ sous ensembles disjoints qui forment autant d'arbres, appelés sous-arbres de r
  - la racine r est liée à la racine de chacun des k sous-arbres.
]

#ex[
  #image("../img/arbre_1.png", width: 30%)
]

#ex[
  Un exemple commun d'arbre est un gestionnaire de fichiers.
]

== Arbre binaire

#def("Arbre binaire")[
  Définition inductive, un arbre binaire est :
  - soit un arbre vide, noté E, ne contenant aucun noeud
  - soit un noeud appelé racine, relié à exactement deux arbres binaire $g$ et $d$, respectivement appelé sous-arbre gauche et sous-arbre droit. On note $N(g,x,d)$ un tel arbre dans la racine porte l'étiquette $x$.
]

#ex[
  représentation d'une expression arithmétique : 
  $3 times(4+1)$ \
  $N(N(E,3,E),times,N(N(E,4,E),+,N(E,1,E)))$\
  _+ dessin_
]

#blk3("Théorème")[
  Il existe une bijection entre abres binaire et abres généraux (pour les arbres non vide).
]

#def("Taille")[
  La taille d'un arbre est le nombre de noeud qui le compose. \
  $t(E) = 0 "et" t(N(g,x,d)) = 1 + t(g) + t(d)$
]

#def("Hauteur")[
  La hauteur d'un arbre est la distance la plus longue de la racine à une feuille.\
  $h(E) = -1 "et" h(N(g,x,d))=1+max(h(g),h(d))$
]

#blk3("Propriété")[
  Soit $t$ un arbre, $n$ son nombre de noeuds et $h$ sa hauteur. Alors :
  - $h+1<=n<=2^(h+1)-1$
  - le nombre de sous-arbres vides de $t$ est $n+1$
]


= Implémentation
== Implémentation avec des pointeurs
#blk2("Propriété")[
  À chaque noeud on associe une valeur et une liste de pointeur qui pointent vers les sous-arbres du noeud. L'arbre vide est représenté par le pointeur NULL.
]

#ex[
  Implémentation d'un arbre binaire avec des pointeurs.
  #image("../img/arbre_2.png", width: 60%)
]

#ex[
  En ocaml on peut utilisé la structure inductive qui utilisera les pointeurs : 
  ```ml
    type 'a arbre_bin = 
      | E
      | N of 'a arbre_bin * 'a * 'a arbre_bin
  ```
]


== Implémentation d'un arbre binaire complet dans un tableau

#def("Arbre binaire complet")[
  Un arbre binaire est dit complet si tous les niveaux à l'exception du dernier sont complètement remplis de noeud et que le dernier niveau est rempli à partir de la gauche.
  #ex[
    #image("../img/arbre_3.png", width: 40%)
  ]
]

#blk2("Propriété")[
  On peut représenter cette arbre par un tableau. \ Le noeud i a pour fils gauche (resp. fils droit) la case 2i+1 (resp. 2i+2) du tableau, sous reserve que 2i+1 < n (resp. 2i+2 < n). \
  Inversement le père d'un noeud i>0 s'obtient avec $floor$(i-1)/2$floor.r$. \
  Cette représentation est très compacte, elle prend $O(n)$ espace mémoire et permet l'accès rapide aux enfants/parents.
]


= Applications
== Parcours d'un arbre binaire
#def("Parcours des arbres")[
  On peut parcourir un arbre de plusieurs façon. Le plu simple est d'utiliser une fonction récursives. 
  Il existe trois parcours : 
  - *préfixe* : qui effectue le traitement du noeud avant le parcours des sous-arbres
  - *infixe* : qui effectue le traitement du noeud entre le parcours du sous-arbre gauche et du sous-arbre droit
  - *postfixe* : qui effectue le traitement du noeud après le parcours des sous-arbres
]

#ex[
  #image("../img/arbre_4.png", width: 20%)
  Préfixe : ABCD\
  Infixe : BCAD\
  Postfixe : CBDA
]

== Arbre binaire de recherche
#def("ABR")[
  Un arbre binaire de recherche est un arbre binaire dont les éléments sont munis d'un ordre total et où, pour chaque sous-arbre $N(g,x,d)$, l'élément $x$ est suppérieur à tous les éléments de $g$ et inférieur à tous les éléments de $d$.
]

#blk3("Propriétés")[
  Pour un ABR de hauteur h, on peut insérer, supprimer et rechercher en $O(h)$.
]

#blk2("Remarque")[
  Si l'arbre est un peigne, on a $h=n$ donc on a les opérations insertion, suppressions, recherche en $O(n)$. On peut améliorer cela.
]

#def("Arbre rouge-noir")[
  ABR ou chaque noeud porte une couleur (noir ou rouge) et vérifie les propriété :
  1. le père d'un noeud rouge n'est jamais rouge
  2. le nombre de noeuds noirs le long d'un chemin de la racine à une feuille est toujours le même.
]

#blk1("Propriété", "Hauteur ARN")[
  Les arbre RN forment un ensemble d'abres équilibrés. La hauteur et donc les opérations se font en $O(log n)$
]

#dev[Insertion dans un arbre Rouge-Noir et preuve des propriétés]

#ex[
  #image("../img/arbre_5.svg", width: 30%)
]

=== Arbre k-dimensionnel
#def("Arbre k-dimensionnel")[
  Un arbre k-dimensionnel est un arbre binaire de recherche qui permet de trouver les plus proches voisins d'un point dans un plan. Les éléments de cette arbre sont comparés à chaque profondeur dans une dimension différentes.
  On effectue un pré-traitement des points de notre plan qui construit cette arbre et nous permet de rechercher les plus proches voisins en moyenne en $O(log(n))$
]

// #dev[Recherche des k plus proche voisins grâce aux arbres k-dimensionnel]

== Tas 
#def("Tas")[
  Un arbre binaire contenant des éléments totalement ordonnées possède la structure de tas si et seulement si : 
  - il est de la forme E, ou
  - il est de la forme $N(g,x,d)$, les arbres $g$ et $d$ possèdent la structure de tas et $x$ est inférieur ou égal à tous les éléments de $g$ et de $d$.
]

#blk2("Propriété")[
  Grâce à la structure de tas, représenté par un arbre binaire, on peut effectuer le tri d'une liste en $O(n log(n))$.
]

#dev[Tri par tas]

