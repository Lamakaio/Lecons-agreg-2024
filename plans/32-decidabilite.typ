#import "@preview/cetz:0.3.0"
#import "@preview/syntree:0.2.1": tree
#import "@preview/lovelace:0.3.0": *
#import "@preview/codly:1.1.1": *
#import "@preview/codly-languages:0.1.1": *

#import "../utils.typtp": *
#import "lecon_tplt.typtp": lecon

#show: lecon.with(
  titre: [Leçon 32 : Décidabilité et indécidabilite. Exemples], 
  niveau: [CPGE], 
  prerequis: [Languages rationels et algébriques, terminaison],
  motivations: [],
  )

= Notion de problèmes et d'algorithmes
#def[Problème][
  Un problème est une relation $alpha$ de $E times S$, où E est l'ensemble des instances du problème, et S l'ensemble des solutions. 

  Si pour $e in E, s in S, e alpha s$ , on dit que $s$ est une _solution_ de $e$
]

#ex[
  Pour le problème CLIQUE, $E$ est l'ensemble des graphes, et $S$ l'ensemble des graphes complets, avec $e alpha s$ ssi $s$ est une clique maximale de $e$.
]

#def[Problème de décision][
  Un problème de décision est un problème avec $S = {0, 1}$
]

#blk1[Propriété][Caractérisation][
  Un problème de décision est caractisé par l'ensemble $E^+$ des instances positives du problème. \
  $E^+ = {e in E | e alpha 1}$

  On pose $E^- = E \\ E^+$
]

#def[Algorithme (définition informelle)][
  Pour un problème $P = (E, S, alpha)$, un algorithme $FF$ est une suite d'instructions élémentaires, qui prend en entrée une instance du problème $e in E$, et qui renvoie une sortie $FF(e) in S$.

  On dit que $FF$ résout le problème $P$ si pour toute instance $e in E$ du problème, $e alpha FF(e)$
]

#def[Programme][
  Un programme est l'implémentation d'un algorithme dans un language de programmation. On admet que pour tout algorithme, on a un programme correspondant. 
]

= Décidabilité
#def[Décidabilité][
  Un problème de décision $P = (E^+, E^-)$ est dit décidable si il esxite un programme qui le résout, et indécidable sinon.  
]

#blk1[Théorème][Problèmes indécisable][
  Il existe des des problèmes indécidables.
]

#ex[
  Un problème indécidable est le problème de l'arrêt : étant donné un programme $PP$ et des entrées $I$, l'execution de $PP(I)$ termine-elle ? 
]

#def[Semi-décidabilité][
  Un problème de décision $P = (E^+)$ est semi-décidable si il existe un programme si il existe un programme qui, pour $e in E$, 
  - termine et renvoie vrai si $e in E^+$
  - ne termine pas, ou renvoie faux, sinon.
]

#ex[
  ARRET est semi-décidable, avec le programme qui simule simplement l'entrée et renvoie vrai quand elle termine. 
]

#blk2[Remarque][
  L'exemple précédent fait appel à la notion de programme universel, c'est à dire à l'existence d'un programme qui peux simuler tout autre programme. On admet l'existence d'un programme universel dans ce cours. 
]

#blk2[Remarque][
  Dessin : pb décidables $subset.neq$ pb semi-décidable $subset.neq$ pb quelconques
]

#blk1[Théorème][Lien entre décidabilité et semi-décidabilité][
  Soit $P = (E^+, E^-)$ un problème de décision. On pose $P^c = (F^+, F^-) = (E^-, E^+)$ le complémentaire de $P$. \
  Alors $P$ est décidable ssi $P$ et $P^c$ sont semi-décidables.
]

#blk2[Preuve][
  $arrow.double.r$ est trivial. \
  $arrow.double.l$ Soit deux algorithmes $M_P, M_(P^c)$ qui semi-décident $P$ et $P^c$. On va les executer "en parallèle" (on execute une instruction de chaque programme en alternant), et, si $M_P$ accepte, on accepte, et si $M_(P^c)$ accepte, on refuse. 
]

#blk2[Remarque][
  Par le théorème 14, on déduit que le complémentaire de ARRET n'est pas semi-décidable.  
]

= Réduction
#def[Fonction calculable][
  Une fonction $f: E -> E'$ est calculable si il existe un programme $FF$ tel que sur toute entrée $e in E$, $FF$ termine et renvoie $f(e)$
]

#def[Réduction (many-to-one)][
  Soit P et Q deux problèmes de décision. On dit que P se réduit en Q (noté $A <= B$) s'il existe une fonction calculable $f$ telle que : \
  $e$ est une instance positive de P ssi $f(e)$ est une instance positive de Q. 
]

#blk2[Illustration][  
  #grid(columns: (3fr, 1fr, 1fr, 1fr, 3fr, 1fr, 3fr, 1fr, 3fr), align: center + horizon, 
  rect[instance de P], [$->$], rect[$f$], $->$, rect[instance de Q], $->$, rect[Programme pour Q], $->$, rect[Solution à l'instance de P])

  $P <= Q$ signifie "Q est un problème plus difficile que P"
]

#blk1[Théorème][Réduction][
  - Si $P <= Q$ et Q est décidable, alors P est décidable
  - Si $P <= Q$ et P est indécidable, alors Q est indécidable
]

#ex[
  On pose le problème $L_emptyset$
  - entrée : un algorithme $A$
  - $A$ termine-il sur au moins une entrée ? 

  Montrons ARRET $<= L_emptyset$ pour prouver que $L_emptyset$ est indécidable. 

  #grid(columns: (3fr, 1fr, 10fr, 1fr, 3fr), align: center + horizon, 
  [$(A, w)$ instance de ARRET], $->$, rect(stroke: (dash: "dashed"))[
    #grid(columns: (1fr, 1fr, 1fr, 1fr, 4fr), rect[$f$], $->$, $(A_w)$, $->$, rect[Programme pour $L_emptyset$]) 
    ARRET
  ], $->$, [Réponse au problème de l'arrêt]
  )

  Avec $f$ qui construit $A_w$ de la façon suivante : $A_w$ accepte si $A$ termine sur $w$, et boucle à l'infini sinon.
]

= Exemples
== Correspondance de POST
#def[Problème de correspondance de POST][
  - entrée : des tuiles $binom(u_1, v_1), dots, binom(u_n, v_n)$ avec $u_i, v_i in Sigma^*$ pour un alphabet $Sigma$
  - Existe-il $i_1, dots, i_p in [|1, n|]$ tels que $u_(i_1) u_(i_2) dots u_(i_p) = v_(i_1) v_(i_2) dots v_(i_p)$ ? 
]

#ex[
  On pose les tuiles $binom("a", "baa"), binom("ab", "aa"), binom("bba", "bb")$ sur $Sigma = {a, b}$. Avec la suite 3, 2, 3, 1 de tuiles, on a : \
  bba + ab + bba + a = bb + aa + bb + baa
]

#blk1[Théorème][décidabilité][
  Le problème de correspondance de POST est indécidable. 
]

== Terminaison et correction de programmes
On pose, pour un algorithme $A$, $phi_A$ la pré-condition de l'algorithme, et $psi_A$ la post-condition de l'algorithme. 

#def[Problème de la terminaison][
  - entrée : $A$ un algorithme
  - $A$ termine-il sur toute entrée ? 
]

#def[Problème de la correction partielle][
  - entrée : $A$ un algorithme
  - Pour une entrée $e$ qui vérifie $phi_A$, est ce que, si elle existe, la sortie de $A$ vérifie $psi_A$ ?  
]

#blk1[Théorème][décidabilité][
  Ces deux problèmes sont indécidables.
]

#dev[Preuve du théorème, en passant par le théorème de Rice]

== Languages algébriques

#blk1[Problème][Appartenance][
  - entrée : Une grammaire G et un mot w
  - est ce que $w in L(G)$ ? 
]

#blk1[Problème][Language universel][
  - entrée : Une grammaire G sur $Sigma$
  - est ce que $L(G) = Sigma^*$ ? 
]

#blk1[Problème][Egalité][
  - entrée : Deux grammaires G et G'
  - est ce que $L(G) = L(G')$ ? 
]

#blk1[Problème][Ambiguité][
  - entrée : une grammaire G
  - G est-elle ambigue ? 
]

#blk1[Théorème][décidabilité][
  - L'appartenance est décidable
  - L'universalité, l'égalité, et l'ambiguité sont indécidables. 
]

#dev[Démonstration du théorème]