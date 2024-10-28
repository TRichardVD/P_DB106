\W;  -- Afficher les warning

-- Effacer les rôles si ils existent (pour pouvoir les créer après)
DROP ROLE IF EXISTS 'AdminJeu';
DROP ROLE IF EXISTS 'Joueur';
DROP ROLE IF EXISTS 'GestionnaireBoutique';

-- Effacer la base de données si elle existe (pour pouvoir la créer ensuite)
DROP DATABASE IF EXISTS db_space_invaders;

-- Effacer les utilisateurs (pour pouvoir les créer ensuite)
DROP USER IF EXISTS 'bob'@'localhost';
DROP USER IF EXISTS 'alice'@'localhost';
DROP USER IF EXISTS 'toto'@'localhost';