-- Besoin 8 : score de satisfaction moyen pondere par le nombre de reponses, par region, 2020.
SELECT r.nom_region, s.type_enquete,
       SUM(s.score * s.nb_reponses) / SUM(s.nb_reponses) AS score_pondere,
       SUM(s.nb_reponses) AS nb_reponses
FROM ${db}.fait_satisfaction s
JOIN ${db}.dim_region_insee r ON r.id_region = s.id_region
WHERE s.annee = 2020 AND s.score IS NOT NULL AND s.nb_reponses > 0
GROUP BY r.nom_region, s.type_enquete;
