#import "@preview/cetz:0.3.0"
#import "@preview/syntree:0.2.1": tree
#import "@preview/lovelace:0.3.0": *
#import "@preview/codly:1.1.1": *
#import "@preview/codly-languages:0.1.1": *

#import "../utils.typtp": *
#import "lecon_tplt.typtp": lecon


#show: lecon.with(
  titre: [Leçon 09: Algorithmique du texte. Exemples et applications], 
  niveau: [MP2I/MPI], 
  prerequis: [Encodage du texte], 
  motivations: [Un auteur envoie son manuscrit à un éditeur. Pour le transfert, il compresse ce manuscrit (I). Puis, l'éditeur peut comparer le livre à d'autres pour détécter le plagiat (II). Il peut également chercher un motif dans le texte (III).])

= Compression
#def[Algorithme de compression sans perte][
  Un algorithme de compression sans perte est une fonction $f: Sigma^* -> Sigma^*$ bijective (il existe un unique décodage). \
  Le calcul de $f$ est appelé *Prétraitement*, l'application de $f$ sur un texte est appelée *compression*, et l'application de la réciproque de $f$ sur un texte compressé est la *décompression*.
]

== Encodage par lettre 
#blk2[Idée][
  La première approche pour compresser du texte, est ce considérer chaque lettre individuellement, et de tenter de l'encoder plus efficacement. 

  Cela veut dire qu'on aimerais encoder les lettres communes dans le texte sur un petit nombre de bits, quitte à utiliser plus de place pour les lettres qui apparaissent peu.
]

#blk1[Algorithme][De Huffmann][
  C'est un algorithme en 3 composantes : 
  + *Prétraitement* : On construit un arbre binaire $A_H$ dont les feuilles sont les lettres de de $a in Sigma$.
  + *Compression* : On code chaque lettre par une suite de 0 et 1 correspondant à son chemin dans l'arbre en partant de la racine (0 quand on emprunte le fils gauche, 1 pour le fils droit).
  + *Décompression* : On décode une suite de bits, en parcourant le chemin correspondant jusqu'à arriver à une feuille.
]
Comment construire l'arbre pour avoir une bonne compression ? 
#dev[Construction de l'arbre et preuve d'optimalité de l'algorithme de Huffmann]

== Encodage par séquences
#def[Motif][On appelle motif une séquence de lettres]

#blk2[Idée][
  Plutôt que d'associer un code binaire à chaque lettre, on va encoder des motifs. Dans l'agorithme LZW, on va, au fur et à mesure qu'on rencontre des motifs dans un texte, les stocker dans un dictionnaire.
]

#blk1[Algorithme][LZW][
  #pseudocode-list(hooks: .5em, title: smallcaps[LZW], booktabs: true)[
  *Entrée* : un texte s codé par des entiers (par exemple, codage ASCII)
  + c $<-$ "" (le résultat compréssé)
  + d $<-$ dictionnaire contenant toutes les lettres et leur encodage.
  + *Tant que* s n'est pas vide 
    + retirer de s son plus long préfixe w présent dans d
    + ajouter l'encodage de w à c
    + ajouter w' = w+s[0] (le préfixe w suivi de la prochaine lettre de s) à d avec un nouvel encodage
  + *Renvoyer* c
]
]

#blk2[Remarques][
  - Il n'est pas nécéssaire de transmettre le dictionnaire : il peut être reconstruit à la volée. En effet, si on lit un motif w connu, on sait que la prochaine lettre du texte original est soit celle d'un motif connu, soit celle du motif qui viens d'être ajouté. Comme ce motif commence par w, on connait également sa première lettre, et donc w', que l'on peut ajouter au dictionnaire de décodage.
  - L'encodage des motifs peut soit être d'une taille fixe, suffisemment grande (16 ou 32 bits), soit être de taille variable (auquel cas il faut spécifier quand changer de taille d'encodage)
]

= Algorithmes de comparaison

== Plus longue sous-suite commune (PLSSC)
#blk2[Problème][
  Soit $m_1, m_2 in Sigma^*$. Une sous suite commune à $m_1$ et $m_2$ est un mot s tel que qu'il existe $i_1< ...< i_k$ et $j_1 < ... < j_k$, tels que $m_1[i_1]...m_1[i_k] = m_2[j_1]...m_2[j_k]$.

  Une PLSSC est une sous suite commune de taille maximale.
] 

#blk2[Application][
  On peut utiliser ce problème pour trouver des gènes en commun dans les séquences d'ADN : \
  pour $m_1 = "AACGCTAT"$, $m_2 = "CGTAGGT"$, une plus longue sous suite commune est $"CGTAT"$.
]

#blk1[Algorithme][Programmation dynamique][
  On considère le sous problème $c_(i j) = |"PLSCC"(m_1[..i], m_2[..j])$. On a alors une relation de récurrence : 

  $c_(i j) = lr(\{#stack(
    [0 si i = 0 ou j = 0], 
    [$c_(i-1, j-1) + 1$ si m_1[i] = m_2[j] ], 
    [max($c_(i, j-1)$, $c_(i-1, j)$) sinon], 
    spacing:3pt))$

  Le tableau à remplir est de taille $|m_1| times |m_2|$, et chaque étape de remplissage se fait en temps constant, donc l'algorithme est en $O(|m_1| |m_2|)$
]

#rq[Pour obtenir la valeur de la suite, il suffit de stocker la sous suite maximale dans le tableau à tout moment.]


== Distance entre deux chaines

#def[Distance][
  Une distance sur un ensemble E est une application $d: E times E -> RR^+$ telle que : 
  - $d(x, y) = d(y, x)$ (symmétrie)
  - $d(x, y) = 0 <=> x = y$ (séparation)
  - $d(x, y) <= d(x, z) + d(z, y)$ (inégalité triangulaire)
]

#def[Distance d'édition (ou de Levenstein)][
  La distance d'édition entre deux chaines de caractères s et m est le nombre minimal d'opérations pour passer de l'une à l'autre parmis : 
  - Insertion(a, i) : on insère une lettre a à la position i
  - Substitution(a, i) : on remplace la lettre à la position i par a
  - Suppression(i) : on supprime la lettre à la position i
  ]

#blk2[Application][
  On peut utiliser la distance de Levenstein pour corriger les fautes de frappe dans un texte (en remplaçant les mots inconnus par les mots les plus proches selon cette distance.)
]

#blk2[Propriété][
  La distance d'édition est une distance sur $Sigma^*$
]

#blk1[Algorithme][Calcule de la distance d'édition][
  On utilise la programmation dynamique, avec la relation de récurrence suivante, pour u, v des mots et a, b des lettres : \
  $"lev"(u a, v b) = min lr(\{#stack(
    [lev(u, v) (+1 si a $!=$ b) (Substitution)], 
    [lev(u, vb) + 1 (Insertion)], 
    [lev(ua, v) + 1 (Suppression)],
  spacing:5pt))$

  Grace à cette relation, on peut faire le calcul en $O(|u| |v|)$
]

= Recherche de motifs
== Rechercher un motif dans un texte

#blk2[Problème][
  Pour un mot $m in Sigma^*$ et un texte $t in Sigma^*$, m est-il un sous-mot de t ? 
]

#blk2[Solution naive][
  On peut faire une recherche exhaustive, en complexite $O(|t| |m|)$
]

#blk2[Idée][
  On peut faire un pré-traitement sur le motif pour ne pas avoir à recommencer la comparaison du début quand on se trompe.
]

#dev[Automate des motifs]

#blk1[Algorithme][Boyer-Moore][
    - Idée : On compare depuis la fin du motif. 
    - On précalcule un tableau _decalage_, qui à chaque lettre de $Sigma$ associe la distance de la dernière occurence de a dans le motif, à la fin de motif. 
    #pseudocode-list(hooks: .5em, booktabs: true)[
    + i = 0
    + *Tant que* i < |t| - |m|
      + *Pour* j allant de |m| - 1 à 0
        + *Si* $t[i + j] != m[j]$
          + $i <- i + $ decalage[t[i+j]] 
          + passer à la prochaine itération de la boucle *Tant que*
        + Si la boucle *Pour* termine, *renvoyer* vrai
    + *renvoyer* faux

]
- Complexité : $O(|t| |m|)$ dans le pire des cas, $O((|t|) / (|m|))$ dans le meilleurs cas (si la dernière lettre de m n'est pas dans t)]



#blk1[Algorithme][Rabin-Karp][
  - Idée : on compare directement $t[i..i+|m|]$ à m à l'aide d'une fonction de hash. Si les hash sont égaux, on fait alors une vérification exhaustive.
  - Avec un hash bien choisi, par exemple $h(s) = sum_(j=0)^(|m| - 1) Beta^(|m| - 1 - j) * t_j$ se calcule ne O(1) à partir du hash du sous-mot précédent. 
  - Complexité : dans le pire des cas, $O(|m| |t|)$ (collision à chaque fois). Dans le meilleurs cas (aucune collision), $O(|t|)$
]

== Analyse lexicale

#blk2[Application][
  Lors de la compilation ou l'interprétation d'un programme, le compilateur reconnait des lexèmes définis par une expression régulière. 
]

#ex[id = $(a-Z)^+ (a-Z | 0-9 \_)^*$]

#blk1[Algorithme][Automate d'une expression régulière][
  Pour savoir si un texte contient un sous-mot correspondant à l'expression régulière e, on construit l'automate qui reconnait $L(Sigma^* e)$, et on execute l'automate sur les lettres du texte jusqu'à ce que celui-ci accepte. 
]