#import "../utils.typtp": *
#import "dev_tplt.typtp": developpement
#import "@preview/codly:1.1.1": *
#import "@preview/codly-languages:0.1.1": *

#show: developpement.with(
  titre: [Fonctionnement de la pile d'execution d'un programme], 
  niveau: [MP2I?], 
  prerequis: [Mémoire, programmation assembleur])


#show: codly-init.with()


= Introduction

Dans un programme, on souhaite pouvoir stocker rapidement les données temporaires, tels que les variables locales, les addresses des fonctions et les adresses de retour, les valeurs intermédiaires des calculs ... 

La pile (ou pile d'execution, ou pile d'appel) répond à ce besoin. 

La gestion de cette pile est effectuée par des instructions statiques, générées par le compilateur (ou écrites à la main dans le cas d'un programme assembleur). Une grande partie des procédures décrites ici sont des conventions, qui peuvent dépendre de l'architecture et du système d'exploitation (on appelle ces conventions l'ABI).

//TODO petit schéma

#text(fill: red)[Ajouter la pile, le tas, tout ça schéma classique]
= Organisation de la pile 
== Appel de fonction
Le haut de la pile est pointé par le registre `sp`, stack pointer (qui peut avoir un autre nom selon l'architecture). Toutes les adresses qui dépassent `sp` sont considérées comme invalides. 

Lors d'un appel de fonction, on effectue les actions suivantes : 
- On empile la valeur des arguments de la fonction
- On sauvegarde le registre `fp`, qui encore la base de la pile de la fonction actuelle. 
- On fait pointé le registre `fp` sur la case mémoire qui contient l'ancien registre `fp` : c'est la base de la nouvelle pile.
- On alloue sur le sommet de la pile de l'espace pour les variables locales de la fonction. 

#text(fill: red)[Au tableau, commencer l'exemple simultanément]

== Retour d'une fonction

Lors d'un retour de fonction, on effectue les actions suivantes : 
- Calculer la valeur de retour
- Dépiler toutes les variables locales
- Rétablir le début de la pile au précédent
- Ecrire la valeur de retour au sommet de la pile
- Sauter à l'addresse de retour (stockée sur la pile)

== L'Exemple en C

#grid(
  columns: (1fr, 1fr),
  gutter: 3pt,
  rect(width: 100%)[
#codly(languages: codly-languages, fill: red.lighten(80%), zebra-fill: none)
```C
int f(int x) {
  int y; 
  y = x + 1;
  x = x * y;
  return x;
}
```

#codly(languages: codly-languages, fill: green.lighten(80%), zebra-fill: none)
```C
int g(int x, int y) {
  int z; 
  z = 0; 
  z = f(x);
  z = z + f(y);
  return z;
}
```
#let g(color, text) = {grid.cell(fill: color.lighten(80%), inset: 3pt, stroke: black)[text]}

#codly(languages: codly-languages, fill: blue.lighten(80%), zebra-fill: none)
```C
int main() {
  int x, y;
  x = 1; 
  y = 2; 
  x = g(x+2, y)
}
```
  ],
  grid(columns: (1fr, ), align: center, inset: 5pt, stroke: black,
  ..(
    [début], 
    [$x_"main"$],
    [$y_"main"$],
    [$x_"g"$],
    [$y_"g"$],
    ).map(grid.cell.with(fill: blue.lighten(80%))),
  
  ..(
    [début], 
    [$z_"g"$],
    [$x_"f"$],
    ).map(grid.cell.with(fill: green.lighten(80%))),

  ..(
    [début], 
    [$y_"f"$],
    ).map(grid.cell.with(fill: red.lighten(80%)))
  
  )
)

= Et en assembleur ? 
== Principe : 
L'idée, c'est d'avoir deux registres, pour le haut de la pile et la base de la pile. 
- Le haut de la pile est le registre `sp`, pour _stack pointer_. Il est mis à jour à chaque fois qu'une valeur est empilée ou dépilée, et à tout moment, toutes les valeur au delà de ce pointeur sont invalides. 
- La base de la pile est le registre `bp`, pour _base pointer_. A chaque appel de fonction, il est sauvegardé sur la pile, et la nouvelle valeur de `bp` pointe sur la sauvegarde de la valeur précédente. 

A noter que ces deux registres sont parfois nommés autrement, dépendant de l'architecture. 

== Exemple
=== Appel de fonction 

#grid(columns: (3fr, 1fr, 3fr), align: center + horizon, 
  rect()[
    #codly(languages: codly-languages, fill: luma(240))
      ```C
      f(x1, ..., xn)
      ```    
  ]
  , $->$, 
  rect()[
    #codly(languages: codly-languages, fill: luma(240))
      ```asm
      # On empile les arguments
      push [x1]
      ...
      push [xn]
      # On appelle f
      call f
      # On récupère la valeur de retour
      load r1, [sp]
      # On dépile les arguments
      pop [x1]
      ...
      pop [xn]

      ```    
  ]
)

=== Fonction et retour

#grid(columns: (3fr, 1fr, 3fr), align: center + horizon, 
  rect()[
    #codly(languages: codly-languages, fill: luma(240))
      ```C
      int f(int x1, ..., int xn) {
        int y;
        //code de f
        return y;
      }
      ```    
  ]
  , $->$, 
  rect()[
    #codly(languages: codly-languages, fill: luma(240))
      ```asm
      # On empile `bp`
      push bp
      # On place `bp` au sommet de la pile
      mv (sp-1) bp
      # Variables locales
      push 0
      # code de f
      ...
      # On met la valeur de retour dans r1
      mv [y] r1
      # On dépile les arguments
      pop [y]
      # On restaure bp 
      mv [sp] bp
      pop
      # On met le retour sur la pile et on retourne
      push r1
      ret
      ```    
  ]
)