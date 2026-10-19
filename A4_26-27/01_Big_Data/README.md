# Stockage & Big Data

Ce module aborde les solutions permettant de dépasser les limites de stockage et d'exploitation des données dans un contexte d'informations **massives, réparties et hétérogènes** : architecture Big Data, modélisation dimensionnelle, entrepôt de données, modèle physique, NoSQL, analyse OLAP et data visualisation.

**Période :** 19/10/2026 – 13/11/2026.

## Boucles d'apprentissage

| # | Boucle | Focus |
| :---: | :--- | :--- |
| 1 | [Architecture](./Boucle_1_Architecture/) | Architecture Big Data, 5 V, stockage distribué (cluster, NAS/SAN, cloud), RGPD. |
| 2 | [Préparation de données](./Boucle_2_PréparationDonnées/) | Intégration via ETL, qualification des données, anonymisation, Data Lake. |
| 3 | [Requêtage](./Boucle_3_Requêtage/) | Modèle physique et optimisation (partitionnement, buckets), SQL, MapReduce, NoSQL. |
| 4 | [Visualisation des données](./Boucle_4_VisualisationDonnées/) | Exploitation et analyse (OLAP), KPI, data visualisation et UX. |

Chaque boucle contiendra son CER (compte-rendu LaTeX → `main.pdf`).

## Projet — Entrepôt de données hospitalier

Conception et implémentation d'un **entrepôt de données décisionnel pour le secteur hospitalier** : chaque boucle traite une problématique du projet et fait avancer la mise en place de la solution Big Data.

## Compétences clés

- Décrire une architecture Big Data et une infrastructure de stockage distribuée.
- Concevoir et alimenter un modèle dimensionnel (Data Mart) à l'aide d'un ETL.
- Traiter des données dans le respect du RGPD (anonymisation).
- Choisir entre SGBDR et NoSQL (ACID vs BASE, théorème CAP) selon le besoin métier.
- Exploiter les données avec SQL et MapReduce, et optimiser le modèle physique.
- Restituer des indicateurs (KPI) via une data visualisation pensée pour l'utilisateur.
