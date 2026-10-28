# Workshop 3 · Manipulation et analyse de données avec Hive

Compte-rendu du workshop de la Boucle 3 (Big Data) : bases et tables Hive (externes et internes), partitions et buckets, puis analyse de salaires en dix requêtes HiveQL (machine Cloudera 5.12, Hive 1.1).

| Fichier | Contenu |
| :--- | :--- |
| [`main.pdf`](./main.pdf) | Compte-rendu complet (parties 1 à 3, arborescence HDFS en TikZ, pièges des données et écarts à l'énoncé) |
| `scripts/` | Scripts exécutés sur la VM (`00_hdfs.sh`, `01` à `03` en `.hql`) |
| `resultats/` | Résultats attendus, notes et sorties réelles de Hive |
| `data/` | Les six fichiers de données (UTF-8, fins de ligne LF) |

Compilation : `make` (nécessite `-shell-escape` pour minted, déjà configuré).
