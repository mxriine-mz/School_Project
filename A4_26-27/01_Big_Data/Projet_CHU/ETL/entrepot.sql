-- Entrepôt de données du CHU : schémas et tables (modèle de la partie 1)
-- Base : chu. Le schéma public contient la base opérationnelle restaurée (DATA2023).

CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE SCHEMA IF NOT EXISTS transit;
CREATE SCHEMA IF NOT EXISTS entrepot;

-- Dimensions
CREATE TABLE IF NOT EXISTS entrepot.dim_temps (
    id_temps   INT PRIMARY KEY,
    date       DATE NOT NULL,
    jour       INT NOT NULL,
    semaine    INT NOT NULL,
    mois       INT NOT NULL,
    trimestre  INT NOT NULL,
    semestre   INT NOT NULL,
    annee      INT NOT NULL
);

CREATE TABLE IF NOT EXISTS entrepot.dim_patient (
    id_patient      INT PRIMARY KEY,
    sexe            CHAR(1) NOT NULL,
    age             INT
);

CREATE TABLE IF NOT EXISTS entrepot.dim_diagnostic (
    id_diagnostic    INT PRIMARY KEY,
    code_diagnostic  VARCHAR(10) NOT NULL UNIQUE,
    diagnostic       VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS entrepot.dim_etablissement (
    id_etablissement                INT PRIMARY KEY,
    finess_site                     CHAR(9),
    finess_etablissement_juridique  CHAR(9),
    identifiant_organisation        VARCHAR(30) NOT NULL UNIQUE,
    raison_sociale_site             VARCHAR(255) NOT NULL,
    enseigne_commerciale_site       VARCHAR(255),
    adresse                         VARCHAR(255),
    code_commune                    CHAR(5),
    code_postal                     CHAR(5),
    commune                         VARCHAR(100),
    pays                            VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS entrepot.dim_professionnel (
    id_professionnel           INT PRIMARY KEY,
    identifiant                VARCHAR(20) NOT NULL UNIQUE,
    type_identifiant           VARCHAR(10) NOT NULL,
    civilite                   VARCHAR(10),
    nom                        VARCHAR(100) NOT NULL,
    prenom                     VARCHAR(100),
    categorie_professionnelle  VARCHAR(50),
    profession                 VARCHAR(100),
    specialite                 VARCHAR(150),
    commune                    VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS entrepot.dim_region_insee (
    id_region           INT PRIMARY KEY,
    code_commune_insee  CHAR(5),
    code_departement    VARCHAR(3),
    nom_departement     VARCHAR(100),
    code_region         VARCHAR(3),
    nom_region          VARCHAR(100),
    pays                VARCHAR(60),
    type_zone           VARCHAR(10) NOT NULL
);

-- Faits
CREATE TABLE IF NOT EXISTS entrepot.fait_consultation (
    num_consultation        INT PRIMARY KEY,
    id_patient              INT NOT NULL REFERENCES entrepot.dim_patient,
    id_temps                INT NOT NULL REFERENCES entrepot.dim_temps,
    id_professionnel        INT NOT NULL REFERENCES entrepot.dim_professionnel,
    id_diagnostic           INT NOT NULL REFERENCES entrepot.dim_diagnostic,
    id_etablissement        INT NOT NULL REFERENCES entrepot.dim_etablissement,
    nombre_de_consultation  INT NOT NULL
);

CREATE TABLE IF NOT EXISTS entrepot.fait_hospitalisation (
    id_hospitalisation    INT PRIMARY KEY,
    id_patient            INT NOT NULL REFERENCES entrepot.dim_patient,
    id_etablissement      INT NOT NULL REFERENCES entrepot.dim_etablissement,
    id_diagnostic         INT NOT NULL REFERENCES entrepot.dim_diagnostic,
    id_date_entree        INT NOT NULL REFERENCES entrepot.dim_temps,
    num_hospitalisation   VARCHAR(20) NOT NULL,
    jour_hospitalisation  INT
);

CREATE TABLE IF NOT EXISTS entrepot.fait_satisfaction (
    id_satisfaction            INT PRIMARY KEY,
    id_etablissement           INT NOT NULL REFERENCES entrepot.dim_etablissement,
    id_region                  INT NOT NULL REFERENCES entrepot.dim_region_insee,
    participation_obligatoire  BOOLEAN,
    depot_valide               BOOLEAN,
    nb_reponses                INT,
    score                      NUMERIC(5,2),
    annee                      INT NOT NULL
);

CREATE TABLE IF NOT EXISTS entrepot.fait_deces (
    id_deces             INT PRIMARY KEY,
    id_temps             INT NOT NULL REFERENCES entrepot.dim_temps,
    id_region_deces      INT NOT NULL REFERENCES entrepot.dim_region_insee,
    id_region_naissance  INT NOT NULL REFERENCES entrepot.dim_region_insee,
    age_deces            INT,
    annee_naissance      INT,
    numero_acte_deces    VARCHAR(10),
    flag_date_partielle  BOOLEAN NOT NULL,
    date_chargement      TIMESTAMP NOT NULL
);
