#import "@preview/cetz:0.3.0"
#import "@preview/syntree:0.2.1": tree
#import "@preview/lovelace:0.3.0": *
#import "@preview/codly:1.1.1": *
#import "@preview/codly-languages:0.1.1": *

#import "../utils.typtp": *
#import "lecon_tplt.typtp": lecon

#show: lecon.with(
  titre: [Leçon 30 : Grammaires hors-contexte. Applications à l’analyse syntaxique.], 
  niveau: [MPI], 
  prerequis: [Langage régulier, Automate, Analyse lexicale],
  motivations: [compilation],
  )

= Motivations
#text(fill:red)[A REFAIRE ]


= Grammaires hors-contexte
== Définitions
#def[Grammaires hors-contexte][
  Une grammaire non contextuelle est un 4-uplet $G = (V, Σ, R, S)$ où
  - $V$ est un alphabet de symboles appelés non terminaux ou variables ;
  - $Σ$ est un alphabet de symboles appelés terminaux, $Σ ∩ V = emptyset$ ;
  - $R ⊂ V times (Σ union V)^*$ est un ensemble fini de couples appelés règles de
production ;
  - $S ∈ V$ est le symbole initial ou l’axiome de la grammaire.
]

#blk1("Notation", "Grammaire")[
  Conventions : majuscule pour non terminaux, minuscule pour terminaux\
  T $->$ d pour une règle\
  On peut écrire un esemble de règle d'un même non terminaux en les séparant par des pipes\
  T $->$ d | d T |$epsilon$
]

#ex[
  Soit une grammaire Gimp = (V, Σ, R, 𝑆) avec :
  - $V = {𝑆, 𝐼, 𝐸, 𝑉 , 𝑁 , 𝐶}$
  - $Σ = {x, y, "print", 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, =, +, ;, (, )}$\

  - $R :&𝑆 → 𝐼 ;𝑆 | 𝜀\
        &𝐼 → 𝑉 =𝐸 | "print"(𝐸)\
        &𝐸 → 𝐸+𝐸 | 𝑁\
        &𝑉 → x|y\
        &𝑁 → 𝐶 𝑁 | 𝐶\
        &𝐶 → 0|1|2|3|4|5|6|7|8|9$
]

== Dérivation
#def[Dérivation immédiate][
  Soit G = (V, Σ, R, S) une grammaire. Soit $u = u_1 X u_2 ∈ (Σ union V)^* V(Σ union V)^*$
  et $v ∈ (Σ union V)^*$ . On dit que u se dérive immédiatement en $v$, et on note $u -> v$,
  s’il existe $r ∈ (Σ union V)^*$ tel que :
    - $X ->r ∈R$
    - $v = u_1 r u_2$\

  Une dérivation est à gauche quand on remplace le non terminal le plus à gauche, et à droite quand on remplace le non terminal le plus à droite.
]

#ex[
  $x=N ;S => x=C N;S$ 
]

#def[Dérivation][
  On note $=>^*$ la clôture réflexive et transitive de $=>$. Si $u=>^* v$, on dit que $u$ se dérive en $v$. Une suite de dérivations immédiates $u_1 => . . . => u_n$ est appelée une dérivation.\
  On appel $n$ la longueur de la dérivation.
]

#blk2("Exercice")[
  Donner la dérivation de "$x=42;$" dans Gimp en précisant les règles utilisées.
]

== Langage engendré par une grammaire 
#def[Langage engendré][
  Le langage engendré par la grammaire,noté $L(G)$, est défini par $L(G) = {v ∈ Σ^* | S =>^* v }$.
  Les langages engendrés par une grammaire sont appélés les langages algébriques (ou hors-contexte).
]

#blk2("Exercice")[
  Donner les langages des grammaires suivantes : 
  - $S -> epsilon | a S a | b S b | a | b$ 
  - $S -> S S | (S) | epsilon$
]

#blk3("Théorème")[
  L'ensemble des langages réguliers est inclus strictement dans l'ensemble des langages algébriques.
]

#dev[démonstration du théorème]

== Ambiguïté d'une grammaire 
#def[Arbre de dérivation][
  Soit $G = (V, Σ, R, S)$ une grammaire. Un arbre de dérivation est un arbre étiqueté aux nœuds, tel que :
  - la racine est étiquetée par $S$ ;
  - tout nœud interne est étiqueté par un symbole de $V$ ;
  - toute feuille est étiquetée par un symbole de $Σ union {epsilon}$ ;
  - si $u_1, . . . , u_n$ sont les fils d’un nœud étiqueté X , alors il existe une règle $X → u_1 . . . u_n$ dans R.
]

#ex[
  DESSINER ARBRE DE DÉRIVATION (print(2+2*2);)
]

#def("Grammaire ambiguë")[
  Une grammaire $G$ est dite ambiguë s’il existe un mot $v ∈ L(G)$ tel que $v$ possède deux arbres de dérivations distincts.
]

#blk2("Exercice")[
  Montrer que Gimp est ambiguë. 
]

#ex[
 $ &I → "if" (E) I \
  &I → "if" (E) I "else" \
  &I → E \
  &E → x = E | E < E | E > E | ...$\
  est ambiguë ```c if (x > 4) if (x < 5) x = 10; else x = 42;``` 
]

#blk2("Remarque")[
  Ce problème d'ambiguïté peut être résulue par une règle externe consistant à choisir le if le plus proche du else.
]
== Équivalence faible
#def[Équivalence faible][
  Soit $G_1$ et $G_2$ deux grammaires non contextuelles. Ces grammaires sont dites faiblement équivalentes si $L(G_1) = L(G_2)$
]

= Analyse syntaxique

== Motivations
Nous nous intéressons ici à la partie front-end du compilateur. Celle-ci comporte deux parties majeures :
- l'analyse lexicale : on part d'un fichier pour obtenir une liste de lexèmes
- l'analyse syntaxique : on part d'une liste de lexèmes pour obtenir un arbre de syntaxe abstraire

#blk3("Objectif")[
  Le but premier de l'analyse syntaxique est de déterminer si une phrase est recennue par la grammaire. L'objectif est alors double :
  - Décider l'appartenance au langage
  - connaitre la dérivation (structure) de la phrase.
]

#def[Algorithme d'analyse descendante/ascendante][
  Descendante : qui tente, à partir d'une liste de lexèmes, de construire une dérivation depuis l'axiome et de descendre jusqu’à la phrase. \
  Ascendante : tente de contruire une dérivation à l'envers depuis la liste et de remonter jusqu’à l'axiome.
]

== Retour sur trace
Une première idée consiste à explorer l'ensemble des solutions de manière exhaustive. Il s'ajit d'une solution génériques (fonctionne quelque soit la grammaire).

#blk3("Idée de l'algorithme")[
  Le but est d'explorer l'ensemble des dérivations jusqu'à obtenir un mot composé uniquement de terminaux et le comparer au mot en entrée. Puisqu'il y a possiblement des branches infinis on utilise la borne suivante sur la taille des dérivations.
]

#blk3("Théorème")[
  Soit G une grammaire et $m in Sigma^*$. Les deux propositions suivantes sont équivalentes : 
  - $m in L(G)$
  - il existe une dérivation reconnaissant m dont la longueur est inférieure à $a^(|m|*r)$ où $a$ est le nombre maximum de symboles à droite d'une règle et $r = |V|$.
]

#dev[présentation d'un algorithme d'analyse syntaxique descendant par retour sur trace]

#blk2("Compléxité")[
  Compléxité exponentielle. \
  #text(fill:red)[TROUVER EXEMPLE]
]
