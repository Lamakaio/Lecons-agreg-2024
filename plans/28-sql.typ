#import "@preview/cetz:0.3.0"
#import "@preview/syntree:0.2.1": tree
#import "@preview/lovelace:0.3.0": *
#import "../utils.typtp": *
#import "lecon_tplt.typtp": lecon

#show: lecon.with(
  titre: [Leçon 28. Requêtes en langage SQL], 
  niveau: [Terminal/MP2I], 
  prerequis: [Modèle relationnel])

= Introduction 

On fait le lien avec la leçon précédente, modèle relationnel et conception de base de donnée.\
Maintenant qu'on a notre schéma relationnel on le traduit en table SQL. Dans un premier temps on va donc construire nos table, puis apprendre à inserer/modifier/supprimer des données à l'intérieur de celles-ci pour enfin pouvoir faire des requêtes d'accès aux données dont on a besoin.

#def("Langage SQL")[
 Structured Query Language (SQL): langage déclaratif qui permet de construire une base de donnée et de stocker, et accéder efficacement aux données contenue. 
]

#def("SGBD")[
  Systèmes de gestion bases de données (SGBD) : Système permettant de faire des requête en langage SQL. Chaque SGBD à de différentes notation et règle mais ont tous une base commune.
]

#ex[
  On va utiliser le modèle relationnel suivant tout au long de la leçon :\
  Produit(#underline[idProduit], nom, prix, poids)\
  Client(#underline[idClient], nom, adresse, ville)\
  Commande(#underline[idProduit], #underline[idClient], quantité, date)\
  DESSINER ENTITE/ASSOCIATION
]

= Création de la base de donnée 

#def("Table")[
  Une table SQL est un tableau où chaque colonne est étiquetée par un attribut et contient des données de même type et ou chaque ligne est appelé une entrée ou un enregistrement.
]

#ex[
  DESSINER UNE TABLE
]

#ex[*(Hors-Programme)*
```sql
CREATE TABLE Produit (idProduit INTEGER PRIMARY KEY,
                      nom VARCHAR(30),
                      prix FLOAT,
                      poids FLOAT);
CREATE TABLE Client  (idClient INTEGER PRIMARY KEY,
                      nom VARCHAR(30),
                      ville VARCHAR(100));
CREATE TABLE Commande (idProduit INTEGER,
                      idClient INTEGER,
                      quantite INTEGER,
                      date DATE,
                      FOREIGN KEY (idProduit) REFERENCES Produit(idProduit),
                      FOREIGN KEY (idClient) REFERENCES Client(idClient),
                      PRIMARY KEY (idProduit, idClient, date) );

```
]

#def("type de donnée")[
  SQL possède de nombreux types de données. On a les type numérique INTEGER, FLOAT, les types textuels VARCHAR(n), TEXT ou plus spécifique comme DATE ou DATETIME. \
  Sur ces types s'appliquent les opérations de comparaisons : $<, <=, =, >=, >, <>$
]

#def("Valeur NULL")[
  Un champ peut avoir un type _nullable_ qui permet d'avoir la valeur NULL qui représente l'absence de valeur.
]

= Inserer / Modifier / Supprimer des données ()

Une fois les tables créées on peut ajouter des données à l'intérieur, on peut aussi modifier ou supprimer les données éxistantes.

#def("Insertion")[
  Pour ajouter une entrée dans une table on utilise les mots clés "INSERT INTO" suivie du nom de la table et du n-uplet.
]
#def("Modification")[
  Pour modifier une ou plusieurs entrées dans une table on utilise le mot clé "UPDATE" suivie du nom de la table puis de "SET" avec les modifications à effectuer et potentiellement un "WHERE" qui définie sur quelles entrée les modifications doivent être adoptées.
]
#def("Suppression")[
  Pour supprimer une ou plusieurs entrées dans une table on utilise le mot clé "DELETE" suivie du nom de la table et potentiellement un "WHERE" qui définie quelles entrée doivent être supprimées.
]

#ex[
  ```sql
  INSERT INTO Produit VALUES (1, 'Chocolat', 2.5, 0.2);
  UPDATE Produit SET prix = 2 WHERE idProduit = 1;
  DELETE Produit WHERE idProduit = 1;
  ```
]


= Requête de sélection basique
#def("Selection")[
  Une requête de séléction prend en entrée une ou plusieurs tables et renvoie une nouvelle table. Cette table est temporaire, elle n'est pas stocké dans la base de donnée.
]

#blk1("Syntaxe", "SELECT")[
  ```sql
  SELECT nom, prix  --clause SELECT 
  FROM Produit      --clause FROM
  WHERE poids > 2;  --condition de séléction
  ``` 
]

#def("Règles de séléction sur la clause SELECT")[
  - le FROM et le WHERE sont optionnel on peut faire _SELECT 42, 'nom';_ qui renvoie une table d'une ligne avec 42 et nom
  - on peut faire des calcules directement sur les données d'une colonne sur un select, et on peut renomer la colonne dans la table résultat :\
    SELECT nom, prix/poids AS prix-au-kg, FROM Produit
]
#def("Règles de séléction sur la condition WHERE")[
  - la condition après le mot clé WHERE est une condition qui renvoie un booléen et renvoie les entrées qui satisfont cette condition
  - le WHERE est optionnel 
  - pour la condition on peut utiliser les attributs de la table en cours de sélection, des constante numérique, des chaines de caractères, la constante NULL, des expression arithmétique, les opérateurs $<, <=, =, >=, >, <>$, les connecteur logique AND, OR et NOT
  - pour vérifier si un attribut est NULL ou non on utilise IS NULL et IS NOT NULL
]

#def("Autres mot clés")[
  - SELECT \* : sélectionne toutes les colonnes des tables dans la clause FROM
  - DISTINCT : avant les attributs dans le select permet de supprimer les ligne en doublons\
  - ORDER BY attribut ASC (resp DESC) : à la fin d'une requête permet d'ordonner la table de résultat en fonction d'une ou plusieurs colonne \
  - LIMITE x OFFSET y : à la fin d'une requête permet de garder que les x premières lignes en enlevant les y premières lignes
  - attribut (NOT) IN table : on peut effectuer une condition d'un élément dans une table contentant une seule colonne du même type qu'attribut 
]

#blk2("Remarque")[
  On peut requêter sur une table de notre base de donnée ou sur une sous-requête car celle ci renvoie une table.
]

#ex[
  Renvoyer le produit le plus cher qui pèse moins d'un kg :
  ```sql 
  SELECT * FROM Produit WHERE poids < 1 ORDER BY prix DESC LIMIT 1
  ```
  Renvoyer les produits qui n'ont pas été commandés
  ```sql 
  SELECT * FROM Produit WHERE idProduit NOT IN (SELECT idProduit FROM Commande); 
  ```
]

= Requête avancées

== Opérations ensemblistes
#def("opérateurs ensemblistes")[
Le langage SQL fournis des opérateurs ensemblistes qui permettent de faire des requêtes de séléction sur plusieurs tables. On trouve :
- UNION : fais l'union de deux tables qui doivent avoir le même schéma, on peut utiliser UNION ALL pour avoir les lignes en doublons
- INTERSECT : pour l'intersection
- EXCEPT : pour la différence
]

#ex[
  ```sql 
  SELECT idProduit, nom, poids FROM Produit WHERE poids < 1
  UNION
  SELECT idProduit, nom, poids FROM Produit WHERE poids > 100;
  ```
]
#def("Produit cartésien")[
  On peut faire le produit cartésien de plusieurs table dans la clause FROM de la séléction. Cette méthode pour faire une séléction sur plusieurs table n'est en général pas utilisé car moins performante que la jointure que nous allons voir dans la suite.
]
#ex[
  Retourne les produits qui ont été commandés
  ```sql 
  SELECT DISTINCT Produit.idProduit, Produit.nom 
  FROM Produit, Commande 
  WHERE Commande.idProduit = Produit.idProduit ;
  ```
]

#blk2("Remarque")[
  Il faut préciser de quelle table vient un attribut si un autre attibut au même nom est présent dans plusieurs tables de la requête.
  Lorsqu'on fait une séléction sur plusieurs tables il est souvent pratique de renommer celles-ci pour plus de lisibilité. 
]

== Jointure
Comme énoncer on peut faire des produit cartésien de plusieurs table pour les relier ensemble et en faire des requêtes. On va voir ici une méthode plus éfficace de faire cela grâce aux jointures.

#def("Jointure")[
  La jointure permet de relier 2 tables en filtrant les entrées sur celles vérifiant une condition. Par exemple, pour relier 2 tables qui sont lié par un attribut (clé étrangère) : 
  - JOIN table2 ON clé-table1 = clé-table2 : jointure interne, nous n'avons que les entrées qui sont à la fois dans la table1 et la table2.
  - FULL JOIN : on a toutes les entrées avec des valeurs à NULL pour les entrée présent dans une seule table.
  - tbale1 LEFT JOIN table2 : on a toutes les entrées de table1 et les entrées de table2 seulement pour les entrée non NULL.
  - RIGHT JOIN : inverse de LEF JOIN
]

#blk2("Remarque")[
  On peut faire plusieurs jointure dans une même requête.
]

#ex[
  Pour chaque produit retourner le nom des clients qui l'a commandés.
  ```sql 
  SELECT DISTINCT P.idProduit, P.nom, Client.nom
  FROM Produit AS P
  JOIN Commande AS Com on P.idProduit = Com.idProduit
  JOIN Client on Client.idCommande = Com.idCommande;
  ```
]

== Fonction d'agrégation
#def("Fonctions d'agrégations")[
  Certaines fonctions existe    
nt en SQL qu'on peut appelé dans nos SELECT, sous la forme : \
  SELECT f(attribut) FROM ... -- avec f la fonction dans :
  - COUNT(): renvoie le nombre de ligne de l'ensemble
  - MIN(): renvoie la plus petite valeur 
  - MAX(): renvoie la plus grande valeur
  - AVG(): renvoie la moyenne
  - SUM(): renvoie la somme\
  Ces fonctions permettent de combiner plusieurs lignes en une seule valeur.
]

#def("GROUP BY")[
  La clause GROUP BY permet de partitioner une table horizentallement en sous-table en fonction d'un atribut de partionnement.
]
#ex[
  FAIRE DESSIN EXPLICATIF
]

#def("HAVING")[
  Pour filter les sous-tables qu'on veut garder on utilise la clause HAVING.
] 

#ex[
  Retourner les ville et le nombre d'habitant de ces villes où il y a plus de 5 habitants de cette ville.
  ```sql
  SELECT ville, count(*) as cpt
  FROM Client
  GROUP BY ville
  HAVING cpt > 5
  ```
]

#blk2("Exercice")[
  Quels sont les produits qui ont été commandés dans chaque ville de la base de donnée?\
  Quel est le produit le moins cher qui pèse plus d'un kg?\
  Quel produit est commandés en moyenne avec la plus grande quantité?
  Par ville, quelle est le nombre de produit commandé et la moyene de quantité commandé.
]

#dev[Requêtes avancées avec ou sans agrégation]

== Modification d'une base de donnée
Une base de donnée n'est pas figé dans le temps et est amené à changer au fil du temps. La conception continue après la création

#dev[ Exemple de modification d'une base de donnée]
