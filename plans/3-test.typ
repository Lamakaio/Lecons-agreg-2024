#import "@preview/cetz:0.3.0"
#import "@preview/syntree:0.2.1": tree
#import "@preview/lovelace:0.3.0": *
#import "@preview/codly:1.1.1": *
#import "@preview/codly-languages:0.1.1": *
#import "@preview/diagraph:0.3.3": raw-render

#import "../utils.typtp": *
#import "lecon_tplt.typtp": lecon

#show: codly-init.with()
#show: lecon.with(
  titre: [Leçon 3 : Test de programme et inspection de code], 
  niveau: [MP2I], 
  prerequis: [Notions de programmation et d'arithmétique])

= Introduction 
== Motivations
Quand on écrit un programme, on aimerait savoir si il est correct. 

#def[Correction][
  Un programme est dit "correct" si : 
  - Il termine toujours (terminaison)
  - Quand il termine, il renvoie l'entrée attendue (correction partielle)
]

#blk2("Remarque")[
  On remarque l'importance d'avoir des bonnes spécifications pour savoir quoi tester sur l'algorithme.
]

Malheureusement, il est impossible pour le compilateur de déterminer si un programme est correct : c'est un problème indécidable. 
#dev[Indécidabilité de la correction, théorème de Rice]

#blk2[Interêt][
Plutôt que de s'assurer, à coup sûr, que notre programme est correct, on va donc écrire des test, qui executent notre programme sur des entrées bien choisies. Cela permetra de trouver les erreurs dans le code. 
]

#blk2("Définition")[
  Il existe plusieurs famille de test, dans cette leçon on va se concentrer sur les test unitaires.
  #image("../img/test_1.png", width: 30%)
]

== Données de test

#def[Donnée de test][
  Une donnée de test est un couple (entrée, sortie), tel que, si il est correct, le programme exécuté sur l'entrée doit donner la sortie spécifiée. 
]

#blk2[Remarque][
  La sortie attendue peut être une erreur ! 
]

#def[Jeu de test][
  Un jeu de test est un ensemble de données de test.
]

#ex[
  Si on a un programme calculant le pgcd de deux nombres, un jeu de test peut être : \
  ${[(1, 2), 1], [(-3, 6), 3], [(0, 0), 0], [(1.3, 4), "Erreur"]}$
]

== Types de test
On distingue deux types de test : 
- Les tests en boite noire, où on ne connait pas le code du programme, on peut simplement l'appeler
- Les tests en boite blanche, où on écrit des tests en fonction de code du programme

= Tests en boite noire 
Pour un test en boite noire, on ne connait pas le code. Il faut donc tester sur un ensemble de données suffisemment grand pour couvrir toutes les éventualités. 

On peut rarement tester toutes les valeurs. On a donc deux problématiques : 
- trouver des entrées pertinentes
- calculer la solution de manière fiable sur ces entrées

== Création des entrées

#blk2[Problème][
Dans le cas où on ne peux pas tester toutes les entrées, il faut choisir un nombre limité d'entrées, qui sont représentatives de toutes les entrées possibles.
]

#blk1[Idée][Partitionnement de l'espace d'entrée][
  Une approche utile est de partinionner l'espace d'entrée en différents ensembles de données "similaires", puis de choisir un représentant pour chaque partition.
]

#ex[Pour le calcul du `pgcd(a, b)`, on peut partinonner le domaine d'entrée ($ZZ times ZZ$) en fonction des positions relatives de a, b et 0 : les ensembles sont $0 <= a <= b$, $0 <= b <= a$, $a <= 0 <= b$, et ainsi de suite.
]

#blk2[Remarque][Le choix du partionnement est souvent assez arbitraire, et proviens d'une intuition sur "ce qui risque de changer quelque chose" au déroulement du programme.]


#blk1[Idée][Cas limites][
  En conjonction avec le partionnement de l'espace d'entrée, il y a parfois des valeurs particulières qu'il est bon de tester : 
  - les valeurs minimales et maximales des entrées
  - les structures (mot, tableau, graphe...) vides 
  - et potentiellement d'autres !
]

#ex[
  Toujours dans l'exemple du pgcd, on peut tester 
  - a = 0 ou b = 0
  - a = b
]

== Determination des sorties

Nous avons vu comment trouver des entrées pertinentes. Pour compléter le jeu de test, il faut disposer des sorties correspondantes !

On présente ici trois indé

=== Calcul à la main
#blk1[Principe][Calcul à la main][
  Pour les valeurs simples et les cas limites, on peut en général directement faire le calcul de la solution, à la main. 
]

#ex[
  Pour le `pgcd`, si on veut simplement tester des petites valeurs d'entrées, comme dans l'exemple 6, on peut facilement faire le calcul.
]

=== Utilisation d'un autre programme

#blk1[Principe][Comparaison avec un autre programme][
  Parfois, on dispose d'un autre programme qui calcule le même résultat que le notre, et dont on est sûr qu'il est correct. On peut alors comparer les sorties des deux programmes, et s'assurer qu'il n'y a pas de différences. 

  En général, cet autre programme est soit moins efficace, soit il lui manque des caractéristiques certaines caractéristiques. 
]

#ex[
  On peut par exemple tester le pgcd avec la méthode d'euclide, en le comparant au pgcd par soustraction successive. 
]

=== Valider la réponse du programme


#blk1[Principe][Comparaison avec un autre programme][
  Pour certains problèmes, il est possibles de vérifier qu'une solution est juste bien plus simplement que de calculer une solution. 

  On peut alors utiliser cette validation pour notre test.
]

#ex[
  Par exemple, si on a un programme qui calcule la décomposition en facteurs premiers, on peut vérifier la réponse en 
  - vérifiant que le produit de tous les facteurs donne bien le nombre
  - vérifiant que chaque facteur est bien premier

  Si c'est deux critères sont vérifiés, on sait que le programme est correct.
]

On peut aussi utiliser des solutions probabilistes pour la vérification :
#dev[Méthode probabiliste pour vérifier le produit de matrices en $O(n²)$]


= Tests en boite blanche
== Graphe de flot de contrôle

#blk2[Motivation][
  Pour un test en boite blanche, on connait le code, et on veut créer un jeu de test qui le teste en intégralité. 

  Dans le cas d'une condition `if ... else`, par exemple, on veut des tests qui empruntent chaque branche de la condition.
]

#def[Graphe de flot de contrôle][
  Le graphe de flot de contrôle est un graphe, dans lequel les sommets sont des blocs de code _sans branchements_ (c'est à dire sans boucles et sans conditions). 

  Les arrêtes sont étiquetés par des conditions, tel que, pour $b_1, b_2$ deux sommets, l'arrête $b_1 -> b_2$ est étiquetée par la condition $c$ si, après le bloc $b_1$, si la condition $c$ est vérifiée, c'est le bloc $b_2$ qui s'execute. 
]

#ex[
  #grid(columns: (1fr, 1fr), 
  pseudocode-list(hooks: .5em, booktabs: true)[
  + *Tant que* $a != b$ :
    + *Si* $a < b$ :
      + $b <- b-a$
    + *Sinon* :
      + $a <- a - b$
  + *Renvoyer* a
  ], 
  raw-render(
    ```dot
      digraph {
        d [label="Début"]
        e [label=""]
        b1 [label = "b <- b - a"]
        b2 [label = "a <- a - b"]
        ret [label = "Renvoyer a"]
        d -> e [label="a != b"]
        e -> b1 [label="a < b"]
        e -> b2 [label="a >= b"]
        b1 -> d
        b2 -> d
        d -> ret [label = "a"]
      }
    ```
  )
  )
]

== Utilisation du graphe
On essaye alors de créer un jeu de test qui emprunte (ou couvre) tout le graphe. 

#def[Critère de couverture][
  On a plusieurs critères de couvertures possibles, qui permettent de determiner que tous le graphe a été testé. Du plus faible au plus fort, ce sont : 
  - La couverture de sommets : tous les sommets du graphe doivent être emprunté par un test
  - La converture d'arrêtes : toutes les arrêtes doivent être emprunté par un test
  - La couverture des chemins : Tous les chemins possibles entre le début et la fin du programme doivent être empruntés. (On n'emprunte les cycles qu'un nombre limité de fois)
]

#blk2("Outil")[
  En pratique, il existe des extension d'IDE qui permettent de voir la couverture du code et quels lignes ne sont pas testé.
]

#ex[
  Dans l'exemple 21, le jeu de test ${((1, 1), 1), ((1, 3), 1)}$ couvre tous les sommets mais pas toutes les arrêtes. 
]

#blk2[Remarque][Ces critères ne garantissent pas la correction d'un algorithme.]

#blk2[Remarque][
  Parfois, certaines conditions peuvent être des conjonctions ou disjonctions de conditions. 

On peut exiger que chacune de ces conditions soit couverte par le jeu de test. Cela reviens à dupliquer les arrêtes pour n'avoir que des conditions élémentaires.]

= Outils pour l'inspection de code

#blk1("Pricipe", "Qualité du code")[
  Un code clair, avec des noms de variables explicites, et des commentaires, sera plus facile à traiter et à débugguer.
]

#blk1("Pricipe", "Programmation défensive")[
  Quand on a des invariants ou pré-conditions, on peut tester directement pendant l'exécution à l'aide de la directive `assert [condition]` (Ocaml et Python)
]

#blk1("Outil", "Compilateur")[
  Le compilateur, peut pouvoir détecter des erreurs. Ce sont des erreurs syntaxiques, on peut définir une grammaire du langage et analyser le code vient un algorithme d'analyse syntaxique.
]

#dev[Analyse syntaxique]

#blk2("Remarque")[
  La pluspart des IDE souligne en rouge les erreurs de compilations/syntaxique, les variables non utilisées...
]

#blk2("Remarque")[
  En C, compiler avec `-Wall`, ce qui active tous les avertissements. Chaque avertissement doit être étudié et corrigé si nécéssaire.
]

#blk1("Outil", "Débuggueur")[
  Les débuggueurs (comme gdb, ou directement dans les IDE) permettent l'exécution pas à pas d'un programme, et l'inspection de la mémoire.
]

#blk1("Outil", "Fuite de mémoire")[
  `valgrind` est un programme qui permet de vérifier les accès et allocations mémoire pour un programme C. Pour un executabl"e `a.out`, on l'utilise avec `valgrind a.out`. Tout ce qui est indiqué par valgrind est une erreur qui doit être corrigée.
]

#blk1("Méthode", "Inspection de code d'un pair")[
  En général sur des projets à plusieurs personne on fait relire son code par un pair pour qu'il vérifie que celui ci est correct et fait ce qui est demandé. Guthub, gitlab et autres gestionnaire de git permettent des Pull-Request qui demande l'aprobation d'un pair pour valider le code.
]

#blk1("Méthode", "Pair programming")[
  On appelle pair programming le fait de coder à plusieurs sur un même ordinateur. Celà permet d'avoir deux personnes concentrer sur un code et réduit les erreurs. C'est souvent utiliser pour former des personnes ou sur des programmes compliqués.
]

#blk1("Méthode", "TDD")[
  Test Driven developpement, est une méthode qui consiste à développer les tests avant de faire le contenu du programme. L'objectif est de passer tous les tests.
]

#blk2("TP")[
  TP pour finaliser la leçon, on donne aux élèves une spécifications clairs et on leur demande de coder des tests qui couvrirait toutes les spécifications. Ensuite ils échangent leurs tests avec un autre binôme et doivent faire un code qui valide tout les tests. Si possible faire un code qui possède des erreurs pour montrer que les tests ne couvrent pas tout les cas.
]
