-- Requete a 3 jointures sur FAIT_DECES (2010-2019) : deces par annee, region de deces,
-- type de zone de naissance, avec age moyen.
SELECT t.annee, rd.nom_region AS region_deces, rn.type_zone AS zone_naissance,
       COUNT(*) AS nb_deces, AVG(f.age_deces) AS age_moyen
FROM ${db}.fait_deces f
JOIN ${db}.dim_temps t         ON t.id_temps = f.id_temps
JOIN ${db}.dim_region_insee rd ON rd.id_region = f.id_region_deces
JOIN ${db}.dim_region_insee rn ON rn.id_region = f.id_region_naissance
WHERE f.annee_deces BETWEEN 2010 AND 2019
GROUP BY t.annee, rd.nom_region, rn.type_zone;
