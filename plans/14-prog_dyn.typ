#import "@preview/cetz:0.3.0"
#import "@preview/syntree:0.2.1": tree
#import "@preview/lovelace:0.3.0": *
#import "@preview/codly:1.1.1": *
#import "@preview/codly-languages:0.1.1": *

#import "../utils.typtp": *
#import "lecon_tplt.typtp": lecon

#show: codly-init.with()
#show: lecon.with(
  titre: [Leçon 14 : Programmation dynamique. Exemples et applications.], 
  niveau: [Terminal, MP2I, MPI], 
  prerequis: [Compléxité, Glouton, Diviser pour régner, Graphe],
  motivations: [Résolution de problème d'optimisation, éviter les calculs redondants, réduction significative de la compléxité temporelle])
\

On fait le lien avec la leçon diviser pour régner, en effet il y a certains problèmes où l'on souhaite utiliser la méthode diviser pour régner et on se rend compte que certains appels récursifs vont être éffectuer plusieurs fois avec les mêmes arguments. On utilise alors la programmation dynamique pour y remédier.


= Principe 

== Motivations
#blk1("Algorithme","Fibonnaci div pour régner")[
  On part de l'exemple de la suite de Fibonacci.
  #pseudocode-list(hooks: .5em, booktabs: true)[
    *Fibo(n) :*
    + *Si* n = 0 ou n = 1 :
      + *Retourner* n 
    + *Retourner* Fibo(n-1) + Fibo(n-2)
  ]
]

#blk2("Compléxité")[
  $O(2^n)$\
  Graphe de dépendance des sous-problèmes pour n = 5 :
  #grid(columns: (1fr, 1fr),
  image("../img/progdyn_1.png", width: 60%), 
  [Les sous problèmes se chevauchent, la méthode de diviser pour régner est inefficace. \ 
  En programmation dynamique on va stocker les valeurs des sous problèmes pour éviter les recalculs.]
)
]
#blk1("Algorithme", "Fibonacci avec stockage")[
  #pseudocode-list(hooks: .5em, booktabs: true)[
      *Fibo(n) :*
      F = [0,1]
      + *Pour* i de 2 à n :
        + F[i] = F[i-1]+F[i-2]
      + *Retourner* F[n]
    ]
]

== Définitions

#def("Programmation dynamique")[
  La programmation dynamique est une technique pour améliorer l'éfficacité d'un algorithme en évitant les calculs redondants. \
  Pricipe : décomposer le problème en sous-problèmes, de résoudre chacun des sous-problèmes en stockant les résultats intermédiaires pour construire la solution.\
]

#blk3("Méthode")[
1. Complexifier le problème en créant des sous-problèmes
2. Trouver une relation entre les sous-problèmes
3. Résoudre les sous-problèmes en utilisant la relation :
  - soit impérativement, du plus petit au plus grand en remplissant un tableau des sous-problèmes (méthode ascendante)
  - soit récursivement, en utilisant la mémoïsation (méthode ascendante)
]

#blk2("Remarque")[
  L'algorithme 3 utilise la méthode ascendante, on aurait pu stocker uniquement les 2 derniers résultats.
]

#blk2("Remarque")[
  La méthode diviser pour régner traite des sous-problèmes indépendant et n'a donc pas besoin de mémoïsation.
]

#dev[Illustration des méthodes de la programmation dynamique sur le problème du chemin dans la pyramide]

= Algorithmes illustrant le principe en comparaison avec approche gloutone

== Rendu de monnaie
#blk2("Problème")[
  Instance : n pièces $v_1 < v_2 < ... < v_n in NN$, S une somme à rendre ($v_1=1$)\
  Problème : trouver un n-uplet $T=(x_1, ..., x_n) in NN^n$ tel que\
  $sum_(i=1)^n x_i v_i = S$ et qui minimise $sum_(i=1)^n x_i$.
  (ie trouver le nombre minimal de (pièces pour rendre la monnaie).
]

#blk1("Algorithme", "Approche gloutone")[
  1. Trier les pièces par valeur décroissantes
  2. Ajouter la pièce $v_i$ de plus grande valeur $>= S$
  3. Recommencer 2 et 3 avec $S-v_i$
]

#blk2("Exercice")[
  Trouver un exemple où cet algorithme n'est pas optimal.\
  _Avec les pièces (1,3,4) et S=6_
]

#blk1("Principe de l'algorithme", "Rendu de monnaie en programmation dynamique")[
  1. On considère les sous-problèmes $m_i (s)$ le nombre minimal de pièces utilisés pour rendre la somme s avec les pièces $ {v_1, v_2, ... , v_i }$
  2. On construit la relation de récurrence :\
    - $m_i (0) = 0$
    - $m_i (1) = 1$
    - $m_i (s) = min(1 + m_i (s - v_i), m_(i-1)(s))$ car
      - Si $v_i > s$ : $m_i (s) = m_(i-1)(s)$, $v_i$ ne peut être utilisé 
      - Sinon : $m_i (s) = 1 + m_i (S-v_i)$
      - On prend donc le minimum des deux.   
]

#blk1("Algorithme", "Rendu de monnaie en programmation dynamique")[
#pseudocode-list(hooks: .5em, booktabs: true)[
    *Rendu_Monnaie(pieces, s, m)* :
    + *Si* s = 0 :
      + *Retourner* 0
    + *Si* m[s] > 0: // on a dejà calculer
      + *Retourner* m[s]
    + n = $infinity$
    + *Pour* p $in$ pieces :
      + *Si* p < s :
        + n = min (n , 1 + *Rendu_Monnaie*(pieces, s-p, m))
    + m[s] = n 
    + *Retourner* n
  ]
]

#blk2("Compléxité")[$Theta (n s)$]

== Sac à dos 
#blk3("Problème")[
  Instance : n objets de poids ${p_1, ..., p_n} in NN^n$ et valeurs ${v_1, ..., v_n} in NN^n$, ainsi qu'une capacité $C in NN$.
  Problème : Trouver $T = {x_1, ..., x_n} in {0,1}^n$ tel que $sum_(i=1)^n x_i p_i <= C$ et qui maximise $sum_(i=1)^n x_i v_i$. 
]

#blk2("Exercice")[
  Proposer des algorithmes gloutons pour résoudre le problème. Sont-ils optimaux ? \
  Exercice guidée pour trouver la décomposition en sous-problème et la relation de récurrence de programmation dynamique.
]


= Application à l'algorithmique du texte 
== Alignement de séquence 
#blk2("Motivation")[
  Comparer deux séquence d'ADN.
]

#blk3("Problème")[
  Instance : 2 séquences (string) s1 et s2 \
  Problème : trouver un alignement des deux séquences qui maximise le score d'alignement. On peut ajouter des trous dans les séquences (représenté par "-"). On note s1' et s2' les séquences incrémenté de trous de taille n. Pour $i in [0:n[$ :
  - si s1'[i] = s2'[i] : score + 1
  - sinon : score -1 
]

#blk3("Formule de programmation dynamique")[
  1. On considère le sous-problème s(i,j) le score maximal pour aligner s1[0:i] et s2[0:j] 
  2. On construit la relation de récurrence
  - $s(0,0)= 0$
  - $s(i,0)= -i$
  - $s(0,j)= -j$
  - $s(i,j) = max (k, 1 + s(i-1, j-1))$ si s1[i-1] = s2[j-1]
  - $s(i,j) = max (k, -1 + s(i-1, j-1))$ sinon 
  avec $k= max (-1 + s(i-1,j), -1 + s(i, j-1))$
]

#blk3("Algorithme")[
  *aligne(s1, s2):*
  + *Pour* i de 0 à |s1| :
    + s[i][0] = -i
  + *Pour* j de 0 à |s2| :
    + s[0][j] = -j
  + *Pour* i de 1 à |s1| :
    + *Pour* j de 1 à |s2| :
      + s = max (-1 + s[i-1][j], -1 + s[i][j-1])
      + *si* s1[i-1] = s2[j-1] :
        + s[i][j] = max (s, 1 + s[i-1][j-1])
      + *sinon* :
        + s[i][j] = max (s, -1 + s[i-1][j-1])
  + *Retourner* s[|s1|][|s2|]
]
#ex[
  #image("../img/progdyn2.png", width: 50%)
]

#blk2("Compléxité")[
  $Theta(|"s1"| |"s2"|)$
]

= Application aux graphes
La programmation dynamique peut être utiliser pour calculer les plus courts chemins dans un graphe. 

== Bellman-Ford
L'algorithme de Bellman-Ford utilise la programmation dynamique pour calculer les plus courts chemins depuis un sommet source vers tous les autres sommets.
Cet algorithme est utilisé en réseau dans le protocole RIP comme algorithme de routage.

#dev[Implémentation et correction de Bellman-Ford]

== Floyd-Warshall
L'algorithme de Bellman-Ford utilise la programmation dynamique pour calculer tous les plus courts chemins d'un graphe.

#blk3("Principe de l'algorithme")[
  1. On considère le sous problème $D^k (i, j)$ qui est le poids minimal d'un chemin du sommet i au sommet j n'empruntant que des sommets intermédiaires dans {1, 2, 3, …, k} s'il en existe un, et $infinity$ sinon.
 2. On a la relation de récurrence :
  - $D^0$ est la matrice d'adjacence
  - $D^k (i,j) = min(D^(k-1) (i,j),D^(k-1) (i,k) + D^(k-1) (k,j))$
]

#blk2("Compléxité")[
  $O(V³)$
]

