#import "@preview/cetz:0.3.0"
#import "@preview/syntree:0.2.1": tree
#import "@preview/lovelace:0.3.0": *
#import "../utils.typtp": *
#import "dev_tplt.typtp": developpement

#show: developpement.with(
  titre: [Présentation et correction de l'algorithme de Bellmann-Ford], 
  niveau: [Term, MP2I], 
  prerequis: [Graphes])

= Présentation et Motivations
Soit G = (S, A, w) un graphe pondéré non orienté. S sommets, A arcs et w(u,v) le poids de l'arc de $u - v$, +$infinity$ si aucun arc.
Objectif : trouver les plus courts chemins d'une source $s$ vers les sommets de S en utilisant la programmation dynamique.

1. On décompose le problème en sous-problème $D^k (t)$ qui est la distance du sommet $s$ à $t$ avec un chemin qui contient au plus k arcs.
2. On a la relation de récurrence :
  - $D^k (s)=0$
  - $D^0 (t)= + infinity$ pour $t≠s$ 
  - $D^k (t)=$min ${ D^(k-1) (t), min_(u-t)(D^(k-1)(u)+w(u,t))}$

= Algorithme

#pseudocode-list(hooks: .5em, booktabs: true)[
    *BELLMANN-FORD ( G, s ) :*
    + d $<-$ Tableau de taille $|S|$ initialisé à $+infinity$
    + d[s] $<-$ 0
    + modifie = vrai
    + *Tant que* modifie :
      + modifie = faux
      + *Pour* u dans S :
        + *Pour* v $in$ V[u] :
          + dv = d[v] + w(u,v)
          + *Si* dv < d[u] :
              + d[u] = dv
              + modifie = vrai
    + *Retourner* d
  ]

= Exemple 



= Preuve de terminaison, correction et complexité 

Invariant de boucle : \
$P(i) : quote D^i (t) "est la distance d'un plus court chemin (pcc) de" s" à" t "avec au plus" i "sauts." quote$

*Démonstration :*\
- $P(0)$ est vrai car le seul endroit où on peut aller en 0 sauts, c’est sur soi-même, qui est à distance 0
- Soit $i in N$ tel que $P(i)$. \
  Alors, $D^(i+1)(t) = min (D^i (t), min_(u-t) D^i (u) + w(u, t))$\
  Or, le pcc de $s$ à $t$ de au plus $i + 1$ sauts est :
  - soit de au plus $i$ sauts
  - soit commence par aller vers un voisin $u$ de $t$, or par $P(i)$ on a un pcc de $s$ à $u$ de au plus $i$ sauts.
  Tous ces chemins sont valides, on prend bien le minimum des deux possibilités. D’où, $P(i+1)$.
Ainsi, par principe de récurrence, $forall i in NN, P(i)$


*Compléxité et Terminaison:* \
De plus, un pcc ne passe pas deux fois par le même sommet (car on suppose les poids des arcs positif) donc un pcc est de longueur au plus |S|. Ainsi, P(|S|) et P(|S| + 1) impliquent que la |S|-ième et la |S| + 1-ième itérations sont les mêmes. On a donc au plus |S| itérations.

Ainsi cet algorithme est en $O(|S|^3)$ 

= Comment décentraliser pour le protocole de routage dans un réseau
