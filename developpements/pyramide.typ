#import "@preview/cetz:0.3.0"
#import "@preview/syntree:0.2.1": tree
#import "@preview/lovelace:0.3.0": *
#import "../utils.typtp": *
#import "dev_tplt.typtp": developpement

#show: developpement.with(
  titre: [Illustration des méthodes de la programmation dynamique sur le problème du chemin dans la pyramide], 
  niveau: [Term, MP2I], 
  prerequis: [])

= Problème

On introduit le problème du chemin dans une pyramide pour introduire le concept de programmation dynamique. On se sert de cet exemple pour montrer l'amélioration de performance obtenu par la programmation dynamique. Celà en illustrant avec les méthodes descendante et ascendante avec mémoïsation.

*Problème :*\
Entrée : Une pyramide $Pi$ de hauteur h remplie d'entier\
Sortie : La valeur maximale d’un chemin du sommet de la pyramide à sa base 

#image("../img/pyramide_1.png", width: 50%)

Exemple : pyramide de hauteur 3. En rouge, la valeur optimale d’un chemin depuis le sommet (19).

= Solutions
== Approche gloutone

A chaque étape, on choisit le sommet de plus grande valeur. Complexité : O(h).

_Faire l'exemple sur la pyramide exemple_

Pas optimal.

== Programmation dynamique

*Étape 1, création des sous-problèmes :* \
Si p est une sous pyramide de $Pi$, on note $S(p)$ la valeur max d’un chemin du sommet de $p$ à sa base.

*Étape 2, relation de récurrence :*\
On note $Pi_g$ et $Pi_d$ les sous-pyramides gauche et droite de $Pi$\
$S(Pi) = v(Pi) + max(S(Pi_g ), S(Pi_d)) $\
où $v(Pi)$ est la valeur du sommet de la pyramide.

= Implémentations

== Représentation 
On va stocker notre pyramide dans une matrice $T$ de dimension $h*h$.\
T[i,j] = jème élément en partant de la gauche à la profondeur i si j ≤ i

#table(columns: (2em,2em,2em),
"5","","","8","4","","1","2","10"
)

Les sous pyramides gauches et droites de (i,j) sont (i+1, j) et (i+1, j+1)

== Méthode descendante 

On part de la version naïve sans mémoïsation.

_laisser un peu de place pour rajouter le code en rouge_

#pseudocode-list(hooks: .5em, booktabs: true)[
  *cheminOpt(T, i, j) :*
  + #text(fill: red)[*si* R[i][j] > -$infinity$ :]
    + #text(fill: red)[*retourner* R[i][j]]
  + *si* i = |T| :
    + r = T[i][j]
  + *sinon* :
    + r = T[i][j] + max(cheminOpt(T,i+1,j), cheminOpt(T, i+1, j+1))
  + #text(fill: red)[R[i][j] = r]
  + *retourner* r
]

La complexité de la version sans mémoïsation est $C(h) = 1 + 2C(h-1)$ donc $O(2^h)$ 

On initialise une matrice globale $R$ de dimension $h*h$ initialisé à -$infinity$

La complexité de la version sans mémoïsation est $O(h^2) $ car on ne remplie la tableau R qu'une fois.

== Méthode déscendante
#pseudocode-list(hooks: .5em, booktabs: true)[
  *cheminOpt (T) :*
  + R = matrice de (|T|+1)^2 
  + *Pour* i de |T|-1 à 0 :
    + *Pour* j de 0 à i :
      + R[i][j] = T[i][j] + max (R[i+1][j], R[i+1][j+1])
  *Retourner* R[0][0]
]

*Exemple*

_Dérouler l'exemple_

_On peut modifier cet algo pour n'avoir qu'un tableau à 1D en stockant seulement l'étage inférieur_

On peut aussi reconstruire le chemin facilement.