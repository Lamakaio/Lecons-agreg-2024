#import "@preview/cetz:0.3.0"
#import "@preview/syntree:0.2.1": tree
#import "@preview/lovelace:0.3.0": *
#import "@preview/codly:1.1.1": *
#import "@preview/codly-languages:0.1.1": *
#import "@preview/diagraph:0.3.3": raw-render

#import "../utils.typtp": *
#import "lecon_tplt.typtp": lecon

#show: codly-init.with()
#show: lecon.with(
  titre: [Leçon 6 : Implémentations et applications des ensembles et des dictionnaires.], 
  niveau: [Première / MP2I], 
  prerequis: [Tableaux, Listes, Arbres])

= Définitions et motivations

#def[Ensemble][
  Un ensemble E en informatique, est comme un ensemble en mathématique.
  Ici la structure d'ensemble est abstraite, et possède les opérations : 
  - inserer(E, x) : ajoute x à E s'il ne l'est pas déjà
  - supprimer(E,x) : enlève x de E s'il y est
  - rechercher(E,x) : renvoie vrai ssi x$in$ E
]

#blk2("Motivation")[
  On souhaite pouvoir implémenter un dictionnaire, comme celui de la langue française ou pour chaque mot on a une définition. On a un ensemble de couple (mots, définitions), où chaque mot est unique.
]

#def[Dictionnaire][
  Un dictionnaire D est une structure de donnée abstraite possédant un ensemble de couple (clés, valeurs) où chaque clé est unique, et possédant les opérations :
   - inserer(D, k, x) : insère le couple (k,x) dans D en écrasant éventuellement le couple (k,y) existant
   - rechercher(D,k) : renvoie x tel que (k,x)$in$ D s'il existe
   - supprimer(D,k) : supprime le couple identifié par la clé k.
]

#blk2("Remarque")[
  Les dictionnaires sont aussi appelé tableaux associatifs.
]

#blk2("Remarque")[
  Un ensemble est un dictionnaire qui ne contient que des clés sans valeurs.
]

= Implémentations 

== Listes 

#blk3("Propriété")[
  On peut implémenter les dictionaries et ensembles par des listes sans ordre particulier. 
]

#blk2("Exercice")[
  Implémenter les dictionnaires, avec leurs opérations, par des listes. Donner les compléxités.
]

== Arbres Binaire de Recherche

#def("ABR")[
  Un arbre binaire de recherche est un arbre binaire dont les éléments sont munis d'un ordre total et où, pour chaque sous-arbre $N(g,x,d)$, l'élément $x$ est suppérieur à tous les éléments de $g$ et inférieur à tous les éléments de $d$.
]

#blk3("Implémentation")[
  On peut implémenter un dictionnaire (ensemble) via un ABR à condition que les clés possèdent un ordre total.
]

#ex[
  _Dessiner 2 ABR pour l'ensemble {10,3,5,8}_
]

#blk3("Propriétés")[
  - Insertion : depuis la racine descendre récursivement jusqu'à arriver sur une feuille en parcourant le fils gauche si x inférieur à la valeur du noeud, droit sinon (s'arrêter si valeur déjà présente).
  - Recherche : même principe que l'insertion, retourner vrai ssi x est trouver sur le chemin entre racine et feuille.
  - Suppression : si le noeud est une feuille, comme insertion et on supprime, sinon on remplace par le maximum du sous-arbre gauche (ou min du sous-arbre droit)
]

#blk3("Propriétés")[
  Pour un ABR de hauteur h, on peut insérer, supprimer et rechercher en $O(h)$.
]

#blk2("Remarque")[
  Si l'arbre est un peigne, on a $h=n$ donc on a les opérations insertion, suppressions, recherche en $O(n)$. On peut améliorer cela.
]

== Arbre Rouge-Noir

#def("Arbre rouge-noir")[
  ABR ou chaque noeud porte une couleur (noir ou rouge) et vérifie les propriété :
  1. le père d'un noeud rouge n'est jamais rouge
  2. le nombre de noeuds noirs le long d'un chemin de la racine à un sous-arbre vide est toujours le même.
]

#blk1("Propriété", "Hauteur ARN")[
  Les arbre RN forment un ensemble d'abres équilibrés. La hauteur et donc les opérations se font en $O(log n)$
]


#dev[Insertion dans un arbre Rouge-Noir et preuve des propriétés]

En C++ std::map est implémenté par les ARN.

== Table de hashage

#def[Table de hashage][
  Structure de donnée qui permet de stocker un ensemble (dictionnaire) dans un tableau.\
  Si les clés étaient dans $[|0:m|]$, on utiliserait directement un tableau.\
  On utilise une fonction, appeler fonction de hashage.
]

#def[Fonction de hashage][
  La fonction de hashage est défini comme suit $h : K -> ZZ$\
  Une fois la fonction de hashage défini on range les éléments dans un tableau de taille $[|0:m-1|]$ en rangeant la clé x dans la case h(x) mod m du tableau.
]

#def[Colision][
  Il est possible que 2 clés soient attribué à la même case du tableau. On appelle celà une colision. \
  Pour celà notre tableau ne sera pas un tableau de clés mais un tableau de seau, qu'on peut représenter par des pointeurs vers des listes qui vont contenir nos clés.
]

#image("../img/dico_1.png", width: 40%)

#blk2("Choix de h")[
  Une bonne fonction d'hashage qui va minimiser les colisions. On peut prendre un m très grand mais on aura un tableau trop grand par rapport aux nombres de données qu'on souhaite stocker.\
]

#blk2("Remarque")[
  Si notre tableau est trop plein (on a trop de colision) il faut l'augmenter et pour cela changer la valeur de m, et recopier toutes les valeurs dans ce nouveau tableau.
]

Les dictionnaires en python sont implémenté par des tables de hashage.

#blk2("Compléxité")[
  Les complexités des opérations d'insertion, suppression et recherche dépendent donc du nombre de colision, et donc de la fonction de hashage. \
  Si on à 100% de colision on se retrouve à chercher dans une liste donc en $O(n)$.\
  En moyenne la complexité de ces opérations est en $O(1 + alpha)$ avec $alpha=n/m$ sous l'hypothèse d'un hashage uniforme. Si $m>n$ alors les opérations sont en moyenne en $O(1)$.
]

#blk2("Récapitulatif")[
  #table( columns: 4,
    "Structure","Insertion", "Suppression", "Recherche",
    [Liste], [$O(n)$],[$O(n)$],[$O(n)$],
    [Liste triée], [$O(n)$],[$O(n)$],[$O(log n)$],
    [ABR], [$O(n)$],[$O(n)$],[$O(n)$],
    [ARN], [$O(log n)$],[$O(log n)$],[$O(log n)$],
    [Table de \ hashage], [$O(n)$ \ $O(1)$ moy],[$O(n)$ \ $O(1)$ moy],[$O(n)$ \ $O(1)$ moy],

  )
]

#blk2("Remarque")[
  Les ensembles et les dictionnaires sont des structures qui semble simple mais on a beaucoup d'implémentations différentes et celle-ci peuvent être plus ou moins complexe.
]

= Applications 
_ PEUT ETRE BOUGER LES APPLICATIONS AU FIL DES IMPLEMENTATIONS _

== Sur les listes et tableaux

#blk2("Exercice")[
  Retirer les doublons d'une liste grace à un ensemble.
]

#ex[
  On peut utiliser un dictionnaire pour étendre le tri par comptage à des tableaux avec des valeurs non bornées.
]

#dev[Tri comptage amélioré]

== Mémoïsation
#ex[
  Les dictionnaires peuvent permettre l'implémentation de cache, donc de mémoïsation pour la programmation dynamique. => mettre exemple
]

== Analyse du texte
#ex[
  Comptage occurences mot ou lettre grâce à un dictionnaire. Peut être utile pour Huffman.
]

== Graphe
#ex[
  On peut représenter un graphe par une liste d'adjacence, ou chaque sommet possède un dictionnaire avec comme clés les sommets de ses voisins et en valeurs le poids de l'arc si le graph est pondéré.
]



