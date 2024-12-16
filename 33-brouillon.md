- [Lecon 33 : Formules de calcul proposotionel : représentation, formes normales, satifiabilité. Applications.](#lecon-33--formules-de-calcul-proposotionel--représentation-formes-normales-satifiabilité-applications)
  - [Syntaxe (MP2I)](#syntaxe-mp2i)
    - [Formules propositionelles](#formules-propositionelles)
      - [Def](#def)
      - [Représentation des formules propositionelles](#représentation-des-formules-propositionelles)
  - [Sémantique (MP2I)](#sémantique-mp2i)
    - [Valutation et sémantique](#valutation-et-sémantique)
    - [satifiabilité](#satifiabilité)
    - [Formes normales](#formes-normales)
    - [Quelques applications](#quelques-applications)
  - [SAT (MPI)](#sat-mpi)
    - [Définition](#définition)
    - [Puissance et complexité de SAT](#puissance-et-complexité-de-sat)
    - [Algorithme de Quinne](#algorithme-de-quinne)

# Lecon 33 : Formules de calcul proposotionel : représentation, formes normales, satifiabilité. Applications.

## Syntaxe (MP2I)
### Formules propositionelles
#### Def 
Construction inductive
- Cas de base : variable dans un ensemble V, true, false
- constructeurs (avec -> et <->)

ex : `x <-> !!x`
rq : une formule est toujours finie.

Exercice : Définir inductivement l'ensemble des variables d'une formule.

#### Représentation des formules propositionelles
Plusieurs représentation équivalentes des formules, qui seront illustrées par l'exemple :
`phi = !(x v y) <-> ((!x) ^ (!x))`

- la représentation usuelle, aussi appelée forme infixe, avec des parenthèses. On se permettra d'omettre certaines parenthèses 
dans certains cas, ce qui sera justifié par la sémantique : associativité de ^, v et on considère ! prioritaire sur les autres constructeurs
, ainsi que v et ^ prioritaires sur -> et <->

Il est donc acceptable d'écrire `phi = !(x v y) <-> !x ^ !y`

- la notation sous forme d'arbre syntaxique : les feuilles sont les cas de base, et les noeuds les constructeurs. 

- la forme préfixe (~ notation polonaise inversée) : c'est le parcours préfixe de l'arbre.
`phi = <-> ! v x y ^ ! x ! y`

Def : l'arbre syntaxique permet de définir la profondeur (profondeur max d'une feuille) et la taille (nombre de noeuds) d'une formule propositionelle. 

## Sémantique (MP2I)
### Valutation et sémantique
Def : Une valuation est une fonction sigma V -> B = {0, 1}
On définit la sémantique `[phi]sigma` d'une formule phi comme : 
`true -> 1, false -> 0, var -> sigma(var)`
`non -> 1 ssi = 0`
`et -> 1 ssi =1 et =1`
`ou -> 1 ssi =1 et/ou =1`...


Def : une table de vérité est une table contenant pour colonnes chacune de variable de la formule, et la formule. 
Elle donne la sémantique de la formule pour chaque valuation possible de ses variables. 
2^n lignes !  (faire exemple)

Exercice : trouvez des formules équivalents à true, false, <-> et -> en utilisant seulement !, v et ^. 

Montrer l'équivalence avec des tables de vérité. 

Dans la suite, on pourra considérer qu'on utilise seulement ces constructeurs dans nos preuves. 

### satifiabilité
Def : Une formule logique phi est :
- satisfiable si il existe une valuation sigma tq =1
- une tautologie si tjr =1
Un ensemble de formule est satifiable si il existe une valuation tq tt =1 \
Deux formules sont équivalentes (noté triple =) si pr tt valuation elles ont la même sémantique. 


### Formes normales
Def : 
- un littéral est une formule de la forme v ou non v, ou v est une variable.
- une clause disjonctive (resp conjonctive) est une formule de la forme
- forme normale conjonctive si elle est de la forme ^ Ci 

Rq : parfois, on utilise simplement "clause" pour parler de clause disjonctive.

Proposition : Toute formule est équivalente à une formule en FNC et en FND. 
Si phi pas tautologie, FND unique. Si !phi n'est pas une tautologie, FNC unique. (à l'ordre des facteurs près)

Exercice : Comment trouver la FND ? Quelle est la complexité de la transformation ? 

### Quelques applications
Théorème : Toute fonction `{0, 1}^n -> {0, 1}` est équivalente à une formule propositionbelle, cqd qu'il existe une formule avec les variables `x1, ..., xn `
tq quelque soit sigma, `f(sigma(x1), ..., sigma(xn)) = [phi]sigma`

Développement 1 : equivalence entre les formules propositionelle et les circuits combinatoires

## SAT (MPI)
### Définition

Def : Le problèmes SAT est un problème de décision 
entrée : une formule logique
sortie : est elle satifiable ? 

Rq : il existe des variantes du problème SAT : CNF-SAT se restreint aux formules sous FNC. \
n-SAT : FNC avec au plus n littéraux par clauses. 

### Puissance et complexité de SAT

Théorème (Cook) : SAT est NP-complet

Theorème (Tseitin) : CNF-SAT est NP-complet
Plus précisément, la transformation de Tseitin construit en temps polynomial une formule equisatifiable (mais pas équivalente !)

Développement 2 : 3-SAT est NP-complet 

Rq : 2-SAT est dans P !

### Algorithme de Quinne
L'algorithme de Quinne résout le pb CNF-SAT par backtracking. Il se généralise à SAT en le précédant de la transformation de Tseitin. 

(cf feuille)

Rq : l'algo est exponentiel.
Exercice : prouver la terminaison.