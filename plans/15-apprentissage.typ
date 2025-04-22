#import "@preview/cetz:0.3.0"
#import "@preview/syntree:0.2.1": tree
#import "@preview/lovelace:0.3.0": *
#import "@preview/codly:1.1.1": *
#import "@preview/codly-languages:0.1.1": *

#import "../utils.typtp": *
#import "lecon_tplt.typtp": lecon

#show: codly-init.with()
#show: lecon.with(
  titre: [Leçon 15 : Algorithme d'apprentissage supervisé et non supervidé. Exemples et applications.], 
  niveau: [MPI], 
  prerequis: [Arbres, algorithmes d'approximation])

#rect[sources : Tortue]

#def[Problème de Classification][Un problème de classification est un problème ou on doit associer chaque donnée $s in S$ à une classe $c in C$ ]

#ex[
  On veut associer à image d'un chiffre écrit à la main, le numéro de ce chiffre entre 0 et 9. 
]

#def[Algorithme d'apprentissage][
  Un algorithme d'apprentissage est un méta-algorithme qui créé un algorithme de classification, capable de classifier les données. Il utilise pour cela un jeu de donnée.
]

#text(fill: red)[faire un schéma : \
donnée -> algo -> classe 
 
jeu de donnée -> apprentissage -> algo
]

= Apprentissage supervisé
#def[apprentissage supervisé][
  Un algorithme d'apprentissage supervisé est un algorithme d'apprentissage qui utilise un jeu de donnée étiqueté, c'est à dire que chaque donnée est associée à une classe. 
]

#blk2[Objectif][
  Produire un algorithme capable de classifier une donnée qui n'était pas présente dans le jeu de donnée initial.
]

#blk2[Remarque][
  En général, une donnée est représentée par un point dans $RR^d$, et donc $S in RR^d$ pour un certain $d$.
]

== Algorithme des k plus proches voisins
#blk1[Algorithme][k plus proche voisins][
  - Apprentissage : stocker tout les couples du jeu de donnée d'entrée
  - Classification : étant donné un point $p in RR^d$, on cherche les k plus proches voisins de $p$ au sens de la distance euclidienne, et on renvoie la classe majoritaire.
]

#ex[faire un dessin !]

#blk2[Remarque][
  Si n est le nombre de données du jeu de données, l'apprentissage se fait en O(n), et la classification en O(n log k)
]

#dev[Améliorations avec les arbres k-dimensionnels]


== Arbre de décision : algorithme ID3
#blk2[Objectif][
  Obtenir un arbre de décision binaire qui permet de classifier facilement les données. Exemple ! 
]

#blk1[Algorithme][Construction d'un arbre de décision binaire via ID3][
  - Entrées :
    - un sensemble d'attributs A
    - un ensemble de classes C
    - Un jeu de données S. Une donnée $s in S$ possède une fonction $f_s : A -> {0, 1}$ qui donne la valeur des attributs, et une classe $c_s$. 
  - Sortie : un arbre de décision

  *Cas général*\
  + On choisi un attribut $a in A$
  + On fait deux appels récursifs : 
    - $g = "ID3"(A \\ {0}, C, {s in S | f_s(a) = 0})$
    - $d = "ID3"(A \\ {0}, C, {s in S | f_s(a) = 1})$
  + renvoyer l'arbre (a, g, d)

  *Cas de Base*\
  + Si $S = emptyset$, renvoyer une feuille étiquetée avec la classe c la plus présente dans le noeud parent. 
  + Si toutes les données de $S$ sont dans la même classe $c$, renvoyer une feuille étiquetée par $c$. 
  + Si $A = emptyset$, renvoyer une feille étiquetée avec la classe $c$ la plus représentée dans $S$. 
]

#blk2[Problème][Comment choisir le $a in A$ dans le cas général ? ]

#blk2[Activité][Introduire l'entropie de Shannon pour répondre à cette question.]

== Mise en oeuvre et validation 
Comment évaluer expérimentalement la qualité de notre algorithme de classification ? 

#blk2[Idée][
  Lorsqu'on a un jeu de données, on le sépare en deux : un jeu d'apprentissage, et un jeu de validation. Cela permet de faire la validation sur de nouvelles données, ce qu'on veut évalue ! 
]

#def[Matrice de confusion][
  La matrice de confusion d'un algorithme de classification et d'un jeu de donnée, est une matrice M de taille $|C| times |C|$, telle que $M_(i j)$ est le nombre de données de classe $c_i$ qui ont été classées en $c_j$ par l'algorithme. 

  Si l'algorithme de classification ne fait jamais d'erreurs (cas idéal), c'est une matrice diagonale. 
]

#blk2[Remarque][Une mauvaise matrice de confusion peut être liée à un sur-apprentissage]

= Apprentissage non supervisé
#def[Apprentissage non supervisé][
  Dans le cadre de l'apprentissage non supervisé, le jeu de donnée ne contient pas de classe. 
]

#blk2[Objectif][
  Regrouper les données en classes en associant les données similaires. L'entrée est $S$, contenant $n$ points de $RR^d$, et un nombre k de classes cible, et la sortie est une fonction $phi: S -> [|1, k|]$.
]

#ex[Faire un dessin !]

== Classification hiérarchique ascendante 

#blk1[Algorithme][classification hiérarchique ascendante][
  *Initialisation* Les n points de S sont chacun dans leur propre classe \
  *étapes* 
  + On calcule pour chaque paire de classes la distance entre ces deux classes
  + On fusionne les deux classes les plus proche
  *Cas d'arrêt* On a exactement k classes
]

#blk2[Problème][
  Comment calculer la distance entre deux classes ? \
  -> plusieurs distances possibles : moyenne, médiane, distance de l'enveloppe connexe ... 
]

#ex[Encore une fois, faire un dessins ! ]

== Algorithme des k-moyennes 
#blk2[Principe][
  On partitionne les n points en k classes de manière à minimiser le plus grand diamètre d'une classe. 
]

#blk2[Problème][
  Ce problème est NP-complet.
]

#blk1[Algorithme][k-moyennes][
  L'algorithme itératif des k-moyennes trouve un minimum local à ce problème. \
  *Initialisation* : On choisi k centres parmis les n points. 
  *étapes*
  + Attribution des classes : chaque point reçoit la classe du centre le plus proche
  + Choix des centres : Pour chaque classe, le nouveau centre est le baricentre des points de la classe. \
  *Cas d'arrêt* : Lorsque les classes ne changent plus, c'est à dire que la k-partition des points n'a pas changé. 
]

#blk1[Théorème][][L'algorithme 28 termine]

#blk2[Problème][Comment choisir les k centres et le nombre de classes k ? ]

#ex[Dans le cas de chiffres à reconnaitre, on sait qu'il y a 10 classes. On peux fixer k légèrement au dessus de 10 pour affiner la classification. ]

#dev[Choix initial des centres via une 2-approx du problème de clustering]

= Enjeux sociétaux
#blk2[Problème][Pour faire l'apprentissage, ona besoin de donnés. Dans quel cadre, et pour quel type de données, a-t-on le droit de collecter et traiter ces données ? ]

== Recolte de donnée 
#blk2[Règle][
  L'article 5 du RGPD (Reglement Général de la Protection des Données) impose certaines contraintes sur la récolte des données :
  - (licéité) : la personne dont les données sont receuilli doit être consentante. 
  - (limitation et explication des finalités) la personne doit savoir que ses donénes sont utilisées par l'apprentissage, on ne peux pas réutiliser des données collectées à d'autres fins. 
  - (limitation de la conservation) on ne doit conserver les données que tant qu'elles sont utiles.
]

#blk2[Règle][L'article 9 du RGPD interdit la collecte de données sensibles]

#blk2[Activité][Qu'est ce qu'une donnée sensible ? ]

== Anonymisation des données
#blk2[Problème][Certains algorithmes de classification doivent conserver les données pour classifier. Comment faire si ces données sont privées ? ]

#blk1[Principe][Anonymisation des données][
  On peut anonymiser les données, qui ne sont alors plus des données personelles. On a les outils suivants : 
  - (randomisation) : On modifie les valeurs des données de telle sorte qu'elles soient moins précises, tout en conservant la répartition globale. 
  - (généralisaiton) On modifie l'échelle des caleurs des données ou leur ordre de grandeur. Par exemple, on peut remplacer une date de naissance par l'année seule, ou même la décennie, selon la finesse souhaitée. 
]