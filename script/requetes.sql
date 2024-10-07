USE db_space_invaders;
\W;

-- 1
SELECT * FROM t_joueur ORDER BY jouNombrePoints DESC LIMIT 5;

-- 2
SELECT MAX(armPrix) AS 'PrixMaximum', MIN(armPrix) AS 'PrixMinimum', AVG(armPrix) AS 'PrixMoyen' FROM t_arme;

-- 3
SELECT j.idJoueur AS 'IdJoueur' , COUNT(c.idCommande) AS NombreCommandes
FROM t_joueur AS j
JOIN t_commande AS c
ON j.idJoueur = c.fkJoueur
GROUP BY idJoueur
ORDER BY NombreCommandes DESC;

-- 4
SELECT j.idJoueur AS 'IdJoueur' , COUNT(c.idCommande) AS NombreCommandes
FROM t_joueur AS j
JOIN t_commande AS c
ON j.idJoueur = c.fkJoueur
GROUP BY idJoueur
HAVING NombreCommandes > 2

-- 5
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

-- 6
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

-- 7
SELECT * 
FROM t_joueur AS j
LEFT JOIN t_commande AS c
ON c.fkJoueur = j.idJoueur;

-- 8
SELECT c.*, j.jouPseudo 
FROM t_joueur AS j
RIGHT JOIN t_commande AS c
ON c.fkJoueur = j.idJoueur;

-- 9
SELECT j.idJoueur, COUNT(dc.fkArme) AS 'NombreTotalArme'
FROM t_joueur AS j
LEFT JOIN t_commande AS c
ON c.fkJoueur = j.idJoueur
LEFT JOIN t_detail_commande AS dc
ON dc.fkCommande = c.idCommande
GROUP BY j.idJoueur;

-- 10
SELECT j.idJoueur, COUNT(DISTINCT dc.fkArme) AS 'NombreTotalArme'
FROM t_joueur AS j
LEFT JOIN t_commande AS c
ON c.fkJoueur = j.idJoueur
LEFT JOIN t_detail_commande AS dc
ON dc.fkCommande = c.idCommande
GROUP BY j.idJoueur
HAVING NombreTotalArme > 3;