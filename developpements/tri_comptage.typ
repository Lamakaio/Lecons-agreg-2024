#import "@preview/lovelace:0.3.0": *

#import "../utils.typtp": *
#import "dev_tplt.typtp": developpement

#show: developpement.with(
  titre: [Généralisation du tri par comptage à
l’aide de dictionnaires], 
  niveau: [Terminal / MP2I], 
  prerequis: [], 
) 

= Version bornée 
Le tri par comptage est un tri qui à l'inverse des tri par comparaison, tri un tableau sans utilisé de comparaison.\
Soit T un tableau à trier de taille n, on sait que les valeurs du tableau T sont compris dans $[|0:m|]$.


#pseudocode-list(booktabs: true, hooks: .5em)[
  *tri_comptage (T, m):*
  + T2 = tableau de taille m+1 init à 0
  + *pour* i de 0 à n-1 :
    + T2[i]++
  + indice = 0
  + *pour* i de 0 à m :
    + *pour* j de 1 à T2[i] :
      + T[indice] = i
      + indice++
  + *retourner* T 
]

#ex[
 T = [2, 1, 5, 1, 2] et m = 5 \
 T2 = [0, 2, 2, 0, 0, 1]\
 T = [1,1,2,2,5]
]

#blk2("Propriété")[
  Compléxité en espace $O(m)$\
  Compléxité en temps $O(n + m)$\
  On peut aussi ne pas passer m en paramètre et calculer le max(T) en $O(n)$. Dans ces deux cas on à une compléxité qui n'est pas bonne si on a des données très dispercé et si m est très grand.
]

= Version sans borne 

#underline[_Entrées :_]\
T : un tableau d'entiers #r[| d'éléments E]\ 
#r[$f:E -> NN$ : une fonction]\
#underline[_Sortie :_]\
T trié #r[en fonction de f]

#pseudocode-list(booktabs: true, hooks: .5em)[
  *tri_comptage-2(T):*
  + d $<-$ dictionnaire vide
  + *pour* x dans T :
    + *si* x clé dans d : #r[ | *si* f(x) dans d :]
      + d[x]++ #r[ | ajouter x à d[f(x)]]
    + *sinon* :
      + d[x] = 1 #r[ | d[f(x)] = [x]]
  + T2 = []
  + *pour* k dans clés(d) :
    + insérer k dans T2
  + trier T2 
  + indice = 0 
  + *pour* k dans T2 :
    + *pour* j de 1 à d[k] : #r[ | *pour* x dans d[f(x)] :]
      + T[indice] = k #r[ | T[indice] = x]
      + indice++
  + *retourner* T
]

#blk2("Propriétés")[
  On note m la taille de |T2|, donc le nombre d'entiers distincts dans T.\
  Compléxité en espace $O(m)$\

  Compléxité en temps, on estime que le tri de T2 se fait par un tri en comparaison en \ $C_("tri") = O(m log(m))$
  Si on implémente le dictionnaire d par :
    - un arbre RN :  $O(n log(m) + C_"tri" + n) = O(n log(m))$
    - une table de hashage (en moyenne): $O(n + C_"tri" + n) = O(n + m log(m))$
]

= Version tableau d'éléments

#r[Faire les modifications en rouge dans le code de la version II]

#ex[
  T = ['abc', 'hello', 'world', 'ac', 'ab'] et f une fonction qui compte le nombre de caractères.\
  d  = {
    3 : ['abc'],\
    5 : ['hello','world']\
    2 : ['ac','ab']
  }
]

#blk2("Propriétés")[
  On a un tri stable.

  Notre algorithme n'est pas pertinant dans toutes les situations, il l'est si on veut trier des données avec beaucoup de redondensce (par exemple les codes postaux).
]