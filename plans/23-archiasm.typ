#import "@preview/cetz:0.3.0"
#import "@preview/syntree:0.2.1": tree
#import "@preview/lovelace:0.3.0": *
#import "@preview/codly:1.1.1": *
#import "@preview/codly-languages:0.1.1": *

#import "../utils.typtp": *
#import "lecon_tplt.typtp": lecon


#show: codly-init.with()
#show: lecon.with(
  titre: [Leçon 23 : Principe de fonctionnement des ordinateurs : architecture, notions d'assembleurs], 
  niveau: [Première, MP2I], 
  prerequis: [Représentation binaire des entiers])
 
= Circuits
== Porte logique et circuits booléens
#def[Porte logique][
  _FAIRE DESSIN PORTES_\
  Une porte logique est un circuit élémentaire qui réalise une opération logique. Les portes usuelles sont les suivantes : 
  - la porte NON
  - la porte ET
  - la porte OU
  - la porte XOR, ou "ou exclusif"
  - les entrées (une porte à 0 entrées et 1 sorties) et les sorties (une porte à une entrée et 0 sorties) du circuit
]

#def[Circuit booléen][
  Un circuit booléen, ou circuit combinatoire, est un graphe orienté acyclique de portes logiques. 
  - Les noeuds sont soit des portes logique, soit des points avec une entrée et un nombre arbitraire de sorties.
  - Les arrêtes sont appelés "fils".
]

#blk2[Exemple][
  #image("../img/circuit.svg")
]

// #def[Valeur d'un circuit][
//   Si on se donne une valeur dans ${0, 1}$ pour chaque entrée du circuit, on étiquette chaque fil par 0 ou 1, tel que 
//   - si le noeud source du fil est une porte logique, sa valeur est le résultat de l'opération logique correspondante
//   - si le noeud source du fil est un point, alors sa valeur est la valeur de l'entrée de celui-ci. 

//   On donne ensuite une valeur à chaque sortie du circuit, qui est l'étiquette de son fil entrant. 

//   On appelle table de vérité d'un circuit le tableau donnant la valeur de ces sorties en fonction de la valeur de ses entrées.
// ]


== Un exemple de circuit réèl : l'additionneur

#blk1[Définition][_half adder_][

Le _half adder_ est un additionneur 1 bit, qui prend deux entrée, et a deux sorties : le résultat est la retenue. 

#grid(columns: 2, figure(caption: [Circuit correspondant au _half adder_])[
#image("../img/ha_xor.svg")
], figure(caption: [Table de vérité correspondant au _half adder_])[#tabledeverite(("A", "B"), ("SUM", "CARRY"), ("calc.max(A*(1-B), B*(1-A))", "calc.min(A, B)"))])

]

#blk1[Définition][_full adder_][

Le _full adder_ est un additionneur 1-bit qui est capable de prendre une retenue en entrée, ce qui lui permet d'être utilisé pour l'addition n-bits.


#grid(columns: 2, figure(caption: [Circuit correspondant au _full adder_])[
#image("../img/fadd.svg", height:180pt)
], figure(caption: [Table de vérité correspondant au _full adder_])[#tabledeverite(("A", "B", "c_in"), ("SUM", "c_out"), ("calc.rem(A + B + c_in, 2)", "calc.div-euclid(A+B+c_in, 2)"))])
]

#blk2[Exercice][Construire un additionneur n-bits à partir de n _full_adder_]

#dev[Optimisation de l'addition, additionneur à saut de retenue]


== Circuits synchrones

Les circuits booléens permettent bien de faire des calculs, mais n'intègrent pas de notion de _temps_, ou de _mémoire_.

En pratique, un ordinateur est donc un circuit _synchrone_. 

#def[Horloge][
  L'horloge d'un circuit est un signal qui alterne entre 0 et 1 de manière périodique. Quand on parle de "fréquence" d'un processeur, c'est le nombre d'oscillations de l'horloge par seconde ! 
]

#def[Registre][
  Un registre est la plus petite unité mémoire d'un ordinateur. 
  
  (dessin d'un registre)

  Un registre a deux entrées et une sortie. 
  - une entrée pour les données à stocker 
  - une entrée pour l'horloge

  A chaque "tic" d'horloge, le registre stocke la valeur de son entrée, et, à tout moment, la sortie du registre vaut la valeur stockée. 
]

#ex[
  Voici un exemple du comportement d'un registre. 
  (mettre un chronogramme ! )
]

#def[Circuit synchrone][
  Un circuit synchrone est un graphe orienté de circuits booléens, et de registres, tels que tous les cycles contiennent au moins un registre. 

  Tous les registres sont relié au même signal d'horloge.
  (dessin)
]

= Modèle de Von Neumann
== Le modèle 
Le modèle de Von Neumann est un modèle des ordinateurs qu'on connait aujourd'hui.
#def[Instruction][
  Une instruction est une opération élémentaire qu'un processeur execute.
]

#def[Modèle de Von Neumann][
  Le modèle de Von Neumann est constitué de 
  - Un CPU, qui execute les instructions
  - Une mémoire (RAM), qui contiens les données et le programme

  Le processeur viens chercher les instructions en mémoire, et les executent (potentiellement en effectuant des lectures ou écriture mémoire).

  (dessin)
]

#blk2[Remarque][
  Dans le modèle de Von Neumann, les instructions sont des données comme les autres. 
]

== Quelques modifications en pratique : registres, hierarchie mémoire

#blk2[Remarque][
  Dans cette partie, on parle à nouveau de registres. Il s'agit de registres d'un point de vue assembleur, et non de registres d'un circuit. 
]

#def[Hiérarchie mémoire][
  En pratique, le processeur n'accède pas directement à la RAM, pour plusieurs raisons : 
  - La RAM est une mémoire relativement "loin" du processeur, et "lente" : un simple accès peut prendre une centaine de cycles. \
    $->$ Il existe des mémoires plus proches du processeur. Plus elle sont proches, plus elles sont petites, et plus elles sont rapides. Il s'agit des registres et des caches (L1, L2, L3...)
  - Le processeur, via les accès mémoire à des adresses reservées, peut également accèder à des périphériques : disque dur, souris, écran ... 

  (faire un schéma encore)
]

= Jeu d'instruction et assembleur
Et en pratique, comment programme-on un processeur ? 
== Différentes familles de jeu d'instructions
#def[Jeu d'instruction][
  Un jeu d'instruction est l'ensemble des instructions executables par un processeur. Il s'agit de x86-64 des PC, ARM v8 des téléphones, et bien d'autres. 
]

#def[RISC vs CISC][
  Il existe deux grandes familles de jeu d'instruction : 
  - Les jeu d'instructions complexes, qui ont un grand nombre d'instructions qui peuvent faire des opérations complexes (par exemple, la racine carré)
  - Les jeu d'instructions réduits, qui se concentrent sur des opérations élémentaires (addition, division, multiplication), qui devront être composés pour faire des opérations plus complexes

  En pratique, les jeux d'instructions modernes sont un peu un mélange des deux : ils définissent des instructions complexes, mais celles-ci sont traduites en "micro-opérations" élémentaires par le processeur. 
]
== Le language assembleur 
Le language assembleur est, en quelque sorte, le language de programmation le plus proche du processeur : les instructions sont directement traduites en suites de bits pour être executées. 

Les instructions assembleur opérent en général sur des _registres_. 

Exemple commenté de programme assembleur : 
```asm
; place l'adresse de la variable dans le registre x1
la x1, $variable
; le label .start n'est pas une instruction, mais permet de marquer une position
.start: 
; charge le contenu de la mémoire à l'adresse stockée dans x1, dans x2
load x2, [x1]
; effectue l'opération x2 <- x2 + 2
addi x2, x2, 2
; stocke le résultat dans la variable
store x2, [x1]
; saute à la position .start : on boucle
j .start
```

== Notion de programmation assembleur : ABI, gestion mémoire 

#def[ABI][
Dans un ordinateur, différents codes assembleur d'auteur et de sources différentes sont amenés à cohabiter. L'ABI est un ensemble de conventions définies par le système d'exploitation pour 
- Coordonner l'utilisation des registres : lequels peuvent être ou non écrasés
- Coordonner les appels de fonction : où mettre les arguments, les valeurs de retours ? 

Ces conventions sont définies en partie par le jeu d'instruction, et en partie par le système d'exploitation. 
]

#dev[Gestion de la pile d'appel]
