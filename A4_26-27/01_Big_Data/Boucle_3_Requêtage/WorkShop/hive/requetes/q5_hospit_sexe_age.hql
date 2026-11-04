-- Besoin 5 : nombre d'hospitalisations par sexe et tranche d'age.
SELECT p.sexe,
       CASE WHEN p.age IS NULL THEN 'inconnu' WHEN p.age < 18 THEN '00-17'
            WHEN p.age < 40 THEN '18-39' WHEN p.age < 65 THEN '40-64'
            WHEN p.age < 80 THEN '65-79' ELSE '80+' END AS tranche_age,
       COUNT(*) AS nb_hospitalisations
FROM ${db}.fait_hospitalisation h
JOIN ${db}.dim_patient p ON p.id_patient = h.id_patient
GROUP BY p.sexe,
       CASE WHEN p.age IS NULL THEN 'inconnu' WHEN p.age < 18 THEN '00-17'
            WHEN p.age < 40 THEN '18-39' WHEN p.age < 65 THEN '40-64'
            WHEN p.age < 80 THEN '65-79' ELSE '80+' END;
