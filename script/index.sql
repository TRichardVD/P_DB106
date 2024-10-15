-- Création des indexs de la table t_arme
CREATE INDEX i_armNom ON t_arme(armNom); -- index pour le champ armNom

-- Création des indexs de la table t_commande
CREATE INDEX i_comDate ON t_commande(comDate); -- index pour le champ comDate
CREATE INDEX i_comNumeroCommande ON t_commande(comNumeroCommande); -- index pour le champ comNumeroCommande

-- Création des indexs de la table t_joueur
CREATE INDEX i_jouPseudo ON t_joueur(jouPseudo); -- index pour le champ jouPseudo