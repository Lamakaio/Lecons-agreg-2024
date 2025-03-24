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

  On défini alors récursivement, pour $n in NN$ l'ensemble inductif $I_n$ de profondeur $n$ : 
  - si $n = 0$, $I_0 = Beta$
  - pour $n > 0$, $I_n = I_(n-1) union union.big_(gamma in C) gamma(I_(n-1))$

  Intuitivement, $I_n$ est l'ensemble obtenu en applicant les constructeurs aux cas de base au maximum $n$ fois. 

  Alors, l'ensemble I défini par induction par les cas de base $Beta$ et les constructeurs $C$ est $I = union.big_(n in NN)I_n$, c'est à dire l'ensemble obtenu en appliquant les constructeurs aux cas de base un nombre fini de fois. 
]

#blk2[Exemple][
  Prenons $Omega = RR$, $Beta = {0}$ et $C = {x -> x+1}$. 

  On a alors, $forall n in NN$, $I_n = [|0, n|]$, et $I = NN$
]

#blk2[Remarque][
  En général, on ne précise pas $Omega$, en admettant qu'il existe un ensemble suffisemment grand pour contenir tous nos objets. On définit alors les fonctions C sur l'ensemble I lui-même. 
]

#blk2[Exemple][
  Prenons $Beta = {[]}$ et $C = {x::l | x in NN, l "une liste"}$. 

  On a alors, $forall n in NN$, $I_n$ est l'ensemble des listes de taille au plus $n$, et $I$ est simplement l'ensemble des listes finies. 
]

#blk1[Théorème][Preuve par induction][
  Soit $I$ un ensemble par induction sur $Omega$, défini par $Beta$ et $C$. 
  Soit un prédicat $P : I -> {"vrai", "faux"}$. 

  Si les conditions suivantes sont réunies
  - pour tout $x in Beta$, $P(x)$ est vrai
  - pour tout $gamma in C$, $x_1, ..., x_n in I$, si tous les $P(x_i)$ sont vrais, il en découle que $P(gamma(x_1, ..., c_n))$ est vrai. 

  Alors pour tout $x in I$, $P(x)$ est vrai. 
]

#blk2[Exemple][
  Soit l une liste décroissante, dont le dernier élément est 0. Montrons que tous les éléments sont positifs. 
  - si $l = [0]$, tous les éléments sont positifs. 
  - si $l = x::y::q$, avec $x in NN$ et $q$ une liste. Alors, on suppose que tous les éléments de $y::q$ sont plus grands que 0. En particulier, $y >= 0$.
  Comme l est décroissante, $x >= y$, et donc $x$ est positif
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

