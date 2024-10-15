Cette page explique tout le travail qui a été effectué et comment. Vous trouverez le fichier contenant toutes les commandes SQL 
## Importation de la base de données

Lancer cette commande depuis le dossier dans lequel se trouve le fichier `db_space_invaders.sql` . Cette commande permet d'importer un dump/ executer les commandes sql présente dans un fichier dans l'environnement mysql.

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

## Accéder au terminal de l'environnement du container docker
Nous utilisons ici, un environnement docker qui exécute un serveur SQL. Mais pour nous connecter dans un terminal à cette environnement nous devons lancé depuis un terminal Windows la commande suivante :
```bash
docker exec -it db bash
```

Cette commande est utilisée pour exécuter une commande interactive dans un conteneur Docker en cours d'exécution.

Explication détaillée de la commande :
`docker exec` : Cette partie indique à Docker d'exécuter une commande dans un conteneur existant.
`-it` : permet d'obtenir un shell interactif dans le conteneur.
`db` : C'est le nom ou l'ID du conteneur dans lequel la commande sera exécutée.
`bash` : C'est la commande à exécuter dans le conteneur, ici un shell Bash.

## Gestion des utilisateurs et des rôles


### Comment faire ?

#### Création d'un utilisateur

Pour créer un utilisateur dans MySQL, utilisez la commande suivante :

```sql
CREATE USER 'username'@'hostname' IDENTIFIED BY 'password';
```

- `username` : Nom de l'utilisateur à créer.
- `hostname` : Définit de quel hôte cet utilisateur est autorisé à se connecter (remplacez par `%` si l'utilisateur peut se connecter de n'importe où).
- `'password'` : Mot de passe de l'utilisateur.

#### Création d'un rôle

Les rôles permettent de grouper des privilèges afin de les attribuer facilement à plusieurs utilisateurs. Voici comment créer un rôle :

```sql
CREATE ROLE 'rolename';
```

- `rolename` : Nom du rôle que vous souhaitez créer.

#### Gestion des privilèges d'un rôle

Pour attribuer des privilèges à un rôle, utilisez la commande `GRANT` :

```sql
GRANT privilege ON lieuDuPrivilege TO 'rolename';
```

- `privilege` : Liste des privilèges à attribuer, séparés par des virgules, sur le niveau ou l'objet pour lequel les privilèges seront attribués.

---
##### Liste des privilèges disponibles

Voici un tableau des principaux privilèges qu'il est possible d'attribuer à un rôle ou un utilisateur (c'est uniquement ceux qui nous seront utile).

| Privilège        | Description                                                                 |
| ---------------- | --------------------------------------------------------------------------- |
| `ALL PRIVILEGES` | Accorde tous les privilèges disponibles                                     |
| `SELECT`         | Permet de lire les données des tables                                       |
| `INSERT`         | Permet d'insérer de nouvelles lignes dans les tables                        |
| `UPDATE`         | Permet de modifier les données existantes dans les tables                   |
| `DELETE`         | Permet de supprimer des lignes des tables                                   |
| `GRANT OPTION`   | Permet d'accorder des privilèges à d'autres utilisateurs                    |
| `USAGE`          | Privilège nul qui permet de créer un compte sans lui accorder de privilèges |

*[Tous les privilèges disponible dans MySQL](https://dev.mysql.com/doc/refman/8.4/en/privileges-provided.html)*

---

- `lieuDuPrivilège` : Le niveau sur lequel les privilèges sont attribués (par exemple : `*.*` pour tout, `database.table` pour une table spécifique).

---
##### Niveaux de privilège
Tous les niveaux de privilèges disponibles dans MySQL (uniquement ceux qui nous seront utile).

| Niveau de privilège     | Description                                               |
| ----------------------- | --------------------------------------------------------- |
| `*.*`                   | Tous les schémas et toutes les tables                     |
| `database.*`            | Toutes les tables dans une base de données                |
| `database.table`        | Une table spécifique dans une base de données             |
| `database.table.column` | Une colonne spécifique d'une table, d'une base de données |

---

- `'rolename'` : Nom du rôle qui recevra ces privilèges.

#### Ajout d'un rôle à un utilisateur

Pour ajouter un rôle à un utilisateur, utilisez la commande suivante :

```sql
GRANT 'rolename' TO 'username'@'hostname';
```

- `'rolename'` : Nom du rôle à ajouter.
- `'username'`@'hostname' : Nom de l'utilisateur qui recevra ce rôle.


*Sources : [Zeste de Savoir : Gestion des utilisateurs](https://zestedesavoir.com/tutoriels/730/administrez-vos-bases-de-donnees-avec-mysql/954_gestion-des-utilisateurs-et-configuration-du-serveur/3962_gestion-des-utilisateurs/), [https://www.emmanuelgautier.fr : Utilisateurs et privilèges sous MySQL](https://www.emmanuelgautier.fr/blog/utilisateurs-et-privileges-sous-mysql) *


### Pratique
**3 utilisateurs doivent être créés :**
 1. Administrateur du jeu
 2. Joueur
 3. Gestionnaire de la boutique

#### Création des utilisateurs et des rôle, ajout des utilisateur dans les rôles et attribution des privilèges pour chaque rôle.
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
SET DEFAULT ROLE 'AdminJeu' TO 'alice'@'localhost';

-- Joueur
CREATE USER 'bob'@'localhost' IDENTIFIED BY 'mdpSecret';
GRANT 'Joueur' TO 'bob'@'localhost';
SET DEFAULT ROLE 'Joueur' TO 'bob'@'localhost';

-- GestionnaireBoutique
CREATE USER 'toto'@'localhost' IDENTIFIED BY 'mdpSuperSecret';
GRANT 'GestionnaireBoutique' TO 'toto'@'localhost';
SET DEFAULT ROLE 'GestionnaireBoutique' TO 'toto'@'localhost';


-- Mettre à jour les privilèges
FLUSH PRIVILEGES;
```


#### Vérifier si la création des utilisateurs et des rôles, et l'attribution des privilèges à fonctionné
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

```sql
USE db_space_invaders; -- Utiliser la base de données db_space_invaders
\W; -- Activer l'affichage des avertissements
```

### Requête n°1
La première requête vise à sélectionner les 5 joueurs ayant le meilleur score, c'est-à-dire le nombre de points le plus élevé. Les joueurs doivent être classés dans l'ordre décroissant.

```sql
SELECT * FROM t_joueur ORDER BY jouNombrePoints DESC LIMIT 5;
```

**Explications :**
Cette requête SQL sélectionne toutes les colonnes (`*`) de la table `t_joueur`. Les résultats sont triés par ordre décroissant (`DESC`) du nombre de points (`jouNombrePoints`), assurant ainsi que les joueurs avec le plus de points apparaissent en premier. La clause `LIMIT 5` restreint le résultat aux 5 premiers joueurs, correspondant ainsi aux 5 meilleurs scores. Cette requête est efficace pour identifier rapidement les joueurs les plus performants du jeu.

### Requête n°2
Trouver le prix maximum, minimum et moyen des armes. Les colonnes doivent avoir pour nom "PrixMaximum", "PrixMinimum" et "PrixMoyen".

```sql
SELECT MAX(armPrix) AS 'PrixMaximum', MIN(armPrix) AS 'PrixMinimum', AVG(armPrix) AS 'PrixMoyen' FROM t_arme;
```

**Explications :**
Cette requête utilise trois fonctions d'agrégation sur la colonne `armPrix` de la table `t_arme` :
- `MAX()` pour trouver le prix le plus élevé
- `MIN()` pour trouver le prix le plus bas
- `AVG()` pour calculer le prix moyen

Chaque résultat est renommé avec la clause `AS` pour correspondre aux noms de colonnes demandés. Cette requête fournit un aperçu rapide de la gamme de prix des armes dans le jeu, utile pour l'analyse économique du système de jeu.

### Requête n°3
Trouver le nombre total de commandes par joueur et trier du plus grand nombre au plus petit. La 1ère colonne aura pour nom "IdJoueur", la 2ème colonne aura pour nom "NombreCommandes".

```sql
SELECT j.idJoueur AS 'IdJoueur', COUNT(c.idCommande) AS NombreCommandes
FROM t_joueur AS j
JOIN t_commande AS c ON j.idJoueur = c.fkJoueur
GROUP BY j.idJoueur
ORDER BY NombreCommandes DESC;
```

**Explications :**
Cette requête effectue une jointure interne entre les tables `t_joueur` (alias `j`) et `t_commande` (alias `c`) sur la base de l'identifiant du joueur. Elle compte le nombre de commandes pour chaque joueur avec `COUNT(c.idCommande)`. Les résultats sont groupés par `idJoueur` et triés par ordre décroissant du nombre de commandes. Cette requête permet d'identifier les joueurs les plus actifs en termes de commandes passées.

### Requête n°4
Trouver les joueurs qui ont passé plus de 2 commandes. La 1ère colonne aura pour nom IdJoueur, la 2ème colonne aura pour nom NombreCommandes.

```sql
SELECT j.idJoueur AS 'IdJoueur', COUNT(c.idCommande) AS NombreCommandes
FROM t_joueur AS j
JOIN t_commande AS c ON j.idJoueur = c.fkJoueur
GROUP BY j.idJoueur
HAVING NombreCommandes > 2;
```

**Explications :**
Cette requête est similaire à la précédente, mais elle ajoute une clause `HAVING` pour filtrer les résultats. Elle sélectionne uniquement les joueurs ayant passé plus de 2 commandes. La clause `HAVING` est utilisée ici car elle permet de filtrer sur le résultat d'une fonction d'agrégation (`COUNT` dans ce cas), contrairement à `WHERE` qui s'applique aux lignes individuelles avant l'agrégation.

### Requête n°5
Trouver le pseudo du joueur et le nom de l'arme pour chaque commande.

```sql
SELECT j.jouPseudo, arm.armNom
FROM t_joueur AS j
JOIN t_arsenal AS ars ON j.idJoueur = ars.fkJoueur
JOIN t_arme AS arm ON arm.idArme = ars.fkArme
JOIN t_detail_commande AS dc ON dc.fkArme = arm.idArme
JOIN t_commande AS c ON c.idCommande = dc.fkCommande AND j.idJoueur = c.fkJoueur;
```

**Explications :**
Cette requête complexe utilise plusieurs jointures pour relier les informations des joueurs, des armes et des commandes. Elle joint les tables `t_joueur`, `t_arsenal`, `t_arme`, `t_detail_commande`, et `t_commande`. Le résultat affiche le pseudo du joueur et le nom de l'arme pour chaque commande passée. Cette requête est utile pour avoir une vue détaillée des achats d'armes par joueur.

### Requête n°6
Trouver le total dépensé par chaque joueur en ordonnant par le montant le plus élevé en premier, et limiter aux 10 premiers joueurs. La 1ère colonne doit avoir pour nom "IdJoueur" et la 2ème colonne "TotalDepense".

```sql
SELECT j.idJoueur AS 'IdJoueur', SUM(arm.armPrix * dc.detQuantiteCommande) AS 'TotalDepense' 
FROM t_joueur AS j 
JOIN t_commande AS c ON j.idJoueur = c.fkJoueur 
JOIN t_detail_commande AS dc ON c.idCommande = dc.fkCommande 
JOIN t_arme AS arm ON dc.fkArme = arm.idArme 
GROUP BY j.idJoueur 
ORDER BY TotalDepense DESC 
LIMIT 10;
```

**Explications :**
Cette requête calcule le total dépensé par chaque joueur en armes. Elle utilise des jointures multiples pour relier les informations des joueurs, des commandes, des détails de commande et des armes. La fonction `SUM` multiplie le prix de chaque arme par la quantité commandée et additionne ces produits. Les résultats sont groupés par joueur, triés par dépense totale décroissante, et limités aux 10 premiers. Cette requête est précieuse pour identifier les joueurs les plus dépensiers.

### Requête n°7
Récupérer tous les joueurs et leurs commandes, même s'ils n'ont pas passé de commande.

```sql
SELECT * 
FROM t_joueur AS j
LEFT JOIN t_commande AS c ON c.fkJoueur = j.idJoueur;
```

**Explications :**
Cette requête utilise une jointure externe gauche (`LEFT JOIN`) entre les tables `t_joueur` et `t_commande`. Elle retourne tous les joueurs, qu'ils aient passé des commandes ou non. Pour les joueurs sans commande, les colonnes de la table `t_commande` afficheront NULL. Cette requête est utile pour avoir une vue complète de tous les joueurs, y compris ceux qui n'ont pas encore effectué d'achat.

### Requête n°8
Récupérer toutes les commandes et afficher le pseudo du joueur s'il existe, sinon afficher NULL pour le pseudo.

```sql
SELECT c.*, j.jouPseudo 
FROM t_commande AS c
LEFT JOIN t_joueur AS j ON c.fkJoueur = j.idJoueur;
```

**Explications :**
Cette requête utilise une jointure externe gauche (`LEFT JOIN`) entre les tables `t_commande` et `t_joueur`. Elle retourne toutes les commandes, qu'elles soient associées à un joueur existant ou non. Si une commande n'est pas liée à un joueur (ce qui pourrait indiquer une anomalie dans les données), le champ `jouPseudo` affichera NULL. Cette requête est utile pour vérifier l'intégrité des données et identifier d'éventuelles commandes orphelines.

### Requête n°9
Trouver le nombre total d'armes achetées par chaque joueur (même si ce joueur n'a acheté aucune Arme).

```sql
SELECT j.idJoueur, COALESCE(SUM(dc.detQuantiteCommande), 0) AS 'NombreTotalArme'
FROM t_joueur AS j
LEFT JOIN t_commande AS c ON c.fkJoueur = j.idJoueur
LEFT JOIN t_detail_commande AS dc ON dc.fkCommande = c.idCommande
GROUP BY j.idJoueur;
```

**Explications :**
Cette requête utilise des jointures externes gauches pour inclure tous les joueurs, même ceux n'ayant pas effectué d'achat. La fonction `COALESCE` est utilisée pour remplacer les valeurs NULL par 0 pour les joueurs sans achat. `SUM(dc.detQuantiteCommande)` calcule le nombre total d'armes achetées. Cette requête fournit une vue complète de l'activité d'achat de tous les joueurs, y compris ceux qui n'ont pas encore fait d'acquisition.

### Requête n°10
Trouver les joueurs qui ont acheté plus de 3 types d'armes différentes.

```sql
SELECT j.idJoueur, COUNT(DISTINCT dc.fkArme) AS 'NombreTypesArmes'
FROM t_joueur AS j
JOIN t_commande AS c ON c.fkJoueur = j.idJoueur
JOIN t_detail_commande AS dc ON dc.fkCommande = c.idCommande
GROUP BY j.idJoueur
HAVING NombreTypesArmes > 3;
```

**Explications :**
Cette requête utilise des jointures internes pour lier les tables de joueurs, commandes et détails de commandes. `COUNT(DISTINCT dc.fkArme)` compte le nombre de types d'armes uniques achetés par chaque joueur. La clause `HAVING` filtre les résultats pour ne montrer que les joueurs ayant acheté plus de 3 types d'armes différents. Cette requête est utile pour identifier les joueurs avec une collection d'armes diversifiée, ce qui peut indiquer un engagement plus important dans le jeu ou une stratégie d'achat variée.
## Création des index
En étudiant le dump MySQL `db_space_invaders.sql` vous constaterez que vous ne trouvez pas le mot clé INDEX. 
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
On remarque qu'il existe déjà quelque index existant. Ils ont tous un point commun : Ils sont soit des clés primaire soit des clés étrangères. On peut donc supposé que en MySQL des index sont créés par défaut pour chaque clés primaires et pour chaque clés étrangères.

[Ce cours de guru99 nous confirme l'hypothèse que nous avons posé.](https://www.guru99.com/fr/indexes.html)

**Conclusion :**
Par défaut, MySQL, créer des index par défaut pour les clés primaires et clés secondaires.

### 2. Quels sont les avantages et les inconvénients des index ? 
#### Avantages
- Amélioration des performances des requêtes

#### Inconvénients
- Augmentation de la taille de la base de données
- Baisse des performances d'insertion, de modifications et de suppression de données.


*Sources : [What are advantages and disadvantages of indexes in MySQL? - Linkedin](https://www.linkedin.com/pulse/what-advantages-disadvantages-indexes-mysql-esam-eisa)*
### 3. Sur quel champ (de quelle table), cela pourrait être pertinent d’ajouter un index ? Justifier votre réponse.

En plus des clés primaires et des clés étrangères, je propose d'ajouter des index sur les colonnes suivantes :

- **`t_arme`**
	- **`armNom`**: Si l'on doit effectuer des recherches dans la base de données par le nom d'une arme, il serait utile d'y ajouter un index. En général, l'ajout de nouvelles armes est moins fréquent que les recherches, ce qui justifie l'utilisation d'un index pour optimiser les recherches.
- **`t_commande`**
	- **`comDate`** : Si les requêtes impliquent souvent des filtres ou des tris par date de commande, un index sur `comDate` peut améliorer les performances.
	- **`comNumeroCommande`** : Si ce champ est utilisé pour rechercher des commandes spécifiques, un index pourrait être bénéfique.
- **`t_joueur`**
	- **`jouPseudo`** : Généralement, on identifie un joueur par son pseudo et on le recherche grâce à celui-ci. C'est probablement l'une des recherches les plus fréquentes, d'où l'intérêt d'en améliorer la vitesse. Bien que de nouveaux joueurs puissent s'inscrire régulièrement, je suppose que les recherches de joueurs sont plus fréquentes que les créations de comptes. Cela améliore considérablement l'expérience utilisateur, surtout dans le cas d'une base de données contenant des millions de joueurs. Sans index, la recherche pourrait prendre un certain temps, tandis que la création d'un nouveau compte peut être légèrement plus lente sans impact significatif sur l'expérience de jeu immédiate.

#### Script SQL permettant de créer les index cités ci-dessus
```sql
-- Création des indexs de la table t_arme
CREATE INDEX i_armNom ON t_arme(armNom); -- index pour le champ armNom

-- Création des indexs de la table t_commande
CREATE INDEX i_comDate ON t_commande(comDate); -- index pour le champ comDate
CREATE INDEX i_comNumeroCommande ON t_commande(comNumeroCommande); -- index pour le champ comNumeroCommande

-- Création des indexs de la table t_joueur
CREATE INDEX i_jouPseudo ON t_joueur(jouPseudo); -- index pour le champ jouPseudo
```
## Backup / Restore
### Backup de la base de données
Nous souhaitons réaliser une sauvegarde (Backup) de la base de données `db_space_invaders`. Ensuite, nous souhaitons nous assurer que cette sauvegarde est correcte en la rechargeant dans MySQL (opération de restauration). Donner la commande permettant de faire :
- Un backup de la base de données `db_space_invaders` 
- Un restore de la base de données `db_space_invaders` En expliquant en détail chaque commande utilisée.

Pour créer un dump d'une base de données, on peut utilisé l'utilitaire présent dans MySQL se nommant `mysqldump`. La commande suivante sert donc à créer un dump d'une base de données précisé (il est aussi possible de faire un dump de toutes les base de données mais nous ne feront pas ca ici)
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

### Restauration de la base de données
Afin de restaurer la base de données, nous devrons utilisé la même commande utilisé pour importer le dump de base de la base de données en cette fois-ci donnant le chemin du dump de la base de données que nous venons de créé. Voici donc la commande à utilisé :
```bash
docker exec -i db mysql -uroot -proot < db_space_invaders.sql
```

Cette commande permet d'exécuter le fichier SQL précisé en tant que root dans l'environnement du container docker se nommant `db`. Attention : cette commande va récupéré le fichier SQL se trouvant  à l'emplacement du terminal utilisé pour exécuté cette commande.
