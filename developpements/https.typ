#import "@preview/lovelace:0.3.0": *

#import "../utils.typtp": *
#import "dev_tplt.typtp": developpement

#show: developpement.with(
  titre: [Présentation de HTTPS], 
  niveau: [Terminal], 
  prerequis: [], 
) 

#rect[source : tortue Terminal + Émile]

= Introduction 
Le protocole HTTP est en clair : les messages ne sont pas chiffrés. On sait que les paquets échangés via les protocoles de la couches applications sont découpés en paquets TCP eux même encapsulés dans des paquets IP. Ces paquets IP passent par plusieurs routeurs intermédiaires. Chaque routeur peut donc inspecter les paquets en transition et connaitre leur contenu. \

On présente le S de HTTPS qui permet de sécuriser les communications entre un client et un serveur.

On part de l'exemple de Alice qui veut communiquer avec Bob, plusieurs attaques peuvent alors arriver.

= Attaque de l'espion

== Problème
Premièrement, leurs messages ne sont pas chiffrés. Ainsi, si Alice communique une information sensible comme un mot de passe, il peut être intercepté par un utilisateur malveillant
sur le réseau.

#image("../img/https_1.png", width: 80%)

Pour résoudre ce problème : on établie une communication chiffrée : un utilisateur qui intercepte le paquet ne peut plus le lire la donnée.

== Chiffrement des données
=== Chiffrement symétrique

Soit $m$ un message en clair qu'on souhaite chiffrer, et $k$ une clé de chiffrement.\
Soit $c(m,k)$ une fonction qui chiffre $m$ avec $k$, et $d(s,k)$ qui décrypte $s$ avec $k$.\
Un chiffrement est symétrique ssi $d(c(m,k),k) = m$.

#ex[
  Le chiffrement de César, qui consiste à décaler les lettres du message de k caractères, est un chiffrement symétrique.
]

#blk2("Problème")[
  Avant d’utiliser une clef commune, Alice et Bob doivent se la communiquer. S’ils le font en clair, un espion pourra plus tard déchiffrer leurs messages.
] 

=== Chiffrement asymétrique RSA
Le chiffrement asymétrique encrypte avec une clé k et décrype le message avec une clé k'.
_Ici on se focalise sur le chyffrement RSA_

Chaque utilisateur dispose d'une clé publique $K^"pub"$ qu'ils peuvent communiquer et d'une clé privée $K^"priv"$ qu'ils ne communique jamais.\
Les messages ont la particularité d’être chiffrable et déchiffrable par les deux clefs.

On a donc : \
$ d(c(m,K_A^"pub"),K_A^"priv") = d(c(m,K_A^"priv"),K_A^"pub") = m $

Donc Alice et Bob peuvent s'envoyer leurs clés publiques et ensuite crypter les messages qu'ils envoient avec la clé publique du destinataire. Et une fois qu'ils recoivent un message ils peuvent le décrypter avec leur clé privée.
#image("../img/https_2.png", width: 70%)

#blk2("Problème")[
  La fonction de chiffrement asymetrique est lourde à calculer. On l’utilise donc au début d’une communication, pour partager une clef symétrique qui servira au chiffrement des messages ultérieurs.
]
#image("../img/https_3.png", width: 70%)

= Attaque de l'homme au milieu
== Problème
Alice ne vérifie jamais l’identité de Bob. Elle peut être victime d’une attaque de l’homme au milieu : Eve, un serveur malveillant, se fait passer pour Bob auprès d’Alice et pour Alice auprès de Bob.

#image("../img/https_4.png", width: 80%)

Pour résoudre ce problème : on utilise l'authentification : Alice a l’assurance qu’elle est bien en communication avec Bob.

== Authentification

Le protocole HTTPS repose sur l’authentification du serveur grâce à un certificat délivré par un tiers de confiance (une autorité de certification ou AC). Parmi les AC, on trouve des entreprises spécialisées, des associations à but non lucratifs et des états.\
Ces certificats sont créés à partir des clefs RSA des participants.

#image("../img/https_5.png", width: 80%)

- Etape 1 : Alice envoie un message initial ”Demande de connexion” et indique les différents algorithmes cryptographiques qu’elle supporte.
- Etape 2 : Le serveur Bob lui répond en envoyant son certificat s sa clef publique $K^"pub"_B$
- Etape 3 : Alice vérifie le certificat grâce à la clef publique de l’AC qu’elle doit posséder.
- Etape 4 : Alice utilise la clef publique de Bob pour lui communiquer de façon chiffrée une clef symétrique de chiffrement k. Elle lui envoie donc $c(k,K^"pub"_B)$
- Etape 5 : Bob déchiffre k grâce à sa clef privée.

La suite du protocole est identique à HTTP, mais tous les messages sont chiffrés avec k.
#image("../img/https_6.png", width: 70%)

Dans le cas d’une attaque de l’homme au milieu, Eve ne connaı̂t pas la clef privée de Bob et ne pourra
donc pas récupérer la clef symétrique k envoyée par Alice.
Si dans le réseau un individu intercepte les messages, il ne pourra pas non plus récupérer k. Les données
sont protégées.