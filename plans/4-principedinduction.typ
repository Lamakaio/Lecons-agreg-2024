#import "@preview/cetz:0.3.0"
#import "@preview/syntree:0.2.1": tree
#import "@preview/lovelace:0.3.0": *
#import "../utils.typtp": *
#import "lecon_tplt.typtp": lecon

#show: lecon.with(
  titre: [Leçon 4 : Principe d'induction], 
  niveau: [MP2I], 
  prerequis: [Récurrence])


= Introduction 

En informatique et en mathématiques, l'induction sert à manipuler des structures récursives, c'est à dire qui se répètent selon des règles locales. 

#blk2[Exemple][
Un arbre est défini comme 
- soit une feuille 
- soit un identifiant, et une liste d'Arbres

C'est une structure inductive, car on utilise des arbres dans la définition de l'arbre !]

= Principe 
== Définition 
Il y a deux concepts principaux dans le principe d'induction : les ensembles inductifs, et les preuves par induction. 

#blk1[Définition][Ensemble inductif][
  Soit $Omega$ un ensemble. 

  On se donne 
  - un sous ensemble $Beta subset Omega$, appelé "cas de base"
  - un ensemble de règle de combinaisons, ou constructeurs $C subset F(Omega^p -> Omega)_(p in NN)$

  On défini alors $I$ comme le plus petit ensemble contenant $Beta$ et stable par les constructeurs. 
]

#blk1[Propriété][Définition alternative de l'induction][
  On défini récursivement, pour $n in NN$ l'ensemble inductif $I_n$ de profondeur $n$ : 
  - si $n = 0$, $I_0 = Beta$
  - pour $n > 0$, $I_n = I_(n-1) union union.big_(gamma in C) gamma(I_(n-1))$

  Intuitivement, $I_n$ est l'ensemble obtenu en applicant les constructeurs aux cas de base au maximum $n$ fois. 

  Alors, l'ensemble $union.big_(n in NN) I_n$ est exactement l'ensemble inductif engendré par $Beta$ et $C$.
]

#blk2[Exemple][
  Prenons $Omega = RR$, $Beta = {0}$ et $C = {x -> x+1}$. 

  On a alors, $forall n in NN$, $I_n = [|0, n|]$, et $I = NN$
]

#blk2[Remarque][
  En général, on ne précise pas $Omega$, en admettant qu'il existe un ensemble suffisemment grand pour contenir tous nos objets. On définit alors les fonctions C sur l'ensemble I lui-même. 
]

#blk1[Théorème][Preuve par induction][
  Soit $I$ un ensemble par induction sur $Omega$, défini par $Beta$ et $C$. 
  Soit un prédicat $P : I -> {"vrai", "faux"}$. 

  Si les conditions suivantes sont réunies
  - pour tout $x in Beta$, $P(x)$ est vrai
  - pour tout $gamma in C$, $x_1, ..., x_n in I$, si tous les $P(x_i)$ sont vrais, il en découle que $P(gamma(x_1, ..., c_n))$ est vrai. 

  Alors pour tout $x in I$, $P(x)$ est vrai. 
]

#blk2[Remarque][
  La récurrence est un cas particulier des preuves par induction, sur l'ensemble $NN$ définit par induction comme dans l'exemple 3. 
]

== Induction et récursivité en Ocaml 

En Ocaml, on travaille souvent sur des types récursifs. On utilise alors les preuves par induction pour la correction de programme. 

#blk1[Principe][Preuve par induction de programmes][
Soit `T` un type récursif. Soit $Beta$ l'ensemble des objets de type `T` qui correspondent à un cas de base, et $C$ les fonctions qui a des objets `x1, ..., xn` de type `T` associe l'objet `Cons (x1, ..., xn)` où `Cons` est un constructeur récursif de `T`. 

Alors l'ensemble des objets de types `T` est exactement l'ensemble inductif défini par `Beta` et `C`. 

Si on a une fonction récursive sur des objets de type `T`, on peut alors prouver par induction la correction de notre fonction !
]

= Structures de données inductives 
== Les listes chainées 

En Ocaml, on peut définir les listes chainées de la manière suivante : 
```Ocaml
type 'a list = V | Cons of 'a * 'a list 
```

On a bien ici un cas de base (V), et des constructeurs : $C = {l -> "Cons"(x, l) | x "de type 'a"}$

#blk2[Remarque][
  On a un raccourci Ocaml qui autorise les constructeurs à prendre des arguments de types quelconques. Cela correspond, dans notre définition, à un ensemble de constructeur, pour chaque valeurs de ces arguments. 
]

#blk2[Remarque][
  C'est le type `list` d'Ocaml ! 
]

#blk2[Exercice][
  Définir inductivement la taille d'une liste chainée. 
]

== Arbres

#blk1[Definition][Arbres binaires][
  Soit A un ensemble. On défini inductivement les arbres binaires sur A par : 
  - l'arbre vide F (cas de base)
  - si $e in A$, $g, d$ des arbres binaires, $A(e, g, d)$ est un arbre binaire.

  En Ocaml, cela donne 
  ```Ocaml
  type 'a arbre = F | Noeud of 'a * 'a arbre * 'a arbre
  ```
]

#blk2[Exemple][
  La hauteur d'un arbre se défini inductivement (ou récursivement en Ocaml) : 
  ```Ocaml
  let rec hauteur arb = match arb with 
    |F -> 0
    |Noeud (e, g, d) = 1 + max (hauteur g) (hauteur dans)
  ```
]

#blk2[Exercice][
  Prouver par induction la terminaison de cette fonction. 
]

#blk2[Exercice][
  Les arbres généraux sont des arbres dont les noeuds peuvent avoir un nombre quelconque de fils. Comment peut-on définir ce type en Ocaml ? 
]

#dev[Exemple d'une preuve par induction : correction de l'insertion dans un tas]

= Ensembles inductifs
== Formules propositionelles 
#blk1[Définition][Formules propositionelle][
  Soit V un ensemble de variables. Une formule propositionelle est : 
  - soit une variable $v in V$. (cas de base)
  - soit les symboles $tack.b$ et $tack.t$. (cas de base)
  - si f est une formule, $not f$ est une formule. 
  - si f et g sont des formules, $f and g$, $f or g$, $f -> g$ et $f <-> g$ sont des formules. 
]

#blk1[Définition][Valuation][
  On appelle valuation une fonction $sigma : V -> {0, 1}$
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

On dit qu'une formule $phi$ est satisfiable si il existe une valuation $sigma$ telle que $[phi]_sigma = 1$
]

#blk2[Remarque][
  Parfois, les structures inductives ne sont pas adaptées à des preuves ou des algorithmes. C'est le cas, par exemple, des algorithmes qui déterminent si une formule est satifiable : ils manipulent des formules sous "forme normale conjonctive", c'est à dire, "à plat".
]

#dev[Transformation d'une structure inductive en une structure "plate" : la transformation de Tseitin]

== Expressions régulières 
#def[Expression régulière][
  Soit $Sigma$ un language. Une expression régulière sur ce language est : 
  - $epsilon$, le mot vide, est une expression régulière (cas de base)
  - si $a in Sigma$, $a$ est une expression régulière (cas de base)
  - si $e$ et $f$ sont des expression régulière, $e*$, $e.f$ et $e|f$ aussi. 
]

#def[Language défini par une expression régulière][
  Une expression régulière $e$ sur $Sigma$ permettent de definir inductivement un language sur $Sigma$ : 
  - si $a in Sigma$, $L(a) = {a}$
  - $L(epsilon) = {epsilon}$
  - si e et f sont des expressions régulières, 
    - $L(e*) = {m_1 ... m_n | m_i in L(e), n in NN}$
    - $L(e.f) = {m_1 m_2 | m_1 in L(e), m_2 in L(f)}$
    - $L(e | f) = L(e) union L(f)$ 
]   