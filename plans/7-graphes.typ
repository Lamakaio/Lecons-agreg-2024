#import "@preview/cetz:0.3.0"
#import "@preview/syntree:0.2.1": tree
#import "@preview/lovelace:0.3.0": *
#import "@preview/codly:1.1.1": *
#import "@preview/codly-languages:0.1.1": *

#import "../utils.typtp": *
#import "lecon_tplt.typtp": lecon


#show: codly-init.with()
#show: lecon.with(
  titre: [Leçon 7 : Accessiblité et chemins dans un graphe. Applications.], 
  niveau: [Terminal (Parcours) / Prépa], 
  prerequis: [Graphes (définitions et représentations)],
  motivations: [Réseaux, Automates, Jeux])


#text(fill:red)[PARLER DES IMPLÉMENTATIONS MATRICE OU LISTE D'ADJACENCE CAR CA CHANGE LES COMPLÉXITÉS]


= Rappels

#blk3("Notation")[
  On note G = (S,A) un graphe G, contentant les sommets S et les arcs A.
]

#def("Chemin")[
  Un chemin d'un sommet $u$ à un sommet $v$ dans G est une  séquence $x_0, ... ,x_n$ de sommets de S tels que $x_0 = u "et" x_n = v "et" forall i in [0:n[ (x_i,x_i+1) in A$. \
  On définit la longueur d'un chemin par le nombre d'arc qu'il le compose.
]

#def("Accessible")[
  Soit $u$ et $v$ deux sommets de S, on dit que $v$ est accessible depuis $u$ s'il existe un chemin de $u "à" v$.
]

#def("Cycle")[
  Un cycle est un chemin d'un sommet $u$ à $u$ de longueur suppérieur à 0. Un graphe qui ne contient pas de cycle est dit acyclique.
]


= Parcours (Terminal/MP2I)

#blk2("Remarque")[
  Beaucoup d'algorithmes sur les graphes nécessitent un parcours de ce graphe.  
]

#blk2[Spécification][
  Un algorithme de parcours de graphe prend en entrée un graphe G et un sommet source $s$.
]
#blk3("Accésibilité")[
  Les sommets renvoyés par un parcours de graphes sont les sommets accessibles depuis $s$. 
]

== Parcours en profondeur
#blk2("Principe de l'algorithme")[
  On part de $s$ tant qu'il est possible de progresser en suivant un arc on le fait, et sinon on fait machine arrière pour considérer d'autres arcs. On sauvegarde les sommets vus pour ne pas boucler en cas de cycle.
]

#blk1("Algorithme", "Parcours en profondeur")[
  #pseudocode-list(hooks: .5em, booktabs: true)[
    + *parcours_profondeur(G, vus, s)* :
      + *si* s n'est pas dans vus :
        + ajouter s à u
        + *pour* v $in$ V[s] :
          + parcours_profondeur(G, vus, v)
  ]
]

#blk2("Exercice")[
  Écrire l'algorithme parcours en profondeur de façon itérative avec une pile.
]

#ex[
  EXEMPLE FACILE
]

#blk2("Compléxité")[$O(S+A)$]

== Parcours en largeur
#blk2("Idée de l'algorithme")[
  On part de $s$ on éxplore le graphe en "cercle concentrique". On va d'abord dans les sommet de distance 1 de $s$ puis 2 et ainsi de suite. On utilise une file dans laquelle on vient mettre les sommets au fure et à mesure qu'on les rencontre.
]

#blk1("Algorithme", "Parcours en largeur")[
  #pseudocode-list(hooks: .5em, booktabs: true)[
    + *parcours_largeur(G, s)* :
      + vus = []
      + f file initilisé avec s 
      + *tant que* f n'est pas vide : 
        + x = defiler f 
        + *pour* v $in$ V[x]:
          + si v n'est pas dans vus :
            + f enfiler v 
            + ajouter v dans vus 
  ]
]

#ex[
  FAIRE EXEMPLE BASIQUE
]

= Applications autour des parcours

== Composantes connexes d'un graphe 

#def("Composante connexe")[
  Un sous-ensemble de sommets d'un graphe non orienté  qui sont tous connectés (ie accessibles).
]

#def("Graphe connexe")[
  Graphe qui comporte une seule composante connexe.
]

#blk3("Propriété")[
  On peut trouver les composantes connexes par un parcours de graphe.
]

#blk2("Exercice")[
  Implémenter un algorithme qui renvoie une liste des composantes connexe d'un graphe non orienté.
]

#def("Composante fortement connexe")[
  Un sous-ensemble de sommets d'un graphe orienté où tous les sommets de ce sous-ensemble sont accessible par tous les sommets de celui-ci.
]
#def("Graphe fortement connexe ")[
  Graphe qui comporte une seule composante fortement connexe.
]

#blk1("TP", "Kosaraju-Saphir")[
  TP guidé pour implémenté de l'algorithme de Kosaraju-Saphir qui renvoie les composantes fortements connexe d'un graphe orienté.
]

== Ordonnancement : tri topologique (À RÉDUIRE)

#blk1("Problème", "Ordonnancement")[
  On a une liste de tâches à effectuer, certaines doivent attendre la fin de l'éxecution d'autres tâches. On souhaite savoir dans quel ordre effectuer les tâches.
]

#blk3("Modélisation")[
  On peut modéliser le problème d'ordonnancement par un graphe orienté. On a un sommet par tâches à éxecuter. Si une tâche $v$ nécessite la fin de l'éxécution d'une tâche $u$ alors, on a un sommet $u->v$.  
]

#def("Tri topologique")[
  Soit G un graphe orienté acyclique. Un tri topologique est une liste ordonnée de ses sommets telle que, pour tout arc $u ->v$ dans le graphe, le sommet $u$ apparait avant le sommet $v$ dans la liste.
]

#blk1("Algorithme", "Ordre postfixe")[
  On utilise l'ordre postfixe d'un parcours en profondeur pour avoir le tri topologique d'un graphe.\
  On initialise une pile vide.\
  Dans le parcours en profondeur, on ajoute le sommet $u$ à notre pile après l'éxploration de tous les voisins d'un sommet.
  On renvoie cette pile.
]

#blk2("Exercice")[
  Rédiger la preuve que l'ordre postfixe d'un parcours en largeur est un tri topologique.
]

== Application sur les automates
Un automate peut etre représenté par un (multi-)graphe orienté pondéré par des lettres de l'alphabet.
#blk2("Langage vide")[
  Vérifier si un le langage d'un automate est vide revient à vérifier si aucun de ces états finaux est accéssible.
]


= Plus court chemins

On concidère des graphes pondérés, les arcs sont donc associés à une valeur. Le principe est de trouver le plus court chemin d'un sommet à un autre.

== D'un sommet à tous les autres

Dans un premier temps on cherche tous les plus courts chemins, avec leurs poids, d'une source $s$ à tous les autres sommets du graphes.


=== Bellman-Ford

#blk3("Principe de l'algorithme")[
  Cet algorithme utilise le principe de programmation dynamique. 
  1. On décompose le problème en sous-problème $D^k (t)$ qui est la distance du sommet $s$ à $t$ avec un chemin qui contient au plus k arcs.
  2. On a la relation de récurrence :
  - $D^k (s)=0$
  - $D^0 (t)= + infinity$ pour $t≠s$ 
  - $D^k (t)=$min ${ D^(k-1) (t), min_(u-t)(D^(k-1)(u)+w(u,t))}$
]
#blk3("Algorithme")[
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
]

#blk2("Compléxité")[
  $O(|S|^3)$ si implémentation par matrice (on parcours la matrice |S| fois en $O(|S|^2)$) 
]

#blk2("Remarque")[
  L'algorithme de Bellman-Ford permet d'avoir certains arc à poids négatifs. Il ne faut juste pas de cycle à poids négatifs pour ne pas avoir de boucle infinie.
]

#blk1("Application","Routage d'un réseau")[
  L'algorithme de Djikstra est utilisé dans le protocole OSPF (Open Shortest Path First) et l'algorithme de Bellman-Ford est utilisé dans le protocole RIP (Routing Information Protocol).\
  Ces protocoles servent à chavoir sur quels liens les routeurs vont communiquer pour avoir des chemins les plus courts.
]
#dev[Bellman-Ford décentralisé]


=== Dijkstra

#blk3("Principe de l'algorithme")[
  L'algorithme de Dijkstra est une variante du parcours en largeur. On procède toujours pas cerlcles concentriques mais cette fois-ci par poids total du chemin depuis la source. Pour faire cela on utilise une file de priorité.
]

#blk2("Remarque")[
  On n'autorise pas des arcs de poids négatifs.
]

#blk3("Algorithme")[
  #pseudocode-list(hooks: .5em, booktabs: true)[
    *Dijkstra (G, s):*
    + distance = tableau de taille |S| initialisé à $+infinity$
    + fp = file de priorité initialisé avec (s,0)
    + vus = tableau de taille |S| initialisé à faux
    + *Tant* que fp n'est pas vide :
      + (x, dx) = extraire min de fp
      + *Si* vus[u] = faux :
        + vus[x] = vrai
        + *Pour* chaque voisins v de x :
          + dv = dx + poids de l'arc x$->$v
          + *Si* dv < distance[v] :
            + distance[v] = dv
            + insérer (v, dv) à fp
    + *Retourner* distance
  ]
]

#blk2("Compléxité")[
  Si les opérations insérer et extraire de la file de priorité sont logarithmique, on a |A| insertion et |A| extraction dans la file de priorité donc on a une compléxité en  $O(|A| log |A|)$.
]

#blk1("Algorithme","A*")[
  L'algorithme A\* est une amélioration de l'algorithme de Dijkstra pour les problèmes où l'on dispose des informations sur la destination. Exemples : point GPS, sortie d'un labyrinthe. \
  L'algorithme utilise une heuristique admissible qui permet de résoudre le plus court chemin entre une source et une destination en parcourant moins de sommet que Dijkstra. La file de priorité n'est plus basé sur la distance d'un sommet depuis la source mais à cette distance additionner à l'heuristique.
]

#dev[Exemple de l'algorithme A\*]


== De tous les sommets à tous les sommets
On cherche maintenant un algorithme plus efficace pour avoir accès à tous les plus courts chemins d'un graphe (de toutes les sources à tous les sommets).


=== Floyd-Warshall

#blk3("Principe de l'algorithme")[
 1. On considère le sous problème $D^k (i, j)$ qui est le poids minimal d'un chemin du sommet i au sommet j n'empruntant que des sommets intermédiaires dans {1, 2, 3, …, k} s'il en existe un, et $infinity$ sinon.
 2. On a la relation de récurrence :
  - $D^0$ est la matrice d'adjacence
  - $D^k (i,j) = min(D^(k-1) (i,j),D^(k-1) (i,k) + D^(k-1) (k,j))$
]

// #blk1("Algorithme", "Floyd-Warshall")[
//    #pseudocode-list(hooks: .5em, booktabs: true)[
//     *Floyd-Warshall ( G ) :*
//     + distance $<-$ matrice de taille $|S|times|S|$ initialisé à $+infinity$ 
//     + on remplie distance des poids des arcs présents
//     + *Pour* k de 0 à |S|-1 :  
//       + *Pour* i de 0 à |S|-1 : 
//         + *Pour* j de 0 à |S|-1 : 
//           + x = distance[i][k] + distance[k][j]
//           + *Si* x < distance[i][j] :
//               + distance[i][j] = x
//     + *Retourner* distance
//   ]
// ]

#blk2("Compléxité")[
  $O(|S|³)$
]

#blk2("Remarque")[
  Si on appliquait Dijkstra pour chaque sommet on aurait un algorithme en $O(|S|² log |A|)$
]

#blk2("TP")[
  Effectuer une implémentation de Dijkstra et Floyd-Warshall et comparer les performances des deux algorithmes.
]

