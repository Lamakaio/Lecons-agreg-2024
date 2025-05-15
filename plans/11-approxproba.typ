#import "@preview/cetz:0.3.0"
#import "@preview/syntree:0.2.1": tree
#import "@preview/lovelace:0.3.0": *
#import "@preview/codly:1.1.1": *
#import "@preview/codly-languages:0.1.1": *

#import "../utils.typtp": *
#import "lecon_tplt.typtp": lecon


#show: lecon.with(
  titre: [Leçon 11 : Algorithmes d'approximation et algorithmes probabilistes. Exemples et applications.], 
  niveau: [MPI], 
  prerequis: [NP-complétude], 
  motivations: [Beaucoup d'algo exactes ont une complexité importante. Pour gagner en temps d'execution, on peut sacrifier la fiabilité du résultat.])

= Algorithmes probabilistes
== Définitions 
#def[Algo probabilistes][
  - Un algorithme est deterministe si, pour une entrée $x$ donnée, il suit le même chemin d'execution et renvoie là même sortie.
  - Un algorithme est probabiliste si son execution dépend de l'entrée x et d'un générateur pseudo-aléatoire.
]

#ex[
  Soit T un tableau de booléens de taille n. On cherche $i in [|1, n|]$ tq $T(i)$.
  #grid(columns: (1fr, 1fr))[
#pseudocode-list(hooks: .5em, title: smallcaps[Deterministe], booktabs: true)[
  + *for* i *in* 1..n
    + *if* T(i)
      + *return* i
  + *return* -1
]
  ][
#pseudocode-list(hooks: .5em, title: smallcaps[Probabiliste], booktabs: true)[
  + Tirer aléatoirement i dans $[|1, n|]$
  + *if* T(i)
    + *return* i
  + *return* -1
]
  ]
]

#rq[
  Soit p la proportion de booléens à False dans T. L'agorithme probabiliste présenté se trompe avec une probabilité p.
]

== Algorithmes de Monte-Carlo
#def[Algo de Monte-Carlo][
  Un algorithme de Monte-Carlo pour un problème P, est un algorithme A tel que, pour toute instance i de P: 
  - A(i) est une solution qui a une certaine probabilité d'être erronnée
  - Le temps d'execution de A(i) peut être borné indépendamment des choix aléatoires.
]

#ex[L'algorithme probabiliste de l'exemple 2 est un algorithme de Monte-Carlo]

#blk1[Proposition][Amplification][
  étant donné un algorithme de Monte-Carlo A avec une probabilité d'erreur p. Il est possible de diminuer cettre pronanilité d'erreur en appliquant k fois A sur une même instance. La probabilité d'erreur est alors au plus $p^k$.
]

#ex[
  On peut faire un test de primalité à l'aide du petit théorème de fermat : 
  - $n$ est premier ssi $forall a in [|1, n[|, $a^(n-1) eq.triple 1 (n)$$
#pseudocode-list(hooks: .5em, title: smallcaps[Primalité(n, k)], booktabs: true)[
  + *if* $n <= 1$ *return* false
  + *if* $n = 2$ *or* $n = 3$ *return* true
  + *if* $n % 2 = 0$ *return* false
  + *for* $i in [|1, k|]$
    + Tirer unif. a dans $[|2, n[|$
    + *if* $a^(n-1) % n != 1$
      + *return* false
  + *return* true
]
]

#rq[La probabilité qu'un n non premier passe le test est inférieur à $1/2$, et donc avec $k$ itérations, inférieur à $(1/2)^k$] 

#dev[Vérification probabilite de la multiplication de matrice]

== Algoritgme de Las Vegas

#def[Algorithme de Las Vegas][
  Un algorithme de Las Vegas pour un problème P est un algorithme probabiliste A tel que pour toute instance i de P 
  - A(i) retourne toujours une solution correcte 
  - Le temps d'execution de A sur i est aléatoire
]

#ex[
  #pseudocode-list(hooks: .5em, title: smallcaps[Tri-rapide(T)], booktabs: true)[
  + *if* $|T| = 1$
    + *return* T
  + Tirer uniformément le pivot q dans $[|1, |T| - 1|]$
  + Diviser T en $T^+$ et $T^-$ les éléments inférieurs et supérieurs à q
  + #smallcaps[Tri-rapide($T^+$)]
  + #smallcaps[Tri-rapide($T^-$)]
]
]

#text(fill: red)[Rajouter soit les N reines soit une section implem, avec générateur pseudo aléatoire, fonctions dans les languages.]

= Algorithmes d'approximation 
== Définitions 
#def[Problème de minimisation][
  Un problème de minimisation est un problème P: I -> S, avec I l'ensemble des instances et S des solutions muni d'une fonction d'évaluation $c: I times S -> RR$.\
  Une solution optimale pour P sur l'instance i est une solution qui minimise $c$. On la note OPT(i) 
]

#def[Approximation][
  Une $alpha$-approximation d'un problème P est un algorithme A tel que : 
  $"max"_(i in I)( A(i)/"OPT"(i), "OPT"(i)/A(i)) <= alpha$
]

#rq[
  On peut, de manière symmétrique, définir les problèmes de maximisation, ausuel cas on veut $A(i) >= 1/alpha "OPT"(i)$
]

== Exemples d'algorithmes d'approximation

#text(fill: red)[Parler de l'ordonnancement, de indep, du voyageur du commerce (euclidien)]

== Exemples d'algorithmes d'approx probabiloistes

#blk1[Problème][MAX-2-SAT][
  - *entrée* Une formule $sigma$ en FNC à 2 littéraux par clause
  - *sortie* Une valuation qui satisfait le maximum de clauses de $sigma$
]

#blk2[Propriété][
  Même si 2-SAT est dans P, MAX-2-SAT est NP-complet.
]

#pseudocode-list(hooks: .5em, title: smallcaps[approx($phi$, n)], booktabs: true)[
  + Tirer uniformément un tableau de booléen v
  + *return* v
]

#blk2[Propriété][
  Si $phi$ n'a que des clauses à deux littéraux distincts, A($phi$, n) satisfait en moyenne $3m / 4$ clauses, où m est le nombre de clauses. 
]

#blk2[Preuve][
  Soit $Phi = c_1 and c_2 ... c_m$ et $c_i = l_i and l_i'$. Soit $X_i$ la v.a. qui vaut 1 ssi $c_i$ est satisfaite.

  $E(Sigma X_i) = Sigma E(X_i) = Sigma P(X_i = 1)$

  Or, $P(X_i = 0) = P(l_i = 0 and l_i' = 0) <= 1/4$ (avec l'hypothése, c'est indépendant)

  Donc $E(Sigma X_i) = 3m/4$
]