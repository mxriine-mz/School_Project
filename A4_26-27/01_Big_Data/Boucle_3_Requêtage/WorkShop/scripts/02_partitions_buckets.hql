-- WS Hive, partie 2 : partitions et buckets
-- Cible : Cloudera quickstart 5.12 (Hive 1.1). Lancer : hive -f 02_partitions_buckets.hql
-- Prérequis : 00_hdfs.sh puis 01_base_et_tables.hql (table htables.emploi_population)
SET hive.cli.print.header=true;
SET hive.cli.print.current.db=true;
USE htables;

SET hive.exec.dynamic.partition=true;
SET hive.exec.dynamic.partition.mode=nonstrict;
SET hive.conf.validation=false;
SET hive.enforce.bucketing=true;

-- Rejouable
DROP TABLE IF EXISTS population_genre;
DROP TABLE IF EXISTS log_internautes_buckets;
DROP TABLE IF EXISTS log_internautes_buckets2;
DROP TABLE IF EXISTS log_internautes;

-- 1. Partition par sexe
DESCRIBE emploi_population;
SELECT DISTINCT(sexe) FROM emploi_population;

CREATE EXTERNAL TABLE population_genre (
  age INT,
  fonction STRING,
  salaire STRING,
  code_postal STRING,
  id INT
)
PARTITIONED BY (sexe STRING)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ',';

INSERT OVERWRITE TABLE population_genre
PARTITION (sexe)
SELECT age, fonction, salaire, code_postal, id_empl, sexe FROM emploi_population;

SHOW PARTITIONS population_genre;
SELECT * FROM emploi_population WHERE sexe = 'F';
SELECT * FROM population_genre WHERE sexe = 'F';
dfs -ls -R /user/hive/data/htables/population_genre;

-- 2. Table intermédiaire des internautes
CREATE EXTERNAL TABLE log_internautes (
  id_internaute INT,
  prenom STRING,
  site_consulte STRING,
  date_consultation STRING,
  pays STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\073'
STORED AS TEXTFILE
LOCATION '/user/hive/data/internautes';

SELECT * FROM log_internautes;

-- 3. Partitions par date + 4 buckets par id_internaute
CREATE TABLE log_internautes_buckets (
  id_internaute INT,
  prenom STRING,
  site_consulte STRING,
  pays STRING
)
PARTITIONED BY (date_consultation STRING)
CLUSTERED BY (id_internaute) INTO 4 BUCKETS
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\073'
STORED AS TEXTFILE;

INSERT OVERWRITE TABLE log_internautes_buckets PARTITION (date_consultation)
SELECT id_internaute, prenom, site_consulte, pays, date_consultation FROM log_internautes;

DESCRIBE FORMATTED log_internautes_buckets;
SHOW PARTITIONS log_internautes_buckets;
dfs -ls -R /user/hive/data/htables/log_internautes_buckets;

-- 4. 4 buckets par pays, sans partition
CREATE TABLE log_internautes_buckets2 (
  id_internaute INT,
  prenom STRING,
  site_consulte STRING,
  date_consultation STRING,
  pays STRING
)
CLUSTERED BY (pays) INTO 4 BUCKETS
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\073'
STORED AS TEXTFILE;

INSERT OVERWRITE TABLE log_internautes_buckets2
SELECT id_internaute, prenom, site_consulte, date_consultation, pays FROM log_internautes;

DESCRIBE FORMATTED log_internautes_buckets2;
dfs -ls -R /user/hive/data/htables/log_internautes_buckets2;
-- Contenu d'un bucket (échantillon, 1er fichier)
SELECT * FROM log_internautes_buckets2 TABLESAMPLE(BUCKET 1 OUT OF 4 ON pays);
