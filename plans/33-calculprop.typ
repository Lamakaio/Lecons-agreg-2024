#import "@preview/cetz:0.3.1"
#import "@preview/syntree:0.2.0": tree

#set page(paper: "a4")
#set document(title: "Leçon 33")
#set heading(numbering: "I.1)")

#let s = state("n", 0)
#let n() = {
  s.update(n => n+1)
  context s.get()
}

#let s2 = state("d", 0)
#let d() = {
  s2.update(d => d+1)
  context s2.get()
}
#let def(type, name, body) = {
  underline()[ _#type #n()_ \[#name\]\ ]
  block(
  body,
  width: 100%,
  above:5pt,
  inset: 5pt,
  fill: luma(95%),
  stroke: (left: 1.5pt + luma(30%))
)
}

#let ex(type, body) = {
  underline()[ _#type #n()_\ ]
  block(
  body,
  width: 100%,
  above:5pt,
  inset: 5pt,
  fill: luma(100%),
)
}

#let dev(name) = {
  block(
  [Développement #d() : #name],
  width: 100%,
  above:5pt,
  inset: 5pt,
  fill: luma(100%),
  stroke: (rest: 1.5pt + luma(30%))
)
}

#let tabledeverite(vars, formula) = {
  let dict = (:)
  let t = (..vars.map(x => [$#x$]), $phi$)
  for x in vars {
    dict.insert(x, 0)
  }
  for i in range(0, calc.pow(2, vars.len())) {
    let p1 = true
    for (x, val) in dict.pairs() {
      t.push([#val])
      if p1 and val == 1 {
        dict.at(x) = 0
      }
      if p1 and val == 0 {
        dict.at(x) = 1
        p1 = false
      }
    }
    t.push([#eval(formula, scope: dict)])
  }
  table(columns: 4, ..t)
}


#align(center, text(17pt)[
  *Leçon 33 : Formules du calcul propositionnel :  représentations, formes normales, satisfiabilité, applications*
])

Niveau : MP2I, MP2I
#align(right)[Prérequis : induction]
#outline()
= Syntaxe (MP2I)
== Formules Propositionelles


#def()[Def][formule propositionelle][
  Soit $V$ un ensemble de variables. \
  On définit inductivement l'ensemble des formules propositionelles sur $V$ comme : 
  - [cas de base]
    - Si $x in V$ alors $x$ est une formule
    - $top$ et $bot$ sont des formules
  - [cas inductif] Si $phi$ et $psi$ sont des formules alors : 
    - $(not phi)$ est une formule
    - $(phi or psi)$, $(phi and psi)$, $(phi -> psi)$ et $(phi <-> psi)$ sont des formules
  ]

#ex()[Exemple][ 
  $(x <-> (not (not x)))$ est une formule
]

#ex()[Exercice][
  Définir (inductivement) l'ensemble des variables apparaissant dans une formule. 
]

== Représentation des formules
On illustrera différentes représentations des formules sur l'exemple : \ 
$phi = ((not (x or y)) <-> ((not x) and (not y)))$

- Dans la représentation usuelle (aussi appelée forme infixe), on se permet d'ommetre certaines parenthèses, en appliquant l'associativité et des priorité sur les opérateurs : $not >> or, and >> <->, ->$. Cela sera justifié par la sémantique.\ $phi = not (x or y) <-> not x and not y $

#figure(caption: [Arbre syntaxique de $phi$])[
  #tree($<->$,
    tree($not$, 
      tree($or$, "x", "y")),
    tree($and$, 
      tree($not$, "x"), 
      tree($not$, "y")))
]<syntree>


- On peut noter une formule sous forme d'arbre syntaxique : les feuilles sont les cas de base, et les noeuds sont les constructeurs (@syntree).

#def[Def][Hauteur et taille d'une formule][
  L'arbre syntaxique permet de définir :
  - la hauteur d'une formule, qui est la profondeur maximale d'une feuille de l'arbre
  - la taille d'une formule, qui est le nombre de neouds de l'arbre.
]

= Sémantique (MP2I)
== Valuation et sémantique

#def[Def][Valuation][
  Une valuation est une fonction $sigma:V->{0, 1}$.
]
#def[Def][Sémantique d'une formule][
On définit inductivement la sémantique (ou valeur de vérité) $[phi]_sigma$ d'une formule $phi$ pour une valuation $sigma$ comme : 
- $[top]_sigma = 1$, $[bot]_sigma = 0$
- $forall x in V, [x]_sigma = sigma(x)$
- $[not phi]_sigma = 1 "ssi" [phi]_sigma = 0$
- $[phi_1 and phi_2] = 1 "ssi" [phi_1]_sigma = 1 "et" [phi_2]_sigma = 1$
- $[phi_1 or phi_2] = 1 "ssi" [phi_1]_sigma = 1 "ou" [phi_2]_sigma = 1$
- $[phi_1 -> phi_2] = 1 "ssi" [phi_1]_sigma = 0 "ou" [phi_2]_sigma = 1$
- $[phi_1 <-> phi_2] = 1 "ssi" [phi_1]_sigma = [phi_2]_sigma$
]

#def[Def][table de vérité][
  Une table de vérité est un tableau donnant la sémantique d'une formule pour chaque valuation de ses variables.
]

#figure(caption: [Table de vérité pour $phi = not x or (y and z)$])[
  #tabledeverite(("x", "y", "z"), "calc.max(1 - x, y * z)")
]<tableverite>

#ex[Remarque][
  Si $phi$ contient $n$ variables distinctes, sa table de vérité a $2^n + 1$ lignes. C'est vite très grand !
]

== Notion d'équivalence et calcul sur les formules
#def[Def][équivalence de formules][
  Deux formules $phi_1$ et $phi_2$ sont _équivalentes_ si $forall sigma: V -> {0, 1}, [phi_1]_sigma = [phi_2]_sigma$. \
  On note $phi_1 eq.triple phi_2$
]

#def[Propriété][des opérateurs][
  On a les propriétés suivantes : 
  - $and "et" or$ sont commutatifs, associatifs, et distributifs l'un sur l'autre.
  - $<->$ est commutatif
]

#ex[Exemple][
  $(a or b) and d eq.triple (a and d) or (b and d)$\
]

#def[Propriété][Lois de De Morgan][
  On a les deux propriétés suivantes : 
  - $not (phi_1 or phi_2) eq.triple not phi_1 and not phi_2 $
  - $not (phi_1 and phi_2) eq.triple not phi_1 or not phi_2 $
]

#ex[Exercice][
  Trouvez des formules équivalentes à $top, bot, phi_1 -> phi_2 "et" phi_1 <-> phi_2 $ en utulisant simplement $or, and "et" not$.
]
#ex[Remarque][
  Dans la suite, on se permettra de considérer des formules contenant seulement des variables et les opérateurs $or, and "et" not$.
]

== Satisfiabilité
#def[Def][Satisfiabilité][
  - Si $phi$ est une formule, on a :
    - $phi$ est satifiable si $exists sigma: V -> {0, 1}, [phi]_sigma = 1$
    - $phi$ est une tautologie si $forall sigma: V -> {0, 1}, [phi]_sigma = 1$
  - Si $E$ est un ensemble de formules, $E$ est satifiable si $exists sigma : V -> {0, 1}, forall phi in E, [phi]_sigma = 1$
]

#ex[Exemples][
  - $phi = (x or y) and not x$ est satifiable avec $y = 1$ et $x = 0$
  - $phi = x and not x$ n'est pas satifiable
] 

== Formes normales
#def[Def][formes normales][
  - un littéral est une formule de la forme $x "ou" not x "pour" x in V$
  - Une clause disjonctive (resp conjonctive) est une formule $or.big_(i=0)^n l_i$ (resp $and.big_(i=0)^n l_i$) avec $(l_i)_(0 <= i <= n)$ des littéraux
  - Une formule $phi$ est en forme normale conjonctive (resp disjonctive) si elle est de la forme $and.big_(i=0)^p C_i$ (resp $or.big_(i=0)^p C_i$) avec $(C_i)_(0<=i<=p)$ des clauses disjonctives (resp conjonctives) \
  En francais, une FNC est une conjonction de disjonction, et une FND est une disjonction de conjonctions. 
]

#ex[Remarque][
  On dit souvent simplement "clause" pour parler de clause disjonctive.
]

#def[Proposition][équivalence à une forme normale][
  Toute formule $phi$ est équivalente à une formule en FNC et à une formule en FNC. De plus (à l'ordre des  facteurs près) : 
  - si $phi$ n'est pas une tautologie, la FND est unique
  - si $not phi$ n'est pas une tautologie, la FNC est unique 
]  

== Quelques applications
#def[Théorème][Modélisation][
  Toute fonction booléenne est équivalente à une formule propositionelle. C'est à dire : \
  $forall f: {0, 1}^n -> {0, 1}, exists phi "une formule sur les variables" V = {x_1, ..., x_n}, \ "tel que" forall sigma : V -> {0, 1}, f(sigma(x_1), ..., sigma(x_n)) = [phi]_sigma$
]

#dev[Equivalence entre formule propositionelle et circuit combinatoire]

= Le problème SAT (MPI)
== Définition
#def[Def][problème SAT][ 

]