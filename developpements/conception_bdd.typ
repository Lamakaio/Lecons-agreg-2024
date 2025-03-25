#import "../utils.typtp": *
#import "dev_tplt.typtp": developpement

#show: developpement.with(
  titre: [Conception d'une base de donnée], 
  niveau: [MP2I], 
  prerequis: [Modèle relationnel])


= Cahier des charges 
Un site référence des séries. Elles sont décomposées saisons et en épisodes. Chaque série contient des acteurs. De plus il est possible de mettre un commentaire à une série ainsi qu'une note.

_souligner les mots clés au tableau_

= Schéma Entité/Association
#image("../img/conception_schema.png")

= Transformation vers schéma relationnel
== Transformations
Remplacer les relations □\*--\*□ en □1--\*□\*--1□\
Regrouper les relations □1--1□ en une seul table

Ici Acteur\*--\*Série devient Acteur 1--\*Role\*--1 Série\
et Commentaire 1--1 Note devient Commentaire.

== Traduction 
Ajouter des champs d'identifiant unique pour les entités pour simplifier les clés primaire.
- Identifier les clés primaires
- Identifier les clés étrangères
- Chaque entités devient une table avec :
  - ses champs
  - pour chaque \*, une clés étrangères de la clé primaire de l'entité de cette association
Attention à l'ordre, il faut commencer par les tables qui n'ont pas de clés étrangères.

Acteur(#underline[idActeur], prénom, nom, dateNaissance)\
Série(#underline[idSérie], titre, dateSortie)\
Role(#underline[\#idActeur, \#idSérie])\
Saison(#underline[idSaison], numéro, date, \#idSérie)\
Épisode(#underline[idÉpisode], numéro, date, intitulé, \#idSaison)\
Commentaire(#underline[idCommentaire], note, \#idSérie)

= Création des tables en SQL
```sql
create table Acteur (
  idActeur integer PRIMARY KEY,
  prenom varchar(50),
  nom varchar(50),
  dateNaissance date
);

create table Serie (
  idSerie integer PRIMARY KEY,
  titre varchar(50),
  dateSortie date
);

create table Role (
  idActeur integer,
  idSerie integer,
  FOREIGN KEY (idActeur) REFERENCES Acteur(idActeur),
  FOREIGN KEY (idSerie) REFERENCES Serie(idSerie),
  PRIMARY KEY (idActeur, idSerie)
)
```
