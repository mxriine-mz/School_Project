# Workshop 3 · Manipulation et analyse de données avec Hive

Compte-rendu du workshop de la Boucle 3 (Big Data) : bases et tables Hive (externes et internes), partitions et buckets, puis analyse de salaires en dix requêtes HiveQL (machine Cloudera 5.12, Hive 1.1).

| Fichier | Contenu |
| :--- | :--- |
| [`main.pdf`](./main.pdf) | Compte-rendu complet (parties 1 à 3, arborescence HDFS en TikZ, pièges des données et écarts à l'énoncé) |
| `scripts/` | Scripts exécutés sur la VM (`00_hdfs.sh`, `01` à `03` en `.hql`) |
| `resultats/` | Résultats attendus, notes et sorties réelles de Hive |
| `data/` | Les six fichiers de données (UTF-8, fins de ligne LF) |

Compilation : `make` (nécessite `-shell-escape` pour minted, déjà configuré).

## Logos (page de garde)

Dans `contents/img/logos/`, convertis en PNG à fond transparent (ImageMagick) :

| Logo | Source |
| :--- | :--- |
| Apache Hive | Wikimedia Commons, `Apache_Hive_logo.svg` (Apache Software Foundation, Apache 2.0) |
| Apache Hadoop | Wikimedia Commons, `Hadoop_logo.svg` (Apache Software Foundation, Apache 2.0) |
| Cloudera | Wikimedia Commons, `Cloudera_logo.svg` (marque Cloudera) |
| Hue | Dépôt officiel `cloudera/hue` sur GitHub, `docs/gethue/static/img/hue-logo.svg` |
