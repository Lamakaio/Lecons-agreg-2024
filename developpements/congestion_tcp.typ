#import "../utils.typtp": *
#import "dev_tplt.typtp": developpement

#import "@preview/codly:1.1.1": *
#import "@preview/codly-languages:0.1.1": *

#show: developpement.with(
  titre: [Gestion de la congestion en TCP], 
  niveau: [Terminal], 
  prerequis: [Protocole TCP])

\

= Introduction

Qu'est ce que la congestion dans le protocole TCP ?
La congestion est un afflux de trasmission de données qui provoque un encombrement.

#image("../img/congestion_1.png", width: 80%)

Les routeurs ont des buffers de réception qui leur permettent de stocker les messages/paquets entrant avant de les traiter et de les router.

_Montrer un echange de message sur le schéma_

Phénomène de congestion :
Lorsque la charge injectée dans un réseau, est suppérieure à sa capacité d'acheminement.

#image("../img/congestion_2.png", width: 50%)

// On à cette effondrement car les buffers deviennent pleins et même si un routeur fini de traiter un paquet et l'envoie il y a de grande chance que le buffer de réception soit pleins lui aussi et donc le paquet sera aussi perdu.

= Détection de la congestion

Hypothèse : la perte de paquet dû à autre chose que la congestion est négligeable.

== Fenêtre d'envoie
En TCP chaque paquet est acquité. La non-réception d'un ack est un bon indicateur de congestion.

Version naïf : 
Envoie des paquet un à un. 
#image("../img/congestion_3.png", width: 40%)
On perd beaucoup de temps, on pourrait mieux utiliser la capacité du réseau.

Version fenêtre d'envoie : 
Evoie en raffale de plusieurs paquets, on attend le ACK de tous les paquets envoyés avant de renvoyer.

_faire schéma avec par exemple une fenêtre de 3_

Quelle taille choisir pour la fenêtre ?
- Fixe : non, car on peut arrivé sur un effondrement ou on peut ne pas utiliser la capacité de charge du réseau à son maximum.
- Ajuster à la capacité en temps réel de charge du réseau.

On veut donc augmenter la fenêtre jusqu'à la congestion, puis on va essayer de maximiser le nombre d'envoie sans avoir de perte de paquets.
\ 

== Taille de la fenêtre
=== Première étape
Objectif : avoir rapidement une idée de la capacité de charge du réseau.

Pour celà on va augmenter la taille de la fenêtre multiplicativement à chaque RTT.
#image("../img/congestion_5.png", width: 60%)

=== Deuxième étape
On sait maintenant qu'il y a de la congestion. On veut s'adapter à la congestion du réseau en temps réel.
Il faut donc rester proche de l'efficacité.\
Ceci peut poser des soucis d'équité. En effet, si plusieurs utilisateurs communiquent sur un même réseau on souhaite qu'ils puissent avoir un débit d'envoie équivalent (ou proche). 
Pour remédier à se problème on a le mécanisme d'AIMD (Additive Increase Multiplicative Decrease) qui dit qu'une fois arrivé sur une congestion, on diminue notre fenêtre de façon multiplicative puis on augmente celle-ci de façon aditive. \
_On peut observer sur le schéma qu'on va se raprocher du point optimal et pourquoi les autres méthodes ne fonctionnent pas_ 
#image("../img/congestion_4.png", width: 50%)

= Application TCP Reno

On applique les étapes précédentes pour gérer la taille de la fenêtre. Cette version de TCP est nommé TCP Reno.

#image("../img/congestion_6.png")
