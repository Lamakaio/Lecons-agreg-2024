#import "@preview/cetz:0.3.0"
#import "@preview/syntree:0.2.1": tree
#import "@preview/lovelace:0.3.0": *
#import "@preview/codly:1.1.1": *
#import "@preview/codly-languages:0.1.1": *

#import "../utils.typtp": *
#import "lecon_tplt.typtp": lecon


#show: codly-init.with()
#show: lecon.with(
  titre: [Leçon 5 : Implémentations et applications des piles, files et files de priorité], 
  niveau: [NSI/MP2I], 
  prerequis: [Tableau, Liste, Arbres])


= Piles (NSI)
== Définition

#blk1("Définition", "Pile")[
  Une pile est une structure de donnée, représentant une collection de données du même type, sur le principe de "dernier arrivé, premier servi" (LIFO en anglais). Elle dispose des opérations suivantes :
  - PileVide : teste si la pile est vide
  - Dépiler : supprime le sommet de la pile et le renvoie
  - Empiler : ajoute un élément au sommet de la pile 
]

#blk2("Analogie")[Une pile d'assiettes]

== Implémentations
=== Avec une liste
L'implémentation de base de la pile utilise une liste.
#blk1("Programme", "Implémentation d'une pile en Ocaml")[
  #codly(languages: codly-languages)
```ocaml
type 'a pile = 'a list;;
let pileVide (p : 'a pile) : bool = (p = []);;
let empile (p : 'a pile) (x: 'a) : 'a pile = x::p;;
let depile (p : 'a pile) : 'a * 'a pile = match p with 
  |[] -> failwith "Erreur : pile vide"
  |x::q -> (x, q);;

(*les trois fonctions ont une complexité en O(1)*)
```]
#blk2("Remarque")[
  Les listes en OCaml sont immutables, et donc notre pile l'est aussi.
]

#blk2("Remarque")[Le module _Stack_ de OCaml fournit des piles mutables]

=== Avec un tableau
Si la capacité de la pile est bornée, on peut directement la réaliser avec un tableau.


#blk1("Programme", "Structure d'une pile en C")[
  En C, on représenterait la pile avec la structure suivante : 
  #codly(languages: codly-languages)
```C
typedef struct pile {
  int capacite; 
  int tete;
  int* donnee
} pile_t
```
]

#blk2("Exercice (TP)")[
  Implémenter les fonctions _pileVide_, _empile_ et _depile_ pour cette structure.
]

#blk2("Exercice (difficile)")[
  Si la pile n'est pas bornée, peut-on toujours la stocker dans un tableau ? Comment ? \
  _Solution : tableaux dynamiques_
]

== Applications
=== La "pile" d'un programme
#blk1("Définition", "Pile d'un programme")[
  Lors de l'execution d'un programme, les paramètres, les variables locales, et les appels de fonction sont stockés dans une partie de la mémoire appelée "la pile", ou bien "pile d'execution". 
]

#dev[Fonctionnement de la pile d'execution d'un programme]

=== Parcours en profondeur (DFS)
L'algorithme de parcours en profondeur utilise une pile, que ce soit la pile d'execution dans le cas d'une implémentation récursive, ou une pile explicite en programmation impérative. 

#blk1("Algorithme", "Parcours en profondeur")[
  #pseudocode-list(hooks: .5em, title: smallcaps[Parcours en profondeur ( G, s0 )], booktabs: true)[
  #underline()[Entrée] : Un graphe G et un sommet s0
  + p = creer_pile()
  + Empiler p s0
  + *While* p est non vide
    + s = Depiler p
    + *if* s non marqué
      + Marquer s
      + Empiler tous les voisins non marqués de s dans p
]
]

#blk2("Exercice")[
  Quelle est la complexité de cette algorithme ? \
  _Réponse : $O(|S| + |A|)$_
]

= Les files (NSI)
== Définition
#blk1("Définition", "File")[
  Une file est une structure de donnée, représentant une collection de données du même type, sur le principe de "premier arrivé, premier servi" (FIFO en anglais). Elle dispose des opérations suivantes :
  - fileVide : teste si la file est vide
  - defile : supprime le premier élément de la file et le renvoie
  - enfile : ajoute un élément à la fin de la file
]

#blk2("Analogie")[
  File d'attente dans un magasin
]

== Implémentations
=== Avec une liste chainée
#blk2("Idée")[
  On forme une liste des éléments dans l'ordre de leur insertion, en maintenant deux pointeurs vers le premier et le dernier élément de la liste. (Dessin ? )
]

=== Avec un tableau circulaire
#blk2("Idée")[
  Si la capacité de la file est bornée, on peut, comme pour la pile, utiliser un tableau. Mais il faudra alors maintenir deux pointeurs, la tête et la queue de la file. 

  Quand l'un des deux pointeurs arrive au bout du tableau, on "boucle" avec le début. (Dessin aussi ? )
]

#blk2("Exercice")[
  Ecrire les fonctions empile, depile et pileVide en C pour cette implémentation.   
]

=== Avec deux piles 
#blk2("Idée")[
  Dans la première pile, on enfile les éléments. Dans la deuxième, on défile les éléments. Quand la deuxième pile est vide, on y transfère tous les éléments de la première. 
]

#blk2("Exercice")[
  Quelle est la complexité des fonctions dans le pire cas pour cette implémentation ? Et la complexité amortie ? 
]

== Applications
=== Parcours en largeur d'un graphe
#blk2("Remarque")[
  Le parcours en largeur d'un graphe est très similaire au parcours en profondeur, simplement on utilise une file plutôt qu'une pile !
]

#blk1("Algorithme", "Parcours en largeur")[
  #pseudocode-list(hooks: .5em, title: smallcaps[Parcours en largeur ( G, s0 )], booktabs: true)[
  #underline()[Entrée] : Un graphe G et un sommet s0
  + f = creer_file()
  + Enfiler f s0
  + *While* f est non vide
    + s = Defiler f
    + *if* s non marqué
      + Marquer s
      + Enfiler tous les voisins non marqués de s dans f
]
]

= Files de priorité (MP2I)
== Définition
#blk1("Définition", "File de priorité")[
  Une file est une structure de donnée, représentant une collection de données *ordonnées* du même type. Elle dispose des opérations suivantes :
  - fileVide : teste si la file est vide
  - enfiler : ajoute un élément à la file de priorité
  - defiler : retire et renvoie *le plus petit élément* de la file de priorité
]

== Implémentations
=== Implémentation naïve avec une liste
#blk2("Idée")[
  On peut implémenter une file de priorité avec une simple liste : il suffit d'effectuer une recherche du minimum de la liste dans la fonction _retirerMin_. Sa complexité est alors en O(n) ! 
]

#blk2("Exercice")[
  Une amélioration possible serait de garder la liste triée. Quelle serait alors la complexité des différentes opérations ? 
]

=== Avec un tas

#blk1("Définition", "Semi-complet à gauche")[
  Un arbre binaire de profondeur $n$ est dit "semi-complet à gauche" si : 
  - Il est complet jusqu'à la profondeur $n-1$
  - Tous ses noeuds de profondeur $n$ sont à gauche
]
#blk1("Définition", "tas min")[
  Un arbre binaire semi-complet à gauche est un tas min si :
  - Soit il est vide
  - Soit il est de la forme $N(x, f_g, f_d)$, où $f_g$ et $f_d$ sont des tas min dont toutes les valeurs sont superieures ou égales à $x$.
]

#blk1("Idée", "Implémentation des opérations de la file de priorité")[
  - _enfiler_ : on ajoute l'élément comme une feuille gauche de l'arbre, puis, tant qu'il est plus petit que son parent, on l'échange avec celui-ci (on le fait "remonter").
  - _défiler_ : on enlève la racine et on la remplace par la denière feuille du tas. Ensuite, tant qu'elle n'est pas plus petite que ses deux fils, on l'échange avec le plus petit d'entre eux (on le fait "descendre").

Ces deux opérations sont en $O(log(n))$ ! 
]



#dev[Correction des opérations du tas min]

== Applications
=== Tri par tas
#blk2("Idée")[
  Comme les fonctions _enfiler_ et _defiler_ sont en $O(log(n))$, simplement enfiler tous les éléments à trier, puis les défiler, donne un tri en $O(n log(n))$
]
=== Algorithme de Djikstra
#blk2("Remarque")[
  L'algorithme de Djikstra est en fait simplement un parcours, mais en utilisant une file de priorité à la place d'une pile ou d'une file ! 

  On traite toujours l'élément non traité le plus proche de l'origine.
]