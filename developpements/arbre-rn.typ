#import "@preview/lovelace:0.3.0": *

#import "../utils.typtp": *
#import "dev_tplt.typtp": developpement

#show: developpement.with(
  titre: [Équilibrage des arbres rouges et noirs], 
  niveau: [MP2I], 
  prerequis: [], 
) 

#rect[
  source : tortue
]

#blk1("Rappel définition", "Arbre rouge-noir")[
  ABR ou chaque noeud porte une couleur (noir ou rouge) et vérifie les propriété :
  1. le père d'un noeud rouge n'est jamais rouge
  2. le nombre de noeuds noirs le long d'un chemin de la racine à un sous-arbre vide est toujours le même.
]

#blk2("Insertion dans un arbre RN")[
  On cherche à insérer x dans l'arbre :
  1. On insert x comme dans un arbre binaire, on lui attribut la couleur rouge (on a potentiellement 2 noeud rouge de suite)
  2. Rétablir la propriété 2 d'abre rouge-noir, en effectuant des rotations succéssives en préservant la propriété 1
  3. On met la racine en noir.
]

#blk2("Rotation")[
  #image("../img/ARN_1.png", width: 50%)
  On préserve la structure d'ABR.
]

#blk2("Étape 2 de l'insertion")[
  On distingue plusieurs cas :
  - #image("../img/ARN_2.png", width: 80%)
  - #image("../img/ARB_3.png", width: 80%)
  - cas symétriques 
]

#blk2("Invariant")[
  On a toujours au plus 2 noeuds rouges consécutifs et la hauteur noire est préservée.
]

#ex[
  #image("../img/ARN_4.png", width: 90%)
]

#blk1("Proposition", "Hauteur ARN")[
  Soit t un ARN de hauteur h(t) à n(t) noeuds, alors :\
  (1) $h(t)<=2b(t)$\
  (2) $2^(b(t))<= n(t) +1$
]

#underline[_Démonstration_]\
  On montre ces inéquations par induction structurelle sur t.\
  - Cas de base : arbre vide \
    $h(t) = -1$ et $n(t)=b(t)=0$ donc (1) et (2) sont vraies.
  - Cas inductif : \
    Soit t un arbre RN non vide, g et d ses deux sous-arbres.\
    - Si la racine de t est noire, alors $b(g)=b(d)=b(t)-1$\
      Alors,\
      $ h(t)&=1+max(h(g), h(d))\
      &<= 1 + 2(b(t)-1) && "par hypothèse d'induction"\
      &< 2b(t) $
      De plus, \
      $ n(t)+1 &= 1 + n(g) + n(d) + 1\
      &>= 2^(b(t)-1)-1+2^(b(t)-1)-1 + 2 && "par hyp. d'ind."\
      &= 2^(b(t)) $
    - Sinon si la racine est rouge, alors $b(g)=b(d)=b(t)$ :
      - Si t ne contient qu'un seul noeud, alors $h(t)=b(t)=0$ et $n(t)=1$. (1) et (2) vraies.
      - Sinon t a 2 sous-arbres non vide qui ont une racine noire. Soit $t_1, t_2, t_3, t_4$ les 4 sous-sous-arbres de t.\
      Alors,\
        $ h(t)&= 2 + max_(i in [1:4])(h(t_i))\
      &<= 2 + 2(b(t)-1) && "par hypothèse d'induction"\
      &= 2b(t) $\
      De plus, \
       $ n(t)+1 &= 1 + n(g) + n(d) + 1\
      &>= 2^(b(t))-1+2^(b(t))-1 + 2 && "par hyp. d'ind."\
      &> 2^(b(t)) $


#blk2("Corolaire")[
  La hauteur d'un ARN est en O(log n(t))\
  #underline[_Démonstration_]\
  En effet, \
  $ h(t) &<= 2b(t) && "par (1)"\ 
  &<= 2log(n(t)+1) && "par (2)"\
  => h(t) = O(log n(t))
  $
]

#blk2("Compléxité de l'insertion")[
  On conclu que l'insertion est en $O(h) = O(log n)$
]