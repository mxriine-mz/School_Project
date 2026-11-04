-- Besoin 7 : nombre de deces par region (lieu de deces) en 2019.
-- annee_deces est une colonne dans chu_brut et la colonne de partition dans chu_opt.
SELECT r.code_region, r.nom_region, COUNT(*) AS nb_deces
FROM ${db}.fait_deces f
JOIN ${db}.dim_region_insee r ON r.id_region = f.id_region_deces
WHERE f.annee_deces = 2019
GROUP BY r.code_region, r.nom_region;
