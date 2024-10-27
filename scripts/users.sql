\W; -- Afficher les Warning

-- Role AdminJeu
CREATE ROLE 'AdminJeu'; -- Création du rôle AdminJeu
GRANT SELECT, INSERT, UPDATE, DELETE ON db_space_invaders.* TO 'AdminJeu'; -- Donner les privilèges nécessaires au rôle AdminJeu


-- Role Joueur
CREATE ROLE 'Joueur'; -- Création du rôle Joueur
GRANT SELECT ON db_space_invaders.t_arme TO 'Joueur';
GRANT SELECT, INSERT ON db_space_invaders.t_commande TO 'Joueur';
GRANT SELECT, INSERT ON db_space_invaders.t_detail_commande TO 'Joueur';

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