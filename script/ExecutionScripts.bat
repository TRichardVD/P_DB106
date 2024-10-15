:: Importation du dump de base de la base de donneées db_space_invaders.
docker exec -i db mysql -uroot -proot < db_space_invaders_Base.sql

:: Excecution du script créés pour répondre au éxigence du cahier des charges liés à la gestion des rôles et des utilisateurs.
docker exec -i db mysql -uroot -proot < users.sql

:: Execution des requêtes de sélections
docker exec -i db mysql -uroot -proot < requetes.sql

:: Création des indexes
docker exec -i db mysql -uroot -proot < index.sql

:: Création d'un backup
mysqldump -uroot -proot db_space_invaders > db_space_invaders.sql --single-transaction --databases

:: Restaurer le dump de la base de données
docker exec -i db mysql -uroot -proot < db_space_invaders.sql