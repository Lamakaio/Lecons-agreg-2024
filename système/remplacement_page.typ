#import "@preview/cetz:0.3.0"
#import "@preview/syntree:0.2.0": tree
#import "@preview/lovelace:0.3.0": *
#import "@preview/codly:1.1.1": *
#import "@preview/codly-languages:0.1.1": *
#import "../utils.typtp": *
#import "../developpements/dev_tplt.typtp": developpement


#show: developpement.with(
  titre: [Remplacement de pages], 
  niveau: [Euh jsp], 
  prerequis: [Table des pages])
= Introduction
Que fait on quand la mémoire physique est pleine ? On met des pages dans une autre mémoire (disque). En fait, on utilise la RAM comme une sorte de cache, avec de l'éviction...

Le problème est alors de savoir quelle page on garde, et quelle page on remplace. C'est le sujet de ce cours. 

= Objectif 
L'objectif lorsqu'on parle de startégie de remplacement de page, c'est de minimiser les évictions. En effet, une éviction implique 
d'écrire une page sur le disque ! Ce qui est long. 

On peut alors définir une stratégie "optimal" : lorsqu'on choisi une page à évincer, on choisi toujours celle qui sera utilisée dans le plus longtemps. Ainsi, on se garantis un minimum d'évictions. 

Evidemment, ce n'est pas très réaliste, sauf dans un cadre très restreint, parce que ça implique de connaitre le futur. On va donc chercher des heuristiques qui s'approchent de cet optimal dans des programmes réèls. 

= Une première startégie : FIFO
FIFO = First In First Out 

La première page a avoir été chargée sera la première evincée. 

Implémentation : un peu couteux, car il faut garder en mémoire l'ordre de chargement des pages. 
Cela peut être un index, une liste chainée...

Mais on a des problèmes avec cette méthode : 
- déjà, à priori, rien ne nous dit qu'une page qui a été chargée il y a longtemps n'est plus importante. Peut être qu'on y accède en permanence ! 
- Ensuite, on a une propriété un peu facheuse : parfois, en augmentant la mémoire, on augmente le nombre de défauts de page. C'est l'anomalie de Bélády. 
#figure(caption: "Anomalie de Bélády")[
  #grid(align: center, columns: (1fr, 2fr, 2fr), gutter: 10pt, [Page accédées],
  [Mémoire de 3 pages],
  [Mémoire de 4 pages], 
  [3], [x x 3], [x x x 3],
  [2], [x 3 2], [x x 3 2],
  [1], [3 2 1], [x 3 2 1],
  [0], [2 1 0], [3 2 1 0],
  [3], [1 0 3], text(stroke: green)[3 2 1 0],
  [2], [0 3 2], text(stroke: green)[3 2 1 0],
  [4], [3 2 4], [2 1 0 4],
  [3], text(stroke: green)[3 2 4], [1 0 4 3],
  [2], text(stroke: green)[3 2 4], [0 4 3 2],
  [1], [2 4 1], [4 3 2 1],
  [0], [4 1 0], [3 2 1 0],
  [4], text(stroke: green)[4 1 0], [3 2 1 0],
  )
]


= LRU ? 
== Une solution attractive
On peut supposer que si une page n'a pas été utilisée depuis longtemps, alors elle ne le sera pas dans le futur non plus. C'est différent de FIFO, car on parle de l'utilisation des pages, pas de leur allocation. 

== Quasiment impossible à implémenter en pratique
Cela implique de garder en mémoire quelle page à été utilisée en dernier. C'est à dire qu'à chaque accès mémoire, il faudra mettre à jour une structure de donnée, sur laquelle on sera ensuite capable d'extraire le minimum en temps raisonnable (par exemple, une file de priorité !). Sachant qu'il y a des milliers voir millions de pages. 

C'est trop lent en pratique. 

= Dans la réalité
== Les outils à notre disposition 
Le processeur offre quelques outils pour faciliter l'implémentation de l'éviction des pages : 
- 
