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
  niveau: [L3], 
  prerequis: [Circuit combinatoires])

= Circuit séquentiels

À l'aide de portes logique nous avons pu voir comment construre des circuits combinatoires. 
Les circuits séquentiels forment une généralisations des circuits combinatoires permettant la mémorisation d'informations.

#def("Circuit séquentiel")[
  Un circuit séquentiel est un circuit logique dont les valeurs des variables en sortie dépendent des variables d'entrées et de variables internes mémorisées.
]

#ex[
  FAIRE SCHEMA
]

== Horloge

#def("Horloge")[
  Une horloge est un signal libre ayant une période (et donc une fréquence) fixée. Une période d'horloge est appelée cycle d'horloge
  FAIRE SCHEMA
  L'état d'un élément est mis à jour sur un front montant.
]

#def("Synchrone")[
  Lorsqu'un système contient une seule horloge on dit qu'il est synchrone. Sinon il est asynchrone.
]

#def("État stable")[
  Un circuit séquentiel est dans un état stable lorsque tous ses éléments à états sont stables, c'est à dire qu'il n'y a aucune autre information que celle du front montant qui pourrait la mettre à jour.
]
#blk2("Remarque")[
  Il est fortement souhaitable que notre circuit soit dans un état stable avant d'enclencher un nouveau front montant d'horloge.
]

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
  Une mémoire adressable est composée de plusieurs registres juxtaposés. Chaque registre possède une adresse, grâce à laquelle on peut séléctionner quel registres on souhaite accèder ou écrire.
  #image("../img/RAM.png", width: 40%)
]

= Hiérarchie mémoire

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



