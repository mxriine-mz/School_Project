# Source 4 — Décès en France (INSEE)

Analyse de la source `deces.csv` (fichier INSEE des personnes décédées, 2,0 Go, 25 088 208 lignes, 1970 – 30/03/2020) et référentiel géographique qui alimente `DIM_Geographie`.

## Contenu

| Fichier | Rôle |
| :--- | :--- |
| `profilage_deces.py` | Profil qualité du fichier : complétude, dates invalides, doublons, lieux, couverture par année |
| `referentiel_geo.py` | Construit `referentiel/dim_geographie.csv` à partir du COG INSEE 2026 |
| `controle_geo_deces.py` | Vérifie le rattachement de chaque lieu de décès et calcule l'indicateur 7 (décès par région en 2019) |
| `referentiel/dim_geographie.csv` | Référentiel commune → département → région, partageable avec les autres sources |
| `rapports/` | Rapports Markdown générés (comptages uniquement, aucun nom ni prénom) |

`deces.csv` n'est pas versionné : il contient des données personnelles et pèse 2 Go.

## Lancer

```bash
python -m venv .venv && .venv/bin/pip install -r requirements.txt
.venv/bin/python referentiel_geo.py                       # télécharge le COG dans cog/ puis construit le référentiel
.venv/bin/python profilage_deces.py  "CHEMIN/deces.csv"   # ~30 s
.venv/bin/python controle_geo_deces.py "CHEMIN/deces.csv" # ~15 s
```

## Référentiel géographique

Une ligne par code, au format de `DIM_Geographie` (`id_geographie`, `BK : code_commune_insee`, département, région, pays, `type_zone`).

| `type_zone` | Codes | Origine |
| :--- | ---: | :--- |
| Metropole | 39 027 | Communes actuelles et historiques depuis 1943, dont l'ancien département 20 (Corse avant 1976) |
| Etranger | 254 | Pays `99xxx` |
| DROM | 135 | Guadeloupe, Martinique, Guyane, La Réunion, Mayotte |
| COM | 104 | Collectivités d'outre-mer, plus une ligne par collectivité pour les anciens codes `98xxx` |
| Inconnu | 1 | `id_geographie = -1`, pour les lieux vides |

Règles de rattachement d'un code de lieu :

1. code exact trouvé dans le référentiel ;
2. sinon, code `98xxx` → ligne de la collectivité (3 premiers caractères) ;
3. lieu vide ou code jamais attribué par l'INSEE → `-1` Inconnu, et la ligne part dans `rejets_deces`.

## Résultats

- **99,993 %** des décès (dédoublonnés) retrouvent leur lieu ; 1 765 codes n'existent pas dans le COG (`00000`, `95551`…).
- **Indicateur 7 :** 613 323 décès rattachés à une région en 2019 ; 7 187 hors région (étranger, COM, inconnu).
- Détail dans [`rapports/controle_geo_deces.md`](rapports/controle_geo_deces.md) et [`rapports/profilage_deces.md`](rapports/profilage_deces.md).

Source du référentiel : [Code officiel géographique 2026, INSEE](https://www.insee.fr/fr/information/8740218) (Licence Ouverte).
