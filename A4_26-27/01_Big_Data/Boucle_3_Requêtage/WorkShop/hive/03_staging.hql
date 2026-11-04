-- Zone de staging (ELT). stg_deces contient des noms : table EXTERNE, supprimee en 06.
CREATE DATABASE IF NOT EXISTS chu_stage;
USE chu_stage;

CREATE EXTERNAL TABLE stg_deces (nom STRING, prenom STRING, sexe STRING, date_naissance STRING,
  code_lieu_naissance STRING, lieu_naissance STRING, pays_naissance STRING, date_deces STRING,
  code_lieu_deces STRING, numero_acte_deces STRING)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES ('separatorChar'=',', 'quoteChar'='"')
STORED AS TEXTFILE LOCATION '/user/cloudera/chu/stage/deces'
TBLPROPERTIES ('skip.header.line.count'='1');

-- Satisfaction 2020 : seules les 9 premieres colonnes servent (les suivantes sont ignorees).
CREATE EXTERNAL TABLE stg_esatis48h (finess STRING, rs_finess STRING, finess_geo STRING,
  rs_finess_geo STRING, region STRING, participation STRING, depot STRING, nb_rep STRING, score STRING)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' STORED AS TEXTFILE
LOCATION '/user/cloudera/chu/raw/sat_esatis48h' TBLPROPERTIES ('skip.header.line.count'='1');

CREATE EXTERNAL TABLE stg_esatisca (finess STRING, rs_finess STRING, finess_geo STRING,
  rs_finess_geo STRING, region STRING, participation STRING, depot STRING, nb_rep STRING, score STRING)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' STORED AS TEXTFILE
LOCATION '/user/cloudera/chu/raw/sat_esatisca' TBLPROPERTIES ('skip.header.line.count'='1');

SELECT COUNT(*) FROM stg_deces;
SELECT COUNT(*) FROM stg_esatis48h;
SELECT COUNT(*) FROM stg_esatisca;
