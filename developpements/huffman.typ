#import "../utils.typtp": *
#import "dev_tplt.typtp": developpement
#import "@preview/syntree:0.2.1": tree

#show: developpement.with(
  titre: [Optimalité de Huffman], 
  niveau: [MP2I], 
  prerequis: [Arbre])


#rect[source: Tortue + Isaline]

= Expliquer l'algo ou dérouler sur un exemple

= Théorème

Soit $N$ la taille du texte à compresser et $n_i$ le nombre d’occurrences du caractères $c_i$.\
 On note $f_i = n_i /N$ la fréquence du caractère $c_i$ .

#blk1("Théorème", "Optimalité Huffman")[
  Soit T un arbre de traduction construit par l’algorithme de Huffman pour un texte de taille $N in NN$ sur l'alphabet {$c_1, c_2, ..., c_n$}.\
  T minimise la quantité $S_T = sum_i^n f_i times d_i$ \
  Où $d_i$ est la profondeur du caractère $c_i$ dans l'arbre, c'est à dire la longueur du code du caractère $c_i$ dans le texte compressé.\
]

= Preuve 
On montre l'optimalité par réccurrence sur n le nombre de caractères différents. \
On cherche à montrer la propriété : \
P(n):"Pour tout texte avec n caractères différents, Huffman construit T qui minimise $S_T$"

#underline[
  Initialisation : 
] \
Pour n = 2, Huffman construit l'un des deux arbres de traduction suivant :
#image("../img/huffman_1.png", width:60%)

Ces deux arbres sont optimaux. Un caractère est encodé par un bit.

#underline[
  Hérédité : 
] \
Soit n > 3, tel que P(n-1) est vraie. \
Soit T l'arbre construit par Huffman. Par l'absurde, il existe un arbre de traduction $S_"Topt"$ tel que $S_"Topt" < S_T$

Soit $c_i$ et $c_j$ les deux premiers caractères choisis par l'algorithme d'Huffman. Donc les caractères de plus petites fréquences. Donc les feuille $c_i$ et $c_j$ sont de profondeur maximale dans T.\
#image("../img/huffman_2.png", width: 20%)

On peut supposer que $c_i$ et $c_j$ sont à la profondeur maximum dans Topt. \
En effet si on a un $c_k$ tel que $d_k > d_i$ alors si on échange $c_i$ et $c_k$ $S_"Topt"$ n'augmente pas car $f_i <= f_k$.\
#image("../img/huffman_3.png", width: 20%)

On peut aussi supposer que $c_i$ et $c_j$ sont enfant d'un même noeud dans Topt. \
En effet si $c_i$ n'a pas de frère, on pose p son premier ancetre qui a un frère. Alors sans augmenter $S_"Topt"$, on peut remplacer p par la feuille $c_i$.\
Donc $c_i$ a un frère. Si son frère n'est pas $c_j$, on peut inverser son frère par $c_j$ sans augmenter $S_"Topt"$. (car $c_i$ et $c_j$ sont à la profondeur maximum).

Donc on a : 

#image("../img/huffman_4.png", width: 60%)

Si on remplace le parent de $c_i$ et $c_j$ par une feuille de fréquence $f_i + f_j$ dans les arbre T et Topt pour avoir T' et Topt'. (comme si on remplacait les caractère $c_i$ et $c_j$ par un nouveau caractère.\
Alors $S_T' = S_T - (f_i times d_i) - (f_j times d_i) + (f_i+f_j) times (d_i -1) =   S_T - (f_i+f_j)$ \
et $S_(T"opt")' = S_(T"opt") - (f_i+f_j)$.\
Donc $S_(T"opt") < S_T'$.

T' est bien un arbre donné par l'algorithme d'Huffman pour un texte contenant (n-1) caractères différents.
Topt' contredit P(n-1). Par hypothèse de réccurrence on a donc une contradiction. 
Par l'absurde P(n) vraie pour $n >= 3$.

Donc par réccurrence P(n) est vraie, donc l'abre construit par l'algorithme d'Huffman est optimal.