-- WS Hive, partie 3 : analyse des salaires
-- Cible : Cloudera quickstart 5.12 (Hive 1.1). Lancer : hive -f 03_analyse.hql
-- Prérequis : 00_hdfs.sh
-- Notes : année courante via YEAR(CURRENT_DATE()) (dispo dans Hive 1.1 CDH 5.12).
--         Q4, Q8, Q9, Q10 dépendent de l'année d'exécution (attendus.md : année 2026).
SET hive.cli.print.header=true;
SET hive.cli.print.current.db=true;
-- Jointure map-join locale en échec sur la quickstart (MapredLocalTask, NullPointerException) : désactivée
SET hive.auto.convert.join=false;

-- Rejouable
DROP DATABASE IF EXISTS analyse_salaires CASCADE;

CREATE DATABASE analyse_salaires;
USE analyse_salaires;

-- Tables externes (vrais noms de fichiers : .txt). fonction/salaire ont un en-tête, employes non.
CREATE EXTERNAL TABLE salaire_employes (
  sexe STRING,
  secteur STRING,
  salaire STRING,
  code_postal INT,
  id_empl INT
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\073'
STORED AS TEXTFILE
LOCATION '/user/hive/data/salaire'
TBLPROPERTIES ("skip.header.line.count"="1");

CREATE EXTERNAL TABLE fonction_employes (
  id_empl INT,
  annee_embauche INT,
  fonction STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\073'
STORED AS TEXTFILE
LOCATION '/user/hive/data/fonction'
TBLPROPERTIES ("skip.header.line.count"="1");

CREATE EXTERNAL TABLE employes (
  id_empl INT,
  nom STRING,
  prenom STRING,
  date_naissance STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\073'
STORED AS TEXTFILE
LOCATION '/user/hive/data/employes';

SELECT COUNT(*) AS nb_employes FROM employes;
SELECT COUNT(*) AS nb_fonctions FROM fonction_employes;
SELECT COUNT(*) AS nb_salaires FROM salaire_employes;

-- Vue utilitaire (hors énoncé) : une ligne par employé, salaire converti en nombre
-- ('20000euro/an' -> 20000 ; regexp_replace retire tout sauf les chiffres, ce qui couvre aussi la faute '42000euo/an')
-- experience = année courante - année d'embauche
CREATE VIEW v_employes_complet AS
SELECT
  e.id_empl,
  e.nom,
  e.prenom,
  s.sexe,
  s.secteur,
  CAST(REGEXP_REPLACE(s.salaire, '[^0-9]', '') AS INT) AS salaire_num,
  s.code_postal,
  f.annee_embauche,
  f.fonction,
  YEAR(CURRENT_DATE()) - f.annee_embauche AS experience
FROM employes e
JOIN fonction_employes f ON e.id_empl = f.id_empl
JOIN salaire_employes s ON e.id_empl = s.id_empl;

-- Q1. Combien d'employés ont été embauchés après 2019 ?
-- Interprétation : annee_embauche > 2019 (2019 exclu).
SELECT COUNT(*) AS nb_embauches_apres_2019
FROM fonction_employes
WHERE annee_embauche > 2019;

-- Q2. Quelles paires employé-secteur ont un salaire > 35000 euro/an ?
-- Interprétation : une paire (employé, secteur) par ligne, salaire strictement > 35000.
SELECT id_empl, nom, prenom, secteur, salaire_num
FROM v_employes_complet
WHERE salaire_num > 35000
ORDER BY id_empl;

-- Q3. Employés du secteur éducation recrutés après 2010.
-- Interprétation : la vue joint employes et fonction_employes (annee_embauche > 2010) ;
-- le secteur vient de salaire_employes, donc jointure supplémentaire, filtre secteur = 'education'
-- (égalité stricte : 'soin et education' n'est pas retenu).
CREATE VIEW vue_employes_apres_2010 AS
SELECT e.id_empl, e.nom, e.prenom, f.annee_embauche, f.fonction
FROM employes e
JOIN fonction_employes f ON e.id_empl = f.id_empl
WHERE f.annee_embauche > 2010;

SELECT v.id_empl, v.nom, v.prenom, v.annee_embauche, v.fonction
FROM vue_employes_apres_2010 v
JOIN salaire_employes s ON v.id_empl = s.id_empl
WHERE s.secteur = 'education'
ORDER BY v.id_empl;

-- Q4. Quel employé a le plus d'expérience professionnelle ?
-- Interprétation : expérience = année courante - annee_embauche ; plus grande valeur,
-- ex-aequo conservés grâce à rank().
SELECT id_empl, nom, prenom, annee_embauche, fonction, experience
FROM (
  SELECT id_empl, nom, prenom, annee_embauche, fonction, experience,
         RANK() OVER (ORDER BY experience DESC) AS rang
  FROM v_employes_complet
) t
WHERE rang = 1;

-- Q5. Salaire moyen des employés (salaire converti en numérique).
SELECT ROUND(AVG(salaire_num), 2) AS salaire_moyen
FROM v_employes_complet;

-- Q6. Ensemble des fonctions des femmes par année d'embauche.
-- Interprétation : sexe = 'F' (salaire_employes), collect_set -> fonctions distinctes par année.
SELECT annee_embauche, COLLECT_SET(fonction) AS fonctions
FROM v_employes_complet
WHERE sexe = 'F'
GROUP BY annee_embauche
ORDER BY annee_embauche;

-- Q7. Paires <prénom, fonction> des employés qui résident à Paris.
-- Interprétation : code postal commençant par 75 (75000 à 75999), comme demandé "75xxx".
-- Attention : 75780 est retenu bien que ce ne soit pas un code postal parisien réel.
-- code_postal ajouté au SELECT : Hive 1.1 refuse ORDER BY sur une colonne absente du SELECT.
SELECT prenom, fonction, code_postal
FROM v_employes_complet
WHERE code_postal BETWEEN 75000 AND 75999
ORDER BY code_postal;

-- Q8. Différence de salaire entre femmes et hommes ?
-- Ratio = somme des salaires / somme des années d'expérience, par sexe.
SELECT sexe,
       COUNT(*) AS nb,
       SUM(salaire_num) AS somme_salaires,
       SUM(experience) AS somme_experience,
       ROUND(SUM(salaire_num) / SUM(experience), 2) AS ratio_salaire_par_annee_exp,
       ROUND(AVG(salaire_num), 2) AS salaire_moyen
FROM v_employes_complet
GROUP BY sexe
ORDER BY sexe;

-- Q9. L'expérience influence-t-elle le salaire ? Coefficient de corrélation de Pearson.
SELECT ROUND(CORR(experience, salaire_num), 4) AS correlation_experience_salaire
FROM v_employes_complet;

-- Q10. Le secteur influence-t-il le salaire ?
-- Salaire moyen par secteur (+ expérience moyenne issue de Q9 pour contrôler l'effet de l'expérience).
SELECT secteur,
       COUNT(*) AS nb,
       ROUND(AVG(salaire_num), 2) AS salaire_moyen,
       ROUND(AVG(experience), 2) AS experience_moyenne
FROM v_employes_complet
GROUP BY secteur
ORDER BY salaire_moyen DESC;
