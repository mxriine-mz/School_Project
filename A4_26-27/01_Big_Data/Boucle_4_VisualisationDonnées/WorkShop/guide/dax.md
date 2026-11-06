# Mesures DAX pour la partie visualisation (08_01.pbix)

## Ce qui est connu et ce qui ne l'est pas

Le modèle de `08_01.pbix` est compressé (XPress9) : je n'ai **pas pu lire** les définitions des mesures ni des colonnes. Ce qui est lisible dans la mise en page du rapport :

- table `activité_2019` : colonne `pays`, mesures `montant` et `qté` ;
- table `Datum` (calendrier) : colonnes `Annee mois`, `Semaine ISO`, `Trimestre` utilisées dans les visuels ; d'autres colonnes visibles dans le volet Champs de l'énoncé (page 56) : `Annee`, `Mois`, `Nom du mois`, `Nom du jour`, `Jour ouvré`, `Semaine`, `Annee_Sem_ISO`, `Date`.

Les formules ci-dessous sont donc **reconstituées**, pas copiées du .pbix. Elles ont été choisies pour redonner exactement les valeurs visibles sur la capture de l'énoncé (par exemple Chine 824, 58,03 %). Elles n'ont pas été exécutées dans Power BI. Pour voir les vraies formules : ouvrir `08_01.pbix`, vue Données, cliquer sur la mesure `montant` ou `qté` (barre de formule).

Les valeurs attendues viennent de `resultats/attendus.md`, section 9.

## 1. Mesures de base (table activité_2019)

Modélisation > Nouvelle mesure, une par une.

```dax
qté = SUM ( 'activité_2019'[quantité] )
```
Attendu, sans filtre : **1420**.

```dax
montant = SUMX ( 'activité_2019', 'activité_2019'[quantité] * 'activité_2019'[prix_unitaire] )
```
Attendu, sans filtre : **71588**. `SUMX` est nécessaire : le montant est calculé ligne par ligne (quantité fois prix), pas en multipliant deux totaux.

```dax
nb lignes = COUNTROWS ( 'activité_2019' )
```
Attendu : **478**.

```dax
nb clients = DISTINCTCOUNT ( 'activité_2019'[id_client] )
```
Attendu : **182**.

```dax
prix moyen = DIVIDE ( [montant], [qté] )
```
Attendu : **50,41** (71588 / 1420).

## 2. Part de chaque pays

```dax
% qté par pays = DIVIDE ( [qté], CALCULATE ( [qté], ALL ( 'activité_2019'[pays] ) ) )
```
Dans le secteur ou un tableau avec `pays` : China 58,03 %, USA 11,69 %, Japan 8,31 %, Sweden 6,76 %, Finland 4,93 %, Canada 4,86 %, France 3,52 %, Netherlands 1,20 %, Norway 0,70 %. Format : pourcentage, 2 décimales.

## 3. Table de dates `Datum` (si elle manque ou pour la reconstruire)

Modélisation > Nouvelle table. Les données vont du 2019-01-02 au 2019-11-29 ; on prend l'année 2019 entière.

```dax
Datum =
ADDCOLUMNS (
    CALENDAR ( DATE ( 2019, 1, 1 ), DATE ( 2019, 12, 31 ) ),
    "Annee", YEAR ( [Date] ),
    "Mois", MONTH ( [Date] ),
    "Annee mois", YEAR ( [Date] ) * 100 + MONTH ( [Date] ),
    "Nom du mois", FORMAT ( [Date], "MMMM", "fr-FR" ),
    "Nom du jour", FORMAT ( [Date], "dddd", "fr-FR" ),
    "Trimestre", "T" & QUARTER ( [Date] ),
    "Semaine ISO", WEEKNUM ( [Date], 21 ),
    "Annee_Sem_ISO", YEAR ( [Date] - WEEKDAY ( [Date], 2 ) + 4 ) * 100 + WEEKNUM ( [Date], 21 ),
    "Jour ouvré", IF ( WEEKDAY ( [Date], 2 ) <= 5, 1, 0 )
)
```

Ensuite :

1. Vue Modèle : relier `Datum[Date]` à `'activité_2019'[date]` (un à plusieurs, `Datum` côté « 1 »). La colonne `date` de `activité_2019` doit être de type Date (voir `powerquery/01_activite_2019.m`).
2. Clic droit sur `Datum` > Marquer comme table de dates, colonne `Date`.
3. Pour `Annee mois`, vue Données : Trier par colonne > `Annee mois`. `Nom du mois` : trier par `Mois`.

Contrôle : `Annee mois` vaut 201901, 201902, ... (c'est le format des étiquettes de l'axe sur la capture de l'énoncé). `Trimestre` vaut T1 à T4.

## 4. Mesures de temps (optionnelles)

```dax
montant cumulé = TOTALYTD ( [montant], Datum[Date] )
```
Attendu à `Annee mois` = 201911 : **71588** (c'est la fin des données). À 201901 : 8621 ; à 201902 : 16899 (8621 + 8278).

```dax
montant mois précédent = CALCULATE ( [montant], DATEADD ( Datum[Date], -1, MONTH ) )
```
Attendu à 201902 : **8621**.

```dax
évolution mensuelle = DIVIDE ( [montant] - [montant mois précédent], [montant mois précédent] )
```
Attendu à 201902 : (8278 - 8621) / 8621 = **-3,98 %**.

## 5. Valeurs de contrôle des visuels

Tous les chiffres viennent de `resultats/attendus.md`, section 9.

| Visuel | Réglage | Contrôle |
|---|---|---|
| Histogramme empilé | Axe `Annee mois`, valeurs `montant` | 11 barres, de 8621 (201901) à 5315 (201911) |
| Courbe | Axe `Semaine ISO`, valeurs `qté`, valeurs secondaires `montant` | 48 points (semaines 1 à 48) |
| Secteurs | Légende `pays`, valeurs `qté` | 9 parts, China 824 |
| Segment `Trimestre` = T3 | filtre tous les visuels | qté 360, montant 18687 |

## 6. Si on travaille sur 02_02.pbix (modèle avec relations)

Dans 02_02.pbix les tables s'appellent `Clients`, `Transactions globales` et `Produit-fournisseur` d'après l'énoncé ; je n'ai pas pu vérifier les noms de colonnes. Avec les relations de la section 4 du guide, le montant se calcule avec `RELATED` (noms à adapter) :

```dax
montant 2018-2019 = SUMX ( 'Transactions globales', 'Transactions globales'[quantité] * RELATED ( 'Produit-fournisseur'[prix_unitaire] ) )
```
Attendu si la table `Transactions globales` contient 2018 et 2019 (1000 lignes) : à relever dans Power BI (je n'ai calculé le montant que pour 2019 : 71588).
