#import "@preview/cetz:0.3.0"
#import "@preview/syntree:0.2.1": tree
#import "@preview/lovelace:0.3.0": *
#import "../utils.typtp": *
#import "dev_tplt.typtp": developpement

#show: developpement.with(
  titre: [K-moyennes], 
  niveau: [MPI], 
  prerequis: [])

\

= Introduction 
#underline[_Objectif :_]
Classifier des données en k classes. On part de l'exemple des chiffres qui vont de 0 à 9, et on souhaite classifier en 10 classes.\

#underline[_Modélisation :_]
On estime qu'on a une fonction $d(x,y)$ qui calcule la distance entre 2 images. Cette fonction à les propriétés : 
- $d(x,y) >= 0$
- $d(x,y) = 0$ ssi $x=y$ 
- $d(x,y) = d(y,x)$
- $d(x,y)<= d(x,z)+d(z,y)$
Ici on modélise nos images par des points dans un plan 2D et on utilise la distance euclidienne entre 2 points.

= Version naïve, points initiaux aléatoires
== Exemple
_simplifier un peu l'exemple_
#image("../img/k-m_1.png", width: 80%)
#image("../img/k-m_2.png", width: 80%)
#image("../img/k-m_3.png", width: 80%)

== Algo (à écrire en même temps)
#pseudocode-list(booktabs: true, hooks: .5em)[
  *k-moyenne (X, k, d):*
  + $mu$ = tableau de taille k
  + C = tableau d'ensemble de taile k
  + *pour* i de 1 à k :
    + $mu$[i] = aléatoire dans X et pas dans $mu$[1:i-1]
  + changement = vrai
  + *tant que* changement :
    + *pour* x $in$ X : 
      + i = argmin(d($mu$[i],x)
      + ajouter x à C[i]
    + *pour* i de 1 à k :
      + $mu$[i] = épicentre de C[i]
    + *si* aucun changement n'est survenu dans $mu$[1:k] :
      + changement = faux
  + *retourner* C
]

Variant : $sum_(i=1)^k sum_(x in C[i]) d(x, mu[i])^2$\
Comme nombre de partition dénombrable, l'algorithme termine. En général on n'attend pas la convergence mais on demande un nombre maximal d'itérations.

== Problème 
Prendre les points aléatoirement au début présente des risques.
#image("../img/k-m_4.png", width: 80%)
Ici on va avoir le point de droite qui prend les 2 clusters de droite, et le cluster de gauche découper en plusieurs clusters.

On peut soit prendre un k plus grand pour avoir plus de chances de découpler les grandes classes quitte à avoir plusieurs classe de chaque chiffre. Ou alors on peut choisir nos points initiaux d'une meilleure façon.

= Version choix des points initiaux
Pour choisir nos points initiaux on pourrait prendre le problème du clustering, qui est en somme le même problème que celui des k-moyennes mais qui cherche l'optimal des cluster en souhaitant minimiser le diametre des clusters.

Ce problème est un problème NP-complet, mais on connait une 2-approximation qui est dans P. 

#pseudocode-list(booktabs: true, hooks: .5em)[
  *cluster-approx (X,k,d):*
  + $mu$ = tableau de taille k
  + $mu$[1] = point aléatoire de X 
  + *pour* i de 2 à k :
    + $mu$[i] = point le plus loins de $mu$[1:i-1]
  + *retourner* $mu$
]

Cette algorithme certifie que le diametre des clusters est au plus 2 fois l'optimal. On peut ensuite appliquer l'algorithme des k-moyennes avec ces k points initiaux et on résuit grandement le problème évoquer lors de la séléction de points aléatoire.

#r[Notée idée de la preuve de l'approx de 2 si jamais question ou trop de temps]