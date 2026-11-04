-- Besoin 4 : nombre d'hospitalisations par diagnostic et par annee.
SELECT d.code_diagnostic, d.diagnostic, t.annee, COUNT(*) AS nb_hospitalisations
FROM ${db}.fait_hospitalisation h
JOIN ${db}.dim_diagnostic d ON d.id_diagnostic = h.id_diagnostic
JOIN ${db}.dim_temps t      ON t.id_temps = h.id_date_entree
GROUP BY d.code_diagnostic, d.diagnostic, t.annee;
