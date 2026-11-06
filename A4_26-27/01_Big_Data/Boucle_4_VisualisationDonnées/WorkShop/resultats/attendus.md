# Résultats attendus du workshop Power BI

Tout est calculé en Python (bibliothèque standard, lecture directe des .xlsx) sur les fichiers de `ressources/`. Aucun chiffre n'est repris de l'énoncé sans calcul. Ce qui ne peut pas être calculé est marqué « à relever dans Power BI ».

Les nombres de lignes ci-dessous excluent la ligne d'en-têtes (comptage affiché par Power BI, « N lignes, M colonnes » en bas à gauche).

## 1. Classeurs Excel : feuilles et dimensions

La colonne « Plage » est la dimension déclarée dans le fichier. « Lignes remplies » compte les lignes qui contiennent au moins une cellule.

| Fichier | Feuille | Plage | Lignes remplies |
|---|---|---|---|
| 02_01_rainforest_global_2019.xlsx | activité_2019 | A1:O479 | 479 |
| 02_02_rainforest_inc.xlsx | transactions_2018 | A1:D523 | 523 |
| 02_02_rainforest_inc.xlsx | transactions_2019 | A1:D479 | 479 |
| 02_02_rainforest_inc.xlsx | clients | A1:F204 | 203 |
| 02_02_rainforest_inc.xlsx | produits | A2:F74 | 72 |
| 02_02_rainforest_inc.xlsx | fournisseurs | A1:B21 | 21 |
| 02_03_rainforest_inc_TCD.xlsx | TCD_activité | A1:GO45 | 45 |
| 05_01_transactions_par_annee/partiel_2018.xlsx | transactions | A1:D523 | 523 |
| 05_01_transactions_par_annee/partiel_2019.xlsx | transactions | A1:D479 | 479 |

Aucun de ces classeurs ne contient de « tableau Excel » nommé : Power BI propose donc uniquement les feuilles (icône feuille) dans le navigateur.

## 2. 02_01_rainforest_global_2019.xlsx : activité_2019

- Chargement brut : **478 lignes x 15 colonnes** (en-têtes promus).
- Colonnes : `id_client`, `prenom`, `nom`, `code_pays`, `pays`, `ville`, `id_produit`, `nom_produit`, `famille_produit`, `couleur`, `prix_unitaire`, `id_fournisseur`, `nom_fournisseur`, `quantité`, `date`.
- Aucune valeur vide. Dates du 2019-01-02 au 2019-11-29 (texte `jj/mm/aaaa` dans le fichier).
- Le .pbix 02_01 supprime les colonnes `id_produit` et `id_fournisseur` : il reste **13 colonnes** (voir section 8), toujours 478 lignes.
- Quantité totale : **1420**. Montant total (quantité x prix_unitaire) : **71588**. Clients distincts : 182. Produits distincts : 70.

## 3. 02_02_rainforest_inc.xlsx : chargement brut des 5 feuilles

Ce sont les dimensions attendues dans le navigateur Power Query (valeurs calculées sur le fichier ; à confirmer à l'écran pour `clients` et `produits`, voir notes).

| Table | Lignes | Colonnes | Remarque |
|---|---|---|---|
| transactions_2018 | 522 | 4 | id_client, id_produit, quantité, date |
| transactions_2019 | 478 | 4 | identique aux 478 lignes d'activité_2019 (id_client, id_produit, quantité, date) |
| clients | 203 | 6 | dont 1 ligne entièrement vide (ligne 193 du classeur), 1 doublon (id 200) et 1 ligne de test (id 999) |
| produits | 70 (après en-têtes) | 6 | avant promotion des en-têtes : ligne titre « Catalogue 2018-2019 » + ligne vide au-dessus des en-têtes |
| fournisseurs | 20 | 2 | id_fournisseur, nom_fournisseur |

Chargement brut de `produits` : à relever dans Power BI. Le classeur a la plage A2:F74. Selon la version de Power BI, la ligne vide 3 peut apparaître ou non comme ligne de nulls. Le code M fourni cherche la ligne d'en-têtes (valeur « id »), donc il ne dépend pas de ce point.

### Transformations de l'énoncé

| Étape | Résultat attendu |
|---|---|
| clients : brut | 203 lignes x 6 colonnes |
| clients : supprimer les lignes vides | 202 lignes x 6 colonnes |
| clients : supprimer les 2 dernières lignes (doublon id 200 + test id 999) | 200 lignes (id 1 à 200, tous uniques) |
| clients : variante « supprimer les doublons » (toutes colonnes) à la place | 201 lignes (le doublon id 200 part, mais la ligne de test id 999 reste) |
| produits : après en-têtes | 70 lignes x 6 colonnes (id 1 à 70) |
| produits : couleur en majuscule à chaque mot | 19 valeurs distinctes : Aquamarine, Blue, Crimson, Fuscia, Goldenrod, Green, Indigo, Khaki, Maroon, Mauv, Orange, Pink, Puce, Purple, Red, Teal, Turquoise, Violet, Yellow |
| produits : colonne à partir d'exemples « nom (couleur) » | 70 lignes x 7 colonnes ; 1re valeur : `Wheat Sedge (Blue)` |
| produits fusionné avec fournisseurs (jointure gauche, id_fournisseur) | 70 lignes x 7 colonnes (+ nom_fournisseur) ; 0 produit sans fournisseur ; 20 fournisseurs utilisés sur 20 |

Notes sur `couleur` : 8 lignes contiennent « Green » avec des espaces devant (`"      Green"`), 2 « blue » en minuscules et 2 « PINK » en capitales. La mise en majuscule de Power BI ne supprime pas les espaces : le code M fourni ajoute un `Text.Trim` (étape en plus, signalée). Sans le trim, le nombre de valeurs distinctes reste 19, mais « Green » garde ses espaces.

### transactions_2018 : trimestre et regroupement

- Dates 2018 : du 2018-01-02 au 2018-12-31. Format `jj/mm/aaaa` en texte : il faut convertir avec la culture **fr-FR** (sinon `02/01/2018` devient le 1er février).
- Après duplication de `date` (colonne renommée `Trimestre`), extraction du trimestre et préfixe : **522 lignes x 5 colonnes** (id_client, id_produit, quantité, date, Trimestre).
- Valeurs de `Trimestre` : TRIM1, TRIM2, TRIM3, TRIM4.

Regroupement par trimestre, somme de `quantité` (table dupliquée) : **4 lignes x 2 colonnes**.

| Trimestre | Somme de quantité (2018) | Nb de lignes sources |
|---|---|---|
| TRIM1 | 394 | 134 |
| TRIM2 | 365 | 122 |
| TRIM3 | 425 | 142 |
| TRIM4 | 352 | 124 |
| Total | 1536 | 522 |

Pour mémoire, 2019 par trimestre (même calcul sur transactions_2019) :

| Trimestre | Somme de quantité (2019) | Nb de lignes sources |
|---|---|---|
| TRIM1 | 472 | 155 |
| TRIM2 | 358 | 126 |
| TRIM3 | 360 | 124 |
| TRIM4 | 230 | 73 |
| Total | 1420 | 478 |

### Ajout 2018 + 2019 (ajouter des requêtes)

- transactions_2018 (522) + transactions_2019 (478) = **1000 lignes**.
- Colonnes : 4 si on ajoute les tables brutes (id_client, id_produit, quantité, date). Si on ajoute après avoir créé `Trimestre` sur 2018 seulement, 5 colonnes avec 478 valeurs `null` dans `Trimestre` pour 2019.
- Quantité totale combinée : **2956** (1536 + 1420).
- Années : 2018 = 522 lignes, 2019 = 478 lignes.
- Intégrité : 0 transaction avec id_client absent de `clients` ; 0 transaction avec id_produit absent de `produits`.

## 4. Import du dossier 05_01_transactions_par_annee

- `partiel_2018.xlsx` : feuille unique `transactions`, plage A1:D523, 522 lignes de données x 4 colonnes.
- `partiel_2019.xlsx` : feuille unique `transactions`, plage A1:D479, 478 lignes de données x 4 colonnes.
- Après « combiner et transformer » : **1000 lignes**, colonnes `Source.Name`, `id_client`, `id_produit`, `quantité`, `date` (**5 colonnes**). Les lignes sont identiques à celles de transactions_2018 et transactions_2019.
- Vérifié : contenu de partiel_2018 identique à transactions_2018 : oui ; partiel_2019 identique à transactions_2019 : oui.
- Valeurs de `Source.Name` : `partiel_2018.xlsx` (522 lignes), `partiel_2019.xlsx` (478 lignes). Dans l'assistant, Power BI crée aussi des requêtes auxiliaires (« Exemple de fichier », « Paramètre », « Transformer le fichier ») : à relever dans Power BI.

## 5. TCD : 02_03_rainforest_inc_TCD.xlsx, feuille TCD_activité

Plage A1:GO45 (45 lignes x 197 colonnes, dont les colonnes 190 à 197 vides). Total général lu dans la feuille : **1420**.

| Étape | Lignes x colonnes | Détail |
|---|---|---|
| Brut | 45 x 197 | ligne 1 « Somme de quantité / Étiquettes de colonnes », ligne 2 pays, ligne 3 villes, puis 41 familles, dernière ligne « Total général » |
| Supprimer la 1re ligne du haut | 44 x 197 |  |
| Supprimer la dernière ligne | 43 x 197 |  |
| Transposer | 197 x 43 | si Power Query ignore les 8 colonnes vides de fin : 189 x 43, même résultat final |
| Remplir vers le bas (colonne 1) | 197 x 43 | la colonne 1 contient le pays sur chaque ligne ; 1re ligne : null puis « Étiquettes de lignes » |
| Filtrer les totaux (texte contenant « tot ») | 180 x 43 | 17 lignes retirées : 9 lignes « Total … » (8 pays + Total général) et les 8 colonnes vides de fin, remplies vers le bas avec « Total général » ; reste la ligne d'en-têtes + 179 lignes ville |
| Utiliser la 1re ligne comme en-têtes | 179 x 43 | colonnes : `Column1` (pays), `Étiquettes de lignes` (ville) + 41 familles |
| Dépivoter les autres colonnes (sélection des 2 premières) | 454 x 4 | colonnes : `Column1`, `Étiquettes de lignes`, `Attribut` (famille), `Valeur` (quantité). Les null sont ignorés. |

Contrôles : somme de `Valeur` = **1420** (= Total général de la feuille). Nombre de villes distinctes : 179.

| Pays (Column1) | Lignes aplaties | Somme de Valeur |
|---|---|---|
| China | 317 | 990 |
| Japan | 36 | 118 |
| Sweden | 35 | 96 |
| Finland | 17 | 70 |
| Canada | 25 | 69 |
| France | 16 | 50 |
| Netherlands | 4 | 17 |
| Norway | 4 | 10 |

Remarque : dans le TCD, `China` = **990**, soit les 824 de China plus les 166 de USA dans activité_2019 (il n'y a pas de pays USA dans le TCD). C'est une particularité du fichier, pas une erreur de transformation.

Premières lignes attendues après dépivotage :

| Column1 | Étiquettes de lignes | Attribut | Valeur |
|---|---|---|---|
| Canada | Bay Roberts | Annonaceae | 1 |
| Canada | Bay Roberts | Cyperaceae | 8 |
| Canada | Bowen Island | Cyperaceae | 4 |

## 6. Fichiers texte

- `05_02_client_csv_comma.csv` : UTF-8, séparateur virgule, fins de ligne CRLF. **100 lignes x 6 colonnes** (+ en-têtes) : `id`, `first_name`, `last_name`, `email`, `gender`, `ip_address`. Ids de 1 à 100.
- `source.txt` : 249 lignes de texte, **une seule colonne** au chargement initial (Power BI propose l'encodage 1252, fins de ligne CRLF). Structure : 3 lignes par enregistrement (pays, nombre de cas, nombre de décès).
- Après « extraire une table avec des exemples » : **83 lignes x 3 colonnes** (pays, cas, décès). Premier enregistrement : Mainland China / 80270 / 2981 ; dernier : Ukraine / 1 / 0.
- Contrôles : somme de la 2e colonne = 94974 ; somme de la 3e = 3254.

## 7. Page web ISO 3166-1 et PDF

- Page web : page vivante, donc le résultat peut changer. Relevé le 2026-11-04 en lisant le HTML de `https://fr.wikipedia.org/wiki/ISO_3166-1` : le 1er tableau (celui de l'énoncé) a **249 lignes de données** et 8 colonnes (en-têtes : Code num., Code alpha-3, Code alpha-2, Codes des subdivisions, Nom en français du pays ou territoire, Nom ISO en français du pays ou territoire, Nom en forme longue dans la langue originale (translittération) [traduction en français], Indé-pendant). Ce que Power BI affiche dans « Table 0 » est **à relever dans Power BI** (il peut fusionner des cellules ou typer les colonnes différemment).
- PDF `Fichier clientele.pdf` (2 pages) : texte parasite (Lorem Ipsum) et trois tableaux de 5 colonnes (Pays, Ville, Latitude, Longitude, Base_clientele). Lecture par `pdftotext` :
  - Table001 (page 1) : France, **12 lignes** (Aix-en-Provence à Toulouse) ; vu sur la capture de l'énoncé.
  - Table002 (page 2) : Germany, **5 lignes** (Berlin, Düsseldorf, Hamburg x2, Stuttgart).
  - Table003 (page 2) : United Kingdom, **8 lignes** (East End à Wootton, dont Newport en double).
  - Les entrées du navigateur sont Table001, Table002, Table003, Page001, Page002. Les décimales sont écrites avec une virgule : Power BI en culture fr-FR les lit en nombres, sinon elles restent en texte. Les nombres de lignes exacts après import sont **à relever dans Power BI** (les valeurs ci-dessus viennent du texte du PDF).

## 8. Fichiers .pbix

Les .pbix sont des archives zip. Le `DataModel` est compressé en XPress9 : **illisible sans outil dédié**, je ne l'ai pas décodé. Ce qui est lisible :

- `02_01.pbix` : requête M lisible (DataMashup) : table `activité_2019` lue depuis le .xlsx 02_01, en-têtes promus, types, puis **suppression de `id_produit` et `id_fournisseur`** (13 colonnes restantes), `id_client` converti en texte. Elle sert de base au fichier `activité_2019.m`.
- `02_02.pbix`, `02_03.pbix`, `08_01.pbix` : pas de DataMashup (requêtes illisibles). Tables visibles dans le rapport 02_02 : `Clients` et `Transactions globales` (noms utilisés dans la mise en page). Relations, colonnes et mesures : **à relever dans Power BI**.
- `08_01.pbix` : la mise en page (`Report/Layout`) est lisible. Elle utilise la table `activité_2019` (champs `pays` et mesures `montant`, `qté`) et la table `Datum` (champs `Annee mois`, `Semaine ISO`, `Trimestre`). Voir `guide/dax.md`.

## 9. Visualisation : valeurs attendues sur 08_01 (calculées sur activité_2019)

La définition des mesures `montant` et `qté` n'a pas pu être lue (modèle compressé). Les valeurs ci-dessous sont calculées avec : qté = somme de `quantité`, montant = somme de `quantité` x `prix_unitaire`. Elles correspondent aux étiquettes visibles sur la capture de l'énoncé (page 56) : Chine 824 (58,03 %), USA 166 (11,69 %), Japon 118, Suède 96, Finlande 70, Canada 69, France 50.

Totaux : qté **1420**, montant **71588**, 478 lignes.

| Pays | qté | part de qté | montant |
|---|---|---|---|
| China | 824 | 58.03 % | 40536 |
| USA | 166 | 11.69 % | 7846 |
| Japan | 118 | 8.31 % | 6325 |
| Sweden | 96 | 6.76 % | 5408 |
| Finland | 70 | 4.93 % | 3565 |
| Canada | 69 | 4.86 % | 4176 |
| France | 50 | 3.52 % | 2744 |
| Netherlands | 17 | 1.20 % | 384 |
| Norway | 10 | 0.70 % | 604 |

| Annee mois | qté | montant |
|---|---|---|
| 201901 | 186 | 8621 |
| 201902 | 161 | 8278 |
| 201903 | 125 | 7344 |
| 201904 | 116 | 5420 |
| 201905 | 95 | 5539 |
| 201906 | 147 | 7345 |
| 201907 | 137 | 7329 |
| 201908 | 110 | 5535 |
| 201909 | 113 | 5823 |
| 201910 | 120 | 5039 |
| 201911 | 110 | 5315 |

Il n'y a aucune vente en décembre 2019 (dernière date : 2019-11-29) : l'histogramme a **11 barres**.

| Trimestre | qté | montant |
|---|---|---|
| T1 | 472 | 24243 |
| T2 | 358 | 18304 |
| T3 | 360 | 18687 |
| T4 | 230 | 10354 |

Semaines ISO : **48 semaines** avec ventes, de la semaine 1 à la semaine 48 (toutes dans l'année ISO 2019). Quelques semaines pour contrôle :

| Semaine ISO | qté | montant |
|---|---|---|
| 1 | 25 | 1038 |
| 2 | 50 | 2397 |
| 3 | 28 | 1527 |
| 4 | 42 | 1669 |
| 5 | 55 | 2510 |
| 6 | 39 | 2045 |

Liste complète semaine par semaine : `python3 -I` sur le fichier, ou à lire dans le visuel (48 points sur la courbe).

Avec le segment `Trimestre` sur T3 : qté **360**, montant **18687**.
