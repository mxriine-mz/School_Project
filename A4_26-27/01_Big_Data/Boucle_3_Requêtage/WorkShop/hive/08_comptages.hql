-- Nombre de lignes par table dans chaque design (passer --hivevar db=chu_brut|chu_opt).
SELECT 'dim_temps', COUNT(*) FROM ${db}.dim_temps
UNION ALL SELECT 'dim_patient', COUNT(*) FROM ${db}.dim_patient
UNION ALL SELECT 'dim_diagnostic', COUNT(*) FROM ${db}.dim_diagnostic
UNION ALL SELECT 'dim_etablissement', COUNT(*) FROM ${db}.dim_etablissement
UNION ALL SELECT 'dim_professionnel', COUNT(*) FROM ${db}.dim_professionnel
UNION ALL SELECT 'dim_region_insee', COUNT(*) FROM ${db}.dim_region_insee
UNION ALL SELECT 'fait_consultation', COUNT(*) FROM ${db}.fait_consultation
UNION ALL SELECT 'fait_hospitalisation', COUNT(*) FROM ${db}.fait_hospitalisation
UNION ALL SELECT 'fait_deces', COUNT(*) FROM ${db}.fait_deces
UNION ALL SELECT 'fait_satisfaction', COUNT(*) FROM ${db}.fait_satisfaction;
