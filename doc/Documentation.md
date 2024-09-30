
## Importation de la base de données

Lancer cette commande depuis le dossier dans lequel se trouve le fichier `db_space_invaders.sql`.

```shell
docker exec -i db mysql -uroot -proot db_space_invaders < db_space_invaders.sql
```

`docker exec ` : Lance une commande dans un container
`-i` : permet de garder l'entrée standard ouverte, même si personne n'est connecté à un terminal.
`db` : nom du container
`mysql -uroot -proot db_space_invaders < db_space_invaders.sql` : Cette commande est lancé dans le container docker
	`mysql` : le programme `mysql.exe` est lancé
	`-uroot` : lancer mysql en tant qu'utilisteur se nommant 'root'
	`-proot` : et avec password 'root'
	`db_space_invaders`: C'est le nom de la base de données MySQL à laquelle on va se connecter et sur laquelle le fichier SQL sera exécuté.
	`< db_space_invaders.sql` :  Cette partie utilise la redirection d'entrée du shell pour envoyer le contenu du fichier `db_space_invaders.sql` en tant qu'entrée à la commande MySQL. Cela signifie que toutes les instructions SQL contenues dans `db_space_invaders.sql` seront exécutées sur la base de données `db_space_invaders`.

## Création des utilisateurs


### Comment faire ?
https://zestedesavoir.com/tutoriels/730/administrez-vos-bases-de-donnees-avec-mysql/954_gestion-des-utilisateurs-et-configuration-du-serveur/3962_gestion-des-utilisateurs/

https://www.emmanuelgautier.fr/blog/utilisateurs-et-privileges-sous-mysql



### Pratique


 3 utilisateurs doivent être créés :
 1. Administrateur du jeu
 2. Joueur
 3. Gestionnaire de la boutique


### Création des utilisateurs et des rôle, ajout des utilisateur dans les rôles et attribution des privilèges pour chaque rôle.
```sql
-- Role AdminJeu
CREATE ROLE 'AdminJeu'; -- Création du rôle AdminJeu
GRANT SELECT, INSERT, UPDATE, DELETE ON db_space_invaders.* TO 'AdminJeu'; -- Donner les privilèges nécessaires au rôle AdminJeu


-- Role Joueur
CREATE ROLE 'Joueur'; -- Création du rôle Joueur
GRANT SELECT ON db_space_invaders.t_arme TO 'Joueur';
GRANT SELECT, INSERT ON db_space_invaders.t_commande TO 'Joueur';
GRANT SELECT, INSERT ON db_space_invaders.t_deatil_commande TO 'Joueur';

-- Role GestionnaireBoutique
CREATE ROLE 'GestionnaireBoutique'; -- Création du rôle GestionnaireBoutique
GRANT SELECT ON db_space_invaders.t_joueur TO 'GestionnaireBoutique';
GRANT SELECT, UPDATE, DELETE ON db_space_invaders.t_arme TO 'GestionnaireBoutique';
GRANT SELECT ON db_space_invaders.t_commande TO 'GestionnaireBoutique';
GRANT SELECT ON db_space_invaders.t_detail_commande TO 'GestionnaireBoutique';


-- Pour chaque rôle, ajouté un utilisateur.
-- AdminJeu
CREATE USER 'alice'@'localhost' IDENTIFIED BY 'mdp';
GRANT 'AdminJeu' TO 'alice'@'localhost';

-- Joueur
CREATE USER 'bob'@'localhost' IDENTIFIED BY 'mdpSecret';
GRANT 'Joueur' TO 'bob'@'localhost';

-- GestionnaireBoutique
CREATE USER 'toto'@'localhost' IDENTIFIED BY 'mdpSuperSecret';
GRANT 'GestionnaireBoutique' TO 'toto'@'localhost';


-- Mettre à jour les privilèges
FLUSH PRIVILEGES;
```


### Vérifier si la création des utilisateurs et des rôles, et l'attribution des privilèges à fonctionné
```sql

-- Pour vérifier si les autorisations ont bien été attribués
-- Cette commande permet de lister les groupe elle est complexe car pas existante nativement dans mysql
SELECT user AS nom_role FROM mysql.user WHERE account_locked='Y' AND password_expired='Y' AND authentication_string='';

-- Afficher les permissions des rôles créés
SHOW GRANTS FOR 'AdminJeu'@'localhost';
SHOW GRANTS FOR 'Joueur'@'localhost';
SHOW GRANTS FOR 'GestionnaireBoutique'@'localhost';

-- Afficher les permissions des utilisateurs créés
SHOW GRANTS FOR 'alice'@'localhost';
SHOW GRANTS FOR 'bob'@'localhost';
SHOW GRANTS FOR 'toto'@'localhost';

```









## Requêtes SQL demandées

```
USE db_space_invaders;
\W;
```

### Requêtes n°1
La première requête que l’on vous demande de réaliser est de sélectionner les 5 joueurs qui ont le meilleur score c’est-à-dire qui ont le nombre de points le plus élevé. Les joueurs doivent être classés dans l’ordre décroissant
```sql
SELECT * FROM t_joueur ORDER BY jouNombrePoints DESC LIMIT 5;
```

### Requêtes n°2
Trouver le prix maximum, minimum et moyen des armes. Les colonnes doivent avoir pour nom « PrixMaximum », « PrixMinimum » et « PrixMoyen)
```sql
SELECT MAX(armPrix) AS 'PrixMaximum', MIN(armPrix) AS 'PrixMinimum', AVG(armPrix) AS 'PrixMoyen' FROM t_arme;
```

### Requêtes n°3
Trouver le nombre total de commandes par joueur et trier du plus grand nombre au plus petit. La 1ère colonne aura pour nom "IdJoueur", la 2ème colonne aura pour nom "NombreCommandes"
```sql
SELECT j.idJoueur AS 'IdJoueur' , COUNT(c.idCommande) AS NombreCommandes
FROM t_joueur AS j
JOIN t_commande AS c
ON j.idJoueur = c.fkJoueur
GROUP BY idJoueur
ORDER BY NombreCommandes DESC;
```

### Requêtes n°4
Trouver les joueurs qui ont passé plus de 2 commandes. La 1ère colonne aura pour nom "IdJoueur", la 2ème colonne aura pour nom "NombreCommandes"
```sql
SELECT j.idJoueur AS 'IdJoueur' , COUNT(c.idCommande) AS NombreCommandes
FROM t_joueur AS j
JOIN t_commande AS c
ON j.idJoueur = c.fkJoueur
GROUP BY idJoueur
HAVING NombreCommandes > 2
```

### Requêtes n°5
Trouver le pseudo du joueur et le nom de l'arme pour chaque commande.
```sql
SELECT j.jouPseudo, arm.armNom
FROM t_joueur AS j
JOIN t_arsenal AS ars
ON j.idJoueur = ars.fkJoueur
JOIN t_arme AS arm
ON arm.idArme = ars.fkArme
JOIN t_detail_commande AS dc
ON dc.fkArme = arm.idArme
JOIN t_commande AS c
ON c.idCommande = dc.fkCommande AND j.idJoueur = c.fkJoueur;

```

### Requêtes n°6
	Trouver le total dépensé par chaque joueur en ordonnant par le montant le plus élevé en premier, et limiter aux 10 premiers joueurs. La 1ère colonne doit avoir pour nom "IdJoueur" et la 2ème colonne "TotalDepense"
```sql
SELECT j.idJoueur AS 'IdJoueur', SUM(arm.armPrix * dc.detQuantiteCommande) AS 'TotalDepense' 
FROM t_joueur AS j 
JOIN t_commande AS c 
ON j.idJoueur = c.fkJoueur 
JOIN t_detail_commande AS dc 
ON c.idCommande = dc.fkCommande 
JOIN t_arme AS arm ON dc.fkArme = arm.idArme 
GROUP BY j.idJoueur 
ORDER BY TotalDepense DESC 
LIMIT 10;

```

### Requêtes n°7
Récupérez tous les joueurs et leurs commandes, même s'ils n'ont pas passé de commande. Dans cet exemple, même si un joueur n'a jamais passé de commande, il sera quand même listé, avec des valeurs `NULL` pour les champs de la table `t_commande`.
```sql
SELECT * 
FROM t_joueur AS j
LEFT JOIN t_commande AS c
ON c.fkJoueur = j.idJoueur;

```

**Explications :**

### Requêtes n°8
Récupérer toutes les commandes et afficher le pseudo du joueur s’il existe, sinon afficher `NULL` pour le pseudo.
```sql
SELECT c.*, j.jouPseudo 
FROM t_joueur AS j
RIGHT JOIN t_commande AS c
ON c.fkJoueur = j.idJoueur;
```

**Explications :**
### Requêtes n°9
Trouver le nombre total d'armes achetées par chaque joueur (même si ce joueur n'a acheté aucune Arme).
```sql
SELECT j.idJoueur, COUNT(dc.fkArme) AS 'NombreTotalArme'
FROM t_joueur AS j
LEFT JOIN t_commande AS c
ON c.fkJoueur = j.idJoueur
LEFT JOIN t_detail_commande AS dc
ON dc.fkCommande = c.idCommande
GROUP BY j.idJoueur;
```

### Requêtes n°10
Trouver les joueurs qui ont acheté plus de 3 types d'armes différentes
```sql
SELECT j.idJoueur, COUNT(DISTINCT dc.fkArme) AS 'NombreTotalArme'
FROM t_joueur AS j
LEFT JOIN t_commande AS c
ON c.fkJoueur = j.idJoueur
LEFT JOIN t_detail_commande AS dc
ON dc.fkCommande = c.idCommande
GROUP BY j.idJoueur
HAVING NombreTotalArme > 3;
```

**Explications :**

## Création des index
En étudiant le dump MySQL db_space_invaders.sql vous constaterez que vous ne trouvez pas le mot clé INDEX. 
### 1. Pourtant certains index existent déjà. Pourquoi ? 

```sql
/* 
SHOW INDEX FROM nom_table ; --permet d'afficher les index existant sur une table précise 
*/

SHOW INDEX FROM t_arme;
SHOW INDEX FROM t_arsenal;
SHOW INDEX FROM t_commande;
SHOW INDEX FROM t_detail_commande;
SHOW INDEX FROM t_joueur;
```
En utilisant les commandes ci-dessus, on peut afficher dans la console tous les index existant pour les tables de notre base de données.
On remarque qu'il existe déjà quelque index existant. Ils ont tous un point commun : Ils sont soit des clés primaire soit des clés étrangères. On peut donc supposé que en mysql des index sont créés par défaut pour chaque clés primaires et pour chaque clés étrangères.

[Ce cours de guru99 nous confirme l'hypothèse que nous avons posé.](https://www.guru99.com/fr/indexes.html)

**Conclusion :**
Par défaut, mysql, créer des index par défaut pour les clés primaires et clés secondaires.

### 2. Quels sont les avantages et les inconvénients des index ? 
#### Avantages
- Accélère considérablement les recherches dans les données d'une base de données (`SELECT`)
- 

#### Inconvénients
- Peut ralentir lors de l'ajour de données (`INSERT INTO`, etc.)


*Sources : [What are advantages and disadvantages of indexes in MySQL? - Linkedin](https://www.linkedin.com/pulse/what-advantages-disadvantages-indexes-mysql-esam-eisa)*
### 3. Sur quel champ (de quelle table), cela pourrait être pertinent d’ajouter un index ? Justifier votre réponse.

En plus des clés primaires et des clés étrangères, je propose d'ajouter des index sur les colonnes suivantes :

- **jouPseudo (dans t_joueur)** : Généralement, on identifie un joueur par son pseudo et on le recherche grâce à celui-ci. C'est probablement l'une des recherches les plus fréquentes, d'où l'intérêt d'en améliorer la vitesse. Bien que de nouveaux joueurs puissent s'inscrire régulièrement, je suppose que les recherches de joueurs sont plus fréquentes que les créations de comptes. Cela améliore considérablement l'expérience utilisateur, surtout dans le cas d'une base de données contenant des millions de joueurs. Sans index, la recherche pourrait prendre un certain temps, tandis que la création d'un nouveau compte peut être légèrement plus lente sans impact significatif sur l'expérience de jeu immédiate.
- **armNom (dans t_arme)** : Si l'on doit effectuer des recherches dans la base de données par le nom d'une arme, il serait utile d'y ajouter un index. En général, l'ajout de nouvelles armes est moins fréquent que les recherches, ce qui justifie l'utilisation d'un index pour optimiser les recherches.

## Backup / Restore
Nous souhaitons réaliser une sauvegarde (Backup) de la base de données db_space_invaders. Ensuite, nous souhaitons nous assurer que cette sauvegarde est correcte en la rechargeant dans MySQL (opération de restauration). Donner la commande permettant de faire :
- Un backup de la base de données db_space_invaders 
- Un restore de la base de données db_space_invaders En expliquant en détail chaque commande utilisée.

Pour créer un dump d'une base de données, on peut utilisé l'utilitaire présent dans mysql se nommant `mysqldump`. La commande suivante sert donc à créer un dump d'une base de données précisé (il est aussi possible de faire un dump de toutes les base de données mais nous ne feront pas ca ici)
```bash
mysqldump -uroot -proot nom_db > nom_fichier.sql --single-transaction --databases
```

Donc si on applique ceci dans note base de données :
```bash
mysqldump -uroot -proot db_space_invaders > db_space_invaders.sql --single-transaction --databases
```

Un dump c'est créé dans l'emplacement approprié. On peut le copier dans l'emplacement de notre choix avec la commande suivante en dehors de notre container.
```bash
docker cp emplacement_du_fichier_source emplacement_du_fichier_destination
```

Donc on applique la commande suivante dans notre environnement
```bash
docker cp db:db_space_invaders.sql db_space_invaders.sql 
```

