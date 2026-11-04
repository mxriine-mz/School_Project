-- ELT en HiveQL : construction de FAIT_DECES et FAIT_SATISFACTION dans chu_brut (TEXTFILE).
-- Aucune colonne nom / prenom ne sort de chu_stage.stg_deces.
USE chu_brut;

-- Date partielle "1930" ou "1989-05" (ou "-00") completee au premier jour.
CREATE TEMPORARY MACRO norm_date(s STRING)
  regexp_replace(regexp_replace(
    CASE WHEN s RLIKE '^[0-9]{4}$' THEN concat(s, '-01-01')
         WHEN s RLIKE '^[0-9]{4}-[0-9]{2}$' THEN concat(s, '-01')
         ELSE s END, '-00-', '-01-'), '-00$', '-01');
-- Date lisible = format AAAA-MM-JJ ET date reelle (to_date ne la deplace pas, ex. 30 fevrier).
CREATE TEMPORARY MACRO date_ok(s STRING)
  s RLIKE '^[0-9]{4}-[0-9]{2}-[0-9]{2}$' AND to_date(s) = s;
CREATE TEMPORARY MACRO est_partielle(s STRING)
  NOT (s RLIKE '^[0-9]{4}-[0-9]{2}-[0-9]{2}$') OR s RLIKE '-00';

CREATE TABLE fait_deces (id_deces BIGINT, id_temps INT, id_region_deces INT,
  id_region_naissance INT, age_deces INT, annee_naissance INT, numero_acte_deces STRING,
  flag_date_partielle BOOLEAN, date_chargement TIMESTAMP, annee_deces INT)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' STORED AS TEXTFILE;

INSERT OVERWRITE TABLE fait_deces
SELECT d.id_deces,
       CAST(regexp_replace(d.dd, '-', '') AS INT)            AS id_temps,
       COALESCE(rd.id_region, -1)                            AS id_region_deces,
       COALESCE(rn.id_region, -1)                            AS id_region_naissance,
       d.age                                                 AS age_deces,
       IF(d.dn_ok, year(d.dn), NULL)                         AS annee_naissance,
       d.numero_acte_deces,
       d.partielle                                           AS flag_date_partielle,
       CAST(from_unixtime(unix_timestamp()) AS TIMESTAMP)    AS date_chargement,
       year(d.dd)                                            AS annee_deces
FROM (
  SELECT x.id_deces, x.dd, x.dn, x.dn_ok, x.partielle, x.numero_acte_deces,
         x.code_lieu_deces, x.code_lieu_naissance,
         IF(x.dn_ok, year(x.dd) - year(x.dn)
              - IF(substr(x.dd, 6, 5) < substr(x.dn, 6, 5), 1, 0), NULL) AS age
  FROM (
    SELECT s.off AS id_deces,
           norm_date(s.date_deces)      AS dd,
           norm_date(s.date_naissance)  AS dn,
           date_ok(norm_date(s.date_naissance)) AS dn_ok,
           (est_partielle(s.date_deces) OR est_partielle(s.date_naissance)) AS partielle,
           s.numero_acte_deces, s.code_lieu_deces, s.code_lieu_naissance,
           -- deduplication sur (nom, prenom, date_naissance, date_deces, code_lieu_deces)
           row_number() OVER (PARTITION BY s.nom, s.prenom, s.date_naissance, s.date_deces,
                                           s.code_lieu_deces ORDER BY s.off) AS rang
    FROM (SELECT BLOCK__OFFSET__INSIDE__FILE AS off, * FROM chu_stage.stg_deces) s
  ) x
  WHERE x.rang = 1 AND date_ok(x.dd)
) d
LEFT JOIN dim_region_insee rd ON rd.code_commune_insee = d.code_lieu_deces
LEFT JOIN dim_region_insee rn ON rn.code_commune_insee = d.code_lieu_naissance
WHERE d.age IS NULL OR (d.age >= 0 AND d.age <= 120);

CREATE TABLE fait_satisfaction (id_satisfaction INT, id_etablissement INT, id_region INT,
  type_enquete STRING, participation_obligatoire BOOLEAN, depot_valide BOOLEAN,
  nb_reponses INT, score DOUBLE, annee INT)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' STORED AS TEXTFILE;

INSERT OVERWRITE TABLE fait_satisfaction
SELECT row_number() OVER (ORDER BY s.type_enquete, s.finess_geo) AS id_satisfaction,
       COALESCE(e.id_etablissement, -1), COALESCE(r.id_region, -1),
       s.type_enquete,
       s.participation LIKE '1-%', s.depot LIKE '1-%',
       CAST(s.nb_rep AS INT), CAST(s.score AS DOUBLE),  -- 'NA' -> NULL
       2020
FROM (
  SELECT 'E48H' AS type_enquete, finess_geo, participation, depot, nb_rep, score FROM chu_stage.stg_esatis48h
  UNION ALL
  SELECT 'ECA'  AS type_enquete, finess_geo, participation, depot, nb_rep, score FROM chu_stage.stg_esatisca
) s
LEFT JOIN dim_etablissement e ON e.identifiant_organisation = concat('F', s.finess_geo)
LEFT JOIN dim_region_insee r ON r.code_commune_insee = e.code_commune;

SELECT COUNT(*) FROM fait_deces;
SELECT COUNT(*) FROM fait_satisfaction;
