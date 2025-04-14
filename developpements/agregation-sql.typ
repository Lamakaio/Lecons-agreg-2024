
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
WHERE prix = (SELECT MIN(prix) FROM Produit);
```

== Sans agrégation
\
* Avec LIMIT 1 :*
```sql
SELECT * 
FROM Produit
WHERE prix = (SELECT prix
  FROM Produit
  ORDER BY prix 
  LIMIT 1);
```

*Avec EXCEPT :* \
On prend l'ensemble des produits qu'on soustrait aux produits qui ne sont pas les moins cher.
Les produits qui ne sont pas les moins cher = tous les produits qui ont un produits plus chers 
$pi_"p1.idProduit" ("Produit") - pi_"p1.idProduit" (sigma_"p1.prix>p2.prix" (rho_"p1" ("Produit")times rho_"p2" ("Produit")))$

Faire dessin tableau en parrallèle
#grid(columns: (2fr, 1fr, 3fr), align: horizon,
grid.cell[
  #table(columns: (5em, 5em), [idProduit], [prix], [1], [2], [2], [3], [3], [1])
],
[*$-$* (+select)]
,
grid.cell[
  #table(columns: (5em, 5em, 5em, 5em), [idProduit1], [prix1],[idProduit2], [prix2], [1], [2], [2], [3], [1], [2], [3], [1] )
  ...
]
)


```sql
SELECT * 
FROM Produit 

EXCEPT 

SELECT DISTINCT p1.*
FROM Produit p1, Produit p2
WHERE p1.prix > p2.prix
and p1.idProduit <> p2.idProduit; -- à ajouter apres avec dessin tableau
```
On modifie le code qu'on a déjà sans effacer en ecrivant à côté pour montrer qu'on peut faire JOIN à la place de produit cartésien et que c'est plus performant. Puis qu'on pourrait utiliser NOT IN mais que c'est pareil en performance.\

```sql
SELECT * 
FROM Produit 
WHERE idProduit NOT IN (
  SELECT DISTINCT p1.idProduit
  FROM Produit p1 JOIN Produit p2 on p1.idProduit <> p2.idProduit
  WHERE p1.prix > p2.prix
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


#grid(columns: (1fr, 1fr), 
grid.cell[
  #table(columns: (5em, 5em), [idClient], [idProduit], [1], [2], [4], [2], [1], [3], [1], [1], [4], [1] )
],
grid.cell[
  #table(columns: (5em, 5em), [idClient], [idProduit], table.cell(rowspan: 3)[1], [2], [3], [1], table.cell(rowspan: 2)[4], [2], [1] )
]
)

== Sans agrégation
$$\
Tout les clients - ceux qui ont un produit non commandé(= toutes les paires client\*produit - celle qui existe dans commande)

$pi_"idClient" ("Commande") - pi_"idClient" ( pi_"idClient, idProduit" ("Client"times"Produit") - pi_"idClient, idProduit" ("Commande"))$


Faire code couleur de traduction

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


= Conclusion 
L'utilisation de fonctions d'agrégations n'est pas toujours nécéssaire mais rend en général l'écriture de la requête plus facile. De plus les requêtes par agrégations sont souvent plus performantes que les versions sans fonction d'agrégation. \
Attention pas toutes les requêtes peuvent s'écrire sans fonction d'agrégation. Par exemple la fonction Count() n'est pas remplacable dans certains cas, si on veut par exemple savoir combien de produits on a dans la base de donnée on va devoir utiliser la fonction count().