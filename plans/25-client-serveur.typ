#import "@preview/cetz:0.3.0"
#import "@preview/syntree:0.2.1": tree
#import "@preview/lovelace:0.3.0": *
#import "../utils.typtp": *
#import "lecon_tplt.typtp": lecon

#show: lecon.with(
  titre: [Leçon 25 : Client-serveur : des sockets TCP aux requêtes HTTP], 
  niveau: [Première, Terminal, BTS, L3], 
  prerequis: [Couches Réseau et Internet])

= Vue d'ensemble 

== Encapsulation 

#blk2("Principe")[
  Les différents protocoles nécessaires au bon fonctionnement d'un réseau sont répartie en plusieurs couches.
]

#blk2[Protocoles][
  - [Couche applicative] HTTP : méthode d'échange de données
  - [Couche transport] TCP, UDP : : méthode d'échange de données
  - [Couche Réseau] IP : routeur
  - [Couche lien] Éthernet : switch 
]

== Relation Client-serveur

#def[Terminal][
  Un terminal est un appareil informatique qui se trouve en extrémité de chaine de communication. Les ordinateurs ou téléphones sont des terminaux, les routeurs ou switchs sont des non-terminaux. 
]

#image("../img/reseau.png")

#def[Client/Serveur][
  Un client est un terminal qui initie une connexion.\
  Un serveur est un terminal qui accepte des connexions.
]

#blk2("Remarque")[
  Selon le contacte, un même terminal peut être client ou serveur.
]

#blk2("Objectif de la leçon")[
  Comprendre le fonctionnement des couches application et transport pour les communications client-serveur.
]

= Couche transport

== Socket TCP

#def[Socket][
  Une socket est un canal de communication bidirectionnel entre 2 processus, pas forcément situé sur le même appareil. Il existe plusieurs type de socket (TCP, UDP, Unix).
]

#ex[
 _Faire exemple socket _
]

#blk2("Activité")[
  TP guidé pour faire établir une connexion entre plusieurs machines.
]

== Gestion des messages par TCP

#blk2("Principe")[
  Le protocole TCP se doit d'initialiser, de maintenir et de terminer la connexion entre le client et le serveur. Cette connexion se fait par une triple poignée de main. _Schéma_ \
  La fermeture de la connexion se fait aussi avec validation.
]

#blk2("Principe")[
  Pour chaque message envoyé on attend une réponse d'acuitement pour être sûr qu'il est arrivé à destination. S'il au bou d'un temps RTO l'ACK n'est pas reçu on renvoie le paquet.
]

Comment gérer le flux de données qui transite sur un réseau ?
#dev[Gestion de la congestion en TCP]

= Couche application 
== Protocole DNS

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

_Dessin en mode connexion TCP echange HTTP fermeture TCP_

#def[Chiffrement][
  Les paquets qui transitent via les requêtes HTTP ne sont pas chiffré, ils sont en clair donc comme ils sont encapsulé dans des paquets IP qui passent par de nombreux routeurs, on peut avoir des intercaptions de donnée. Pour résoudre celà on va chiffrer les données Grâce au protocol HTTPS
]

#dev[Présentation de HTTPS]