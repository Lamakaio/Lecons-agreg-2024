#import "../utils.typtp": *
#import "dev_tplt.typtp": developpement

#show: developpement.with(
  titre: [Additionneur à saut de retenue], 
  niveau: [???], 
  prerequis: [Circuits])

= Rappels sur l'additionneur classique

Dans un additionneur classique, on chains simplement une série d'additionneur 1-bit en propageant la retenue.

#figure(caption: "Un additionneur 8 bits")[
  #image("../img/adder_8b.svg")
]

En architecture, on s'interesse souvent au *chemin critique* et à la *latence* d'un circuit, c'est à dire le nombre de porte que devra traverser le signal, au maximum, avant que la sortie soit valide. 

Dans l'additionneur "classique" à propagation de retenue, ce chemin critique se situe dans la gestion de la retenue : le signal doit passer par chaque additionneur, soit un nombre de portes proportionnel au nombre de bits. 

L'idée de l'additionneur à saut de retenue, c'est d'accélérer le calcul de la retenue, afin de réduire la latence (quitte à augmenter le nombre de portes).

= L'additionneur à retenue anticipée
== Principe de base

Le problème du calcul de la retenue dans l'additionneur classique, c'est que la retenue précédente est nécéssaire pour la calculer : $C_(i+1) = (A and B) or ((A or B) and C_i)$

Mais dans cette formule, on remarque que si A et B ont la même valeur, la retenue $C_(i+1)$ ne dépend pas de $C_i$ ! 

Pour chaque additionneur 1b, on va donc vérifier, _avant d'avoir reçu le signal de la retenue_, si on peut déjà connaitre la valeur de la retenue suivante, et si oui, la propager. 

#figure(caption: "Additionneur simple à saut de retenue, 4 bits")[
  #image("../img/cs_adder_4b.svg")
]

Cet optimisation permet d'accélerer la propagation du signal dans certains cas, mais le pire des cas reste identique. Or, dans le cas de la latence, c'est souvent le pire cas qui nous intéresse ! 

On va donc rafiner cette idée pour améliorer le pire cas. 

== Additionneur à saut de retenue par bloc

L'idée, c'est de précalculer la retenue non pas pour un additionneur, mais pour un bloc de _k_ additionneurs successifs. On a alors _p_ blocs au total, avec $n = p k $ le nombre de bits de l'additionneur. 

#figure(caption: "Additionneur 8b à saut de retenue par blocs, avec k = 2")[
  #image("../img/csb_adder_8b.svg")
]

L'idée, est de pré-calculer pour chaque bloc deux valeurs, en fonction de A et B : 
- $C$ qui indique si une retenue sera envoyée au bloc suivant quelque soit la retenue d'entrée
- $C_"cond"$ qui indique que si le bloc reçoit une retenue en entrée, il en enverra une au bloc suivant.

#figure(caption: "Logique additionelle de propagation de retenue ajoutée pour chaque bit de l'entrée")[
  #image("../img/skip_logic.svg")
]

Alors, chaque bloc peut calculer les valeurs $C$ et $C_"cond"$ indépendamment (et donc en parallèle). 

Puis, la propagation de retenue entre les blocs utilise simplement la formule : $C_"bloc out" = C or (C_"bloc in" and C_"cond")$, soit deux portes quelle que soit la taille du bloc. 

Soient : 
- $T_"bloc carry"$ le nombre de portes maximal pour produire $C_"bloc out"$ au sein d'un bloc
- $T_"propag"$ le nombre de portes maximal pour propager la retenue à tous les blocs, une fois les $C_"bloc out"$ calculés. 
- $T_"add"$ le nombre de portes maximal pour effectuer l'addition une fois les retenues calculées. 

La latence du circuit en nombre de portes est : $T = T_"bloc carry" + T_"propag" + T_"add"$

Or, on a 
- $T_"bloc_carry" = 2 k + 1$, car on a deux portes entre $C_"in"$ et $C_"out"$.
- $T_"propag" = 2 p$
- $T_"add" = 1$

Au total, $T = 2p + 2k + 2$

Cette formule est minimale pour $p = k = sqrt(n)$. 
On a alors $T = 4sqrt(n) + 2$. 

Contre $2n + 1$ pour l'additionneur classique. 

De plus, on a ajouté un nombre fixe de portes pour chaque bit, donc notre additonneur utilise toujours un nombre de portes en $O(n)$. 


= Conclusion
L'additionneur à saut de retenue par blocs est une manière assez simple d'accélérer l'addition, sans ajouter trop de logique au circuit. En pratique, on a un autre additionneur encore plus performant : l'additionneur à anticipation de retenue (carry-lookahead adder), a un chemin critique en $O(log(n))$, mais un nombre de portes en $O(n^2)$.

Il est apparemment possible de réaliser un additionneur avec $O(n)$ portes et une latence en $O(log(n))$, mais le sujet commence à être un peu trop poussé. 