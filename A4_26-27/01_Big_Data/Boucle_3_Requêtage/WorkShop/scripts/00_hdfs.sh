#!/bin/bash
# Prépare HDFS pour le WS Hive (Cloudera quickstart 5.12).
# A lancer en tant que cloudera (ou hdfs dfs -chmod 777 nécessite les droits sur le répertoire).
# Prérequis : les 6 fichiers de data/ sont copiés dans /home/cloudera/ (UTF-8, fins de ligne LF).
# Usage : bash 00_hdfs.sh   (rejouable : -f / -p évitent les erreurs si déjà présent)
set -u
SRC=/home/cloudera

# --- Partie 1 : base htables, tables externes, table interne ---
hdfs dfs -chmod 777 /user/hive/warehouse
hdfs dfs -mkdir -p /user/hive/data
hdfs dfs -chmod 777 /user/hive/data

# emploi_population.txt dans son propre dossier (cf. NOTES.md : /user/hive/data contient des sous-dossiers)
hdfs dfs -mkdir -p /user/hive/data/emploi_population
hdfs dfs -chmod 777 /user/hive/data/emploi_population
hdfs dfs -copyFromLocal -f $SRC/emploi_population.txt /user/hive/data/emploi_population/

# personne.txt dans le warehouse (LOAD DATA INPATH le déplace ensuite : à recopier avant chaque rejeu de 01)
hdfs dfs -copyFromLocal -f $SRC/personne.txt /user/hive/warehouse/
hdfs dfs -ls /user/hive/warehouse

# --- Partie 2 : partitions et buckets ---
hdfs dfs -mkdir -p /user/hive/data/internautes
hdfs dfs -chmod 777 /user/hive/data/internautes
hdfs dfs -copyFromLocal -f $SRC/internautes_log.txt /user/hive/data/internautes/

# --- Partie 3 : analyse_salaires ---
hdfs dfs -mkdir -p /user/hive/data/employes /user/hive/data/salaire /user/hive/data/fonction
hdfs dfs -chmod 777 /user/hive/data/employes
hdfs dfs -chmod 777 /user/hive/data/salaire
hdfs dfs -chmod 777 /user/hive/data/fonction
hdfs dfs -copyFromLocal -f $SRC/employes.txt           /user/hive/data/employes/
hdfs dfs -copyFromLocal -f $SRC/salaire_employes.txt   /user/hive/data/salaire/
hdfs dfs -copyFromLocal -f $SRC/fonction_employes.txt  /user/hive/data/fonction/

hdfs dfs -ls -R /user/hive/data
