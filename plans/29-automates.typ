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
  #image("../img/automate_1.png")
]

#def("Chemin")[
  Soit $A = (𝑄, Σ, 𝑞_0, 𝐹, 𝛿)$ un automate fini déterministe et 𝑣 = $𝑎_1$... $𝑎_𝑛$ un mot
de $Σ^∗$ . Un chemin de l’état $𝑟_0$ à l’état $𝑟_𝑛$ dans A pour le mot 𝑣 est une séquence
$𝑟_0$, ... , $𝑟_𝑛$ de $𝑛+1$ états telle que :
- $∀𝑖, 0 ⩽ 𝑖 ⩽ 𝑛, 𝑟_𝑖 ∈ 𝑄$ ;
- $∀𝑖, 1 ⩽ 𝑖 ⩽ 𝑛, 𝑟_𝑖 = 𝛿 (𝑟_(𝑖−1), 𝑎_𝑖)$
Le chemin est dit acceptant si $𝑟_0 = 𝑞_0$ et $𝑟_𝑛$ ∈ 𝐹 . On dit que $A$ reconnaît (ou
accepte) le mot 𝑣 s’il existe un chemin acceptant dans $A$ pour le mot 𝑣.
]