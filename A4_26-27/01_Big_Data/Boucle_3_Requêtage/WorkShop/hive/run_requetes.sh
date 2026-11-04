#!/bin/bash
# Execute chaque requete 3 fois sur chaque design et releve le temps beeline + le nombre de lignes.
# Usage (sur la VM) : ./run_requetes.sh [nb_runs] [requetes...]
cd "$(dirname "$0")"; mkdir -p logs/requetes
RUNS=${1:-3}; shift
QS=${@:-requetes/q*.hql}
OUT=logs/mesures.tsv
[ -f $OUT ] || printf 'requete\tdesign\trun\tbeeline_s\tmur_s\tlignes\tstatut\n' > $OUT
for q in $QS; do
  for db in chu_brut chu_opt; do
    design=${db#chu_}
    cat 00_commun.hql 10_reglages_$design.hql > /tmp/init_$design.hql
    for r in $(seq 1 $RUNS); do
      L=logs/requetes/$(basename $q .hql)_${design}_$r.log
      T0=$(date +%s.%N)
      beeline -u jdbc:hive2://localhost:10000/default -n cloudera --outputformat=tsv2 \
        --hivevar db=$db -i /tmp/init_$design.hql -f $q > $L.out 2> $L
      RC=$?
      T1=$(date +%s.%N)
      LINE=$(grep -E "rows? selected|No rows selected" $L | tail -1)
      SECS=$(echo "$LINE" | grep -oE '\(([0-9.]+) seconds\)' | grep -oE '[0-9.]+')
      ROWS=$(echo "$LINE" | grep -oE '^[0-9]+')
      echo "$LINE" | grep -q "No rows" && ROWS=0
      ST=OK; [ $RC -ne 0 -o -z "$SECS" ] && ST="ECHEC rc=$RC"
      printf '%s\t%s\t%s\t%s\t%.1f\t%s\t%s\n' $(basename $q .hql) $design $r "${SECS:-NA}" \
        "$(echo "$T1 - $T0" | bc)" "${ROWS:-NA}" "$ST" | tee -a $OUT
    done
  done
done
