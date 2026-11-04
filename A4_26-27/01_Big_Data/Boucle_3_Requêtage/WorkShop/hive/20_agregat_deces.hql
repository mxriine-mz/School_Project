-- Hive 1.1 (CDH 5.12) n'a pas de vues materialisees (arrivees en Hive 3.0).
-- Emulation : table d'agregat precalculee par CTAS, a rafraichir apres chaque chargement.
-- Usage : --hivevar db=chu_brut --hivevar fmt=TEXTFILE  |  --hivevar db=chu_opt --hivevar fmt=ORC
DROP TABLE IF EXISTS ${db}.agg_deces_region_annee;
CREATE TABLE ${db}.agg_deces_region_annee STORED AS ${fmt} AS
SELECT f.annee_deces, r.code_region, r.nom_region, COUNT(*) AS nb_deces
FROM ${db}.fait_deces f
JOIN ${db}.dim_region_insee r ON r.id_region = f.id_region_deces
GROUP BY f.annee_deces, r.code_region, r.nom_region;
