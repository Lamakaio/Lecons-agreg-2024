#import "@preview/lovelace:0.3.0": *

#import "../utils.typtp": *
#import "dev_tplt.typtp": developpement

#show: developpement.with(
  titre: [Correction du tri fusion], 
  niveau: [MP2I], 
  prerequis: [Algorithmes récursifs])

\

(On met le pseudo-code dans le plan donc on ne le ré-écrit pas au tableau).


#pseudocode-list(hooks: .5em, booktabs: true)[
    *fusion $(L_1,L_2)$*
      + res = tableau de taille $|L_1| + |L_2|$
      + $i = 0$
      + $j = 0$
      + *Tant que* $i < |L_1| "et" j < |L_2| :$
        + *si* $L_1[i] <= L_2[j]$ :
          + res$[i+j]=L_1[i]$
          + $i = i+1$
        + *sinon* 
          + res$[i+j]=L_2[j]$
          + $j = j+1$
      + *Tant que*  $i < |L_1|$ :
        + res$[i+j]=L_1[i]$
        + $i = i+1$
      + *Tant que*  $j < |L_2|$ :
          + res$[i+j]=L_2[j]$
          + $j = j+1$
      + *renvoyer* res
  ]
#pseudocode-list(hooks: .5em, booktabs: true)[
      *tri_fusion $(L)$*
        + *si* $|L| <= 1$
          + *renvoyer* $L$
        + *sinon* 
          + s = $|L|$/2
        + *renvoyer* fusion $("tri_fusion"(L[s:]), "tri_fusion"(L[:s]))$
  ]


= Terminaison de fusion
Prenons comme variant $|L_1|-i+|L_2|-j$. \
C'est bien un entier, positif (car si $|L_1|>i, |L_1|>=i+1 "donc" |L_1|-|i+1|>=0$), qui décroit strictement à chaque itération, en effet : \
- soit i $<-$ i+1 donc $|L_1|-i<-|L_1|-i-1$
- soit j $<-$ j+1 donc $|L_2|-j<-|L_2|-j-1$
Donc fusion termine

= Terminaison de tri_fusion
On prend $|L|$ comme variant.\
Les seuls appels récursifs à tri_fusion se font sur des listes de taille strictement inférieures, et tri_fusion s'arrête instantanément si $|L|<=1$. Donc il n'y a qu'un nombre fini d'appels récursifs.
Or fusion termine, donc chaque appel récursif termine. Donc tri_fusion termine.

= Correction partielle de fusion
Spécification de fusion : Si $L_1 "et" L_2$ sont triés, alors fusion($L_1, L_2$) = $L_1 union.sq  L_2$ est trié.\ \
Prenons comme invariant pour la première boucle "Tant que" :\
$P$ : "res=$L_1[:i] union.sq L_2[:j] "est trié et "L_1[i] "et" L_2[j]$ sont plus grand que les éléments de res"\
- Avant la boucle, on a bien i=0, j=0 donc res $=[]=[] union.sq []$ trié 
- Supposons P vrai au début de la boucle, alors
  - si $L_1[i]<=L_2[j]$ :\
    alors on ajoute à res $L_1[i]$. Donc par $P$ res est trié. Et comme $L_1$ est trié, $L_1[i+1]>=L_1[i]$ et $L_2[j]>=L_1[i]$. Donc par $P$, $L_1[i+1] "et" L_2[j]$ sont plus grand que tous les éléments de res. Donc quand $i <- i+1$, on obtient bien le résultat attendu.
  - si $L_1[i]>=L_2[j]$ : cas symétrique
Donc P est un invariant valide.
\ \
Ainsi à la fin $P$ est vrai et comme la condition d'arrêt est à faux, on a $i=|L_1|$ ou $j=|L_2|$. Donc par $P$, une des deux listes est totalement dans res, et il ne manque à l'autre que ses éléments plus grand que ceux de res. On les ajoutes donc à res. À la fin de fusion, on a donc res$=L_1 union.sq L_2$ trié.\
Donc fusion est partiellement correcte.
On peut conclure que fusion est correcte.

= Correction partielle de tri_fusion
Soit $P$ la propriété définie pour $n in NN^*$ par \
$P(n):$ "tri_fusion(L) tri L pour toute liste de taille n"

Soit $n in NN^*$ tel que $forall k in NN, P(k)$. Soit $L$ une liste de taille $n$ 
- si $n=0$ ou $n=1$ alors tri_fusion(L)=L qui est trié
- sinon par $P(floor.l n/2 floor.r)$ et $P(ceil.l n/2 ceil.r)$, on a par hypothèse de récurrence que tri_fusion($L_1$) vaut $L_1$ trié et tri_fusion($L_2$) vaut $L_2$ trié.\
  Donc $L_1$ et $L_2$ vérifient les pré-conditions de fusion. \
  Donc fusion(tri_fusion($L_1$),tri_fusion($L_2$)) vaut $L_1 union.sq L_2$ trié. \
  Or $L_1$ et $L_2$ partitionnent $L$ (leur union disjointes contient donc les mêmes éléments que $L$). \
  Donc tri_fusion($L$) renvoie $L$ trié.

Ainsi par récurrence, tri_fusion est partiellement correcte.\
Donc tri_fusion est correcte.