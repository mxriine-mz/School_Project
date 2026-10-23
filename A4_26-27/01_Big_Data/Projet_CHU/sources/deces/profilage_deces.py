"""Profil qualité du fichier INSEE des décès (deces.csv).

Calcule la complétude par colonne, les dates invalides, les doublons, la
couverture par année et les codes de lieu particuliers, puis écrit un rapport
Markdown. Le rapport ne contient que des comptages : aucun nom ni prénom.

Usage :
    python profilage_deces.py CHEMIN/deces.csv [--rapport rapports/profilage_deces.md]
"""
import argparse
from pathlib import Path

import duckdb

ICI = Path(__file__).parent
COLONNES = ["nom", "prenom", "sexe", "date_naissance", "code_lieu_naissance", "lieu_naissance",
            "pays_naissance", "date_deces", "code_lieu_deces", "numero_acte_deces"]
# Colonnes dont les valeurs peuvent apparaître dans le rapport (pas d'identifiant personnel)
COLONNES_AFFICHABLES = {"sexe", "date_naissance", "code_lieu_naissance", "date_deces", "code_lieu_deces"}


def nombre(n) -> str:
    return f"{n:,}".replace(",", " ")


def tableau(entetes, lignes) -> str:
    out = ["| " + " | ".join(entetes) + " |", "|" + "---|" * len(entetes)]
    out += ["| " + " | ".join(str(v) for v in l) + " |" for l in lignes]
    return "\n".join(out)


def profiler(csv: Path, rapport: Path) -> None:
    con = duckdb.connect()
    con.execute(f"CREATE TABLE d AS SELECT * FROM read_csv('{csv}', header=true, all_varchar=true)")
    un = lambda sql: con.execute(sql).fetchone()[0]
    total = un("SELECT count(*) FROM d")
    md = [f"# Profil qualité – deces.csv\n",
          f"Fichier analysé en entier : **{nombre(total)} lignes**.\n"]

    # Complétude par colonne
    lignes = []
    for c in COLONNES:
        vides, distincts = con.execute(
            f"SELECT count(*) FILTER (WHERE trim(coalesce({c}, '')) = ''), count(DISTINCT {c}) FROM d").fetchone()
        lignes.append([f"`{c}`", nombre(vides), f"{100 * (total - vides) / total:.2f} %", nombre(distincts)])
    md += ["## Complétude par colonne\n", tableau(["Colonne", "Vides", "Remplissage", "Valeurs distinctes"], lignes), ""]

    # Dates invalides (partielles comme '1930' ou '1989-05', impossibles comme '1901-06-31')
    lignes = []
    for c in ["date_naissance", "date_deces"]:
        n = un(f"SELECT count(*) FROM d WHERE try_strptime({c}, '%Y-%m-%d') IS NULL")
        ex = con.execute(f"""SELECT {c} FROM d WHERE try_strptime({c}, '%Y-%m-%d') IS NULL
                             GROUP BY 1 ORDER BY count(*) DESC LIMIT 4""").fetchall()
        lignes.append([f"`{c}`", nombre(n), ", ".join(f"`{e[0]}`" for e in ex)])
    md += ["## Dates invalides\n", tableau(["Colonne", "Invalides", "Exemples les plus fréquents"], lignes), ""]

    # Âges incohérents
    con.execute("""CREATE TABLE ages AS SELECT
        date_diff('year', try_strptime(date_naissance, '%Y-%m-%d'), try_strptime(date_deces, '%Y-%m-%d')) AS age,
        try_strptime(date_naissance, '%Y-%m-%d') > try_strptime(date_deces, '%Y-%m-%d') AS naissance_apres
        FROM d""")
    incoherents = un("SELECT count(*) FROM ages WHERE naissance_apres OR age > 120")
    mediane = un("SELECT median(age) FROM ages WHERE age BETWEEN 0 AND 120")
    md += ["## Âge au décès\n",
           f"- Âge médian : **{mediane:.0f} ans**",
           f"- Naissance après le décès ou âge > 120 ans : **{nombre(incoherents)} lignes**\n"]

    # Doublons
    exacts = total - un("SELECT count(*) FROM (SELECT DISTINCT * FROM d)")
    groupes = un("""SELECT count(*) FROM (SELECT 1 FROM d
                    GROUP BY nom, prenom, date_naissance, date_deces, code_lieu_deces HAVING count(*) > 1)""")
    md += ["## Doublons\n",
           f"- Lignes en double exact : **{nombre(exacts)}** ({100 * exacts / total:.2f} %)",
           f"- Groupes de même nom, prénom, naissance, date et lieu de décès : **{nombre(groupes)}**\n"]

    # Codes de lieu de décès particuliers
    lignes = con.execute("""SELECT CASE
            WHEN trim(code_lieu_deces) = '' OR code_lieu_deces IS NULL THEN 'Vide'
            WHEN code_lieu_deces LIKE '99%' THEN 'Étranger (99xxx)'
            WHEN code_lieu_deces LIKE '97%' AND substr(code_lieu_deces, 1, 3) IN ('971','972','973','974','976') THEN 'DROM (971 à 976)'
            WHEN code_lieu_deces LIKE '97%' OR code_lieu_deces LIKE '98%' THEN 'COM (975, 977, 978, 98x)'
            WHEN code_lieu_deces LIKE '2A%' OR code_lieu_deces LIKE '2B%' THEN 'Corse (2A/2B, en texte)'
            ELSE 'Métropole' END AS zone, count(*) FROM d GROUP BY 1 ORDER BY 2 DESC""").fetchall()
    md += ["## Lieu de décès\n", tableau(["Zone", "Décès"], [[z, nombre(n)] for z, n in lignes]), ""]

    # Couverture par année de décès
    lignes = con.execute("""SELECT substr(date_deces, 1, 4) AS annee, count(*) FROM d
                            WHERE date_deces >= '1970' GROUP BY 1 ORDER BY 1""").fetchall()
    avant = un("SELECT count(*) FROM d WHERE date_deces < '1970'")
    md += ["## Décès par année\n",
           f"{nombre(avant)} décès sont datés d'avant 1970 (inscriptions tardives).\n",
           tableau(["Année", "Décès"], [[a, nombre(n)] for a, n in lignes]), ""]

    rapport.parent.mkdir(parents=True, exist_ok=True)
    rapport.write_text("\n".join(md), encoding="utf-8")
    print(f"-> {rapport}")


if __name__ == "__main__":
    p = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    p.add_argument("csv", type=Path)
    p.add_argument("--rapport", type=Path, default=ICI / "rapports" / "profilage_deces.md")
    args = p.parse_args()
    profiler(args.csv, args.rapport)
