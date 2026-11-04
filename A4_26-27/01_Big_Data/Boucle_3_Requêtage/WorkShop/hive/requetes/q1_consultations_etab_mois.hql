-- Besoin 1 : nombre de consultations par etablissement et par mois.
SELECT e.id_etablissement, e.raison_sociale_site, t.annee, t.mois,
       SUM(c.nombre_de_consultation) AS nb_consultations
FROM ${db}.fait_consultation c
JOIN ${db}.dim_temps t         ON t.id_temps = c.id_temps
JOIN ${db}.dim_etablissement e ON e.id_etablissement = c.id_etablissement
GROUP BY e.id_etablissement, e.raison_sociale_site, t.annee, t.mois;
