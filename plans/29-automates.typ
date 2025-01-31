#import "@preview/cetz:0.3.0"
#import "@preview/syntree:0.2.0": tree
#import "@preview/lovelace:0.3.0": *
#import "@preview/codly:1.1.1": *
#import "@preview/codly-languages:0.1.1": *

#import "../utils.typtp": *
#import "lecon_tplt.typtp": lecon

#show: lecon.with(
  titre: [Leçon 29 : Langages rationnels et automates finis. Exemples et applications], 
  niveau: [MP2I], 
  prerequis: [],
  motivations: [compilation, fouille de texte, validation de données, la conception de circuits],
  )
\
= Langages réguliers

== Langages

#def("Alphabet")[
  On appelle alphabet Σ un ensemble fini et non vide d’éléments. Les éléments d’un alphabet sont appelés des symboles (ou des lettres).
]

#def("Mot")[
  Un mot sur un alphabet Σ est une suite finie de symboles. Le mot vide (constitué de 0 symbole) est noté 𝜀.
]

#ex[
  $Sigma = {0,1}, $∅$, {epsilon, 101, 11}, {epsilon}, {"mot de taille pair sur "Sigma}$
]

#def("Langage")[
  Un langage $L$ sur un alphabet Σ est un sous-ensemble de mots sur Σ.\
  Soit $L_1$ et $L_2$ des langages :
  - $L_1 union L_2 = {v|v in L_1 or v in L_2}$
  - $L_1 sect L_2 = {v|v in L_1 and v in L_2}$
  - $L_1 L_2 = {u v|u in L_1, v in L_2}$
  - $L_1⁰ = {epsilon}$
  - $L_1^n = L L^(n-1)$
  - $L_1^* = union L^n$
]

== Langages réguliers

#def("Expréssion régulière")[
 Une expression régulière sur un alphabet Σ est définie inductivement comme
suit.
- ∅ et 𝜀 sont des expressions régulières 
- pour tout $a$ ∈ Σ, le symbole $a$ est une expression régulière 
- si $r_1$ et $r_2$ sont deux expressions régulières, $r_1$|$r_2$ et $r_1 r_2$ sont des expressions régulières 
- si $r$ est une expression régulière, $r^*$ est une expression régulière 
]

#ex[
  $(0|1)^*10$ est une expression régulière.
]

#def("Langage d'une expression régulière")[
Soit $r$ une expression régulière sur un alphabet Σ. Le langage de l’expression
régulière $r$ , noté $L(r$), est défini inductivement sur la structure de l’expression.
- $L(∅) = ∅$
- $L(𝜀) = {𝜀}$
- $∀𝑎 ∈ Σ, L(a) = {a}$
- $L(r_1|𝑟 2 ) = L(r_1) union L(r_2)$
- $L(r_1 𝑟 2) = L(r_1)L(r_2)$
- $L(r^*) = (L(r))^∗$
]

= Automates

== Automates déterministes

#def("DFA")[
Un automate fini déterministe complet (DFA) est un 5-uplet $A = (𝑄, Σ, q_0, 𝐹, 𝛿)$, où
- 𝑄 est un ensemble fini d’états
- Σ est un alphabet
- $𝑞_0$ ∈ 𝑄 est l’état initial
- 𝐹 ⊆ 𝑄 est l’ensemble des états acceptants (ou finaux)
- 𝛿 : 𝑄 × Σ → 𝑄 est une fonction totale, appelée fonction de transition de l’automate
]

#blk2("Représentation")[
  Les états sont des cercles et les transitions des flèches etiquetées.
]

#ex[
  #figure(caption: "Aperçu de la représentation d'un automate")[
    #image("../img/automate_1.png", width: 40%)
  ]
]

#def("Chemin")[
  Soit $A = (𝑄, Σ, 𝑞_0, 𝐹, 𝛿)$ un automate fini déterministe et 𝑣 = $𝑎_1$... $𝑎_𝑛$ un mot
de $Σ^∗$ . Un chemin de l’état $𝑟_0$ à l’état $𝑟_𝑛$ dans A pour le mot 𝑣 est une séquence
$𝑟_0$, ... , $𝑟_𝑛$ de $𝑛+1$ états telle que :
- $∀𝑖, 0 ⩽ 𝑖 ⩽ 𝑛, 𝑟_𝑖 ∈ 𝑄$ ;
- $∀𝑖, 1 ⩽ 𝑖 ⩽ 𝑛, 𝑟_𝑖 = 𝛿 (𝑟_(𝑖−1), 𝑎_𝑖)$
]

#def("Chemin acceptant")[
  Le chemin est dit acceptant si $𝑟_0 = 𝑞_0$ et $𝑟_𝑛$ ∈ 𝐹 . On dit que $A$ reconnaît (ou accepte) le mot 𝑣 s’il existe un chemin acceptant dans $A$ pour le mot 𝑣.
]

#def("Langage de l'automate")[
  Soit $A$ un automate. Le langage de l’automate $A$, noté $L (A)$, est l’ensemble des mots acceptés par l’automate.
]

#def("Langage rationnel")[
  Si pour un langage L, il existe un automate déterministe tel que $L(A)=L$ alors $L$ est un langage rationnel.
]

#def("Équivalence")[
  Deux automates reconnaissant le même langage sont dit équivalent.
]

#def("Automates incomplets")[
  On peut avoir des automates incomplets avec 𝛿 une fonction partielle. Pour le compléter il suffit de créer un état dit "puit".
]

== Automates non déterministe

#def("Automates non déterministe")[
  Un automate fini non déterministe (NFA) est un 5-uplet $A = (𝑄, Σ, 𝑞_0, 𝐹, 𝛿)$, où :
  - 𝑄 est un ensemble d’états 
  - Σ est un alphabet 
  - $𝑞_0$ ∈ 𝑄 est l’état initial 
  - 𝐹 ⊆ 𝑄 est l’ensemble des états acceptants (ou finaux) 
  - 𝛿 : 𝑄 × Σ → P (𝑄) est une fonction partielle, appelée fonction de transition de l’automate
]

#blk2("Remarque")[
  Il peut y avoir plusieurs chemin possible pour un même mot. Si un est acceptant, $A$ reconnaît $v$.
]

#def("𝜀-transition")[
  $𝛿(q,𝜀)$ est appelé une 𝜀-transition.
]

#ex[
 #figure(caption: "Aperçu d'un automate non déterministe")[
    #image("../img/automate_2.png", width:40%)
  ]
]

== Déterminisation et suppréssion des 𝜀-transitions

=== Déterminisation

#blk3("Théorème")[
  Tout NFA est &quivalent à un DFA.
]

#def("Déterminisation")[
  Soit$ A_N = (𝑄_N, Σ, 𝑞_0, 𝐹_N, 𝛿_N)$ un automate non déterministe. On appelle
$det(A_N)$ l’automate déterministe $A_D = (𝑄_D, Σ, {𝑞_0}, 𝐹_D, 𝛿_D)$ construit
comme suit :
- $𝑄_D = P (𝑄_N)$
- $𝐹_D = {𝑆 | 𝑆 ∈ 𝑄_D, 𝑆 ∩ 𝐹_N ≠ ∅}$
- $𝛿_D : 𝑄_D × Σ →P(𝑄_D)$
   \ $(𝑆, 𝑎) ↦ union.big_(q in S) 𝛿_N (𝑞, 𝑎)$
]

#blk2("Exercice")[
  Déterminisation d'automates NFA.
]

=== Suppréssion des 𝜀-transitions

#def("𝜀-fermeture")[
  Soit $A = (𝑄, Σ, 𝑞_0, 𝐹, 𝛿)$ un automate à 𝜀-transitions. On appelle 𝜀-fermeture de 𝑞 l’ensemble \
  $𝐸 (𝑞) = {𝑞'| 𝑞 →^𝜀∗  𝑞'}$\
  Informellement, l’ensemble 𝐸 (𝑞) représente tous les états de l’automate accessibles
depuis 𝑞 en ne prenant que des transitions spontanées.
]

#def("Suppression des 𝜀-transitions")[
  Soit $A_S = (𝑄_S, Σ, 𝑞_0, 𝐹_S, 𝛿_S)$ un automate avec 𝜀-transitions. On
appelle rm𝜀 ($A_S)$ l’automate non déterministe $A_N = (𝑄_N, Σ, 𝑞_0, 𝐹_N, 𝛿_N)$
construit comme suit :
- $𝑄_N = 𝑄_S$
- $𝐹_N = 𝐹_S$
- $𝛿_N : 𝑄_N × Σ → P(𝑄_N)$\
 $(q,a)↦union.big_(p in E(q)) 𝛿_N (p, 𝑎)$
]

#blk3("Théorème")[
  Il est possible de déterminiser et d'enlever les 𝜀-transitions en même temps.
]

#def("Supression des 𝜀-transitions et déterminisation")[
  Soit $A_S = (𝑄_S, Σ, 𝑞_0, 𝐹_S, 𝛿_S)$ un automate avec 𝜀-transitions.
On appelle $"det"^𝜀 (A_S)$ l’automate déterministe $A_D = (𝑄_D, Σ, 𝐸 (𝑞_0), 𝐹_D, 𝛿_D)$
construit comme suit :
- $𝑄_D = P (𝑄_S)$
- $𝐹_D = {𝑆 | 𝑆 ∈ 𝑄_D, 𝑆 ∩ 𝐹_S ≠ ∅}$
- $𝛿_D : 𝑄_D × Σ → P(𝑄_D)$
$(𝑆, 𝑎) ↦  𝐸 ( union.big_(q in S) 𝛿_S (𝑞, 𝑎))$
]

= Liens entre automates finis et langages réguliers

== Équivalence

#blk1("Théorème", "Kleen")[
  Pour $L subset Sigma^*, L$ régulier $<=> L$ rationnel\
  Preuve \
    $=>$ contruction de Thompson\
    $arrow.l.double$ algorithme d'éliminations d'états
]

#blk2("Remarque")[
  L'algorithme de Thompson nous fournit un NFA avec beaucoup d'𝜀-transitions.
]

#dev("Construction de Thompson, déterminisation et suppression des 𝜀-transitions")

#def("Langage local")[
  Soit Σ un alphabet et 𝐿 ⊆ Σ∗ un langage. On note :
- First$(𝐿) = { 𝑎 | 𝑎 ∈ Σ, {𝑎}Σ^∗ ∩ 𝐿 ≠ ∅ }$
- Last$(𝐿) = { 𝑎 | 𝑎 ∈ Σ, Σ^∗ {𝑎} ∩ 𝐿 ≠ ∅ }$
- Fact$(𝐿) = { 𝑣 | 𝑣 ∈ Σ × Σ, Σ^∗ {𝑣 }Σ∗ ∩ 𝐿 ≠ ∅ }$
- NFact$(𝐿) = Σ × Σ backslash$ Fact(𝐿)
𝐿 est un langage local si et seulement si
$𝐿 backslash {𝜀} = ("First"(𝐿)Σ^∗ ∩ Σ^∗ "Last"(𝐿)) backslash Σ∗ "NFact"(𝐿)Σ^∗$
]

#def("Automate de Glushkov")[
  Soit Σ un alphabet et $𝐿 ⊆ Σ^∗$ un langage local. \ On note Loc(𝐿) l’automate
définit par Loc$(𝐿) = (𝑄_𝐿 , Σ, 𝑞_0, 𝐹_𝐿 , 𝛿_𝐿)$ et :
- $𝑄_𝐿 = {𝑞_𝑎 | 𝑎 ∈ Σ } ∪ {𝑞_0}$
- $𝐹_𝐿 = {𝑞_𝑎 | 𝑎 ∈ "Last"(𝐿) } ∪ {𝑞_0 | 𝜀 ∈ 𝐿 }$
- $𝛿_𝐿 : 𝑄_𝐿 × Σ → 𝑄_𝐿$ \ $(𝑞_0, 𝑎) ↦ 𝑞_𝑎$ ∀𝑎 ∈ First(𝐿)\ $(𝑞_𝑎 , 𝑏) ↦ 𝑞_𝑏$ ∀𝑎, ∀𝑏, 𝑎𝑏 ∈ Fact(𝐿)
]

#blk3("Théorème")[
  Si $L$ est local alors $L = LL("Loc"(L))$
]

#blk1("Algorithme", "Berry-Sethi")[
  Entrée : r une regex \
  Sortie : NFA sans 𝜀-transitions qui reconnait $LL(r)$ \
1. Linéariser 𝑟 pour obtenir 𝑟'.
2. Calculer First$(LL(𝑟))$, Last$(LL(𝑟))$ et Fact$(LL(𝑟))$.
3. Construire $A = "Loc"(LL(𝑟 ))$.
4. Effacer les indices des symboles se trouvant sur les transitions de $A$.
]

== Propriétés des langages réguliers

#blk3("Théorème")[
  Les langages réguliers sont clos par complémentaire et intersection. Démonstration en passant par les automates.
]

#blk1("Théorème", "Lemme de l'étoile")[
Soit 𝐿 un langage régulier sur un alphabet Σ. Il existe $𝑛 ⩾ 1$ tel que pour tout
mot 𝑢 ∈ 𝐿 tel que $|𝑢| ⩾ 𝑛$, il existe $𝑥, 𝑦, 𝑧 ∈ Σ^∗$ tels que $𝑢 = 𝑥 𝑦 𝑧$ 
- $|𝑥 𝑦|⩽𝑛$
- $𝑦 ≠ 𝜀 $
- $𝑥 𝑦^∗𝑧 ⊆ 𝐿$
]

#blk2("Remarque")[
  Ce lemme est surtout utilisé poue prouver la non rationnalité d'un langage.
]

#blk2("Exercice")[
  Montrer que ${𝑎^𝑛 𝑏^𝑛 | 𝑛 ⩾ 0}$ n'est pas rationnel. Est-il possible d'avoir un langage rationnel qui garantie le bon parenthésage d'un texte ?
]

= Applications

==  Analyse lexical

Les expressions régulière et automates interviennent dans la compilation des langages de programmation. Pour l’analyse lexicale, on décrit sous forme d’expressions régulières les
lexèmes à reconnaître ou à ignorer. Ces expressions sont ensuite transformées
en un automate.

#ex[
  Reconnaitre le code ```c if(true) then 42```
]

== Expressions régulières Posix

#ex[
  ```unix $ grep '0\|1(0\|1)*' monfichier.txt```
  retourne toutes les lignes dont une sous chaine est dans $LL(0\|1(0\|1)*)$.
]

== Reconnaissance de motif dans un texte

On a un texte t et un mot w. On veut samoir si w est un sous mot de t. \
Motivation ctrl + F. \
Solution naïve : on parcourt et on compare les lettre une à une $Omicron(|t|times|w|)$\
Autre solution : On construit l'automate des motifs en $Omicron(P(|w|))$ où P est un polynôme. On détecte ensuite si w est un sous mot de t en $Omicron(|t|)$.

#dev("Contruction de l'automate des motifs")