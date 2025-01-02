#import "@preview/cetz:0.3.0"
#import "@preview/syntree:0.2.0": tree
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

// TODO