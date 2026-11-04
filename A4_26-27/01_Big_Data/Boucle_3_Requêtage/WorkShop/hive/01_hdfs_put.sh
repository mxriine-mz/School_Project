#!/bin/bash
# Depose les fichiers bruts dans HDFS (a lancer sur la VM, utilisateur cloudera).
# Entree : ~/chu/export/*.tsv (export PostgreSQL entrepot + satisfaction 2020) et ~/chu/deces.csv
set -e
R=/user/cloudera/chu
hdfs dfs -rm -r -f -skipTrash $R
for t in dim_temps dim_patient dim_diagnostic dim_etablissement dim_professionnel dim_region_insee \
         fait_consultation fait_hospitalisation sat_esatis48h sat_esatisca; do
  hdfs dfs -mkdir -p $R/raw/$t
  hdfs dfs -put ~/chu/export/$t.tsv $R/raw/$t/
done
hdfs dfs -mkdir -p $R/stage/deces
hdfs dfs -put ~/chu/deces.csv $R/stage/deces/
hdfs dfs -du -h $R/raw $R/stage
