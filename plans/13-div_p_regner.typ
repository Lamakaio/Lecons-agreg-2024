#import "@preview/cetz:0.3.0"
#import "@preview/syntree:0.2.1": tree
#import "@preview/lovelace:0.3.0": *
#import "@preview/codly:1.1.1": *
#import "@preview/codly-languages:0.1.1": *

#import "../utils.typtp": *
#import "lecon_tplt.typtp": lecon

#show: codly-init.with()
#show: lecon.with(
  titre: [Leçon 13 : Algorithmes utilisant la méthode ≪ diviser pour régner ≫. Exemples et applications.], 
  niveau: [Terminal, MP2I, MPI], 
  prerequis: [Compléxité, Récursion, Arbre],
  motivations: [Décomposer un problème en sous problème plus simple pour le résoudre plus efficacement])
\

= Présentation et méthodes
#def("Diviser pour régner")[
  Diviser pour régner s'effectue en trois étapes :
  - Diviser : cette étape décompose le problème initial en un ou plusieurs sous-problèmes de plus petites tailles
  - Régner : chaque sous-problème est résolu
  - Rassembler : les solutions des sous-problèmes sont rassemblées pour construire la solution du problème initial
]

#blk1("Méthode", "Calcul de complexité")[
  Trouver une fonction donnant la taille du problème (ex : le nombre d'élément d'une liste). Définir C comme la compléxité maximale des instances de cette taille, puis établir une relation de récurrence sur C de la forme $C(n) = a times C(f(n))+g(n)$
]

#blk1("Outil", "Résoudre la relation de récurrence")[
  - Conjecturer la solution, majorer
  - changement de variable \
    (ex : $C(n)=2C(sqrt(n))+log(n)$ avec $n=2^m$ on a $C(2^m)=S(m)=2S(n/2)+n$)
  - arbre récursif : "dépliage" des appels récursifs
]

= Applications à des listes de données
== Recherche dichotomique

#blk2("Problème")[
  Recherche un élément x dans une liste L triée dans l'ordre croissant.
]

#blk3("Algorithme")[
  Entrées : t liste trié, x entier, $0 <= g <= d <= "len"(t)$ \
  Sortie : renvoie une position de x dans t[g..d]
  #pseudocode-list(hooks: .5em, booktabs: true)[
    *Recherche(t, x, g, d):*
    + *Si* g > d :
      + *Renvoyer* None
    + m = (a+b)/2
    + *Si* t[m] < x:
      + *Retourner* Recherche(t, x, m+1, d)
    + *Si* E[m] > x:
      + *Retourner* Recherche(t, x, g, m-1)
    + *Sinon*:
      + *Renvoyer* m
  ]
  #pseudocode-list(hooks: .5em, booktabs: true)[
    *Recherche_dichotomique(t, x):*
    + *Retourner* Recherche(t, x, 0, len(t)-1)
  ]
]

#blk2("Compléxité")[
  $
    C(n)&=C(n/2)+1\
    &= O(log(n))
  $
]

#blk2("Exercice")[
  Écrire une version itérative de cet algorithme.
]

== Tri fusion

#blk2("Problème")[
  Trier une liste L de n éléments.
]

#blk3("Algorithme")[
  #pseudocode-list(hooks: .5em, booktabs: true)[
    *fusion $(L_1,L_2)$*
      + res = tableau de taille $|L_1| + |L_2|$
      + $i = 0$
      + $j = 0$
      + *Tant que* $i < |L_1| "et" j < |L_2| :$
        + *si* $L_1[i] <= L_2[j]$ :
          + res$[i+j]=L_1[i]$
          + $i = i+1$
        + *sinon* 
          + res$[i+j]=L_2[j]$
          + $j = j+1$
      + *Tant que*  $i < |L_1|$ :
        + res$[i+j]=L_1[i]$
        + $i = i+1$
      + *Tant que*  $j < |L_2|$ :
          + res$[i+j]=L_2[j]$
          + $j = j+1$
      + *renvoyer* res
  ]
  #pseudocode-list(hooks: .5em, booktabs: true)[
    *tri_fusion $(L)$*
      + *si* $|L| <= 1$
        + *renvoyer* $L$
      + *sinon* 
        + s = $|L|$/2
        + *renvoyer* fusion $("tri_fusion"(L[s:]), "tri_fusion"(L[:s]))$
  ]
]

#blk2("Compléxité")[
  $
    C(n)&=2C(n/2)+O(n)\
    &= 2(2(n/4)+O(n))+O(n)\
    &=...\
    &= 2^k C(n/2^k)+k O(n)\
    &= n O(1)+ log(n)O(n) \
    &= O(n log(n))
  $
]

#dev("Correction totale de tri fusion")

= Applications au calcul formel 
== L'exponentiation rapide
#blk2("Problème")[
  Calculer $a^n$
]

#blk3("Algorithme")[
  #pseudocode-list(hooks: .5em, booktabs: true)[
    *Exponentiation (a, n) :*
    + *Si* n = 0 :
      + *Retourner 1*
    + b = Exponentiation(a, n/2)
    + *Si* n mod 2 = 0 :
      + *Retourner* b \* b
    + *Sinon* :
      + *Retourner* a \* b \* b
  ]
]

#blk2("Compléxité")[
  $
    C(n)&= C(floor(n/2))+O(1)\
    &= O(log(n))
  $
  On a log(n) multiplication au lieu de n pour la version naïve.
]

== Multiplication de matrice

#blk2("Problème")[
  La multiplication de deux matrice carrée $n times n$ se fait en $O(n³)$ de façon naïve.
  \ L'algorithme de Strassen obtient un produit matriciel en $O(n^log(7))$.
]

#blk1("Algorithme", "Strassen")[
  L'idée derrière cette algorithme est de réduire le nombre de multiplication.
  On transforme le problème en sous problème, en traitant nos matrices par sous bloc de taille $n/2 times n/2$.\
  Prenons deux matrices : 
  $X = mat(A,B;  C,D)$ $Y = mat(E,F;G,H)$\
  On peut ensuite calculer le produit de tel façon :  \
  $X Y= mat(P_5+P_4-P_2+P_6, P_1+P_2;P_3+P_4, P_1+P_5-P_3-P_7)$\ \ 
  avec:  \
  $P_1 &= A(F-H) P_5 &= (A+D)(E+H)\
  P_2 &= (A+B)H P_6 &= (B-D)(G+H)\
  P_3 &= (C+D)E P_7 &= (A-C)(E+F)\
  P_4 &= D(G-E)
  $
  \
  Avec cet algorithme on arrive à la formule de compléxité suivante : \
  $C(n) = 7C(n/N)+O(n²)=O(n^log(7))$
]

= Applications géométrique

== Points les plus proche dans un plan
#blk2("Problème")[
  Étant données $n$ points dans $RR²$, donner la plus petite distance entre deux points.\
]

#blk2("Solutions")[
  Solution naïve : on teste tous les couples $O(n²)$\

  Idée de l'algorithme : \
  - Diviser le plan en 2 sur $x_m$, P1 et P2 de taille égale (à 1 près)
  - Trouver récursivement les plus petites distances $d_1 "et" d_2, d_0 = min(d_1,d_2)$
  - Rechercher la plus petite distance dans la bande autour du découpage $[x_m-d_0;x_m+d_0]$
  - Renvoyer le $min(d_0, d_3)$
]

#blk2("Compléxité")[
  $C(n)=2C(n/2)+O(n)=O(n log(n))$
]


== Arbre K-dimensionnel

#blk2("Problème")[
  Rechercher les 𝑘 plus proches voisins d'un point dans $RR^K$. \
]
#blk2("Solution")[
  Solution naïve : on test la distance pour tout les points : $O(n²)$.\

  Idée de l'algorithme :\
  - Construire un arbre binaire de recherche, appelé arbre K-dimensionnel, qui pour chaque profondeur de l'arbre, diminuer le nombre de point par deux (à un près). Chaque profondeur de l'arbre effectue la recherche du point médian $x$ sur une dimension différente. On a les points inférieurs à $x$ dans le sous-arbre gauche et les points suppérieur dans le sous-arbre droit. Puis on construit récursivement l'arbre en changeant de dimension à chaque profondeur.
  - Une fois l'arbre K-dimensionnel créé, on peut rechercher dans l'arbre en partant de la feuille sur laquelle on aurait positionner notre point et en élargissant pour avoir le nombre de k voisins.
]

#dev[Recherche des k plus proches voisins grâce aux arbre K-dimensionnel]