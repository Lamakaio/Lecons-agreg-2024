#import "../utils.typtp": *
#import "dev_tplt.typtp": developpement

#show: developpement.with(
  titre: [Modification d'une base de donnée], 
  niveau: [MP2I], 
  prerequis: [Modèle relationnel, SQL])

= Problème
Un magasin possède une base de donnée pour garder en mémoire ses produits et les catégories auquels ils appartiennent. On veut maintenant rajouter des informations sur les impactes environnementaux de ces produits. Celà dans le but de pouvoir calculer quels produits ou quelles catégories ont le plus grand impact.

Initialement on a le schéma relationnel suivant :\
Categorie(#underline[idCat], nomCat)\
Produit(#underline[idProduit], nomProduit, origine, \#idCat)

On suppose qu'on a une base de donnée équivalente au schéma et qu'on peut faire des requêtes SQL sur celle-ci.

= Modification
== Emission carbone
Dans un premier temps on souhaite, ajouter pour chaque produit son equivalent en émission carbone.\ Écrire la requête SQL et modifier le schéma relationnel pour intégrer cette donnée.

```sql
ALTER TABLE Produit ADD EmissionCarbone float; 
```

Produit(#underline[idProduit], nomProduit, origine, \#idCat, *EmissionCarbone*)

== Consomation en eau 
On veut maintenant ajouter la consomation en eau du produit. Faire les modifications nécessaire.


_On pourrait ici séparer dans une table les notions d'impact du produit, dans le but de séparer les informations relatives au produit et celle relative à son impact. On aurait alors une relation 1--1, ce qui n'aurait pas grande utilité. Pour rester le plus simple on fait comme pour l'émission carbone on ajoute un champs à Produit._ 

```sql
ALTER TABLE Produit ADD ConsomationEau float; 
```


Produit(#underline[idProduit], nomProduit, origine, \#idCat, EmissionCarbone, *ConsomationEau*)

== Détail impact
Maintenant on se rend compte que les impactes en eau et en emission carbones sont calculés sur 3 quantificateurs différents, qu'on veut stocker. Les données sont Agriculture, Embalage et Transport. L'impacte est donc la somme de ces 3 valeurs. Modifier la base de donnée pour sauvegarder ces données.

_Ici on va devoir créer une nouvelle table pour stocker les données. On créé la table impactProduit qui va contenir ces données pour un type et un produit. On a donc une clé primaire sur type et idProduit. Il faut penser à supprimer les colonnes que l'on a créées précédemment._

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

ALTER TABLE Produit DROP column EmissionCarbone;
ALTER TABLE Produit DROP column ConsomationEau;
```

_ Maintenant il est facile d'ajouter un indicateur comme transformation, ou un type d'impact_

= Requête
 En supposant la base de donnée remplie de valeur, faites la requête permettant d'identifier la catégorie qui a la plus grande émission carbone. Que changer pour avoir celle qui consomme le plus d'eau ?

```sql
WITH carboneProduit as (
  SELECT P.idCat, I.idProduit, (I.agriculture + I.embalage + I.transport) as impactCabone
    FROM ImpactProduit I
    JOIN Produit P on P.idProd = I.idProd
    WHERE I.type = 'EmissionCarbone'
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