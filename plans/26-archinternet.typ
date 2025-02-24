#import "@preview/cetz:0.3.0"
#import "@preview/syntree:0.2.1": tree
#import "@preview/lovelace:0.3.0": *
#import "../utils.typtp": *
#import "lecon_tplt.typtp": lecon

#show: lecon.with(
  titre: [Leçon 26 : Architecture d'Internet], 
  niveau: [NSI/MP2I/MPI], 
  prerequis: [Représentation binaire, graphes])

= Mise en contexte (NSI)
== Historique
#figure(caption: "Historique de certains éléments d'internet")[
  #cetz.canvas({
    import cetz.draw: *
    line((0,0), (10, 0), name: "line", mark: (end: ">"))

    set-style(content: (frame: "rect", stroke: none, padding: .3, align: "center"))

    let point(pos, text, date) = {
      content((name: "line", anchor: pos), align(alignment.center, text), anchor: "south")
      content((name: "line", anchor: pos), date, anchor: "north")
      content((name: "line", anchor: pos), [|])
    }

    point(10%, [Invention du modem], [1959])
    point(35%, [1969], [Arpanet])
    point(55%, [mot "Internet"\ TCP], [1974])
    point(75%, [1983], [DNS])
    point(90%, [4G], [2011])
    

    })

]

== Maintenant


#figure(caption: "Apercu de la forme d'internet désormais : un très grand graphe")[
  #image("../img/archi-internet.png")
]

Des milliards d'utilisateurs sont connectés à travers ce graphe. 

= Modèle des couches TCP/IP
== Motivations

#blk1("Définition", "Couche")[
  On appelle "couche" une collection de programmes et de programmes et de concepts qui intéragissent fortement entre eux, et de manière minimale avec les autres couches, via une interface pré-définie.
]

#blk2[Avantage][
  Ainsi, séparer l'architecture d'internet en couches permet d'avoir plusieurs parties indépendantes, et compatibles entre elles. Par exemple, le navigateur internet de notre téléphone fonctionne de la même façon qu'on soit en 4g ou en wifi, et inversement la communication 4g fonctionne de la même façon qu'on envoie un message ou qu'on regarde une série. 
]

== Les différentes couches
On fait une analogie entre Internet et la Poste. 

#grid(
  columns: (1fr, 1fr),
  stroke: (paint: black, thickness: 1pt, dash: "dotted"),
  align: center,
  inset: 5pt,
  grid.cell(stroke: (thickness: 0pt))[Réseau],
  grid.cell(stroke: (thickness: 0pt))[Poste],
  grid.hline(stroke: 1pt),
  grid.cell(colspan: 2)[*Couche applicative*],
  [Fais le lien entre les besoins d'une application et les messages transitant sur Internet],
  [Manière de lire et écrire une lettre dans laquelle on communique],

  grid.cell(colspan: 2)[*Couche transport*],
  [Centralise les données qu'envoient différentes applications d'une même machine et les envoies sur le réseau. C'est le lien PC $<->$ Réseau.],
  [Aller poster le courrier, aller le chercher à la boite au lettres, le donner au différents habitants d'un foyer.],
  grid.cell(colspan: 2)[*Couche Réseau*],
  [S'occupe de faire passer les données d'un réseau à un autre. C'est là qu'on décide où vont les données (ce qu'on appelle le routage).],
  [C'est le centre de tri, qui envoie les lettres vers le prochain endroit où elles doivent aller, jusqu'à la boite aux lettres de destination],
  grid.cell(colspan: 2)[*Couche lien, ou hôte réseau*],
  [Achemine effectivement les données d'un point A à un point B.],
  [Le camion de la poste, le facteur, etc]
)

== Les protocoles
#blk1[Définition][Protocole][
  Un protocole est une manière de communiquer sur laquelle les différents partis se mettent d'accord en amont.
]
Une machine ne lis que des 0 et des 1 sur un lien ! Comment les interpréter ? 

#blk2[Exemple][
  Dans l'analogie de la poste, le fait d'écrire l'adresse sur l'enveloppe sous un certain format et de coller le timbre dans un coin est un protocole ! 
]

#blk2[Remarque][Il y a des protocoles dans toutes les couches vues à la partie précédentes ! 
- [Couche applicative] HTTP, qui permet de lire les pages web
- [Couche transport] TCP, qui permet d'envoyer des données de manière fiable
- [Couche Réseau] IP, qui se charge d'acheminer les données sur Internet
- [Couche lien] USB, qui permet de transmettre des données entre deux appareils. 
]


== Principe d'encapsulation

#blk1[Définition][Paquet][
  Pour envoyer des données, la plupart des protocoles utilisent des paquets. Les données sont découpées en blocs de taille définie par le protocole (en général assez petits), et chaque bloc est précédé d'une entête avant d'être transmis.
]

#blk2[Interêts][
  - Plusieurs acteurs peuvent utiliser un même lien, grâces aux entêtes de leurs paquets qui spécifient à qui ils appartiennent
  - Si un paquet est corrompu ou perdu, on est pas obligé de tout renvoyer : on peut simplement le renvoyer. 
  - On peut faire emprunter plusieurs chemins différents aux paquets d'une même donnée, ce qui permet d'exploiter tous les liens.
]

#blk1[Principe][Encapsulation][
  Chaque protocole ajoute une nouvelle entête aux paquets. Pour le protocole de couche inferieur, cette entête deviens de la donnée, et il ajoute à nouveu une entête...
]

#grid(
  columns: (1fr, 1fr, 1fr, 1fr, 1fr),
  align: center, 
  [Application $arrow.r.hook$], [], [], [], rect(width:100%)[Données],
  [Protocole appli. $arrow.r.hook$], [], [], rect(width:100%)[Entête appli.], rect(width:100%)[Données], 
  [Protocole trans. $arrow.r.hook$], [], rect(width:100%)[Entête transport], rect(width:100%)[Entête appli.], rect(width:100%)[Données],
  [Protocole réseau $arrow.r.hook$ ], rect(width:100%)[Entête réseau], rect(width:100%)[Entête transport], rect(width:100%)[Entête appli.], rect(width:100%)[Données],
)

= Des protocoles structurants
== IP (v4)
L'Internet Protocole (IP) est un protocole de la couche réseau ayant pour but d'acheminer les messages d'un hôte à l'autre. 

Chaque hôte est identifié par une adresse sur 32 bits, souvent notée comme 4 groupes de 8 bits. 

#blk2[Exemples][
  192.168.0.1 est un adresse IPv4
]

#grid(
  columns: (1fr, 1fr, 1fr, 1fr, 1fr), 
  align: center, 
  [Paquet IP : ], rect(width:100%)[préfixe], rect(width:100%)[adresse IP source], rect(width:100%)[adresse IP dest.], rect(width:100%)[données], [], [12 octets], [4 octets], [4 octets]
)

#blk1[Définition][Routage][
  On appelle "routage" les principes et algorithmes qui régissent l'acheminenemt d'un paquet au bon endroit. Dans Internet, ce processus est fait au niveau de la couche IP.
  
  Les "routeurs" sont les machines qui servent de relai aux paquets. Ce sont les noeuds du graphe d'Internet.
]

Les routeurs gardent en mémoire des tables, pour savoir, pour chaque IP destination, à quel routeur faut-il l'envoyer ensuite. 

#dev[Convergence de l'algorithme de Bellmann-Ford]

#blk2[Problème][Les tables sont beaucoup trop grosses ! On ne peux pas stocker toutes les IP possibles dans une table. On utilise pour cela des sous-réseaux]

#blk1[Définition][sous-réseaux][Un ensemble d'adresses IP, et donc à priori de machines, peuvent être reunies au sein d'un sous réseau. Il y a alors un certain nombre de bits au début de ces adresse IP qui est commun. Ce nombre de bit $n$ est noté $\/n$.]

#blk2[Exemple][10.10.0.0/16 représente toutes les IP commençant par 10.10]

== DNS
#blk2[Motivation][
  Le protocole IP permet à Internet d'acheminer un paquet en connaissant son adresse IP de destination. 
  Mais quelle est l'adresse IP de _www.google.com_ ? 

  Le protocole DNS est un protocol de la couche application pour convertir les URL en addresses IP. 
]


#figure(caption: [Exemple d'organistation DNS])[
  #tree(rect[Racine], 
    tree(rect[.fr], rect[wikipedia.fr]),
    rect[.com],
    tree(rect[.org], rect[agreg-info.org], rect[wikipedia.org])
  )
]<fig3>

Les URL sont organisées hiérarchiquement, et chaque niveau a un serveur, qui garde en mémoire les adresses des serveurs du niveau suivant. 

Tout le monde connait l'adresse de la racine. 

#blk2[Exemple][
  Un navigateur veut résoudre l'URL `wikipedia.fr`.
+ Il demande à la racine l'adresse du serveur `.fr`
+ Il demande au serveur `.fr` l'adresse de `wikipedia.fr`
+ Il recupère la page `wikipedia.fr`
]

== TCP
TCP est un protocole de la couche transport, qui fait donc le lien entre machine et réseau. Il décide donc de ce qui doit être envoyé, renvoyé, quand, etc.

#blk2[Principes][
  TCP est un protocole de la couche transport, qui fait donc le lien entre machine et réseau. Il décide donc de ce qui doit être envoyé, renvoyé, quand, etc.

  TCP apporte un certain nombre de garanties : 
- les paquets arrivent : si un paquet est perdu, il peu être renvoyé. 
- les paquets sont ordonnées : même si ils arrivent dans le mauvais ordre, le récépteur peut les réordonner 
- les paquets sont justes : le contenu des paquets à la destination est le même qu'à la source

TCP peut aussi gérer le flux de données afin de ne pas surcharger le réseau.
]

#dev[Fonctionnement des principes de base de TCP]

== HTTP
C'est le protocole de la couche applicative qui sert à échanger des pages web ! (avec sa variante sécurisée, HTTPS).

#blk2[Principe][
  Les paquets HTTP sont en général échangés via TCP. Ils contiennent un certain nombre d'information, par exemple la page échangée, la date, l'identité des deux partis...

  HTTP fonctionne sur un principe de "méthodes", c'est à dire des actions que le client demande au serveur. Ces méthodes peuvent être, par exemple : 
  - `GET` pour obtenir une page web 
  - `POST` pour envoyer des données au serveur 

  Le serveur répond ensuite avec un code de réussite (ou d'erreur) : 
  - 200 : réussite de la requête
  - 404 : la page n'existe pas
]