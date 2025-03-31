#import "@preview/cetz:0.3.0"
#import "@preview/syntree:0.2.1": tree
#import "@preview/lovelace:0.3.0": *
#import "@preview/codly:1.1.1": *
#import "@preview/codly-languages:0.1.1": *

#import "../utils.typtp": *
#import "lecon_tplt.typtp": lecon


#show: codly-init.with()
#show: lecon.with(
  titre: [Leçon 22 : Fonctions et circuits booléens en architecture des ordinateurs], 
  niveau: [Première, MP2I], 
  prerequis: [Représentation binaire des entiers])
 
#blk2[Motivations][
  Un ordinateur est capable de diverses opérations comme l'addition de deux entiers. Comment peut-on modéliser ce comportement ? 
]

= Expressions et fonctions booléennes 
== Fonctions booléennes
#blk1[Définition][Fonction booléennes][
  Soit l'ensemble $BB = {0, 1}$ l'ensembles des booléens. \
  Une fonction booléennes est une fonction $f: BB^n -> BB$
]

#blk1[Définition][table de vérité][
  La table de vérité d'une fonction booléenne $f$ est un tableau donnant, pour chaque $x_1, ..., x_n in BB$, la valeur de $f(x_1, ..., x_n)$
]

#figure(caption: [Table de vérité pour $f$ la fonction "ET"])[
  #tabledeverite(("x", "y"), ([$f(x, y)$],), ("calc.max(x, y)",))
]<tableverite>

== Expressions booléennes

#blk1[Définition][formule propositionelle][
  Soit $V$ un ensemble de variables. \
  On définit inductivement l'ensemble des expressions booléennes sur $V$ comme : 
  - [cas de base]
    - 0 et 1 sont des expressions
    - Si $x in V$ alors $x$ est une expression
  - [cas inductif] Si $e_1$ et $e_2$ sont des expressions alors $not e_1$, $ e_1 and e_2$ et $e_1 or e_2$ sont des expressions.  
  ]

#blk1[Définition][Evaluation d'une expression booléenne][
  Soit $nu : V -> BB$ une fonction qui attribue une valeur booléenne aux variables.

  L'évaluation de $[e]_nu in BB$ de $e$ une expression booléenne par $nu$ est : 
  - si $e in BB, [e] = e$
  - si $e in V, [e] = nu(e)$
  - si $e = not e'$, $e = e_1 and e_2$ ou $e = e_1 or e_2$, alors, respectivement, $[e] = not [e']$, $[e] = [e_1] and [e_2]$ et $[e] = [e_1] or [e_2]$, avec les fonctions $not, and, or$ définis par la table de vérité suivante : 

  #tabledeverite(("x", "y"), ([$not x$], [$x or y$], [$x and y$]), ("1-x","calc.max(x, y)", "calc.min(x, y)"))

]

#blk2[Exemple][
  Soit l'expression $e = not x_1 or (x_2 and x_3) or 0$.
  Pour $nu(x_1, x_2, x_3) = (1, 1, 0)$, on a $[e] = not 1 or (1 and 0) or 0 = 0$
]

#blk1[Définition][Equivalence de deux expressions booléennes][
  Deux expressions booléenne $e_1$ et $e_2$ sont équivalentes si, $forall nu in BB^n, [e_1]_nu = [e_2]_nu$
]

== Equivalence

#blk1[Théorème][Equivalence entre fonction et expression booléenne][
  Pour toute fonction booléènne $f: BB^n -> BB$, il existe une expression booléenne e sur $V = {x_1, ..., x_n}$ telle que $forall (v_1, ..., v_n) in BB^n, f(v_1, ..., v_n) = [e]_(v_1, ..., v_n)$
]

#blk2[Exercice][
  Soit $f: BB^4 -> BB$, tel que $f(x_1, x_2, x_3, x_4)$ vaille 1 si et seulement si l'entier en binaire $x_1 x_2 x_3 x_4$ est multiple de 3. 
  Construire l'expression booléenne associée. 
]

#blk2[Exercice][
  Ici, le théorème est valide pour les expressions booléènnes avec les trois opérateurs $not, and, or$.
  Serait-il toujours valide avec : 
  - Seulement $and, or$ ? 
  - Seulement $"NAND"$ défini par $"NAND"(x, y) = not (x and y)$ ? 
]

= Circuits booléens
== Définitions
#blk2[Objectif][On souhaite avoir une représentation des circuits éléctronique qui soit proche des expressions booléennes]

#blk1[Définition][Porte logique][
  Une porte logique est une représentation d'un opérateur élémentaire. Elle a des entrées et une sortie. 
  Les portes usuelles sont : (faire un dessin)
  - la porte identité, qui correspond à l'expression $a$. 
  - la porte NON qui correspond à l'expression $not a$
  - la porte ET qui correspond à l'expression $a and b$
  - la porte OU qui correspond à l'expression $a or b$
  - la porte XOR qui correspond à l'expression $(a and not b) or (b and not a)$
  - la négation de n'importe quelle porte, qui représente l'expression de cette porte précédé d'un $not$
]

#blk1[Définition][Circuit booléen][
  On définit inductivement un circuit booléen comme
  - [cas de base] une porte logique
  - [induction] si $c_1$ et $c_2$ sont des circuits, 
    - l'union disjoint de $c_1$ et $c_2$
    - l'union avec les mêmes entrées, si $c_1$ et $c_2$ ont le même nombre d'entrées
    - la composition, si $c_2$ a autant d'entrées que $c_1$ a de sorties. 
]

#blk1[Définition][évaluation d'un circuit booléen][
  Soit c un circuit booléen, d'entrées $i_1, ..., i_n$ et de sorties $o_1, ..., o_m$. 
  Soit $nu = (v_1, ..., v_n) in BB^n$. On défini $[c]^(o_i)_nu$ la valeur de la sortie $i$ comme :
  - si c est une porte, alors $m = 1$ et $[c]^(o_1)_nu = [e(c)]_nu$
  - si c est l'union (quelconque) de $c_1$ et $c_2$, alors, si $o_i$ est une sortie de $c_1$, $[c]^(o_i)_nu = [c_1]^(o_i)_nu$ et de même pour $c_2$.
  - si c est la composition de $c_1$ et $c_2$, alors $[c]^(o_i)_nu = [c_2]^(o_i)_([c_1]^1_nu, ..., [c_1]^k_nu)$
]

#blk2[Remarque][
  On peut voir un circuit booléen comme un graphe orienté acyclique de portes. 
]

#dev[Equivalence entre circuit booléen et expression booléenne]

== Mesure

#blk2[Problématique][
  Quand on conçoit un circuits éléctroniques, on veut qu'il soit "petit" (pas trop de portes) et "rapide" (une latence faible). Comment définir ces exigences formellement ? 
]

#blk1[Définition][Mesure d'un circuit][
  On défini les métriques suivantes sur les circuits : 
  - Le nombre de portes du circuit 
  - Le chemin critique du circuit, c'est à dire le plus long chemin entre une entrée et une sortie. 
]

= Exemple de circuits booléens
== Additioner deux entiers n bits

#blk1[Définition][_half adder_][

Le _half adder_ est un additionneur 1 bit, qui prend deux entrée, et a deux sorties : le résultat est la retenue. 

#grid(columns: 2, figure(caption: [Circuit correspondant au _half adder_])[
#image("../img/ha_xor.svg")
], figure(caption: [Table de vérité correspondant au _half adder_])[#tabledeverite(("A", "B"), ("SUM", "CARRY"), ("calc.max(A*(1-B), B*(1-A))", "calc.min(A, B)"))])

]

#blk1[Définition][_full adder_][

Le _full adder_ est un additionneur 1-bit qui est capable de prendre une retenue en entrée, ce qui lui permet d'être utilisé pour l'addition n-bits.


#grid(columns: 2, figure(caption: [Circuit correspondant au _full adder_])[
#image("../img/fadd.svg", height:180pt)
], figure(caption: [Table de vérité correspondant au _full adder_])[#tabledeverite(("A", "B", "c_in"), ("SUM", "c_out"), ("calc.rem(A + B + c_in, 2)", "calc.div-euclid(A+B+c_in, 2)"))])
]

#blk2[Exercice][Construire un additionneur n-bits à partir de n _full_adder_]

#dev[Optimisation de l'addition, additionneur à saut de retenue]

== Multiplexeurs

#blk2[Motivations][
  On a souvent envie de gérer des "conditions" lorsqu'on fait de la logique. Le multiplexer est l'équivalent du _if .. else .._ en circuit. 
]

#blk1[Définition][Multiplexeur][
  Un multiplexeur $2^n$ vers 1 a pour entrées 
  - $2^n$ entrées à k bits $x_1, ..., x_(2^n)$
  - une entrée à $n$ bits, _select_
  Et une sortie à k bits. 

  Si _select_ représente le nombre i en base 2, alors la sortie vaut la valeur de $x_i$.

  (dessin)
]

#blk2[Exercice][
  - Construisez un multiplexeur avec $n = 1$ et $k = 1$. Sa table de vérité est : 
  #tabledeverite(("x1", "x2", "select"), ("out",), ("select * x1 + (1-select)*x2",))

  - Comment peut-on modifier le circuit pour augmenter n ? 
]