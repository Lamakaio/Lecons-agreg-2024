#import "@preview/cetz:0.3.0"
#import "@preview/syntree:0.2.1": tree
#import "@preview/lovelace:0.3.0": *
#import "../utils.typtp": *
#import "dev_tplt.typtp": developpement

#show: developpement.with(
  titre: [Vérification du produit de matrice], 
  niveau: [MP2I], 
  prerequis: [Probabilité])

#blk2("Contexte")[
  On suppose que l’on a un algorithme produit qui calcule le produit de matrice efficacement.\
  On veut vérifier qu’il est correct sur de grandes entrées. Comment faire ?
  Notre problème est donc de vérifier, étant donné A, B et C de taille $n²$, si AB = C.\
  On se concentrera ici sur des matrices d’entiers modulo 2.
]

#blk2("Solution naïve")[
  On pourrait calculer le produit, mais si les matrices sont grandes cela serait très long $Theta(n^3)$ (ou moins si Strassen ou FFT).
]


#blk2("Solution probabiliste")[
  On peut alors utiliser un algorithme probabiliste. On choisit un vecteur $r = (r_1,r_2,...,r_n)in {0,1}^n$. Ensuite on calcule A(Br) et Cr en $Theta(n^2)$. Si A(Br) $!=$ Cr alors AB $!=$ C sinon l'algorithme retourne AB = C.
]

#blk3("Théorème")[
  Si AB $!=$ C avec r choisi au hasard dans ${0,1}^n$, alors, \
  $PP("ABr"="Cr")<=1/2$
]

#blk2("Démonstration")[
  L'évênement considéré est "ABr = Cr". \
  Choisir r aléatoirement dans ${0,1}^n$ revient à choisir aléatoirement chaque $r_i$ dans ${0,1}$.\

  Soit D = AB-C $!=$ 0, ainsi ABr = Cr $=>$ Dr = 0 (car Dr = ABr - Cr). Puisque D $!=$ 0, il a au moins un coefficient non nul : on pose $d_11 !=$ 0\

  Puisque Dr = 0, on a \
  $ &sum_(j=1)^n d_(1j) r_j = 0 \
    =>&d_(11) r_1+ sum_(j=2)^n d_(1j) r_j = 0 \
   =>&r_1 = - (sum_(j=2)^n d_(1j) r_j)/d_(11)  && "(car "d_11 !=" 0)" $ 
  
  #blk2("Théorème : Loi des probabilités totale")[
    Soit $E_1, E_2, ..., E_k$, k évênements disjoints dans $Omega$ tel que $union_(i=1)^k E_i = Omega$. Alors, 
    $ PP(B) = sum_(i=1)^k PP(B inter E_i) $
  ]
  
]

#text[
  On peut supposer que l’on choisit $(r_2,..., r_n)$ uniformément dans ${0, 1}^(n-1)$ et $r_1$ uniformément dans  ${0,1}$. Ces deux tirages sont réalisés de manière indépendante.

  $ &PP(A B r = C r) \ 
  &= sum_((x_2,...,x_n) in {0,1}^(n-1))  PP((A B r = C r) inter (r_2,...,r_n) = (x_2,...,x_n)) \ 
  &<= sum_((x_2,...,x_n) in {0,1}^(n-1)) PP(r_1 = - (sum_(j=2)^n d_(1j) r_j)/d_(11) inter (r_2,...,r_n) = (x_2,...,x_n)) \
  &= sum_((x_2,...,x_n) in {0,1}^(n-1)) PP(r_1 = - (sum_(j=2)^n d_(1j) r_j)/d_(11) | (r_2,...,r_n) = (x_2,...,x_n)) times PP((r_2,...,r_n) = (x_2,...,x_n))\
  &=  sum_((x_2,...,x_n) in {0,1}^(n-1)) 1/2 times PP((r_2,...,r_n) = (x_2,...,x_n))\ 
  &= 1/2
   $
\
]


#blk2("Algorithme de test")[
  #pseudocode-list(booktabs: true, hooks : .5em)[
    *Vérification*(A,B,C,k) :
    + *Pour* i de 1 à k :
      + choisir r uniformément
      + *Si* A(Br) $!=$ Cr :
        + *Retourner* faux
    + *Retourner* vrai 
  ]
]

#blk2("Efficacité")[
  Si AB=C, l'algorithme renvoie la bonne réponse. Sinon en choisissant r de façon aléatoire et indépendante pour chaque essai, on obtient qu'après k essais, la probabilité d'erreur est au plus de $(1/2)^k =2^(-k)$. Donc notre algorithme réussi avec une probabilité d'au moins $1-2^k$ , en $Theta(k n^2)$.
]

#blk2("En vrai")[
  En vrai Ainsi, pour k = 100, on échoue avec probabilité $2^(-100)$ soit environ une chance sur 1 quintillion (donc jamais). Ainsi, on a un algorithme en $O(100 n^2 )$ qui tant en théorie que en vrai, peut être considéré en $O(n^2)$ qui vérifie en gros sans erreur le produit de matrice.
]

#blk2("Remarques")[
  - Et si jamais c’est faux, on va probablement finir beaucoup plus vite que ça, car il y a aura souvent plusieurs coefficient faux.

  - Qu’en est il si on ne considère pas des entiers modulos 2 ? Et bien la probabilité de se tromper est encore plus faible, car on a plus de valeurs possibles.

  - Quid des flottants ?
]
#rect[Source : Mitzenmacher]
