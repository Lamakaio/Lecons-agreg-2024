#import "../utils.typtp": *
#import "dev_tplt.typtp": developpement

#import "@preview/codly:1.1.1": *
#import "@preview/codly-languages:0.1.1": *

#show: developpement.with(
  titre: [Indécidabilité de la terminaison et de la correction partielle], 
  niveau: [MP2I], 
  prerequis: [Ocaml])

\

= Indécidabilité de la terminaison
\

#blk3("Théorème")[
  Il n'existe pas d'algorithme décidant pour tout algorithme si celui-ci termine en temps fini sur une entrée $e$.
]

== Problème de l'arrêt en Ocaml
Le problème de l'arrêt consiste à écrire une fonction
```ml
halts: string -> string -> bool
```
entrées : 
  - f: une chaine contenant le code source d'un programme
  - e: une chaine représentant des entrées pour le programme donnée par f
sortie :\
Pour toutes entrées, termine en temps fini en renvoyant true si l'éxecution du programme f sue les entrées e termine en temps dini, false sinon.

== Démonstration
On cherche à montrer que ce problème de l'arrêt n'a pas de solution. \
On démontre ce résultat par l'absurde, en supposant l'existance d'une fonction ```ml halts``` et en s'en servant pour construire un programme dont le comportement est contradictoire.
On écrit alors le programme suivant dans un fichier "paradox.ml" :
```ml 
let s = In_channel.input_all(open_in "paradox.ml")
let _ = if halts s Sys.arg.(1) then while true do () done
```
+ Lit sont propre code
+ On execute halts sur son code
- si l'execution de _./paradox e_ termine en temps fini, alors le programme déclenche une boucle infinie. On a donc une contradiction de la terminaison.
- sinon si l'execution de _./paradox e_ ne termine pas, alors halts renvoie false donc le programme s'arrête immédiatement. On a donc encore une contradiction de la terminaison.
Donc l'execution _./paradox e_  ne peut ni s'arrêter en temps fini, ni ne pas s'arrêter. Dinc le programme paradox ne peut pas exister car la fonction ```ml halts``` ne peux pas exister.

= Indécidabilité de la correction partielle.
\
#blk3("Théorème")[
  Il n'existe pas d'algorithme décidant pour tout algorithme si celui-ci, lorsqu'il termine, renvoie un résultat validant la post-condition (avec une pré-condition valide).
]

== Indécidabilité de la trivialité d'un programme
#blk3("Problème")[
  On cherche à déterminer si une fonction Ocaml ```ml string -> bool ``` donnée par son code source est triviale (renvoie toujours vrai).
]

Démonstration :
Montrons que ce problème est indécidable par réduction du problème de l'arrêt.
Supposons qu'il existe une fonction Ocaml :\
```ml trivial : string -> bool``` \
entrée :
- s: code source d'une fonction Ocaml de type ```ml string -> bool```
sortie :
- termine à coup sûr en renvoyant true ssi la fonction définie par le code s renvoie true sur toute entrée.
On a donc :\
```ml
let halts (s: string) (e:string) : bool =
  trivial "fun _ -> try let _ = eval s e in true
            with _ -> true"```
Un appel ```ml halts s e``` applique la fonction trivial à une fonction qui
- soit renvoie true sur toutes entrées, si eval s e termine
- soit ne temine sur aucune entrée, si eval s e ne termine pas
Donc 
- si ```ml eval s e``` termine alors ```ml halts``` renverra true en un temps fini
- si ```ml eval s e``` ne termine pas alors ```ml halts``` renverra false en un temps fini
Donc comme cette fonction résoud le problème de l'arrêt qui est indécidable, on a une contradiction.\
Donc la trivialité d'un programme est indécidable.

Conclusion : \
La terminaison et la correction partielle d'un algorithme sont indécidables.