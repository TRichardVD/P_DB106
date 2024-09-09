



\W;

-- Role AdminJeu
CREATE ROLE 'AdminJeu'@'localhost'; -- Création du rôle AdminJeu
GRANT SELECT, INSERT, UPDATE, DELETE ON db_space_invaders.* TO 'AdminJeu'@'localhost';


-- Role Joueur
CREATE ROLE 'Joueur'@'localhost'; -- Création du rôle Joueur
GRANT SELECT ON db_space_invaders.t_arme TO 'Joueur'@'localhost';
GRANT SELECT, INSERT ON db_space_invaders.t_commande TO 'Joueur'@'localhost';
GRANT SELECT, INSERT ON db_space_invaders.t_deatil_commande TO 'Joueur'@'localhost';

-- Role GestionnaireBoutique
CREATE ROLE 'GestionnaireBoutique'@'localhost'; -- Création du rôle GestionnaireBoutique
GRANT SELECT ON db_space_invaders.t_joueur TO 'GestionnaireBoutique'@'localhost';
GRANT SELECT, UPDATE, DELETE ON db_space_invaders.t_arme TO 'GestionnaireBoutique'@'localhost';
GRANT SELECT ON db_space_invaders.t_commande TO 'GestionnaireBoutique'@'localhost';
GRANT SELECT ON db_space_invaders.t_detail_commande TO 'GestionnaireBoutique'@'localhost';


-- Pour chaque rôle, ajouté un utilisateur.
-- AdminJeu
CREATE USER 'alice'@'localhost' IDENTIFIED BY 'mdp';
GRANT 'AdminJeu'@'localhost' TO 'alice'@'localhost';

-- Joueur
CREATE USER 'bob'@'localhost' IDENTIFIED BY 'mdpSecret';
GRANT 'Joueur'@'localhost' TO 'bob'@'localhost';

-- GestionnaireBoutique
CREATE USER 'toto'@'localhost' IDENTIFIED BY 'mdpSuperSecret';
GRANT 'GestionnaireBoutique'@'localhost' TO 'toto'@'localhost';


-- Mettre à jour les privilèges
FLUSH PRIVILEGES;



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

