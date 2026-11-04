-- Statistiques de table et de colonnes (utilisees par l'optimiseur pour choisir les map joins).
USE chu_opt;
-- Hive 1.1 refuse les stats de colonne sur un type DATE : liste explicite sans date_jour.
ANALYZE TABLE dim_temps COMPUTE STATISTICS;
ANALYZE TABLE dim_temps COMPUTE STATISTICS FOR COLUMNS id_temps, jour, semaine, mois, trimestre, semestre, annee;
ANALYZE TABLE dim_patient COMPUTE STATISTICS;        ANALYZE TABLE dim_patient COMPUTE STATISTICS FOR COLUMNS;
ANALYZE TABLE dim_diagnostic COMPUTE STATISTICS;     ANALYZE TABLE dim_diagnostic COMPUTE STATISTICS FOR COLUMNS;
ANALYZE TABLE dim_etablissement COMPUTE STATISTICS;  ANALYZE TABLE dim_etablissement COMPUTE STATISTICS FOR COLUMNS;
ANALYZE TABLE dim_professionnel COMPUTE STATISTICS;  ANALYZE TABLE dim_professionnel COMPUTE STATISTICS FOR COLUMNS;
ANALYZE TABLE dim_region_insee COMPUTE STATISTICS;   ANALYZE TABLE dim_region_insee COMPUTE STATISTICS FOR COLUMNS;
ANALYZE TABLE fait_hospitalisation COMPUTE STATISTICS; ANALYZE TABLE fait_hospitalisation COMPUTE STATISTICS FOR COLUMNS;
ANALYZE TABLE fait_consultation PARTITION (annee) COMPUTE STATISTICS;
ANALYZE TABLE fait_consultation PARTITION (annee) COMPUTE STATISTICS FOR COLUMNS;
ANALYZE TABLE fait_deces PARTITION (annee_deces) COMPUTE STATISTICS;
ANALYZE TABLE fait_deces PARTITION (annee_deces) COMPUTE STATISTICS FOR COLUMNS;
ANALYZE TABLE fait_satisfaction PARTITION (annee) COMPUTE STATISTICS;
ANALYZE TABLE fait_satisfaction PARTITION (annee) COMPUTE STATISTICS FOR COLUMNS;
