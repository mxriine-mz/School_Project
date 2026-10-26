-- Entrepôt de données du CHU : schémas et tables (modèle de la partie 1)
-- Base : chu. Le schéma public contient la base opérationnelle restaurée (DATA2023).

CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE SCHEMA IF NOT EXISTS transit;
CREATE SCHEMA IF NOT EXISTS entrepot;

-- Dimensions
CREATE TABLE IF NOT EXISTS entrepot.dim_temps (
    id_temps   INTEGER PRIMARY KEY,
    date       DATE NOT NULL,
    jour       SMALLINT NOT NULL,
    semaine    SMALLINT NOT NULL,
    mois       SMALLINT NOT NULL,
    trimestre  SMALLINT NOT NULL,
    semestre   SMALLINT NOT NULL,
    annee      SMALLINT NOT NULL
);

CREATE TABLE IF NOT EXISTS entrepot.dim_patient (
    id_patient      INTEGER PRIMARY KEY,
    nom             VARCHAR(100),
    prenom          VARCHAR(100),
    sexe            CHAR(1) NOT NULL,
    adresse         VARCHAR(255),
    ville           VARCHAR(100),
    code_postal     CHAR(5),
    pays            VARCHAR(50),
    email           VARCHAR(255),
    tel             VARCHAR(20),
    date_naissance  DATE,
    age             SMALLINT,
    num_secu        CHAR(15),
    groupe_sanguin  VARCHAR(3),
    poids           NUMERIC(5,1),
    taille          NUMERIC(4,1)
);

CREATE TABLE IF NOT EXISTS entrepot.dim_diagnostic (
    id_diagnostic    INTEGER PRIMARY KEY,
    code_diagnostic  VARCHAR(10) NOT NULL UNIQUE,
    diagnostic       VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS entrepot.dim_etablissement (
    id_etablissement                INTEGER PRIMARY KEY,
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
    id_professionnel           INTEGER PRIMARY KEY,
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
    id_region           INTEGER PRIMARY KEY,
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
    num_consultation        BIGINT PRIMARY KEY,
    id_patient              INTEGER NOT NULL REFERENCES entrepot.dim_patient,
    id_temps                INTEGER NOT NULL REFERENCES entrepot.dim_temps,
    id_professionnel        INTEGER NOT NULL REFERENCES entrepot.dim_professionnel,
    id_diagnostic           INTEGER NOT NULL REFERENCES entrepot.dim_diagnostic,
    id_etablissement        INTEGER NOT NULL REFERENCES entrepot.dim_etablissement,
    nombre_de_consultation  SMALLINT NOT NULL
);

CREATE TABLE IF NOT EXISTS entrepot.fait_hospitalisation (
    id_hospitalisation    BIGINT PRIMARY KEY,
    id_patient            INTEGER NOT NULL REFERENCES entrepot.dim_patient,
    id_etablissement      INTEGER NOT NULL REFERENCES entrepot.dim_etablissement,
    id_diagnostic         INTEGER NOT NULL REFERENCES entrepot.dim_diagnostic,
    id_date_entree        INTEGER NOT NULL REFERENCES entrepot.dim_temps,
    num_hospitalisation   VARCHAR(20) NOT NULL,
    jour_hospitalisation  SMALLINT
);

CREATE TABLE IF NOT EXISTS entrepot.fait_satisfaction (
    id_satisfaction            BIGINT PRIMARY KEY,
    id_temps                   INTEGER NOT NULL REFERENCES entrepot.dim_temps,
    id_etablissement           INTEGER NOT NULL REFERENCES entrepot.dim_etablissement,
    participation_obligatoire  BOOLEAN,
    depot_valide               BOOLEAN,
    nb_reponses                INTEGER,
    score                      NUMERIC(5,2)
);

CREATE TABLE IF NOT EXISTS entrepot.fait_deces (
    id_deces             BIGINT PRIMARY KEY,
    id_temps             INTEGER NOT NULL REFERENCES entrepot.dim_temps,
    id_region_deces      INTEGER NOT NULL REFERENCES entrepot.dim_region_insee,
    id_region_naissance  INTEGER NOT NULL REFERENCES entrepot.dim_region_insee,
    age_deces            SMALLINT,
    annee_naissance      SMALLINT,
    numero_acte_deces    VARCHAR(10),
    flag_date_partielle  BOOLEAN NOT NULL,
    date_chargement      TIMESTAMP NOT NULL
);
