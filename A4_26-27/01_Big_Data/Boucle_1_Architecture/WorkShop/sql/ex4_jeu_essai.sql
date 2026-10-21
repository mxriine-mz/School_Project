-- =====================================================================
--  Workshop 1 - Exercice 4 : jeu d'essai et requête d'analyse
--  (à exécuter après ex4_hotel_datamart.sql)
-- =====================================================================

INSERT INTO dim_date VALUES
    (20270310, '2027-03-10',  10, 'Mercredi', 10, 3, 'Mars',    1, 2027, 'Basse', FALSE),
    (20270702, '2027-07-02',   2, 'Vendredi', 26, 7, 'Juillet', 3, 2027, 'Haute', TRUE),
    (20270705, '2027-07-05',   5, 'Lundi',    27, 7, 'Juillet', 3, 2027, 'Haute', TRUE),
    (20270712, '2027-07-12',  12, 'Lundi',    28, 7, 'Juillet', 3, 2027, 'Haute', TRUE),
    (20270802, '2027-08-02',   2, 'Lundi',    31, 8, 'Août',    3, 2027, 'Haute', TRUE),
    (20270806, '2027-08-06',   6, 'Vendredi', 31, 8, 'Août',    3, 2027, 'Haute', TRUE);

INSERT INTO dim_client VALUES
    (1, 'Martin', 'Thierry', 'thierry.martin@mail.fr', 'Lyon',  'France',  '35-44', 'Loisir'),
    (2, 'Rossi',  'Giulia',  'giulia.rossi@mail.it',   'Milan', 'Italie',  '25-34', 'Affaires');

INSERT INTO dim_hotel VALUES
    (1, 'Atlántico Lisboa', 4, 'Pestana',  'Av. da Liberdade 10', 'Lisbonne', 'Portugal', 120),
    (2, 'Casa do Mar',      3, NULL,       'Rua do Mar 5',        'Porto',    'Portugal',  25);

INSERT INTO dim_chambre VALUES
    (101, '312', 3, 'Double', 2, 22.0, 'Mer'),
    (102, '501', 5, 'Suite',  4, 45.0, 'Mer'),
    (201, '12',  1, 'Simple', 1, 14.5, 'Cour');

INSERT INTO dim_canal VALUES
    (1, 'Site de l''hôtel', 'Direct'),
    (2, 'Booking.com',      'OTA');

INSERT INTO dim_caracteristique VALUES
    (1, 'Piscine', 'Loisir'),
    (2, 'Spa',     'Bien-être'),
    (3, 'Wi-Fi',   'Service');

INSERT INTO pont_hotel_caracteristique VALUES (1, 1), (1, 2), (1, 3), (2, 3);

-- Thierry réserve en mars une chambre double, puis réduit son séjour à 3 nuits
INSERT INTO fait_reservation VALUES
    ('R-0001', 101, 1, 1, 2, 20270310, 20270702, 20270705, 'Modifiée',  3, 1, 145.00,  0.00, 435.00),
    ('R-0002', 102, 1, 2, 1, 20270310, 20270705, 20270712, 'Confirmée', 7, 3, 310.00, 70.00, 2100.00),
    ('R-0003', 201, 2, 2, 2, 20270705, 20270802, 20270806, 'Confirmée', 4, 1,  60.00,  0.00, 240.00);

-- Chiffre d'affaires par chaîne, mois d'arrivée et type de chambre
SELECT COALESCE(h.nom_chaine, 'Indépendant') AS chaine,
       d.libelle_mois                         AS mois_arrivee,
       c.type_chambre,
       SUM(f.nb_nuits)                        AS nuitees,
       SUM(f.montant_total)                   AS chiffre_affaires
FROM fait_reservation f
JOIN dim_hotel   h ON h.id_hotel   = f.id_hotel
JOIN dim_date    d ON d.id_date    = f.id_date_arrivee
JOIN dim_chambre c ON c.id_chambre = f.id_chambre
WHERE f.statut <> 'Annulée'
GROUP BY chaine, d.mois, d.libelle_mois, c.type_chambre
ORDER BY d.mois, chiffre_affaires DESC;
