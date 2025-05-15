#import "@preview/lovelace:0.3.0": *

#import "../utils.typtp": *
#import "dev_tplt.typtp": developpement

#show: developpement.with(
  titre: [Généralisation du tri par comptage à
l’aide de dictionnaires], 
  niveau: [Terminal / MP2I], 
  prerequis: [], 
) 

= Version naïve 
_Le tri par comptage est un tri qui à l'inverse des tri par comparaison, tri un tableau sans utilisé de comparaison._\
Entrées : T un tableau de taille n à valeur dans  $[|0:m|]$\
Sortie : T trié

#ex[
  _A faire en même temps c'est mieux_\
 T = [2, 1, 5, 1, 2] et m = 5 \
 T2 = [0, 2, 2, 0, 0, 1]\
 T = [1,1,2,2,5]
]

#pseudocode-list(booktabs: true, hooks: .5em)[
  *tri_comptage (T, m):*
  + T2 = tableau de taille m+1 init à 0
  + *pour* i de 0 à n-1 :
    + T2[T[i]]++
  + indice = 0
  + *pour* i de 0 à m :
    + *pour* j de 1 à T2[i] :
      + T[indice] = i
      + indice++
  + *retourner* T 
]

#blk2("Propriété")[
  Compléxité en espace $O(m)$\
  Compléxité en temps $O(n + m)$\
  On peut aussi ne pas passer m en paramètre et calculer le max(T) en $O(n)$. Dans ces deux cas on à une compléxité qui n'est pas bonne si on a des données très dispercé et si m est très grand.
]

= Version  avec dictionnaire

#underline[_Objectif :_] : améliorer l'algorithme dans les cas ou les données sont très éloignées.\

#ex[
  T=[7400,10000, 10000, 1, 7400]
  _dérouler en même temps que l'écriture de l'algo_
]

#pseudocode-list(booktabs: true, hooks: .5em)[
  *tri_comptage-2(T):*
  + d $<-$ dictionnaire vide
  + *pour* x dans T :
    + *si* x dans clés(d) : #r[ | *si* f(x) dans clés(d) :]
      + d[x]++ #r[ | ajouter x à d[f(x)]]
    + *sinon* :
      + d[x] = 1 #r[ | d[f(x)] = [x]]
  + T2 $<-$ tri(clés(d))
  + indice = 0 
  + *pour* x dans T2 :
    + *pour* i de 1 à d[k] : #r[ | *pour* y dans d[f(x)] :]
      + T[indice] = k #r[ | T[indice] = y]
      + indice++
  + *retourner* T
]

#blk2("Propriétés")[
  On note k la taille de |T2|, donc le nombre d'entiers distincts de T.\
  Compléxité en espace $O(m)$\

  Compléxité en temps, on estime que le tri de T2 se fait par un tri en comparaison en \ $C_("tri") = O(k log(k))$
  Si on implémente le dictionnaire d par :
    - un arbre RN :  $O(n log(k) + C_"tri" + n) = O((n+k) log(k) )$
    - une table de hashage (en moyenne): $O(n + C_"tri" + n) = O(n + m log(k))$
]

= Version tableau d'éléments

#ex[
  T = ['abc', 'hello', 'world', 'ac', 'ab'] et f une fonction qui compte le nombre de caractères.\
  d  = {\
    3 : ['abc'],\
    5 : ['hello','world']\
    2 : ['ac','ab']
  }
]

#r[Faire les modifications en rouge dans le code de la version II si le temps sinon expliciter ce qu'on fait]


#blk2("Propriétés")[
  On a un tri stable.

  Notre algorithme n'est pas pertinant dans toutes les situations, il l'est si on veut trier des données avec beaucoup de redondensce (par exemple les codes postaux).
]