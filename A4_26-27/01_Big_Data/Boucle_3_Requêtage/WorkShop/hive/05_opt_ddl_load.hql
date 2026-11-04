-- Design OPTIMISE : chu_opt = ORC compresse SNAPPY, faits partitionnes par annee
-- et bucketes sur la cle de jointure principale, dimensions de jointure bucketees pareil.
-- Alimente par INSERT ... SELECT depuis chu_brut (memes donnees, autre stockage).
SET hive.exec.dynamic.partition=true;
SET hive.exec.dynamic.partition.mode=nonstrict;
SET hive.exec.max.dynamic.partitions=2000;
SET hive.exec.max.dynamic.partitions.pernode=2000;
SET hive.enforce.bucketing=true;
SET hive.enforce.sorting=true;
SET hive.optimize.sort.dynamic.partition=true;

CREATE DATABASE IF NOT EXISTS chu_opt;
USE chu_opt;

CREATE TABLE dim_temps (id_temps INT, date_jour DATE, jour INT, semaine INT, mois INT,
  trimestre INT, semestre INT, annee INT)
STORED AS ORC TBLPROPERTIES ('orc.compress'='SNAPPY');
CREATE TABLE dim_patient (id_patient INT, sexe STRING, age INT)
STORED AS ORC TBLPROPERTIES ('orc.compress'='SNAPPY');
CREATE TABLE dim_diagnostic (id_diagnostic INT, code_diagnostic STRING, diagnostic STRING)
STORED AS ORC TBLPROPERTIES ('orc.compress'='SNAPPY');
CREATE TABLE dim_etablissement (id_etablissement INT, finess_site STRING,
  finess_etablissement_juridique STRING, identifiant_organisation STRING,
  raison_sociale_site STRING, enseigne_commerciale_site STRING, adresse STRING,
  code_commune STRING, code_postal STRING, commune STRING, pays STRING)
CLUSTERED BY (id_etablissement) SORTED BY (id_etablissement) INTO 8 BUCKETS
STORED AS ORC TBLPROPERTIES ('orc.compress'='SNAPPY');
CREATE TABLE dim_professionnel (id_professionnel INT, identifiant STRING, type_identifiant STRING,
  categorie_professionnelle STRING, profession STRING, specialite STRING, commune STRING)
STORED AS ORC TBLPROPERTIES ('orc.compress'='SNAPPY');
CREATE TABLE dim_region_insee (id_region INT, code_commune_insee STRING, code_departement STRING,
  nom_departement STRING, code_region STRING, nom_region STRING, pays STRING, type_zone STRING)
CLUSTERED BY (id_region) SORTED BY (id_region) INTO 4 BUCKETS
STORED AS ORC TBLPROPERTIES ('orc.compress'='SNAPPY');

CREATE TABLE fait_consultation (num_consultation BIGINT, id_patient INT, id_temps INT,
  id_professionnel INT, id_diagnostic INT, id_etablissement INT, nombre_de_consultation INT)
PARTITIONED BY (annee INT)
CLUSTERED BY (id_etablissement) SORTED BY (id_etablissement) INTO 8 BUCKETS
STORED AS ORC TBLPROPERTIES ('orc.compress'='SNAPPY');
-- 2 479 lignes : partitionner creerait des fichiers minuscules, on garde un seul ORC.
CREATE TABLE fait_hospitalisation (id_hospitalisation INT, id_patient INT, id_etablissement INT,
  id_diagnostic INT, id_date_entree INT, num_hospitalisation STRING, jour_hospitalisation INT)
STORED AS ORC TBLPROPERTIES ('orc.compress'='SNAPPY');
CREATE TABLE fait_deces (id_deces BIGINT, id_temps INT, id_region_deces INT,
  id_region_naissance INT, age_deces INT, annee_naissance INT, numero_acte_deces STRING,
  flag_date_partielle BOOLEAN, date_chargement TIMESTAMP)
PARTITIONED BY (annee_deces INT)
CLUSTERED BY (id_region_deces) SORTED BY (id_region_deces) INTO 4 BUCKETS
STORED AS ORC TBLPROPERTIES ('orc.compress'='SNAPPY');
CREATE TABLE fait_satisfaction (id_satisfaction INT, id_etablissement INT, id_region INT,
  type_enquete STRING, participation_obligatoire BOOLEAN, depot_valide BOOLEAN,
  nb_reponses INT, score DOUBLE)
PARTITIONED BY (annee INT)
STORED AS ORC TBLPROPERTIES ('orc.compress'='SNAPPY');

INSERT OVERWRITE TABLE dim_temps         SELECT * FROM chu_brut.dim_temps;
INSERT OVERWRITE TABLE dim_patient       SELECT * FROM chu_brut.dim_patient;
INSERT OVERWRITE TABLE dim_diagnostic    SELECT * FROM chu_brut.dim_diagnostic;
INSERT OVERWRITE TABLE dim_etablissement SELECT * FROM chu_brut.dim_etablissement;
INSERT OVERWRITE TABLE dim_professionnel SELECT * FROM chu_brut.dim_professionnel;
INSERT OVERWRITE TABLE dim_region_insee  SELECT * FROM chu_brut.dim_region_insee;
INSERT OVERWRITE TABLE fait_hospitalisation SELECT * FROM chu_brut.fait_hospitalisation;
INSERT OVERWRITE TABLE fait_consultation PARTITION (annee)
  SELECT c.*, CAST(c.id_temps / 10000 AS INT) AS annee FROM chu_brut.fait_consultation c;
INSERT OVERWRITE TABLE fait_deces PARTITION (annee_deces)
  SELECT * FROM chu_brut.fait_deces;
INSERT OVERWRITE TABLE fait_satisfaction PARTITION (annee)
  SELECT * FROM chu_brut.fait_satisfaction;
