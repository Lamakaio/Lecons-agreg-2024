
#import "@preview/lovelace:0.3.0": *

#import "../utils.typtp": *
#import "dev_tplt.typtp": developpement

#show: developpement.with(
  titre: [Requêtes avancées avec ou sans agrégation], 
  niveau: [MPI], 
  prerequis: [SQL]
)
\
= Trouver les produits les moins cher 

== Avec agrégation 
```sql
SELECT * 
FROM Produit
WHERE prix = (SELECT MIN(prix) FROM Produit where poids > 1);
```

== Sans agrégation
\
* Avec LIMIT 1 :*
```sql
SELECT * 
FROM Produit
WHERE prix = (SELECT * 
  FROM Produit
  ORDER BY prix 
  LIMIT 1);
```

*Avec EXCEPT :* \
On prend l'ensemble des produits qu'on soustrait aux produits qui ne sont pas les moins cher.

$("Produit") - (sigma_"p1.prix<p2.prix" (rho_"p1" ("Produit")times rho_"p2" ("Produit")))$

```sql
SELECT * 
FROM Produit 

EXCEPT 

SELECT DISTINCT p1.*
FROM Produit p1, Produit p2
WHERE p1.prix < p2.prix;
```
*Avec NOT IN :* \
On pourrait aussi l'écrire 
```sql
SELECT * 
FROM Produit 
WHERE idProduit NOT IN (
  SELECT DISTINCT p1.idProduit
  FROM Produit p1, Produit p2
  WHERE p1.prix < p2.prix
);
```

= Trouver les clients qui ont commandé tous les produits de la base de donnée

== Avec agrégation 

```sql
SELECT idClient
FROM Commande 
GROUP BY idClient
HAVING COUNT(DISTINCT idProduit) = (SELECT COUNT(*) FROM Produit)
```

== Sans agrégation
$$\
Tout les clients - ceux qui ont un produit non commandé(= toutes les paires client\*produit - celle qui existe dans commande)

$pi_"idClient" ("Commande") - pi_"idClient" ( pi_"idClient, idProduit" ("Client"times"Produit") - pi_"idClient, idProduit" ("Commande"))$

```sql
SELECT idClient
FROM Commande 

EXCEPT

SELECT idClient
FROM (
  SELECT idClient, idProduit
  FROM Client, Produit

  EXCEPT

  SELECT idClient, idProduit
  FROM Commande
)
```