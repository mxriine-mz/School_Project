"""Contrôle la correspondance entre deces.csv et le référentiel DIM_Geographie.

Vérifie que chaque code_lieu_deces retrouve sa commune, son département et sa
région, liste les codes non reconnus, puis calcule l'indicateur 7 du projet :
le nombre de décès par région en 2019.

Usage :
    python controle_geo_deces.py CHEMIN/deces.csv [--referentiel referentiel/dim_geographie.csv]
                                 [--rapport rapports/controle_geo_deces.md]
"""
import argparse
from pathlib import Path

import duckdb

from profilage_deces import nombre, tableau

ICI = Path(__file__).parent


def controler(csv: Path, referentiel: Path, rapport: Path) -> None:
    con = duckdb.connect()
    con.execute(f"""CREATE TABLE d AS
        SELECT DISTINCT * FROM read_csv('{csv}', header=true, all_varchar=true)""")  # sans doublons exacts
    con.execute(f"CREATE TABLE geo AS SELECT * FROM read_csv('{referentiel}', header=true, delim=',', quote='\"', all_varchar=true)")
    # Rattachement : code exact, sinon collectivité d'outre-mer (98x) par ses 3 premiers
    # caractères ; un lieu vide pointe vers la ligne Inconnu (-1)
    con.execute("""CREATE TABLE lien AS
        SELECT d.date_deces, d.code_lieu_deces,
               CASE WHEN trim(coalesce(d.code_lieu_deces, '')) = '' THEN '-1'
                    ELSE coalesce(g.id_geographie, c.id_geographie) END AS id_geographie,
               coalesce(g.type_zone, c.type_zone,
                        CASE WHEN trim(coalesce(d.code_lieu_deces, '')) = '' THEN 'Inconnu' END) AS type_zone,
               g.nom_region
        FROM d
        LEFT JOIN geo g ON g.code_commune_insee = d.code_lieu_deces
        LEFT JOIN geo c ON c.type_zone = 'COM' AND c.code_commune_insee = substr(d.code_lieu_deces, 1, 3)
                       AND d.code_lieu_deces LIKE '98%'""")
    un = lambda sql: con.execute(sql).fetchone()[0]
    total = un("SELECT count(*) FROM lien")
    rates = un("SELECT count(*) FROM lien WHERE id_geographie IS NULL")

    md = ["# Contrôle géographique – deces.csv × DIM_Geographie\n",
          f"Référentiel : COG INSEE millésime 2026. Décès après suppression des doublons exacts : **{nombre(total)}**.\n",
          f"**{nombre(total - rates)} décès rattachés ({100 * (total - rates) / total:.3f} %)**, "
          f"{nombre(rates)} sans correspondance.\n"]

    lignes = con.execute("""SELECT coalesce(type_zone, 'Non reconnu'), count(*) FROM lien
                            GROUP BY 1 ORDER BY 2 DESC""").fetchall()
    md += ["## Répartition par type de zone\n",
           tableau(["Type de zone", "Décès", "Part"], [[z, nombre(n), f"{100 * n / total:.2f} %"] for z, n in lignes]), ""]

    lignes = con.execute("""SELECT code_lieu_deces, count(*) FROM lien WHERE id_geographie IS NULL
                            GROUP BY 1 ORDER BY 2 DESC LIMIT 15""").fetchall()
    if lignes:
        md += ["## Codes non reconnus (15 plus fréquents)\n",
               tableau(["Code", "Décès"], [[f"`{c}`", nombre(n)] for c, n in lignes]), ""]

    lignes = con.execute("""SELECT nom_region, count(*) FROM lien
                            WHERE date_deces LIKE '2019%' AND nom_region IS NOT NULL
                            GROUP BY 1 ORDER BY 2 DESC""").fetchall()
    hors = un("SELECT count(*) FROM lien WHERE date_deces LIKE '2019%' AND nom_region IS NULL")
    md += ["## Indicateur 7 : décès par région en 2019\n",
           f"Hors région (étranger, COM, inconnu, non reconnu) : {nombre(hors)} décès.\n",
           tableau(["Région", "Décès 2019"], [[r, nombre(n)] for r, n in lignes]),
           f"\nTotal des régions : **{nombre(sum(n for _, n in lignes))}**.\n"]

    rapport.parent.mkdir(parents=True, exist_ok=True)
    rapport.write_text("\n".join(md), encoding="utf-8")
    print(f"-> {rapport}")


if __name__ == "__main__":
    p = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    p.add_argument("csv", type=Path)
    p.add_argument("--referentiel", type=Path, default=ICI / "referentiel" / "dim_geographie.csv")
    p.add_argument("--rapport", type=Path, default=ICI / "rapports" / "controle_geo_deces.md")
    args = p.parse_args()
    controler(args.csv, args.referentiel, args.rapport)
