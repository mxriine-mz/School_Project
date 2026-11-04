-- Design NAIF : chu_brut = TEXTFILE, pas de partition, pas de bucket, pas de statistiques.
CREATE DATABASE IF NOT EXISTS chu_brut;
USE chu_brut;

CREATE TABLE dim_temps (id_temps INT, date_jour DATE, jour INT, semaine INT, mois INT,
  trimestre INT, semestre INT, annee INT)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' ESCAPED BY '\\' STORED AS TEXTFILE;

CREATE TABLE dim_patient (id_patient INT, sexe STRING, age INT)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' ESCAPED BY '\\' STORED AS TEXTFILE;

CREATE TABLE dim_diagnostic (id_diagnostic INT, code_diagnostic STRING, diagnostic STRING)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' ESCAPED BY '\\' STORED AS TEXTFILE;

CREATE TABLE dim_etablissement (id_etablissement INT, finess_site STRING,
  finess_etablissement_juridique STRING, identifiant_organisation STRING,
  raison_sociale_site STRING, enseigne_commerciale_site STRING, adresse STRING,
  code_commune STRING, code_postal STRING, commune STRING, pays STRING)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' ESCAPED BY '\\' STORED AS TEXTFILE;

-- nom / prenom / civilite volontairement NON exportes (aucun nom dans Hive).
CREATE TABLE dim_professionnel (id_professionnel INT, identifiant STRING, type_identifiant STRING,
  categorie_professionnelle STRING, profession STRING, specialite STRING, commune STRING)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' ESCAPED BY '\\' STORED AS TEXTFILE;

CREATE TABLE dim_region_insee (id_region INT, code_commune_insee STRING, code_departement STRING,
  nom_departement STRING, code_region STRING, nom_region STRING, pays STRING, type_zone STRING)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' ESCAPED BY '\\' STORED AS TEXTFILE;

CREATE TABLE fait_consultation (num_consultation BIGINT, id_patient INT, id_temps INT,
  id_professionnel INT, id_diagnostic INT, id_etablissement INT, nombre_de_consultation INT)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' ESCAPED BY '\\' STORED AS TEXTFILE;

CREATE TABLE fait_hospitalisation (id_hospitalisation INT, id_patient INT, id_etablissement INT,
  id_diagnostic INT, id_date_entree INT, num_hospitalisation STRING, jour_hospitalisation INT)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' ESCAPED BY '\\' STORED AS TEXTFILE;

LOAD DATA INPATH '/user/cloudera/chu/raw/dim_temps'            OVERWRITE INTO TABLE dim_temps;
LOAD DATA INPATH '/user/cloudera/chu/raw/dim_patient'          OVERWRITE INTO TABLE dim_patient;
LOAD DATA INPATH '/user/cloudera/chu/raw/dim_diagnostic'       OVERWRITE INTO TABLE dim_diagnostic;
LOAD DATA INPATH '/user/cloudera/chu/raw/dim_etablissement'    OVERWRITE INTO TABLE dim_etablissement;
LOAD DATA INPATH '/user/cloudera/chu/raw/dim_professionnel'    OVERWRITE INTO TABLE dim_professionnel;
LOAD DATA INPATH '/user/cloudera/chu/raw/dim_region_insee'     OVERWRITE INTO TABLE dim_region_insee;
LOAD DATA INPATH '/user/cloudera/chu/raw/fait_consultation'    OVERWRITE INTO TABLE fait_consultation;
LOAD DATA INPATH '/user/cloudera/chu/raw/fait_hospitalisation' OVERWRITE INTO TABLE fait_hospitalisation;
