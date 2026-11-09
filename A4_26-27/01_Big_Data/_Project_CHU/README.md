# Projet CHU — Entrepôt de données hospitalier

Projet fil rouge du module **Big Data** (A4). Le groupe CHU (Cloud Healthcare Unit) souhaite un entrepôt de données décisionnel pour suivre l'activité de ses établissements : consultations, hospitalisations, mortalité et satisfaction des patients, à l'échelle nationale et sur plusieurs années.

Le projet est découpé en deux livrables, qui suivent la progression des boucles du module.

## [Livrable 1](./Livrable_1/) — Conception et alimentation

Modélisation dimensionnelle (schéma en constellation de Kimball) et première alimentation de l'entrepôt sur **PostgreSQL** avec **Talend Open Studio 7.3.1**.

| Dossier | Contenu |
| :--- | :--- |
| [ETL/](./Livrable_1/ETL/) | Jobs Talend J00 à J10 + job maître `PROJET_CHU`, script `entrepot.sql`, référentiel INSEE des communes. Voir `LISEZMOI.txt` pour l'installation. |
| [Rapport/](./Livrable_1/Rapport/) | Rapport LaTeX du livrable (`main.pdf`) : architecture, modèle conceptuel, spécifications des jobs. |

## [Livrable 2](./Livrable_2/) — Implémentation physique, qualité et performance

Portage de l'entrepôt vers **HDFS / Hive** (tables externes puis internes en Parquet), rapport de qualité des données, partitionnement, indexation et benchmark de requêtes. Restitution prévue dans **Power BI**.

- Dépôt : [mxriine-mz/Projet-CHU](https://github.com/mxriine-mz/Projet-CHU), intégré ici en sous-module git (projet d'équipe, en cours).
- Après un clone de ce dépôt : `git submodule update --init --recursive`. Le dépôt est privé, un accès GitHub est nécessaire.

**Équipe** : A. Tellez, M. Mazou, M. Sepulveda, N. Durtelle de Saint Sauveur.
