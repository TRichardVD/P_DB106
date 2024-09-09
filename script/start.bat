docker run db


docker exec -i db mysql -uroot -proot db_space_invaders < prerequis.sql
docker exec -i db mysql -uroot -proot db_space_invaders < db_space_invaders.sql
docker exec -i db mysql -uroot -proot db_space_invaders < users.sql

ECHO OFF
PAUSE
