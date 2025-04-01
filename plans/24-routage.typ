#import "@preview/cetz:0.3.0"
#import "@preview/syntree:0.2.1": tree
#import "@preview/lovelace:0.3.0": *
#import "../utils.typtp": *
#import "lecon_tplt.typtp": lecon

#show: lecon.with(
  titre: [Leçon 24 : Échange de données et routage. Exemples.], 
  niveau: [Première, Terminal], 
  prerequis: [Graphes])

= Architecture d'un réseau

#image("../img/reseau-ecole.png", width: 90%)

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
#blk2[Protocoles][
- [Couche applicative] HTTP : méthode d'échange de données
- [Couche transport] TCP, UDP : : méthode d'échange de données
- [Couche Réseau] IP : routeur
- [Couche lien] Éthernet : switch 
]

#blk1("Définition", "Protocole éthernet")[
  Protocole dans lequel les données sont encapsulées dans une trame Éthernet qui contient l'adresse MAC source et destination. Un switch retransmet les trames.
]

#blk1("Définition", "Protocole IPv4")[
  L'Internet Protocole (IP) est un protocole de la couche réseau ayant pour but d'acheminer les messages d'un hôte à l'autre. Permet l'identifications des membres d'un même réseau local avec une adresse IP sur 32 bits (ex : 127.0.0.1).

  Cette adresse est utilisé par les routeurs pour emmener les données au bon endroit.
]

#blk2("Activité")[
  Brancher les ordinateurs entre eux avec des câbles éthernet. Définir une adresse IP pour chaque machine. Utiliser la commande PING.
]

#blk1("Définition", "Protocole TCP")[
  Transmission Control Protocol.
  Ce protocole décide comment doivent être envoyées les données, sur quel réseau et quand, et si les données doivent être renvoyées. Les données sont découpées en paquets.
  + principe TCP (connexion par triple poigné de mains...)
]

#dev[Gestion de la congestion par TCP]

= Routage

#def("Routage")[
  En pratique il n'y a pas de lien direct entre un point A et un point B du réseau, il faut passer par des routeurs intermédiaires.\
  Les routeurs doivent donc choisir le chemin à emprunter pour envoyer les données au destinataire. Pour cela les routeurs disposent d'une table de routtage qui associe chaque destination connues à un lien sortant.
]

#blk3("Représentation")[
  On représente un réseau sous forme de graphe pondéré. Le poids d'un chemin est la somme des poids de des arrêtes qu'il traverse.\
  Ici :
  - les noeuds sont des routeurs et terminaux
  - les arrêtes sont les liens
  - le poinds est le temps qu'une donnée met pour parcourir le lien
]

#blk2("Objectif")[
  Router les données de manière efficace, donc trouver le plus court chemin dans le graphe.
]

#blk2("Remarque")[
  Il est illusoire de remplir les tables de routage à la main. De plus les réseaux sont dynamique, on ajoute ou retire des routeurs ou terminaux fréquemment.
]
== Routage à vecteur de distance

#def("Routage à vecteur de distance")[
  Qualifie les protocoles de routage qui mettent à jour leurs tables de routage de manière régulière.
]

#blk1("Protocole", "Routing Information Protocole")[
  - Chaque routeur calcule la distance temporelle avec ses voisins
  - Il met dans sa table de routage ses voisins et leurs distances
  - Il envoie sa table à ses voisins
  - Quand il reçoit de nouvelle information, il met à jour sa table et envoie sa table mise à jour à ses voisins.
]

#blk2("Remarque")[
  RIP est basé sur l'aglorithme de Bellman-Ford, qui calcule les plus courts chemin d'un sommet source vers le reste des sommets d'un graphe pondéré.
]

#dev[Correction de Belleman-Ford décentralisé]

#ex[
  DESSINER EXEMPLE AVEC TABLE ROUTAGE
]

== Routage à état de lien

#def("Routage à état de lien")[
  Qualifie les protocoles de routage qui mettent à jour leurs tables de routage lorsqu'un changement dans le réseau se produit.
]

#blk1("Protocole", "Open Shortest Path First")[
  - Chaque routeur calcule la liste de ses voisins et sa distance avec eux
  - Phase d'inondation : chaque routeur partage cette information avec tout le monde
  - Après cette phase, le routeur connait tout le réseau. Il applique l'algorithme Dijkstra.
]

#blk2("Inconvénient")[
  Les routeurs doivent avoir une mémoire suffisante pour stocker tout le réseau.
]

#ex[
  DESSINER EXEMPLE AVEC TABLE ROUTAGE
]