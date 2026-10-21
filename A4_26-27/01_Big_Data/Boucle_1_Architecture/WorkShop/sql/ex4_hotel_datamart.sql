-- =====================================================================
--  Workshop 1 - Exercice 4 : modèle physique du data mart
--  « Revenus des hôtels » (SGBD cible : PostgreSQL)
-- =====================================================================

DROP TABLE IF EXISTS fait_reservation;
DROP TABLE IF EXISTS pont_hotel_caracteristique;
DROP TABLE IF EXISTS dim_caracteristique;
DROP TABLE IF EXISTS dim_canal;
DROP TABLE IF EXISTS dim_chambre;
DROP TABLE IF EXISTS dim_hotel;
DROP TABLE IF EXISTS dim_client;
DROP TABLE IF EXISTS dim_date;

-- ---------------------------------------------------------------------
--  Dimensions
-- ---------------------------------------------------------------------

-- Dimension temps (role-playing : réservation, arrivée, départ)
CREATE TABLE dim_date (
    id_date        INTEGER      PRIMARY KEY,          -- format AAAAMMJJ
    date_complete  DATE         NOT NULL UNIQUE,
    jour           SMALLINT     NOT NULL CHECK (jour BETWEEN 1 AND 31),
    jour_semaine   VARCHAR(10)  NOT NULL,
    semaine        SMALLINT     NOT NULL CHECK (semaine BETWEEN 1 AND 53),
    mois           SMALLINT     NOT NULL CHECK (mois BETWEEN 1 AND 12),
    libelle_mois   VARCHAR(10)  NOT NULL,
    trimestre      SMALLINT     NOT NULL CHECK (trimestre BETWEEN 1 AND 4),
    annee          SMALLINT     NOT NULL,
    saison         VARCHAR(7)   NOT NULL CHECK (saison IN ('Basse', 'Moyenne', 'Haute')),
    est_vacances   BOOLEAN      NOT NULL DEFAULT FALSE
);

CREATE TABLE dim_client (
    id_client      INTEGER      PRIMARY KEY,
    nom            VARCHAR(50)  NOT NULL,
    prenom         VARCHAR(50)  NOT NULL,
    email          VARCHAR(100) UNIQUE,
    ville          VARCHAR(60),
    pays           VARCHAR(60)  NOT NULL,
    tranche_age    VARCHAR(10),
    segment        VARCHAR(20)  CHECK (segment IN ('Loisir', 'Affaires', 'Groupe'))
);

CREATE TABLE dim_hotel (
    id_hotel       INTEGER      PRIMARY KEY,
    nom_hotel      VARCHAR(100) NOT NULL,
    nb_etoiles     SMALLINT     NOT NULL CHECK (nb_etoiles BETWEEN 1 AND 5),
    nom_chaine     VARCHAR(100),                      -- NULL : hôtel indépendant
    adresse        VARCHAR(150) NOT NULL,
    ville          VARCHAR(60)  NOT NULL,
    pays           VARCHAR(60)  NOT NULL,
    nb_chambres    SMALLINT     NOT NULL CHECK (nb_chambres > 0)
);

CREATE TABLE dim_chambre (
    id_chambre     INTEGER      PRIMARY KEY,
    numero_chambre VARCHAR(10)  NOT NULL,
    etage          SMALLINT,
    type_chambre   VARCHAR(20)  NOT NULL
                   CHECK (type_chambre IN ('Simple', 'Double', 'Twin', 'Suite', 'Familiale')),
    capacite       SMALLINT     NOT NULL CHECK (capacite > 0),
    superficie_m2  NUMERIC(5,1) CHECK (superficie_m2 > 0),
    vue            VARCHAR(20)
);

CREATE TABLE dim_canal (
    id_canal       INTEGER      PRIMARY KEY,
    libelle_canal  VARCHAR(50)  NOT NULL,
    type_canal     VARCHAR(10)  NOT NULL CHECK (type_canal IN ('Direct', 'Agence', 'OTA'))
);

CREATE TABLE dim_caracteristique (
    id_caracteristique INTEGER     PRIMARY KEY,
    libelle            VARCHAR(50) NOT NULL UNIQUE,
    categorie          VARCHAR(30) NOT NULL
);

-- Table pont : un hôtel possède plusieurs caractéristiques (n-n)
CREATE TABLE pont_hotel_caracteristique (
    id_hotel           INTEGER NOT NULL REFERENCES dim_hotel (id_hotel),
    id_caracteristique INTEGER NOT NULL REFERENCES dim_caracteristique (id_caracteristique),
    PRIMARY KEY (id_hotel, id_caracteristique)
);

-- ---------------------------------------------------------------------
--  Table de faits (grain : une chambre réservée dans une réservation)
-- ---------------------------------------------------------------------
CREATE TABLE fait_reservation (
    num_reservation     VARCHAR(20)   NOT NULL,       -- dimension dégénérée
    id_chambre          INTEGER       NOT NULL REFERENCES dim_chambre (id_chambre),
    id_hotel            INTEGER       NOT NULL REFERENCES dim_hotel (id_hotel),
    id_client           INTEGER       NOT NULL REFERENCES dim_client (id_client),
    id_canal            INTEGER       NOT NULL REFERENCES dim_canal (id_canal),
    id_date_reservation INTEGER       NOT NULL REFERENCES dim_date (id_date),
    id_date_arrivee     INTEGER       NOT NULL REFERENCES dim_date (id_date),
    id_date_depart      INTEGER       NOT NULL REFERENCES dim_date (id_date),
    statut              VARCHAR(10)   NOT NULL DEFAULT 'Confirmée'
                        CHECK (statut IN ('Confirmée', 'Modifiée', 'Annulée')),
    -- Mesures
    nb_nuits            SMALLINT      NOT NULL CHECK (nb_nuits > 0),
    nb_personnes        SMALLINT      NOT NULL CHECK (nb_personnes > 0),
    tarif_journalier    NUMERIC(8,2)  NOT NULL CHECK (tarif_journalier >= 0),
    montant_remise      NUMERIC(10,2) NOT NULL DEFAULT 0 CHECK (montant_remise >= 0),
    montant_total       NUMERIC(10,2) NOT NULL CHECK (montant_total >= 0),
    PRIMARY KEY (num_reservation, id_chambre),
    CHECK (id_date_reservation <= id_date_arrivee),
    CHECK (id_date_arrivee < id_date_depart)
);

-- Index sur les clés étrangères (jointures de l'étoile)
CREATE INDEX idx_fait_hotel     ON fait_reservation (id_hotel);
CREATE INDEX idx_fait_client    ON fait_reservation (id_client);
CREATE INDEX idx_fait_canal     ON fait_reservation (id_canal);
CREATE INDEX idx_fait_date_resa ON fait_reservation (id_date_reservation);
CREATE INDEX idx_fait_date_arr  ON fait_reservation (id_date_arrivee);
