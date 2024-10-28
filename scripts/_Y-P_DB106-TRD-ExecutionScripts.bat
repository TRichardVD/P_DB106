:: Effacer les rôles etc. si déjà créés
docker exec -i db mysql -uroot -proot < Y-P_DB106-TRD-prerequis.sql

:: Importation du dump de base de la base de donneées db_space_invaders.
docker exec -i db mysql -uroot -proot < db_space_invaders_Base.sql


:: Excecution du script créés pour répondre au éxigence du cahier des charges liés à la gestion des rôles et des utilisateurs.
docker exec -i db mysql -uroot -proot db_space_invaders < Y-P_DB106-TRD-users.sql


:: Execution des requêtes de sélections
docker exec -i db mysql -uroot -proot db_space_invaders < Y-P_DB106-TRD-requetes.sql


:: Création des indexes
docker exec -i db mysql -uroot -proot db_space_invaders < Y-P_DB106-TRD-index.sql


PAUSE

:: Création d'un backup
docker exec -i db mysqldump -uroot -proot db_space_invaders > ./Backup/db_space_invaders.sql --single-transaction --databases

PAUSE

:: Effacer la base de données, les utilisateurs et les rôles
docker exec -i db mysql -uroot -proot < Y-P_DB106-TRD-prerequis.sql

:: Restaurer le dump de la base de données
docker exec -i db mysql -uroot -proot < ./Backup/db_space_invaders.sql

:: Si on veut recréer les utilisateurs il faut reexecuter le script qui est dans le fichier users.sql


PAUSE