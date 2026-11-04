-- Besoin 7 servi par la table d'agregat (emulation de vue materialisee).
SELECT code_region, nom_region, nb_deces
FROM ${db}.agg_deces_region_annee
WHERE annee_deces = 2019;
