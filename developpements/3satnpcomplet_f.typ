#import "../utils.typtp": *
#import "dev_tplt.typtp": developpement
#import "@preview/syntree:0.2.1": tree

#show: developpement.with(
  titre: [3-SAT est NP-complet], 
  niveau: [MPI], 
  prerequis: [NP-complétude, SAT])

= Le problème 3-SAT
Le problème 3-SAT est la restriction du problème SAT aux formules propositionnelles sous forme normale conjonctive dans lesquelles chaque clause contient au plus trois littéraux.
\

En un sens, le problème 3SAT est plus simple que le problème SAT, puisque ses formules ont une forme beaucoup mieux maîtrisée. Cependant, on peut démontrer que le problème reste NP-complet. On réalise ceci en montrant que toute formule propositionnelle 𝜑 peut être transformée en une formule 𝜑 respectant les contraintes 3SAT, sans explosion de taille, et qui est satisfiable si et seulement si 𝜑 l’est également. La construction est basée sur deux éléments, formant une technique de transformation de formules appelée transformation de Tseitin.
\

= Transformation de Tseitin

== Construction
Considérons pour commencer une formule $𝑥 ↔ (𝑦 ∧ 𝑧)$ avec trois variables
propositionnelles 𝑥, 𝑦 et 𝑧, et décomposons-la.

$𝑥 ↔ ( 𝑦 ∧ 𝑧 )$\
$≡ ( 𝑥 → ( 𝑦 ∧ 𝑧 ) ) ∧ ( ( 𝑦 ∧ 𝑧 ) → 𝑥 )$ décomposition de ↔\
$≡ (¬ 𝑥 ∨ ( 𝑦 ∧ 𝑧 ) ) ∧ (¬ ( 𝑦 ∧ 𝑧 ) ∨ 𝑥 )$ décompositions de →\
$≡ (¬ 𝑥 ∨ 𝑦 ) ∧ (¬ 𝑥 ∨ 𝑦 ) ∧ (¬ ( 𝑦 ∧ 𝑧 ) ∨ 𝑥 )$ distributivité de ∨ sur ∧\
$≡ (¬ 𝑥 ∨ 𝑦 ) ∧ (¬ 𝑥 ∨ 𝑦 ) ∧ (¬ 𝑦 ∨ ¬ 𝑧 ∨ 𝑥 )$ loi de de Morgan\

Nous obtenons la conjonction de trois clauses avec au maximum trois littéraux chacune, c’est-à-dire une formule répondant à la restriction 3SAT. \
On peut vérifier de même les deux autres équivalences suivantes. \
$𝑥 ↔ ( 𝑦 ∨ 𝑧 ) &≡ (¬ 𝑥 ∨ 𝑦 ∨ 𝑧 ) ∧ (¬ 𝑦 ∨ 𝑥 ) ∧ (¬ 𝑧 ∨ 𝑥 ) \
𝑥 ↔ ¬ 𝑦 &≡ (¬ 𝑥 ∨ ¬ 𝑦 ) ∧ ( 𝑦 ∨ 𝑥 )$

On peut donc mettre sous forme 3SAT toute formule obtenue par conjonction de formules ayant l’une des trois formes suivantes :
- $𝑥 ↔ ( 𝑦 ∧ 𝑧 )$
- $𝑥 ↔ ( 𝑦 ∨ 𝑧 )$
- $𝑥 ↔ ¬ 𝑦$
\

Il suffit alors de montrer que toute formule propositionnelle construite avec les trois connecteurs ∧, ∨, ¬ peut effectivement être mise sous une telle forme. Intuitivement, partant d’une formule propositionnelle 𝜑, nous allons associer à chaque connecteur de 𝜑, c’est-à-dire à chaque sous-arbre de l’arbre de syntaxe abstraite de 𝜑, une nouvelle variable propositionnelle destinée à représenter la validité de ce sous-arbre. Chacune de ces nouvelles variables sera alors incluse dans une formule de l’une des trois formes précédentes, en fonction du connecteur correspondant.

== Exemple
Considérons la formule propositionnelle $𝜑 = (𝑥 ∧ 𝑦) ∨ (¬ 𝑥)$. Son arbre de syntaxe est le suivant.

#image("../img/3sat_1.png", width: 30%)

On associe à la racine de cet arbre une nouvelle variable $𝑧_1$ , à son fils gauche la variable $𝑧_2$ et à son fils droit la variable $𝑧_3$ . En écrivant la formule définis-
sant chaque nœud, on obtient la conjonction suivante, qui est équisatisfiable avec 𝜑. \
$𝑧_1 ∧ ( 𝑧_1 ↔ 𝑧_2 ∨ 𝑧_3 ) ∧ ( 𝑧_2 ↔ 𝑥 ∧ 𝑦 ) ∧ ( 𝑧_3 ↔ ¬ 𝑥 )$

Il ne reste plus qu’à transformer chaque élément de cette conjonction en une formule 3SAT.
$𝜑 ≡ &𝑧_1 ∧ (¬𝑧_1 ∨ 𝑧_2 ∨ 𝑧_3 ) ∧ (¬𝑧_2 ∨ 𝑧_1 ) ∧ (¬𝑧_3 ∨ 𝑧_1 ) \
&∧ (¬𝑧_2 ∨ 𝑥) ∧ (¬𝑧_2 ∨ 𝑦) ∧ (¬𝑥 ∨ ¬𝑦 ∨ 𝑧_2 ) \
&∧ (¬𝑧_3 ∨ ¬𝑥) ∧ (𝑥 ∨ 𝑧_3 )$

= NP-complétude
== NP
3-SAT est dans NP : on prend comme certificat une valuation qui satisfait la formule, et la vérification est polynomiale. 

On définit une fonction 𝑓 qui prend en entrée une formule 𝜑 et renvoie une paire (𝑥, 𝜑 ) telle que 𝜑 est en forme 3SAT avec au maximum 3|𝜑| clauses, et telle
que la conjonction 𝑥 ∧ 𝜑 est satisfiable si et seulement si 𝜑 l’est. On se donne pour cela les équations récursives suivantes.\
Dans chacune des équations suivantes, 𝑥 est une nouvelle variable. \ On note $𝑓 (𝜑_1 ) = (𝑦_1, 𝜑_1 ) "et" 𝑓 (𝜑_2 ) = (𝑦_2, 𝜑_2 )$ les applications de 𝑓 à des sous formes.\

$f(z) &= (z, V)\
f(V) &= (x, x)\
f(F) &= (x, not x)\
f(not phi_1) &= (𝑥, (¬𝑥 ∨ ¬𝑦_1 ) ∧ (𝑦_1 ∨ 𝑥) ∧ 𝜑_1')\
𝑓 (𝜑_1 ∧ 𝜑_2 ) &= (𝑥, (¬𝑥 ∨ 𝑦_1 ) ∧ (¬𝑥 ∨ 𝑦_2 ) ∧ (¬𝑦_1 ∨ ¬𝑦_2 ∨ 𝑥) ∧ 𝜑_1' ∧ 𝜑_2' )\
𝑓 (𝜑_1 ∨ 𝜑_2 ) &= (𝑥, (¬𝑥 ∨ 𝑦_1 ∨ 𝑦_2 ) ∧ (¬𝑦_1 ∨ 𝑥) ∧ (¬𝑦_2 ∨ 𝑥) ∧ 𝜑_1' ∧ 𝜑_2' )
$

La formule 𝜑 produite est en forme 3SAT, avec au maximum 3|𝜑| clauses.

Prouvons maintenant l'équisatisfiabilité en démontrant par récurrence structurelle sur la formule 𝜑.
Prenons P : "une valuation 𝑣 pour les variables de 𝜑 satisfait 𝜑 si et seulement si elle peut
être étendue en une valuation 𝑣 satisfiant 𝑥 ∧ 𝜑"
- Cas d'une variable $z$ : \
  On a $𝑓 (𝑧) = (𝑧, V)$, et $𝑧 ∧ V$ est satisfaite par les mêmes valuations que 𝑧.\

- Cas V : \
  On a$ 𝑓 (V) = (𝑥, 𝑥)$, pour une certaine nouvelle variable $x$. La formule $𝑥 ∧ 𝑥$ est satisfaite par la valuation qui à 𝑥 associe V.
- Cas F : \
  On a$ 𝑓 (F) = (𝑥, not 𝑥)$, pour une certaine nouvelle variable $x$. La formule $𝑥 ∧ not 𝑥$ n'est pas satisfiable, comme F ne l'est pas non plus.
- Cas 𝜑_1 ∧ 𝜑_2 :\
  Par récurrence  on a $𝑓 (𝜑_1 ) = (𝑦_1, 𝜑_1 ) "et" 𝑓 (𝜑_2 ) = (𝑦_2, 𝜑_2 )$ qui satisfont P. On a $𝑓 (𝜑_1 ∧ 𝜑_1 ) = (𝑥, 𝜑')$, avec 𝑥 une nouvelle variable et $𝜑' =(¬ 𝑥 ∨ 𝑦_1 ) ∧ (¬ 𝑥 ∨ 𝑦_2 ) ∧ (¬ 𝑦_1 ∨ ¬ 𝑦_2 ∨ 𝑥 ) ∧ 𝜑_1 ∧ 𝜑_2 $.
  - Supposons qu’il existe une valuation 𝑣 satisfiant $𝜑_1 ∧ 𝜑_2$ . En particulier,  𝑣 satisfait $𝜑_1$ , et 𝑣 satisfait également $𝜑_2$ . Par hypothèses de récurrence, il existe une extension $𝑣_1'$ de 𝑣 satisfaisant $𝑦_1 ∧ 𝜑_1$ et une extension $𝑣_2'$  de 𝑣 satisfaisant $𝑦_2 ∧ 𝜑_2$ . Du fait que chaque variable introduite par la transformation de Tseitin est neuve, les deux valuations $𝑣_1'$ et $𝑣_2'$ n’ont  comme domaine commun que les variables déjà définies dans 𝑣. Sur  ces variables, par hypothèse, $𝑣_1'$ et $𝑣_2'$ conservent les valeurs de 𝑣. Ainsi,  l’union des deux extensions $𝑣_1'$ et $𝑣_2'$ de 𝑣 est bien définie. Définissons une valuation de $v'$ par : \
    $v'(x) &= V\
    v'(z) &= v(z) "si" z in "dom"(v) \
    v'(z) &= v_1'(z) "si" z in "dom"(v_1')\
    v'(z) &= v_2'(z) "si" z in "dom"(v_2')\
    $\
    Comme on a$ 𝑣'(𝑥) = 𝑣_1' (𝑦_1 ) = 𝑣_2'(𝑦_2 ) = V$, cette valuation 𝑣' satisfait les trois clauses $¬𝑥 ∨ 𝑦_1 , ¬𝑥 ∨ 𝑦_2 "et" ¬𝑦_1 ∨ ¬𝑦_2 ∨ 𝑥$, et donc finalement satisfait bien 𝑥 ∧ 𝜑 .

  - Supposons qu’il existe une valuation 𝑣' satisfiant $𝑥 ∧ 𝜑$ . En particulier, 𝑣' satisfait les quatre clauses $𝑥, ¬ 𝑥 ∨ 𝑦_1 , ¬ 𝑥 ∨ 𝑦_2 "et" ¬ 𝑦_1 ∨ ¬ 𝑦_2 ∨ 𝑥$. On en déduit que, nécessairement, $𝑣'(𝑥) = 𝑣'(𝑦_1) = 𝑣'(𝑦_2) = V$. Ainsi, 𝑣' satisfait à la fois $𝑦_1 "et" 𝜑_1$ , et satisfait donc $𝑦_1 ∧ 𝜑_1$. Donc, par hypothèse de récurrence, 𝑣' satisfait $𝜑_1$. De même, on déduit que 𝑣' satisfait $𝜑_2$. Finalement, 𝑣' satisfait bien $𝜑_1 ∧ 𝜑_2$.
- De même pour $not phi_1$ et $𝜑_1 ∨ 𝜑_2$.

Ainsi, partant d’une formule propositionnelle 𝜑 quelconque utilisant les connecteurs ∧, ∨ et ¬, on peut construire une formule 3-SAT $𝑥 ∧ 𝜑$ de taille  proportionnelle à |𝜑|, qui est satisfiable si et seulement si 𝜑 l’est. Ainsi SAT $⩽_P$ 3-SAT, le problème SAT se réduit polynomialement au problème 3-SAT, et ce dernier est donc NP-difficile.

Donc 3-SAT est NP-complet.