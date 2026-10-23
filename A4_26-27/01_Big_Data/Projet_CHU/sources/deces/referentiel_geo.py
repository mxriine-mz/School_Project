"""Construit le référentiel géographique DIM_Geographie à partir du COG INSEE.

Une ligne par code commune INSEE (actuel ou historique depuis 1943), avec son
département et sa région au 1er janvier 2026. S'y ajoutent les pays étrangers
(codes 99xxx), les collectivités d'outre-mer (975, 977, 978, 98x) et une ligne
« Inconnu » (Id_Geographie = -1) pour les lieux vides.

Usage :
    python referentiel_geo.py [--cog-dir DOSSIER] [--sortie referentiel/dim_geographie.csv]

Les fichiers COG sont téléchargés dans --cog-dir s'ils n'y sont pas déjà.
"""
import argparse
import urllib.request
from pathlib import Path

import duckdb

# Millésime 2026 du COG, publié par l'INSEE le 24/02/2026
COG_URL = "https://www.insee.fr/fr/statistiques/fichier/8740222/{}.csv"
COG_FICHIERS = [
    "v_region_2026",
    "v_departement_2026",
    "v_commune_2026",
    "v_commune_depuis_1943",
    "v_commune_comer_2026",
    "v_comer_2026",
    "v_pays_et_territoire_depuis_1943",
]

ICI = Path(__file__).parent


def telecharger_cog(cog_dir: Path) -> None:
    cog_dir.mkdir(parents=True, exist_ok=True)
    for nom in COG_FICHIERS:
        cible = cog_dir / f"{nom}.csv"
        if not cible.exists():
            print(f"Téléchargement {nom}.csv")
            urllib.request.urlretrieve(COG_URL.format(nom), cible)


def construire(cog_dir: Path, sortie: Path) -> None:
    con = duckdb.connect()
    for nom in COG_FICHIERS:
        con.execute(f"CREATE VIEW {nom} AS SELECT * FROM read_csv('{cog_dir / nom}.csv', header=true, delim=',', quote='\"', all_varchar=true)")

    con.execute("""
    CREATE TABLE dim_geographie AS
    WITH
    dep AS (
        SELECT d.DEP AS code_departement, d.LIBELLE AS nom_departement,
               r.REG AS code_region, r.LIBELLE AS nom_region
        FROM v_departement_2026 d JOIN v_region_2026 r USING (REG)
        -- Ancien département de Corse, scindé en 2A/2B en 1976
        UNION ALL SELECT '20', 'Corse (avant 1976)', '94', 'Corse'
    ),
    -- Communes françaises : code actuel ou historique, libellé le plus récent
    communes AS (
        SELECT COM, arg_max(LIBELLE, coalesce(DATE_DEBUT, '1943-01-01')) AS nom_commune
        FROM (SELECT COM, LIBELLE, DATE_DEBUT FROM v_commune_depuis_1943
              UNION ALL
              SELECT COM, LIBELLE, '2026-01-01' FROM v_commune_2026)
        GROUP BY COM
    ),
    france AS (
        SELECT c.COM AS code_commune_insee, c.nom_commune,
               dep.code_departement, dep.nom_departement, dep.code_region, dep.nom_region,
               'France' AS pays,
               CASE WHEN dep.code_region IN ('01', '02', '03', '04', '06') THEN 'DROM'
                    ELSE 'Metropole' END AS type_zone
        FROM communes c
        -- Le département se lit dans le code : 3 caractères en outre-mer (97x), 2 sinon
        JOIN dep ON dep.code_departement =
             CASE WHEN c.COM LIKE '97%' THEN substr(c.COM, 1, 3) ELSE substr(c.COM, 1, 2) END
    ),
    com AS (
        -- Collectivités d'outre-mer : hors région, la collectivité tient lieu de département
        SELECT COM_COMER, LIBELLE, COMER, LIBELLE_COMER, NULL, NULL, 'France', 'COM'
        FROM v_commune_comer_2026
        -- Une ligne par collectivité (code à 3 caractères), cible de repli pour
        -- les anciens codes 98xxx absents du COG (Wallis-et-Futuna, TAAF...)
        UNION ALL
        SELECT COMER, LIBELLE, COMER, LIBELLE, NULL, NULL, 'France', 'COM'
        FROM v_comer_2026
    ),
    etranger AS (
        SELECT COG, NULL, NULL, NULL, NULL, NULL,
               arg_max(LIBCOG, coalesce(DATE_DEBUT, '1943-01-01')), 'Etranger'
        FROM v_pays_et_territoire_depuis_1943
        WHERE COG <> '99100'  -- 99100 = France
        GROUP BY COG
    ),
    tout AS (
        SELECT * FROM france
        UNION ALL SELECT * FROM com
        UNION ALL SELECT * FROM etranger
    )
    SELECT -1 AS id_geographie, NULL AS code_commune_insee, 'Inconnu' AS nom_commune,
           NULL AS code_departement, NULL AS nom_departement, NULL AS code_region,
           NULL AS nom_region, NULL AS pays, 'Inconnu' AS type_zone
    UNION ALL
    SELECT row_number() OVER (ORDER BY code_commune_insee), *
    FROM tout
    """)

    doublons = con.execute("""
        SELECT count(*) FROM (SELECT code_commune_insee FROM dim_geographie
                              WHERE code_commune_insee IS NOT NULL GROUP BY 1 HAVING count(*) > 1)
    """).fetchone()[0]
    if doublons:
        raise SystemExit(f"{doublons} codes commune en double dans le référentiel")

    sortie.parent.mkdir(parents=True, exist_ok=True)
    con.execute(f"COPY (SELECT * FROM dim_geographie ORDER BY id_geographie) TO '{sortie}' (HEADER, DELIMITER ',')")
    for zone, n in con.execute("SELECT type_zone, count(*) FROM dim_geographie GROUP BY 1 ORDER BY 2 DESC").fetchall():
        print(f"{zone:<10} {n:>7} codes")
    print(f"-> {sortie}")


if __name__ == "__main__":
    p = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    p.add_argument("--cog-dir", type=Path, default=ICI / "cog")
    p.add_argument("--sortie", type=Path, default=ICI / "referentiel" / "dim_geographie.csv")
    args = p.parse_args()
    telecharger_cog(args.cog_dir)
    construire(args.cog_dir, args.sortie)
