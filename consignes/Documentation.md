
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





## Gestion de des privilèges des utilisateurs







## Requêtes SQL demandées

### Requêtes n°1
La première requête que l’on vous demande de réaliser est de sélectionner les 5 joueurs qui ont le meilleur score c’est-à-dire qui ont le nombre de points le plus élevé. Les joueurs doivent être classés dans l’ordre décroissant
```sql

```

### Requêtes n°2
Trouver le prix maximum, minimum et moyen des armes. Les colonnes doivent avoir pour nom « PrixMaximum », « PrixMinimum » et « PrixMoyen)
```sql

```

### Requêtes n°3
Trouver le nombre total de commandes par joueur et trier du plus grand nombre au plus petit. La 1ère colonne aura pour nom "IdJoueur", la 2ème colonne aura pour nom "NombreCommandes"
```sql

```

### Requêtes n°4
Trouver les joueurs qui ont passé plus de 2 commandes. La 1ère colonne aura pour nom "IdJoueur", la 2ème colonne aura pour nom "NombreCommandes"
```sql

```

### Requêtes n°5
Trouver le pseudo du joueur et le nom de l'arme pour chaque commande.
```sql

```

### Requêtes n°6
Trouver le total dépensé par chaque joueur en ordonnant par le montant le plus élevé en premier, et limiter aux 10 premiers joueurs. La 1ère colonne doit avoir pour nom "IdJoueur" et la 2ème colonne "TotalDepense"
```sql

```

### Requêtes n°7
Récupérez tous les joueurs et leurs commandes, même s'ils n'ont pas passé de commande. Dans cet exemple, même si un joueur n'a jamais passé de commande, il sera quand même listé, avec des valeurs `NULL` pour les champs de la table `t_commande`.
```sql

```

### Requêtes n°8
Récupérer toutes les commandes et afficher le pseudo du joueur s’il existe, sinon afficher `NULL` pour le pseudo.
```sql

```

### Requêtes n°9
Trouver le nombre total d'armes achetées par chaque joueur (même si ce joueur n'a acheté aucune Arme).
```sql

```

### Requêtes n°10
Trouver les joueurs qui ont acheté plus de 3 types d'armes différentes
```sql

```


## Création des index
En étudiant le dump MySQL db_space_invaders.sql vous constaterez que vous ne trouvez pas le mot clé INDEX. 
### 1. Pourtant certains index existent déjà. Pourquoi ? 

### 2. Quels sont les avantages et les inconvénients des index ? 

### 3. Sur quel champ (de quelle table), cela pourrait être pertinent d’ajouter un index ? Justifier votre réponse.


## Backup / Restore
Nous souhaitons réaliser une sauvegarde (Backup) de la base de données db_space_invaders. Ensuite, nous souhaitons nous assurer que cette sauvegarde est correcte en la rechargeant dans MySQL (opération de restauration). Donner la commande permettant de faire :
- Un backup de la base de données db_space_invaders 
- Un restore de la base de données db_space_invaders En expliquant en détail chaque commande utilisée.