#import "@preview/cetz:0.3.0"
#import "@preview/syntree:0.2.0": tree
#import "@preview/lovelace:0.3.0": *
#import "@preview/codly:1.1.1": *
#import "@preview/codly-languages:0.1.1": *

#import "../utils.typtp": *
#import "lecon_tplt.typtp": lecon

#show: codly-init.with()
#show: lecon.with(
  titre: [Leçon 1 : Exemple de méthodes et outils pour la correction des programmes], 
  niveau: [NSI/MP2I], 
  prerequis: [Récursivité])
\

= Introduction
\
La conjecture de Syracuse est un problème ouvert de mathématiques. \

$"La suite u définie par :" display(cases(
  U#sub[0] = a in NN,
  U#sub[n] = display(cases(
    display(U_n)/2 "si" U_n "pair",
    3.U_n+1 "sinon"
  )
)))$
\
finit-elle toujours par le cycle 1,2,4 ? (toujours = pour tout a $in NN$)
\


#blk1("Algorithme", "Syracuse")[
  Cela revient à savoir si l'algorithme Syracuse renvoie toujours 1, 2 ou 4.
  #pseudocode-list(hooks: .5em, booktabs: true)[
  *Syracuse (a) :*
  + u = a
  + *Tant que* u est une nouvelle valeur:
    + *si* u est pair :
      + u = u/2
    + *sinon* :
      + u = 3u+1
  + renvoyer u
  ]
]
= Terminaison
\
Une première question est de savoir si Syracuse finit (ne boucle pas à l'infini) sur toute entrée.

#blk3("Définition")[
  Prouver la terminaison d'un algorithme revient à prouver que pour toute entrée il termine.
]

#blk3("Définition")[
  On se limite parfois aux entrés valides (pour Syracuse, a $in NN^*$ par exemple).
]

#blk2("Exemple")[
  #grid(columns: (1fr,3fr),
  grid.cell(
    pseudocode-list(hooks: .5em, booktabs: true)[
    + *Tant que* a > 0:
      + a = a-1
  ]),
  grid.cell[
  Termine sur toute entrée si on n'autorise pas a à valoir +$infinity$])
]

Pour prouver la terminaison on va utiliser la technique du variant.

#blk1("Définition", "Variant")[
  Un variant est une fonction des variables, à valeur dans $NN$ qui décroit strictement :
  - à chaque passage dans la boucle pour les algorithmes itératifs
  - à chaque appel récursif pour les algorithmes récursifs
]

#blk2("Exemple")[
  #grid(columns: (1fr,2fr), 
  grid.cell(
    pseudocode-list(hooks: .5em, booktabs: true)[
      *pgcd(a,b) :*
      + *Tant que* min(a,b)>0:
        + *si* a < b:
          + b=b-a
        + *sinon* :
          + a=a-b
      + *renvoyer* max(a,b)
    ]
  ),
    grid.cell[
    La fonction pgcd(a,b) qui calcule le pgcd de a et b pour a,b$in NN$ admet comme variant a+b, qui décroit à chaque tour de boucle.
    ])
]

#blk3("Propriété")[
  Si une boucle à un variant, alors elle s'exécute un nombre fini de fois. De même pour un algorithme récursif.
]

#blk2("Remarque")[
  La technique du variant fonctionne toujours, mais le variant peut être difficile à trouver.
]


#blk2("Exemple")[
  On définit ack(n,m) pour n,m$in NN$ par 
  #pseudocode-list(hooks: .5em, booktabs: true)[
    *ack (n,m)* :
    + *si* n=0 :
      + *renvoyer* m+1
    + *sinon si* m = 0 :
      + *renvoyer* ack (n-1, 1)
    + *sinon* :
      + *renvoyer* ack (n-1, ack (n,m-1))
  ]
]

#blk1("Définition", "Ordre bien fondé")[
  Soit E un ensemble, $<=$ est un ordre bien fondé, si toute partie non vide de E possède un plus petit élément.
]

#blk3("Définition")[
  On étend alors la définition de variant aux fonctions à valeur dans un ordre bien fondé.
]

#blk3("Propriété")[
  L'ordre lexicographique d'ordres biens fondés est un ordre bien fondé.
]

#blk3("Propriété")[
  La propriété 7 reste vrai avec notre définition étendu.
]

#blk2("Exemple")[
  Pour la fonction ack, (n,m) est un variant dans $NN²$ avec l'ordre lexicographique, donc ack termine. 
]

= Correction partielle
\
Une autre question pour Syracuse est de savoir si on peut tomber sur un autre cycle que 1,2,4 et donc que notre fonction renvoie autre chose que 1,2 ou 4.

#blk1("Définition", "Spécification")[
  On appelle spécification d'un algorithme deux propriétés :
  - sur les entrées appelé pré-condition 
  - sur les sorties appelé post-condition
]

#blk2("Exemple")[
  Pour Syracuse : 
  - P1: "a $in NN^*$"
  - P2: "syracuse (a) $in$ {1,2,4}"
]

#blk1("Définition", "Partiellement correct")[
  On dit qu'un algorithme est partiellement correct pour toute entrée vérifiant la pré-condition, s'il termine alors la sortie vérifie la post-condition.
]

#blk2("Exemple")[
  L'algorithme pgcd de l'exemple 6 est partiellement correct si la pré-condition est "a $in NN$, b $in NN$" et la post-condition est "pgcd(a,b) renvoie le PGCD de a et b".
]

== Correction partielle des algorithmes impératifs

Pour prouver la correction partielle des algorithmes impératifs on utilise un invariant de boucle.

#blk1("Définition", "Invariant")[
  Un invariant de boucle est une propriété qui est vrai avant la boucle, et si elle est vrai au début d'un tour de boucle alors elle l'est à la fin.
]

#blk3("Propriété")[
  Si un invariant de boucle est valide, alors il est vrai après la boucle et la condition d'arrêt de la boucle est fausse.
]

#blk2("Exemple")[
  Pour pgcd, un invariant de boucle valide est : "pgcd$(a,b)="pgcd"(a_0, b_0)$" où $a_0 "et" b_0$ sont les valeurs initiales de a et b.
  À la fin de l'exécution, on a donc min(a,b)=0 et \ 
  pgcd(a,b) = pgcd($a_0, b_0$) = pgcd(min(a,b), max(a,b)) = pgcd(0, max(a,b)) = max(a,b).
]

== Correction partielle des algorithmes récursifs

#blk3("Théorème")[
  Soit $(E,<=)$ un ensemble muni d'un ordre bien fondé et P une propriété sur E.
  Alors \
  $(forall x in E, (forall y in E, y<=E, P(y))=> P(x))=> forall x P(x)$
]

#blk2("Remarque")[
  Cela étend le principe de récurrence forte sur $NN$. 
  On utilise cela pour la correction partielle des algorithmes récursifs.
]

#blk2("Exemple")[
  #grid(columns: (1fr,2fr),
  grid.cell(
    pseudocode-list(hooks: .5em, booktabs: true)[
      *exp (a,n)*:
        + *si* n = 0 :
          + *renvoyer* 1
        + *sinon* :
          + x = exp (a,n/2)
          + *si* n est pair :
            + *renvoyer* x $ast$ x
          + *sinon* :
            + *renvoyer* a $ast$ x $ast$ x
    ]
  ),
  grid.cell()[
    La fonction exp($a,n$) pour $a,n in NN$ renvoie $a^n$.
    \ La propriété P(n): "exp$(a,n)=a^n$" vérifie les hypothèses, donc $forall n$, exp$(a,n)=a^n$ et ce pour tout a $in NN$.
  ])
]

= Correction

#blk1("Définition","Correction totale")[
  Quand un programme termine sur toute entrée valide et est partiellement correcte, on dit qu'il est correcte, ou encore totalement correcte.
]

#blk2("Exemple")[
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

\
#dev[Correction totale de tri_fusion]

Néamoins ce n'est pas toujours facile. La conjecture de Syracuse est toujours un problème ouvert.

#blk3("Théorème")[
  La correction partielle et la terminaison sont indécidables.
]

\
#dev[Preuve du théorème 27]

= outils
\
- Typer : l'utilisation du typage fort comme en Ocaml permet d'éviter de nombreuses erreurs
- Tester : faire des tests tout au long de la programmation
- Commenter : on déclare la spécification des fonctions et permet de rendre le code plus compréhensible et donc plus facile à débugguer

