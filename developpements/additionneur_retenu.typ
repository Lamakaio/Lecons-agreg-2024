#import "../utils.typtp": *
#import "dev_tplt.typtp": developpement

#show: developpement.with(
  titre: [Additionneur à anticipation de retenue], 
  niveau: [], 
  prerequis: [Circuits])

= Problème de l'additionneur classique

Dans un additionneur classique, on chains simplement une série d'additionneur 1-bit en propageant la retenue.

#figure(caption: "Un additionneur 4 bits")[
  #image("../img/additionneur_1.png", width: 80%)
]

En architecture, on s'interesse souvent au *chemin critique* et à la *latence* d'un circuit, c'est à dire le nombre de porte que devra traverser le signal, au maximum, avant que la sortie soit valide. 

$S_i&=a_i xor b_i xor c_i\
c_(i+1)&=a_i dot b_i + (a_i xor b_i) dot c_i
$

Le chemin critique est lors de la propagation de la retenue. Ici de $c_1$ à $c_5$ on parcourt 3 portes par additionneur 1 bit, donc 12 portes. Le calcul des $S_i$ lui traverse 2 portes et nous donne un chemin de 8 portes.

On cherche à optimiser le chemin critique, en particulier sur la propagation de la retenue.
\

= Pistes de solutions

Exemple d'addition : \ \
$&1 1 1 0 1 1 1 1 \
+ &0 1 1 0 0 0 0 1 \
&------\
1 &0 1 0 1 0 0 0 0
$

On distingue deux cas où l'on a une retenue :
- Si $a_i=1 "et" b_i = 1$, le calcul *génère* une retenue.
- Si $a_i=1 "ou (exclusif)" b_i = 1$, le calcul *propage* une retenue (si elle existe).
\
\
On pose :

$g_i = a_i dot b_i\
p_i = a_i xor b_i$

On remarque que : 

$c_(i+1) &= a_i dot b_i + (a_i xor b_i) dot c_i \
 &= g_i + p_i dot c_i$

On peut dépiler sur un exemple : 

$c_2 = g_1 + p_1 dot c_1\
c_3 = g_2 + p_2 dot c_2 = g_2 + p_2 dot g_1 + p_2 dot p_1 dot c_1\
...\
c_(i+1) = g_i + p_i dot g_(i-1) + p_i dot p_(i-1) dot g_(i-2) + ... + p_i dot ... dot p_2 dot c_1
$\
On à i+1 termes. et $p_i dot ... dot p_2 dot c_1$ possède i facteurs.

On représente ces portes : 
#image("../img/additionneur_2.png", width: 40%)
On a i-1 portes et le chemin critique est de i-1.

On peut transformer ces portes de cette façon (exemple avec i = 7) : \
#image("../img/additionneur_3.png", width: 40%)
On a 7 portes mais on a un chemin critique de 3.

#blk2("Proposition")[
  Soit $t_1, ..., t_i$ des termes, le calcul de $p= Pi t_k$ peut s'effectuer de sorte que le chemin critique soit de longueur au plus $ceil(log_2(i))$
]
\
\
\
= Calcul de la retenue sur un additionneur 4 bits 

$c_5 = g_4 + p_4 dot g_3 + p_4 dot p_3 dot g_2 + p_4 dot p_3 dot p_2 dot g_1 + p_4 dot p_3 dot p_2 dot p_1 dot c_0 $

On arrive bien à un chemin critique de 6 portes traversées (5 ici + 1 pour calculer les $p_i$ et $g_i$).

#image("../img/additionneur_4.png", width: 60%)

L'utilité de calculer la retenue de cette façon est d'ensuite utiliser le calcul de celle ci pour réduire le chemin critique d'un grand additionneur en le décomposant en blocs.

Par exemple pour un additionneur 8 bits avec 4 blocs d'additionneur à anticipation de retenue.

#figure(caption: "Additionneur 8b à saut de retenue par blocs, avec k = 2")[
  #image("../img/csb_adder_8b.svg")
]
