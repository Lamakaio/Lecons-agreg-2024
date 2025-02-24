#import "@preview/cetz:0.3.0"
#import "@preview/syntree:0.2.1": tree
#import "@preview/lovelace:0.3.0": *
#import "../utils.typtp": *
#import "lecon_tplt.typtp": lecon

#show: lecon.with(
  titre: [Leçon 33 : Formules du calcul propositionnel :  représentations, formes normales, satisfiabilité, applications], 
  niveau: [MP2I/MPI], 
  prerequis: [Induction])

= Syntaxe (MP2I)
== Formules Propositionelles


#blk1()[Définition][formule propositionelle][
  Soit $V$ un ensemble de variables. \
  On définit inductivement l'ensemble des formules propositionelles sur $V$ comme : 
  - [cas de base]
    - Si $x in V$ alors $x$ est une formule
    - $top$ et $bot$ sont des formules
  - [cas inductif] Si $phi$ et $psi$ sont des formules alors : 
    - $(not phi)$ est une formule
    - $(phi or psi)$, $(phi and psi)$, $(phi -> psi)$ et $(phi <-> psi)$ sont des formules
  ]

#blk2()[Exemple][  
  $(x <-> (not (not x)))$ est une formule
]

#blk2()[Exercice][
  Définir (inductivement) l'ensemble des variables apparaissant dans une formule. 
]

== Représentation des formules
On illustrera différentes représentations des formules sur l'exemple : \ 
$phi = ((not (x or y)) <-> ((not x) and (not y)))$

- Dans la représentation usuelle (aussi appelée forme infixe), on se permet d'ommetre certaines parenthèses, en appliquant l'associativité et des priorité sur les opérateurs : $not >> or, and >> <->, ->$. Cela sera justifié par la sémantique.\ $phi = not (x or y) <-> not x and not y $

#figure(caption: [Arbre syntaxique de $phi$])[
  #tree($<->$,
    tree($not$, 
      tree($or$, "x", "y")),
    tree($and$, 
      tree($not$, "x"), 
      tree($not$, "y")))
]<syntree>


- On peut noter une formule sous forme d'arbre syntaxique : les feuilles sont les cas de base, et les noeuds sont les constructeurs (@syntree).

#blk1[Définition][Hauteur et taille d'une formule][
  L'arbre syntaxique permet de définir :
  - la hauteur d'une formule, qui est la profondeur maximale d'une feuille de l'arbre
  - la taille d'une formule, qui est le nombre de neouds de l'arbre.
]

= Sémantique (MP2I)
== Valuation et sémantique

#blk1[Définition][Valuation][
  Une valuation est une fonction $sigma:V->{0, 1}$.
]
#blk1[Définition][Sémantique d'une formule][
On définit inductivement la sémantique (ou valeur de vérité) $[phi]_sigma$ d'une formule $phi$ pour une valuation $sigma$ comme : 
- $[top]_sigma = 1$, $[bot]_sigma = 0$
- $forall x in V, [x]_sigma = sigma(x)$
- $[not phi]_sigma = 1 "ssi" [phi]_sigma = 0$
- $[phi_1 and phi_2] = 1 "ssi" [phi_1]_sigma = 1 "et" [phi_2]_sigma = 1$
- $[phi_1 or phi_2] = 1 "ssi" [phi_1]_sigma = 1 "ou" [phi_2]_sigma = 1$
- $[phi_1 -> phi_2] = 1 "ssi" [phi_1]_sigma = 0 "ou" [phi_2]_sigma = 1$
- $[phi_1 <-> phi_2] = 1 "ssi" [phi_1]_sigma = [phi_2]_sigma$
]

#blk1[Définition][table de vérité][
  Une table de vérité est un tableau donnant la sémantique d'une formule pour chaque valuation de ses variables.
]

#figure(caption: [Table de vérité pour $phi = not x or (y and z)$])[
  #tabledeverite(("x", "y", "z"), ([$phi$],), ("calc.max(1-x, y * z)",))
]<tableverite>

#blk2[Remarque][
  Si $phi$ contient $n$ variables distinctes, sa table de vérité a $2^n + 1$ lignes. C'est vite très grand !
]

== Notion d'équivalence et calcul sur les formules
#blk1[Définition][équivalence de formules][
  Deux formules $phi_1$ et $phi_2$ sont _équivalentes_ si $forall sigma: V -> {0, 1}, [phi_1]_sigma = [phi_2]_sigma$. \
  On note $phi_1 eq.triple phi_2$
]

#blk1[Propriété][des opérateurs][
  On a les propriétés suivantes : 
  - $and "et" or$ sont commutatifs, associatifs, et distributifs l'un sur l'autre.
  - $<->$ est commutatif
]

#blk2[Exemple][
  $(a or b) and d eq.triple (a and d) or (b and d)$\
]

#blk1[Propriété][Lois de De Morgan][
  On a les deux propriétés suivantes : 
  - $not (phi_1 or phi_2) eq.triple not phi_1 and not phi_2 $
  - $not (phi_1 and phi_2) eq.triple not phi_1 or not phi_2 $
]

#blk2[Exercice][
  Trouvez des formules équivalentes à $top, bot, phi_1 -> phi_2 "et" phi_1 <-> phi_2 $ en utulisant simplement $or, and "et" not$.
]
#blk2[Remarque][
  Dans la suite, on se permettra de considérer des formules contenant seulement des variables et les opérateurs $or, and "et" not$.
]

== Satisfiabilité
#blk1[Définition][Satisfiabilité][
  - Si $phi$ est une formule, on a :
    - $phi$ est satifiable si $exists sigma: V -> {0, 1}, [phi]_sigma = 1$
    - $phi$ est une tautologie si $forall sigma: V -> {0, 1}, [phi]_sigma = 1$
  - Si $E$ est un ensemble de formules, $E$ est satifiable si $exists sigma : V -> {0, 1}, forall phi in E, [phi]_sigma = 1$
]

#blk2[Exemples][
  - $phi = (x or y) and not x$ est satifiable avec $y = 1$ et $x = 0$
  - $phi = x and not x$ n'est pas satifiable
] 

== Formes normales
#blk1[Définition][formes normales][
  - un littéral est une formule de la forme $x "ou" not x "pour" x in V$
  - Une clause disjonctive (resp conjonctive) est une formule $or.big_(i=0)^n l_i$ (resp $and.big_(i=0)^n l_i$) avec $(l_i)_(0 <= i <= n)$ des littéraux
  - Une formule $phi$ est en forme normale conjonctive (resp disjonctive) si elle est de la forme $and.big_(i=0)^p C_i$ (resp $or.big_(i=0)^p C_i$) avec $(C_i)_(0<=i<=p)$ des clauses disjonctives (resp conjonctives) \
  En francais, une FNC est une conjonction de disjonction, et une FND est une disjonction de conjonctions. 
]

#blk2[Remarque][
  On dit souvent simplement "clause" pour parler de clause disjonctive.
]

#blk1[Proposition][équivalence à une forme normale][
  Toute formule $phi$ est équivalente à une formule en FNC et à une formule en FNC. De plus (à l'ordre des  facteurs près) : 
  - si $phi$ n'est pas une tautologie, la FND est unique
  - si $not phi$ n'est pas une tautologie, la FNC est unique 
]    

== Quelques applications
#blk1[Théorème][Modélisation][
  Toute fonction booléenne est équivalente à une formule propositionelle. C'est à dire : \
  $forall f: {0, 1}^n -> {0, 1}, exists phi "une formule sur les variables" V = {x_1, ..., x_n}, \ "tel que" forall sigma : V -> {0, 1}, f(sigma(x_1), ..., sigma(x_n)) = [phi]_sigma$
]

#dev[Equivalence entre formule propositionelle et circuit combinatoire]

= Le problème SAT (MPI)
== Définition
#blk1[Définition][problème SAT][ 
Le problème SAT est un problème de décision. 
- Entrée : Une formule propositionelle
- Sortie : Est-elle satifiable ? 
]

#blk2[Remarque][
  Il existe des variantes de SAT : 
  - CNF-SAT, si la formule est sous FNC
  - n-SAT, si elle a en plus n litteraux par clause
]

== Puissance et complexité de SAT 
#blk1[Théorème][Cook-Levin][
  SAT est NP-complet
]

#dev[3-SAT est NP-complet]

#blk2[Remarque][
  2-SAT est dans P ! 
]

#blk2[Exercice (difficile)][
  SAT permet donc de modéliser tous les problèmes NP. Modélisez donc le problème du 3-coloriage d'un graphe à l'aide d'une instance SAT.
]

== Algorithme de Quinne
L'algorithme de Quinne résout le problème CNF-SAT par backtracking. Il peut se généraliser à SAT en le précédant d'une transformation sur la formule. 
#figure(caption: [Algorithme de Quinne], kind: "algorithme", supplement: [Algorithme])[
#pseudocode-list(hooks: .5em, title: smallcaps[Quinne ( C )], booktabs: true)[
  #underline()[Entrée] : C l'ensemble des clauses de la formule
  
  #underline()[Sortie] : true si et seulement si la formule est satisfiable
  
  + *if* $C = emptyset$ *then*
    + *return* true
  + *elif* $bot in C$ *then*
    + *return* false
  + *else* 
    + Choisir x apparaissant dans une clause de $C$
    + *return* #smallcaps[Quinne] ($C[x <- bot]$) *or* #smallcaps[Quinne] ($C[x <- top]$)
]
]

$C[x <- bot]$ est l'ensemble des clauses obtenu en supprimant les clauses contenant $not x$, et en supprimant $x$ de toutes les autres. Si une clause devient vide, on la met à $bot$.

$C[x <- top]$ est défini de manière similaire, en inversant $x$ et $not x$.


#blk2[Remarque][L'algorithme est exponentiel.]

#blk2[Exercice][
  Prouver la terminaison de l'algorithme à l'aide d'un variant.
]