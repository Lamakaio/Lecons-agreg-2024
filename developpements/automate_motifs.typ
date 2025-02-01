#import "../utils.typtp": *
#import "dev_tplt.typtp": developpement

#show: developpement.with(
  titre: [Automate des motifs], 
  niveau: [MPI], 
  prerequis: [Récurrence],
)

Source : 131 développements

On souhaite détecter si $M$ est un sous mot de $T$. On prend alors $M in Sigma^*, |M|=k$ et on cherche à construire un automate $A$ tel que $LL(A)=Sigma^*M$

= Présentation de la construction
== Notations :

- si $u,v in Sigma^*,$ on note $u subset.sq v$ si u est suffice de v \ ex : ab $subset.sq$ bbab
- $M_i$ : ième préfixe de $M$ \ ex : M = abbab, $M_0=epsilon, M_1="a", M_2="ab", M_3="abb"$...
- On note $sigma(u)="max"{i|M_i subset.sq u}$ \ C'est la taille du plus grand préfixe de M qui est également suffixe de u. \ AJOUTER DESSIN \ ex : $M="abaa", u="aaba" sigma(u)="max"{|"a"|,|"aba"|}=3$ 

== Construction d'un automate
Soit $A=(Q, Sigma, q_0, F, delta)$ tel que :
- $Q={0,...,k}$
- $q_0={0}$
- $F={k}$
- $forall q in Q "et a"in Sigma$ \ $delta(q," a")=sigma(M_q" a")$

#ex[
  $Sigma = {"a, b"}, M=$ab \
  Quelques exemple de calculs de $delta$ : \
  #grid(
    columns: (2fr, 1fr, 1fr),
    rows: (auto, 60pt),
    grid.cell[
      $delta("0,a")=sigma(M_0" a")=sigma (epsilon" a")=1$ \
      $delta("0,b")=sigma("b")=0$ \
      $delta("1,a")=sigma("aa")=1$ \
      $delta("1,b")=sigma("ab")=2$ \
    ],
    grid.cell[
      #table(
        columns: (2em,2em,2em),
        table.header([], [*a*], [*b*]),
        "0","1","0",
        "1","1","2",
        "2","1","0"
      )
    ],
    grid.cell[
      #image("../img/automate_3.png")
    ]
  ) 
]

= Correction $LL(A)=Sigma^*M$

== Montrons que $sigma(u a)=sigma(M_sigma(u)a)$

#blk3("Lemme")[
  Si $u subset.sq v,$ alors $sigma(u)<=sigma(v)$
]
Idée de la preuve : \
Si $u subset.sq v,$ alors tout suffixe de $u$ est suffixe de $v$ on a $M_sigma(u) subset.sq u subset.sq v $ d'où $sigma(u)<=sigma(v)$

#blk3("Lemme")[
  $sigma(u a)<=sigma(u)+1$
]
Idée de la preuve : \
- Si $sigma(u a)=0$ ok
- Sinon $sigma(u a)-1>=0$ donc $M_sigma(u a)=M_(sigma(u a)-1) m_sigma(u a)$ \ comme $M_sigma(u a)subset.sq u a$, on a $m_sigma(u a)= a$ et $M_(sigma(u a)-1) subset.sq u$ \ ainsi $sigma(u a)-1 <= sigma(u) <=> sigma(u a)<= sigma(u a)+1$

*1. $sigma(u a)>= sigma(M_sigma(u)a)$ :* \
Par définition $M_sigma(u)subset.sq u$, d'où $M_sigma(u)a subset.sq u a$. D'après le lemme 
2 $sigma(u a)>= sigma(M_sigma(u)a)$

*2. $sigma(u a)<= sigma(M_sigma(u)a)$ :* \ 
$M_sigma(u)a "et" M_sigma(u a)$ sont deux suffixes du mot $u a$, donc le plus court des deux est suffixe de l'autre. D'après le lemme 3, $|M_sigma(u a)|=sigma(u a)<=sigma(u)+1=|M_sigma(u)a|$ \
Donc $M_sigma(u a)subset.sq M_sigma(u)a$ d'où d'après le lemme 2, $sigma(u a)=sigma(M_sigma(u a))<=sigma(M_sigma(u)a)$\

Donc $sigma(u a)=sigma(M_sigma(u)a)$

== Montrons que $delta^*(0,u)=sigma(u)$
On procède par récurrence sur la longueur $|u|$ : 
- $|u|=0, u=epsilon, delta(0,epsilon)=sigma(epsilon)=0$
- $|u|>=0, u=v a$ tel que $a in Sigma$, par hypothèse de récurrence $delta^*(O,v)=sigma(v)$\
$delta^*(0,u)&=delta(delta^*(0,v),a)\
&=delta(sigma(v),a) && "par HR" \ 
&=sigma(M_sigma(v)a) && "par définition de" delta \ 
&=sigma(v a) && "par II.1" \ 
&=sigma(u)$ \ 
Par récurrence $delta^*(0,u)=sigma(u)$

== Conclusion $LL(A)=Sigma^*M$
\
$u in LL(A)&<=>delta^*(0,u)=k \ 
&<=>sigma(u)=k && "par II.2" \
&<=>M subset.sq u && "par def de" sigma\
&<=>u in Sigma^*M$ \
Donc $LL(A)=Sigma^*M$

= Complexité
L’algorithme naïf de recherche de motif consiste à parcourir les positions i
dans T et tester si pour tout j ∈ [1,k], on a $m_j = t_(i+j)$ . Cet algorithme est alors
de complexité temporelle $O(|T| times |M|)$ dans le pire des cas. \
L’algorithme présenté ici est alors toujours en $O(|T| + P(|M|))$ où $P$ est un polynôme ne dépendant pas de la taille de T.
