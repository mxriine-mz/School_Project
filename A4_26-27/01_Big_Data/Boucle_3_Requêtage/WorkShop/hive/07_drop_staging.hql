-- Suppression de la zone de staging qui contient des noms (table externe + fichier HDFS).
DROP TABLE IF EXISTS chu_stage.stg_deces;
DROP TABLE IF EXISTS chu_stage.stg_esatis48h;
DROP TABLE IF EXISTS chu_stage.stg_esatisca;
DROP DATABASE IF EXISTS chu_stage;
dfs -rm -r -skipTrash /user/cloudera/chu/stage;
