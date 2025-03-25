#import "../utils.typtp": *
#import "dev_tplt.typtp": developpement

#show: developpement.with(
  titre: [Modification d'une base de donnée], 
  niveau: [MP2I], 
  prerequis: [Modèle relationnel])

= Problème
On a un magasin qui possède une base de donnée qui comporte des produits qui appartiennent à des catégories. On veut maintenant rajouter l'information de l'empreinte de ces produits. Pour pouvoir calculer quels produits ou quelle catégories emettent le plus.

Initialement on a le schéma relationnel suivant :
Categorie(#underline[idCat], nomCat)\
Produit(#underline[idProduit], nomProduit, origine, \#idCat)

On suppose qu'on a une base de donnée équivalente au schéma et qu'on peut faire des requêtes SQL sur celle-ci.

= Modification
== Emission carbone
Dans un premier temps on souhaite ajouter pour chaque produite son equivalent en émission carbone. Écrire la requête SQL et modifierle schéma relationnel en fonction.

```sql
ALTER TABLE Produit ADD EmissionCarbone float; 
```
_Modifier en_ \
Produit(#underline[idProduit], nomProduit, origine, \#idCat, EmissionCarbone)

== Consomation en eau 
On veut maintenant ajouter la consomation en eau du produit. Faire les modifications.

On pourrait Séparer dans une table les notions d'impact du produit pour séparer les informations relative au produit et celle relative à son impact. On aurait alors une relation 1--1, ce qui n'aurait pas grande utilité. Pour rester le plus simple on fait comme pour l'émission carbone on ajoute un champs à Produit. 

```sql
ALTER TABLE Produit ADD ConsomationEau float; 
```
_Modifier en_ \
Produit(#underline[idProduit], nomProduit, origine, \#idCat, EmissionCarbone, ConsomationEau)

== Détail impact
Maintenant on se rend compte que les impactes en eau et en emission carbones sont calculer sur 3 aspets différents et qu'on veut stocker ceux-là. Les données sont Agriculture, Embalage et Transport. Modifier la bade de donnée pour sauvegarder ces données.

#image("../img/modification_bdd.png", width: 60%)

Categorie(#underline[idCat], nomCat)\
Produit(#underline[idProduit], nomProduit, origine, \#idCat, $cancel("EmissionCarbone")$, $cancel("ConsomationEau")$)
ImpactProduit(#underline[type,\#idProduit], agriculture, embalage, transport)

```sql
CREATE TABLE ImpactProduit (
  type ENUM('EmissionCarbone', 'ConsomationEau'),
  agriculture float,
  embalage float,
  transport float,
  idProduit integer,
  FOREIGN KEY idProduit REFERENCES Produit(idProduit),
  PRIMARY KEY (type, idProduit)
); 

ALTER TABLE DROP column EmissionCarbone;
ALTER TABLE DROP column ConsomationEau;
```

= Requête
 En supposant la base de donnée remplie de valeur, faites la requête permettant d'identifier la catégorie qui a la plus grande émission carbone.

```sql
WITH carboneProduit as (
  SELECT idCat, idProduit, (I.agriculture + embalage + transport) as impactCabone
    FROM ImpactProduit
    WHERE type = 'EmissionCarbone'
)

SELECT nomCat, moyenne_carbone 
FROM (
  SELECT idCat, AVG(impactCabone) as moyenne_carbone
  FROM carboneProduit
  GROUP BY idCat
) 
JOIN Categorie C on C.idCat = idCat
ORDER BY moyenne_carbone desc 
LIMIT 1;
```