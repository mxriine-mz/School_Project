#!/bin/bash
# EXPLAIN (et EXPLAIN DEPENDENCY pour les partitions lues) de chaque requete sur chaque design.
cd "$(dirname "$0")"; mkdir -p logs/explain
for q in requetes/q*.hql; do
  for db in chu_brut chu_opt; do
    design=${db#chu_}
    cat 00_commun.hql 10_reglages_$design.hql > /tmp/init_$design.hql
    B=logs/explain/$(basename $q .hql)_$design
    { echo "EXPLAIN"; grep -v '^--' $q; } > /tmp/ex.hql
    { echo "EXPLAIN DEPENDENCY"; grep -v '^--' $q; } > /tmp/exd.hql
    beeline -u jdbc:hive2://localhost:10000/default -n cloudera --outputformat=tsv2 \
      --hivevar db=$db -i /tmp/init_$design.hql -f /tmp/ex.hql 2>/dev/null > $B.explain.txt
    beeline -u jdbc:hive2://localhost:10000/default -n cloudera --outputformat=tsv2 \
      --hivevar db=$db -i /tmp/init_$design.hql -f /tmp/exd.hql 2>/dev/null > $B.dependency.txt
  done
done
