#import "@preview/cetz:0.3.0"
#import "@preview/syntree:0.2.1": tree
#import "@preview/lovelace:0.3.0": *
#import "@preview/codly:1.1.1": *
#import "@preview/codly-languages:0.1.1": *

#import "../utils.typtp": *
#import "lecon_tplt.typtp": lecon


#show: codly-init.with()
#show: lecon.with(
  titre: [Leçon 19 : Mémoire : du bit à l'abstraction vue par les processus], 
  niveau: [1ere / MP2I / L3], 
  prerequis: [Circuit combinatoires])

= Introduction 
On modélise un ordinateur par la machine de Von Neumann.
Dans cette leçon on se concentre sur la partie Mémoire.

FAIRE DESSIN

= Du bit à la RAM (L3 ?)

== Circuits séquentiels
À l'aide de portes logique nous avons pu voir comment construre des circuits combinatoires. 
Les circuits séquentiels forment une généralisations des circuits combinatoires permettant la mémorisation d'informations.

#def("Circuit séquentiel")[
  Un circuit séquentiel est un circuit logique dont les valeurs des variables en sortie dépendent des variables d'entrées et de variables internes mémorisées.
]

#ex[
  FAIRE SCHEMA
]

// == Horloge

#def("Horloge")[
  Une horloge est un signal libre ayant une période (et donc une fréquence) fixée. Une période d'horloge est appelée cycle d'horloge
  FAIRE SCHEMA
  L'état d'un élément est mis à jour sur un front montant.
]

// #def("Synchrone")[
//   Lorsqu'un système contient une seule horloge on dit qu'il est synchrone. Sinon il est asynchrone.
// ]

// #def("État stable")[
//   Un circuit séquentiel est dans un état stable lorsque tous ses éléments à états sont stables, c'est à dire qu'il n'y a aucune autre information que celle du front montant qui pourrait la mettre à jour.
// ]
// #blk2("Remarque")[
//   Il est fortement souhaitable que notre circuit soit dans un état stable avant d'enclencher un nouveau front montant d'horloge.
// ]

== Éléments de mémoire : verrous, registres et RAM 

#def("Verrou RS")[
  On peut stocker un bit avec la bascule RS avec deux portes NON-OU.
  #grid(columns: (1fr, 1fr),
    image("../img/bascule_rs.png", width: 55%),
    image("../img/bascule_rs_2.png", width: 50%)
  )
]

#def("Verrou avec multiplexeur")[
  On peut stocker un bit avec 2 MUX. On a ici un registre.
  #image("../img/flip-flop.png")
]

#blk2("Remarque")[
  On peut ajouter aussi une entrée sur notre registre, souvent nous pouvons trouver les entrées _set_ qui met la valeur à 1 et/ou _reset_ qui met la valeur à 0 et/ou _write-enabled_ qui indique si la mémorisation est voulu.
]

#blk3("Propriété")[
  On construit facilement des registres n-bit. Ce sont n registres en parrallèle tous muni de la même horloge.
]

#def("Mémoire adressable (RAM)")[
  La RAM est la mémoire vive, qui perd ses données lorsque l'ordinateur s'éteint à l'inverse la mémoire de stockage ne perd aps son contenu.\
  Une mémoire adressable est composée de plusieurs registres juxtaposés. Chaque registre possède une adresse, grâce à laquelle on peut séléctionner quel registres on souhaite accèder ou écrire.
  #image("../img/RAM.png", width: 40%)
]

= Encodage des données (1ere/MP2I)

== Les entiers

#def[Base][
  Une représentation en base $b >= 2$ d'un entier $N in NN$ est une suite a_i telle que $N = Sigma_(i=0)^(k-1) a_i b^i$ avec $0<=a_i<b$. En base 2 on appelle $a_0$ le bit de poids faible et $a_(k-1)$ le bit de poids fort.
]

#ex[
  FAIRE EXEMPLE DE BASE 10 à BASE 2 ou 16
]

#def("Complément à 2")[
  
]

== Les réels
#def("IEEE 754")[
  $(-1)^s m times 2^(n-d)$\
  [signe][exposant][mantisse]\
  [1 bit ][ 8 bits ] [23 bits]
]

== Le texte 
#def("Codage ASCII")[
  On encode les caractères de par la table ASCII sur 8 bits
]

#def("Codage UNICODE")[
  UTF-8 sur 4 octets
]

= Hiérarchie mémoire (MP2I)

#blk1("Propriété", "Hierarchie mémoire")[
  La mémoire est organisé hierarchiquement. En effet on a plusieurs niveaux de mémoire, les plus proche du processeur sont les plus rapides mais aussi les plus petites en taille. Les mémoires les plus rapides sont souvent celle qui coûte le plus cher à construire, c'est pour celà en partie qu'elles sont bien plus petites.
  #image("../img/hierarchie-memoire.png", width: 80%)
]

#blk1("Propriété", "Cache")[
  En général, dans les ordinateurs récents, on a du cache, et souvent plusieurs niveaux de cache. Ces caches permettent d'accèder plus rapidement à certaine données qui sont souvent utilisées. Il existe plusieurs principes pour savoir que stocker temporairement dans les caches : 
  - localité temporelle : une donnée utilisé a tendance à être utilisé peu de temps après 
  - localité spatiale : une donnée voisine d'une donnée utilisé à tendance à être utilisé peu de temps après.
]

= Processus et mémoire virtuelle

== Mémoire virtuelle

#blk1("Principe", "Mémoire virtuelle")[
  
  #grid(columns: (1fr, 1fr),
    image("../img/memoire_virt.png", width: 60%),
    "
    Chaque processus possède une mémoire virtuelle alloué à sa création. Le but de celle-ci est de faire croire au processus qu'il a accès à toute la mémoire, et que cette mémoire est donc contigue. Cela permet donc une protection de la mémoire (chaque processus n'a pas accès à la mémoire qui n'est pas la sienne), l'utilisation de la mémoire virtuelle permet aussi d'utiliser la mémoire du disque comme extension de la mémoire vive.
    
    Chaque bloque mémoire de la mémoire virtuelle est un lien vers un endroit de la mémoire physique (RAM ou disque)"
   )
]

#blk1("Principe", "Organisation de la mémoire d'un programme")[
  #image("../img/memoire_prog.png", width: 40%)

]

#dev[Gestion d'appels de fonction grâce à la pile d'éxecution]

#blk1("Principe", "Table des pages")[
  En pratique, les bloques mémoire de la mémoire virtuelle sont découper tous en bloque de la même taille appelées pages (environ 4Ko). Ce mécanisme sert à réduire la fragmentation externe, mais créer de la fragmentation interne (qui pose moins de problème). \
  La traduction entre les adresses virtuelles et physique ce fait par une table de traduction appelé la table des pages.
  #image("../img/table_pages.png", width: 70%)
]

#dev[L'utilisation de fork et de Copy-on-Write pour gérer la mémoire de plusieurs fils d'éxecutions]