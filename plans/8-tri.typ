#import "@preview/cetz:0.3.0"
#import "@preview/syntree:0.2.1": tree
#import "@preview/lovelace:0.3.0": *
#import "@preview/codly:1.1.1": *
#import "@preview/codly-languages:0.1.1": *

#import "../utils.typtp": *
#import "lecon_tplt.typtp": lecon

#show: codly-init.with()
#show: lecon.with(
  titre: [Leçon 8 : Algorithmes de tri. Exemple, complexité et applications.], 
  niveau: [Première, Terminal, MP2I], 
  prerequis: [])
\

= Introduction et motivation

#def("Algo de tri")[
  un algorithme de tri prend en entrée une liste d'éléments E muni d'un ordre total $<=$ et renvoie une liste L telle que :
  - L contient exactement les éléments de E
  - les élémentsde L apparaissent dans l'ordre croissant
]

#blk2("Motivation")[
  Pourquoi trier ? Pour simplifier certaines opérations usuelles sur les listes (min, max, recherche)
]

#blk2("Activité")[
  Chercher (à la main) la présence d'un mot dans une liste non triée, puis triée dans l'ordre alphabétique.
]

#def("Propriétés sur les tris")[
  - En place : utilise $O(1)$ espace en plus de l'entrée
  - Stable : $forall i lt j ", "E[i]lt.eq E[j] "et "E[j]lt.eq E[i] => E[i] "est avant " E[j] $ dans L
  - online : on peut trier les données même si elles arrivent au fur et à mesure
]

= Tris quadratiques
== Tri par sélection

#blk3("Algorithme")[
  #pseudocode-list(hooks: .5em, booktabs: true)[
    *Tri_par_selection(E):*
    + n = len(E)
    + L = []
    + *Pour* i=0 à n-1 :
      + m = extraire min de E
      + Ajouter m à la fin de L
    + *renvoyer* L
  ]
]

#ex()[
  _Dérouler un expemble_ 
  [4; 3; 6; 1]
]

#blk2("Terminaison")[
 Variant n-i, décroit strictement jusqu'à 1. La boucle termine.
]

#blk2("Correction")[
  Invariant de boucle : "L est trié et contient les i plus petits éléments de E"
]

#blk2("Complexité")[
  $O(|E|²)$
]
#blk2("Exercice")[
  Ce tri est stable, rendez le en place.
]
== Tri par insertion

#blk3("Algorithme")[
  #pseudocode-list(hooks: .5em, booktabs: true)[
    *Tri_par_insertion(E):*
    + n = len(E)
    + *Pour* i=1 à n-1 :
      + x = E[i]
      + j = i
      + *Tant que* j>0 et E[j-1]>x:
        + E[j] = E[j-1]
        + j = j-1
      + E[j] = x
    + *renvoyer* E
  ]
]

#blk2("Propriété")[
  Ce tri est en place, stable et online.
]

#blk2("Compléxité")[
  Dans le pire cas $O(|E|²)$, dans le meilleur cas $O(|E|)$
]

== Application : la recherche dichotomique
//tortue 1er

#blk3("Algorithme")[
  Entrées : E liste trié, x entier \
  Sortie : renvoie vrai si x est dans E 
  #pseudocode-list(hooks: .5em, booktabs: true)[
    *Recherche_dichotomique(E,x):*
    + *Si* len(E) = 0 :
      + *Renvoyer* Faux
    + g = 0
    + d = len(E)-1
    + *Tant que* g<=d :
      + m = (a+b)/2
      + *Si* E[m] < x:
        + a = m+1
      + *Si* E[m] > x:
        + a = m-1
    + *Si* E[m] = x:
      + *Renvoyer* Vrai
    + *Renvoyer* Faux
  ]
]

#blk2("Terminaison")[
  Variant de boucle : "g-d".
]

#blk2("Correction")[
  Invariant de boucle : "si x est dans E, alors son indice est enree g et d".
]

#blk2("Compléxité")[
  $O(log(|E|))$
]

#blk2("TP")[
  Implémentation et comparaison avec recherche linéaire.
]

= Tris utilisant la méthode diviser pour régner
== Tri fusion

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

#dev("Correction totale de tri fusion")

#blk2("Propriété")[
  Tri stable, mais pas en place et pas online.
]

#blk2("Compléxité")[
  $C(n) = 2C(n/2) + theta(n) => C(n)=O(n log(n))$
]

== Tri rapide

#blk3("Algorithme")[
  #pseudocode-list(hooks: .5em, booktabs: true)[
    *Tri_rapide_aux(E, début, fin):*
    + *Si* début $<=$ fin-1
      + *Retourner* E
    + pivot = E[fin-1]
    + i = début
    + *Pour* j = début à fin-2:
      + si E[j] $>=$ pivot:
        + Echanger E[i] et E[j]
        + i++
    + Echanger E[i] et E[fin-1]
    + tri_rapide_aux (E, début i-1)
    + tri_rapide_aux (E, i+1, fin)
    + *Retourner* L
  ]
  #pseudocode-list(hooks: .5em, booktabs: true)[
    *Tri_rapide(E)*:
    + *Retourner* Tri_rapide (E,0, len(E))
  ]
]

== Tri par tas

#blk3("Principe")[
  Le tri par tas utilise la structure de tas. Un tas est un arbre binaire étiqueté où la valeur de chaque nœud est supérieure ou égale à la valeur de chacun de ses fils. Cette abre est un arbre binaire presque complet à gauche.
  Le tri par tas consiste à construire un tas à partir du tableau à trier, puis à itérer les opérations suivantes : échanger la racine et le dernier élément, diminuer la taille de 1 et restaurer la structure de tas.
]

#dev("Tri par tas")

= Applications
== Algorithmes gloutons

#def("Glouton")[
  Un algorithme glouton est un algorithme qui résout un problème d'entrée E en : 
  - faisant un précalcul sur E (par exemple trier E)
  - construisant une solution en parcourant E sans jamais revenir en arrière.
]

#ex[
  On a $n$ évênements sportifs décrits par leurs dates de début ${d_i}" et de fin" {f_i} "avec" i<=n$ et un gymnase. Comment maximiser le nombre d'évênements.\
  Glouton :
  - Trier les évênements par dates $f_i$ croissantes
  - Mettre les évênements en parcourant la liste si ceux-ci ne s'intersectent pas avec un evenement déjà pris.
]

#def("Arbre couvrant de poids minimal")[
  Un sous graphe connexe acyclique de poids minimal.
]

#blk2("Algorithme")[
  #pseudocode-list(hooks: .5em, booktabs: true)[
    *Kruskal(S)*: \//S est la liste des arrête
    + trier S par ordre croissant de poids
    + A = []
    + *Pour* x dans S :
      + *Si* x $union$ A n'a pas de cycle : 
        + Ajouter x à A
    + *Renvoyer* A 
  ]
]

== Somme de flottants

On veut sommer n flottants. À chaque sommen on peut avoir une erreur d'arrondi. Dans quel ordre faut-il sommer pour avoir une minimisation de cette erreur ?

