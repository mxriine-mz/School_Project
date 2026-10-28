# Notes : pièges des données et écarts par rapport à l'énoncé

Cible : Cloudera quickstart 5.12 (Hive 1.1). Scripts exécutés pour de vrai le 2026-10-28 sur la VM (00, 01, 02, 03 rejoués de bout en bout après corrections) ; sorties brutes dans `sorties/`. `attendus.md` est calculé en Python.

## Pièges des données
- **Encodage** : `fonction_employes.txt` et `salaire_employes.txt` étaient en ISO-8859-1 ; convertis en UTF-8 dans `data/` (accents de « profession juridique privé » et en-tête « année-embauche »).
- **Fins de ligne** : les 6 fichiers d'origine étaient en CRLF. Hive garderait le `\r` dans la dernière colonne (id INT, fonction...), ce qui donne NULL sur les INT. `data/` est converti en LF. Si on recopie les fichiers d'origine sur la VM, faire `dos2unix` avant.
- **En-têtes** : `fonction_employes.txt` et `salaire_employes.txt` ont une ligne d'en-tête (`skip.header.line.count=1`). `employes.txt`, `emploi_population.txt`, `personne.txt`, `internautes_log.txt` n'en ont pas.
- **Date** : `emploi_population.txt` est en AAAA-MM-JJ (type DATE OK) ; `employes.txt` est en JJ/MM/AAAA (gardé en STRING, pas utilisé dans les requêtes).
- **Salaire en chaîne** : `20000euro/an`. Conversion par `CAST(REGEXP_REPLACE(salaire,'[^0-9]','') AS INT)`. La ligne id 26 contient la faute `42000euo/an` : cette regex la traite aussi.
- **Noms de fichiers** : l'énoncé cite `employes1.csv`, `salaire_employes.csv`, `fonction_employes.csv` ; les vrais fichiers sont des `.txt` (`employes.txt`...).
- **personne.txt** a 3 colonnes (id;nom;prénoms), l'énoncé demande 2 champs : le 3e est ignoré par la table.
- **Colonne prenom** de `employes` : contient tous les prénoms d'état civil, pas un seul.
- **Q7** : `75780` (id 7) passe le filtre 75xxx sans être un code postal parisien.
- Q4, Q8, Q9, Q10 et la colonne `age` de `emploi_population` dépendent de l'année d'exécution (attendus calculés avec 2026 / 2026-10-28).

## Écarts par rapport à l'énoncé
- **CURRENT_TIMESTAMP()** : existe bien dans le Hive 1.1 de CDH 5.12 (testé : `current_timestamp()`, `current_date()`). Syntaxe de l'énoncé rétablie dans le CTAS ; année courante des questions via `YEAR(CURRENT_DATE())`.
- **LOCATION de log_emploi_population** : `/user/hive/data/emploi_population` au lieu de `/user/hive/data`. Ce dossier contient aussi les sous-dossiers `internautes`, `employes`, `htables`..., que Hive ne sait pas lire (« Not a file ») sur une table texte.
- **Faute dans l'énoncé** : « supprimer la table log_salaire_population » ; la table s'appelle `log_emploi_population`.
- **Base htables** : l'énoncé fait `CREATE DATABASE htables` puis `CREATE DATABASE IF NOT EXISTS ... LOCATION` (sans effet, la base existe). Le script ne garde que la 2e forme, avec `DROP DATABASE IF EXISTS ... CASCADE` en tête pour être rejouable.
- **Rejeu de 01** : `LOAD DATA` déplace `personne.txt` hors de `/user/hive/warehouse` ; relancer `00_hdfs.sh` avant de rejouer.
- **personne** : l'énoncé laisse la définition à compléter ; choisi `(id INT, nom STRING)`.
- **population_genre** est créée EXTERNAL sans LOCATION (comme l'énoncé), séparateur `,` ; les fichiers de partition sont donc écrits dans le dossier de la base `htables`.
- **population_genre.age INT** reçoit un DOUBLE (résultat de ROUND) : conversion implicite.
- **Q4** : `RANK()` (fonction de fenêtrage, dispo en 1.1) pour garder les ex-aequo ; pas de sous-requête scalaire (non supportée en 1.1).
- **Q3** : la vue de l'énoncé (employes + fonction_employes, > 2010) ne contient pas le secteur ; jointure supplémentaire avec `salaire_employes`.
- Ajout d'une vue utilitaire `v_employes_complet` (jointure des 3 tables, salaire numérique, expérience) pour Q2 et Q4 à Q10.
- `SET hive.enforce.bucketing=true` : conservé (valable en Hive 1.1, supprimé en Hive 4).
- Ajout de commandes `dfs -ls` dans les .hql pour visualiser les fichiers/buckets sans passer par l'interface web du namenode.

## Corrections faites à l'exécution (VM réelle, Hive 1.1 CDH 5.12)
- **`FIELDS TERMINATED BY ';'`** (01, 02, 03) : le CLI Hive coupe l'instruction au `;` placé dans la chaîne. Erreur : `ParseException line 13:22 mismatched input '<EOF>' expecting StringLiteral near 'BY' in table row format's field separator`. Correctif : `'\073'` (code octal du point-virgule) dans les 9 occurrences.
- **Q2 (jointure des 3 tables)** : `FAILED: Execution Error, return code 1 from org.apache.hadoop.hive.ql.exec.mr.MapredLocalTask` (NullPointerException dans la tâche locale de map-join). Correctif : `SET hive.auto.convert.join=false;` en tête de 03.
- **Q7** : `SemanticException [Error 10004] Invalid table alias or column reference 'id_empl'` : `ORDER BY id_empl` sur une colonne absente du SELECT. Correctif : `SELECT prenom, fonction, code_postal ... ORDER BY code_postal`.
- **CURRENT_TIMESTAMP** : voir plus haut (le remplacement n'était pas nécessaire).
- Sans autre changement : `TABLESAMPLE(BUCKET 1 OUT OF 4 ON pays)`, `dfs -ls` dans les .hql, chemin `/user/hive/data/htables`, `RANK() OVER`, `collect_set` fonctionnent tels quels.

## Incidents VM (hors scripts)
- Au départ HDFS restait en safe mode : datanode refusé (`not in the include-list`, 127.0.0.1 vs 192.168.56.101). Réglé par redémarrage de HDFS via l'API Cloudera Manager ; YARN, ZooKeeper et Hive démarrés via CM. ZooKeeper est nécessaire : Hive CLI le contacte (verrous) et reste bloqué sans lui.
- La VM est très lente (4 coeurs, charge 15 à 100) : des requêtes MapReduce restent bloquées plusieurs minutes (ex. `SELECT ... WHERE sexe='F'` à 433 s lors d'un premier passage). Les temps du rejeu final sont plus fiables mais restent sensibles à la charge.
- Les accents sortent en `??` dans la sortie console des commentaires (ex. `donn??es`) : codage de la JVM de la VM, sans effet sur les données (les valeurs avec accents s'affichent bien).
- `age` est de type DOUBLE dans `emploi_population` (ROUND renvoie un double) : affiché `38.0` ; `population_genre.age INT` affiche `38`.
