#import "../utils.typtp": *
#import "dev_tplt.typtp": developpement

#show: developpement.with(
  titre: [Equivalence entre circuits combinatoires et formules propositionelles], 
  niveau: [MP2I], 
  prerequis: [Circuits, formules])

= Rappels sur les circuits combinatoires
Un circuit est un graphe orienté de portes logiques (et, ou, non) et de noeuds.

Un Circuit combinatoire est un circuit qui n'a pas de cycles. 

#figure(caption: [Exemple de circuit combinatoire])[
#image("../img/circuit.svg")
]<fig1>

= Equivalence avec les formules propositionelles
C'est quoi l'équivalence ? 

On veut montrer, que pour C un circuit, d'entrées $i_1, ..., i_n$, et de sorties $s_1, ..., s_p$, alors il existe des formules $phi_1, ..., phi_p$ sur les variables $V = {x_1, ..., x_n}$, tels que : 

$forall sigma: V -> {0, 1}, forall i in [|1, n|], [phi_i]_sigma = s_i$ dans le circuit C ou les entrées sont $i_1 <- sigma(x_1), ..., i_n <- sigma(x_n)$

Et vice-versa : si on a un ensemble de formule, on peut construire le circuit associé. 

== $->$ 

Un circuit combinatoire est un graphe orienté acyclique. C'est donc une structure inductive : l'ordre $prec$ "est un prédécésseur de" est bien fondé sur les éléments d'un circuit. 

On va donc pouvoir construire nos formules inductivement sur le circuit, en partant de chaque sortie.

Ainsi, pour construire la formule $phi$ correspondant à un fil : \
- [cas de base] 
  - le fil est la $k$ème entrée du circuit. Alors, $phi = x_k in V$ 
- [cas inductif]
  - On regarde la porte qui précède ce fil. 
  - Pour le(s) entrée(s) de cette porte, on prend les formule $psi_1, psi_2$ qui correspondent à ces fils. Les entrées de la porte sont bien "plus petites" (au sens de $prec$) que notre fil courant, ce qui nous permet d'utiliser l'hypothèse d'induction. 
  - On construit $phi$ en combinant $psi_1$ et $psi_2$, ainsi, par exemple la porte était une porte "et", $phi = psi_1 and psi_2$

#blk2[Remarque][
  Les circuits peuvent être "factorisés", c'est à dire qu'un fil peut être divisé en plusieurs fils, pour entrer dans plusieurs portes. Les formules contruites sont entièrement disjointe, et donc on répète la partie factorisée pour chaque $phi_k$
]

#blk2[Exemple][
  Si on applique notre transformation sur l'exemple de la @fig1, on a : 
  $cases(gap: #0.5em,
    phi_1 = (x_1 and x_2) or x_3,
    phi_2 = i_3)$

  
]

== $<-$
L'autre sens est plus simple : on va de même faire une induction, cette fois sur chaque formule de notre ensemble $E$ de formules, pour construire $p$ circuits disjoints. \

Puis on va connecter les entrées qui ont le même nom entre elles. 

#blk2[Exemple][
  Par exemple, sur les formules $cases(gap: #0.5em,
    phi_1 = (x_1 and x_2) or x_3,
    phi_2 = x_1 and x_2)$
  
  Cela donne le circuit de la @fig2
]

#figure(caption: [])[
  #image("../img/circuit2.svg")
]<fig2>

= Illustration : un additionneur en formules propositionelles
Le composant basique d'un additionneur est le "Half-Adder", qui fait une addition de deux bits, avec un résultat sur 1 bit et une retenue. Sa table de vérité est présentée en @table.

#figure(caption: [Table de vérité d'un Half-Adder])[
#tabledeverite(("x", "y"), ("o", "c"), ("x + y - 2*x*y", "x * y"))
]<table>

Le circuit correspondant est représenté en @fig3

#figure(caption: [Un Half-Adder en porte logiques])[
  #image("../img/halfadder.svg")
]<fig3>

On peut alors écrire les formules logiques correspondantes : 

$cases(gap: #0.5em,
  phi_("out") = (x or y) and not (x and y),
  phi_c = x and y
)$

