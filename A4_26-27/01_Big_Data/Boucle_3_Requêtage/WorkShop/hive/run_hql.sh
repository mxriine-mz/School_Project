#!/bin/bash
# Lance un script HiveQL via beeline (sur la VM) et mesure le temps mural.
# Usage : [TAG=suffixe] ./run_hql.sh fichier.hql [fichier_init.hql] [args beeline...]
#         -> log dans logs/<fichier><TAG>.log, temps ajoute a logs/temps_chargement.txt
cd "$(dirname "$0")"; mkdir -p logs
F=$1; INIT=${2:-00_commun.hql}; shift; shift
LOG=logs/$(basename "$F" .hql)${TAG}.log
T0=$(date +%s.%N)
beeline -u jdbc:hive2://localhost:10000/default -n cloudera --outputformat=tsv2 \
        -i "$INIT" "$@" -f "$F" > "$LOG" 2>&1
RC=$?
T1=$(date +%s.%N)
printf '%s%s rc=%s mur=%.1fs\n' "$F" "$TAG" "$RC" "$(echo "$T1 - $T0" | bc)" | tee -a logs/temps_chargement.txt
grep -E "rows selected|rows affected|No rows|Error|FAILED" "$LOG" | tail -20
