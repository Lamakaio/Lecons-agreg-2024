#import "@preview/lovelace:0.3.0": *

#import "../utils.typtp": *
#import "dev_tplt.typtp": developpement

#show: developpement.with(
  titre: [Du MCD à la programmation orienté objet], 
  niveau: [Terminal], 
  prerequis: [], 
) 


= Introduction 
Dans le processus de conception d'une application, le passage d'un schéma modèle association (MCD) vers une modélisation orientée objet est une étape essentielle.
Elle permet de traduire les entités et les relations en classes et attributs, en exploitant les principes fondamentaux de la programmation orientée objet (POO), notamment l'héritage.

Nous allons illustrer cette transition avec un système de gestion de clients réalisant des commandes de produits, où les clients sont soit particuliers soit professionnels.

= MCD 
#image("../img/mcd-POO.png", width: 80%)

= Passage en POO
Règles appliquées :
- Chaque entité ⟶ classe.
- Chaque relation ⟶ association entre classes (attributs de type liste)
- Spécialisation Client ⟶ héritage.

= Code 
On écrit peut être pas tout le code dans les \_\_init\_\_.


```python 
class Client:
  def __init__(self, adresse, telephone):
    self.adresse = adresse
    self.telephone = telephone
    self.commandes = []

  def passer_commande(self, commande):
      self.commandes.append(commande)

class Particulier(Client):
  def __init__(self, adresse, telephone, nom, prenom):
    super().__init__(nom, adresse, telephone)
    self.nom = nom
    self.prenom = prenom

class Pro(Client):
  def __init__(self, adresse, telephone, siret):
    super().__init__(nom, adresse, telephone)
    self.siret = siret

class Produit:
  def __init__(self, nom, prix):
    self.nom = nom
    self.prix = prix

class LigneCommande:
  def __init__(self, produit, quantite):
    self.produit = produit
    self.quantite = quantite

  def prix_total(self):
    return self.produit.prix * self.quantite

class Commande:
  def __init__(self, date):
    self.date = date
    self.lignes = []

  def ajouter_produit(self, produit, quantite):
    self.lignes.append(LigneCommande(produit, quantite))

  def montant_total(self):
    return sum(ligne.prix_total() for ligne in self.lignes)
```

Si on a le temps montrer un exemple de création de commande.

= Discussion
- Héritage Client (Pro vs Particulier) car des attributs différents.
- Utilisation d'une classe intermédiaire LigneCommande pour modéliser l'association produit + quantité, ce qui est indispensable dès qu'une association porte des attributs propres.

En pratique : ici on est passé du MCD à la POO mais on n'intéragit pas avec la BDD. En pratique il faudrait faire des requêtes à la base pour pouvoir récupérer/insérer de la données. On peut en python assez facilement se connecter à une base de données et effectuer des requêtes sql. Cependant en pratique on ne fait plus cette connexion et ces requêtes à la main en sql mais on utilise des framework (ex Django) qui permettent une connexion sécurisé et empêcher certaines failles de sécurité (injection sql).


