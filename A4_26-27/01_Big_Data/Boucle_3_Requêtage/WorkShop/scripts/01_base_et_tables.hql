-- WS Hive, partie 1 : base de données, tables externes/internes
-- Cible : Cloudera quickstart 5.12 (Hive 1.1). Lancer : hive -f 01_base_et_tables.hql
-- Prérequis : bash 00_hdfs.sh
SET hive.cli.print.header=true;
SET hive.cli.print.current.db=true;

-- Rejouable
DROP DATABASE IF EXISTS htables CASCADE;

CREATE DATABASE IF NOT EXISTS htables
COMMENT 'Base de données du WS Hive'
LOCATION '/user/hive/data/htables';
USE htables;

ALTER DATABASE htables SET DBPROPERTIES ('owner'='A3', 'date'='2022-02-03');
SHOW TABLES;
DESCRIBE DATABASE EXTENDED htables;

-- Table externe intermédiaire
-- (LOCATION adapté : le fichier est dans /user/hive/data/emploi_population, cf. NOTES.md)
CREATE EXTERNAL TABLE IF NOT EXISTS log_emploi_population (
  genre STRING,
  date_naissance DATE,
  fonction STRING,
  salaire STRING,
  code_postal STRING,
  id INT
)
COMMENT 'table intermediaire'
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\073'
STORED AS TEXTFILE
LOCATION '/user/hive/data/emploi_population';

DESCRIBE FORMATTED log_emploi_population;
SELECT * FROM log_emploi_population;
SHOW TBLPROPERTIES log_emploi_population;

-- Test DROP d'une table externe : les données restent dans HDFS
DROP TABLE log_emploi_population;
dfs -ls /user/hive/data/emploi_population;
CREATE EXTERNAL TABLE IF NOT EXISTS log_emploi_population (
  genre STRING,
  date_naissance DATE,
  fonction STRING,
  salaire STRING,
  code_postal STRING,
  id INT
)
COMMENT 'table intermediaire'
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\073'
STORED AS TEXTFILE
LOCATION '/user/hive/data/emploi_population';
SELECT COUNT(*) AS nb_lignes FROM log_emploi_population;

-- Table finale à partir de la table intermédiaire (CTAS)
CREATE TABLE IF NOT EXISTS emploi_population AS
SELECT
  SUBSTR(genre, 1, 1) AS sexe,
  ROUND(DATEDIFF(CURRENT_TIMESTAMP(), date_naissance) / 365.2425) AS age,
  fonction,
  salaire,
  code_postal,
  id AS Id_empl
FROM log_emploi_population;

DESCRIBE EXTENDED emploi_population;
SELECT * FROM emploi_population;

-- Table interne personne
CREATE TABLE IF NOT EXISTS personne (
  id INT,
  nom STRING
)
COMMENT 'Table interne personne'
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\073'
STORED AS TEXTFILE;

dfs -ls /user/hive/warehouse;
LOAD DATA INPATH '/user/hive/warehouse/personne.txt' OVERWRITE INTO TABLE personne;
SELECT * FROM personne;
dfs -ls /user/hive/data/htables/personne;

-- Test : DROP d'une table interne supprime aussi le fichier de données
DROP TABLE personne;
dfs -ls /user/hive/data/htables;
