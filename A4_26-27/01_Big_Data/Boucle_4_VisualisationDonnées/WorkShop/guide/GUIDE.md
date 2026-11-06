# Guide du workshop Power BI (Boucle 4, Visualisation des données)

Ce guide suit l'énoncé `Workshop_-_powerBI.pdf` section par section. Pour chaque étape :

- **Interface** : les clics, avec les menus en français comme l'énoncé.
- **Code M** : l'équivalent dans l'Éditeur avancé (Accueil > Éditeur avancé), quand c'est une transformation Power Query.
- **Attendu** : ce qu'il faut voir à l'écran pour valider (détail dans `../resultats/attendus.md`).
- **Capture** : nom de fichier proposé, à enregistrer dans `../captures/`.

## Avant de commencer

1. Les fichiers sont dans `ressources/`. Copier ce dossier sur Windows (par exemple `C:\Users\mazou\Documents\WorkShop\ressources\`).
2. Dans chaque fichier `powerquery/*.m`, la ligne `Dossier = "..."` contient ce chemin. Le modifier si le dossier est ailleurs. Garder le `\` final.
3. Les codes M et DAX n'ont **pas été testés** dans Power BI. Les résultats attendus, eux, sont calculés sur les fichiers (voir `attendus.md`).
4. Si un clic de l'interface donne un résultat différent du code fourni, l'interface fait foi : noter l'écart.
5. Un point de l'énoncé est faux en pratique : il dit que le format PBIT garde les données extraites et que le PBIX ne garde que le modèle. C'est l'inverse : un **.pbit est un modèle sans données**, un **.pbix** contient les données. À vérifier au moment de l'enregistrement.

Particularité du nom de dossier : le dossier de l'archive s'appelait `05_01_transactions_par_annВe` (un « В » cyrillique à la place du « e »). Il a été renommé `05_01_transactions_par_annee`.

Ordre conseillé : sections 1 à 4 dans l'ordre. Les captures peuvent être prises au fil de l'eau.

---

## 1. Introduction

Rien à manipuler. Vérifier la version installée : Fichier > Aide > À propos de Power BI Desktop (8 Go de RAM et 10 Go de disque conseillés).

- Capture : `captures/00_version_powerbi.png` (la fenêtre « À propos »).

Points à retenir pour le compte rendu : Power BI est une solution de BI de bout en bout (collecte et retraitement, modélisation et indicateurs avec couche de sécurité, présentation sur un portail collaboratif). Flux : créer le rapport dans Power BI Desktop, le publier dans le service Power BI, le consulter avec Power BI Mobile.

---

## 2. Extraction et traitement des données

### 2.1 Excel : 02_01_rainforest_global_2019.xlsx, table activité_2019 (énoncé p. 4 à 7)

**Interface**

1. Au démarrage, fermer la fenêtre d'accueil.
2. Accueil > Obtenir les données > Plus... > Excel (plus de 70 connecteurs disponibles) > choisir `02_01_rainforest_global_2019.xlsx` > Ouvrir.
3. Cocher `activité_2019`. Deux choix : **Charger** (sans modifier) ou **Transformer les données** (conseillé).
4. Choisir **Transformer les données** : l'éditeur Power Query s'ouvre. À droite, les étapes appliquées sont listées.
5. Le nom de la requête se change dans Propriétés (l'énoncé la nomme activités_2019).
6. Fermer et appliquer.
7. Fichier > Enregistrer (voir la remarque PBIX/PBIT ci-dessus).

**Code M** : `powerquery/01_activite_2019.m` (en plus de l'énoncé : suppression de `id_produit` et `id_fournisseur`, comme dans `02_01.pbix`).

**Attendu** (avant suppression de colonnes) : **478 lignes x 15 colonnes**. Après suppression de `id_produit` et `id_fournisseur` : 13 colonnes. Dernière date : 29/11/2019.

**Captures**

- `captures/01_navigateur_activite_2019.png` : navigateur avec activité_2019 cochée.
- `captures/02_editeur_pq_activite_2019.png` : éditeur Power Query avec les étapes appliquées à droite.
- `captures/03_enregistrement_pbix.png` : fenêtre d'enregistrement.

### 2.2 Excel à plusieurs feuilles : 02_02_rainforest_inc.xlsx (p. 8)

**Interface** : Obtenir les données > Excel > `02_02_rainforest_inc.xlsx` > cocher les 5 feuilles (transactions_2018, transactions_2019, clients, produits, fournisseurs) > Transformer les données.

**Code M** : `powerquery/02_rainforest_inc.m` (transactions_2018, transactions_2019, fournisseurs), `04_clients.m`, `05_produits.m`.

**Attendu** (dimensions affichées en bas à gauche en cliquant sur une colonne) :

| Table | Lignes x colonnes |
|---|---|
| transactions_2018 | 522 x 4 |
| transactions_2019 | 478 x 4 |
| clients | 203 x 6 (dont 1 ligne vide) |
| fournisseurs | 20 x 2 |
| produits | 70 lignes de données ; en-têtes à promouvoir (voir 2.6) |

**Capture** : `captures/04_navigateur_rainforest_inc.png`.

### 2.3 Tableau croisé dynamique : 02_03_rainforest_inc_TCD.xlsx (p. 9 à 14)

Un TCD est lisible pour un humain, mais difficile à exploiter. L'objectif est de l'aplatir.

**Interface** : Obtenir les données > Excel > `02_03_rainforest_inc_TCD.xlsx` > cocher `TCD_activité` > Transformer les données. Puis, dans l'ordre :

1. Accueil > Réduire les lignes > Supprimer les lignes > **Supprimer les premières lignes** > 1 > OK.
2. Même chemin > **Supprimer les dernières lignes** > 1 (la ligne « Total général »).
3. Transformer > **Transposer**. La 2e colonne contient les villes, la 1re les pays.
4. Cliquer sur la colonne 1 > Transformer > Renseigner > **Vers le bas** : le pays est répété sur chaque ligne.
5. Colonne 1 > flèche de filtre > saisir `tot` dans la zone de recherche > retirer de la sélection les valeurs « Total ... » > OK. Les sous-totaux disparaissent.
6. Accueil > **Utiliser la première ligne comme en-têtes**.
7. Sélectionner les deux premières colonnes > Transformer > **Dépivoter les autres colonnes**.

**Code M** : `powerquery/03_tcd_activite.m` (une étape commentée par clic).

**Attendu, étape par étape** (lignes x colonnes) :

| Étape | Attendu |
|---|---|
| Brut | 45 x 197 |
| Après les 2 suppressions | 43 x 197 |
| Après Transposer | 197 x 43 |
| Après filtre « tot » | 180 x 43 |
| Après en-têtes | 179 x 43 |
| Après dépivotage | **454 lignes x 4 colonnes** (Column1, Étiquettes de lignes, Attribut, Valeur) |

Contrôle : somme de `Valeur` = 1420. Première ligne : Canada / Bay Roberts / Annonaceae / 1. Les pays sont 8 : China 990, Japan 118, Sweden 96, Finland 70, Canada 69, France 50, Netherlands 17, Norway 10. Le pays `China` vaut 990 car il regroupe les clients de China (824) et de USA (166) : particularité du fichier.

Point de vigilance : l'énoncé dit « décochez tout en cochant la première ligne » pour le filtre. Si la ligne d'en-têtes (valeur vide en colonne 1) disparaît à cette étape, elle manque ensuite pour les en-têtes : vérifier que 180 lignes restent.

**Captures**

- `captures/05_tcd_brut.png` : le TCD tel qu'importé.
- `captures/06_tcd_transpose_rempli.png` : après Transposer et Vers le bas.
- `captures/07_tcd_filtre_totaux.png` : fenêtre du filtre « tot ».
- `captures/08_tcd_depivote.png` : table finale à plat (454 x 4).

### 2.4 Supprimer une colonne et qualité des données dans 02_01.pbix (p. 14 à 16)

**Interface**

1. Fichier > Ouvrir le rapport > Parcourir > `02_01.pbix`. Ouvrir l'éditeur Power Query (Transformer les données).
2. Clic droit sur la colonne `id_fournisseur` > Supprimer.
3. Affichage > cocher **Qualité de la colonne** (affiche Valide / Erreur / Vide en pourcentage).
4. Pour changer un type : cliquer sur l'icône de type (ABC, 123) à gauche du nom de la colonne.

**Code M** : voir l'étape `Colonnes supprimées` et l'étape de types dans `01_activite_2019.m`. Le .pbix d'origine contient la requête (supprime aussi `id_produit`).

**Attendu** : 13 colonnes dans activité_2019 du .pbix. Qualité : aucune valeur vide ni erreur dans activité_2019 (le fichier n'en contient pas).

**Captures** : `captures/09_qualite_colonne.png`, `captures/10_changement_type.png`.

### 2.5 Table clients : lignes vides et doublons dans 02_02.pbix (p. 17 à 18)

**Interface**

1. Ouvrir `02_02.pbix` > Transformer les données > table `clients`.
2. Accueil > Réduire les lignes > Supprimer les lignes > **Supprimer les lignes vides**. En cliquant sur une colonne, le nombre de lignes s'affiche en bas.
3. La ligne 201 se répète et la dernière ligne est inutile : Réduire les lignes > Supprimer les lignes > **Supprimer les dernières lignes** > 2.
4. L'énoncé dit que la même manipulation existe pour les doublons : Supprimer les doublons (voir variante).

**Code M** : `powerquery/04_clients.m`.

**Attendu**

| Étape | Lignes |
|---|---|
| Brut (xlsx) | 203 x 6 |
| Sans lignes vides | **202** |
| Sans les 2 dernières lignes (doublon id 200 + test id 999) | **200** (ids 1 à 200) |
| Variante « Supprimer les doublons » | 201 (la ligne de test id 999 reste) |

**Captures** : `captures/11_clients_lignes_vides.png`, `captures/12_clients_apres_nettoyage.png`.

### 2.6 Produits : majuscule sur la couleur (p. 19)

**Interface** : table `produits` > colonne `couleur` > Transformer > Format (icône ABC) > **Mettre en majuscule chaque mot**. Il faut d'abord que les en-têtes soient promus (la feuille commence par un titre « Catalogue 2018-2019 »).

**Code M** : `powerquery/05_produits.m`. Il ajoute un `Text.Trim` hors énoncé (8 couleurs « Green » ont des espaces au début).

**Attendu** : 70 lignes ; 19 couleurs distinctes (Aquamarine, Blue, Crimson, Fuscia, Goldenrod, Green, Indigo, Khaki, Maroon, Mauv, Orange, Pink, Puce, Purple, Red, Teal, Turquoise, Violet, Yellow). « blue » devient « Blue », « PINK » devient « Pink ».

**Capture** : `captures/13_produits_couleur_majuscule.png`.

### 2.7 transactions_2018 : trimestre et préfixe TRIM (p. 20)

**Interface**

1. Table `transactions_2018` > clic droit sur `date` > **Dupliquer la colonne**. La renommer `Trimestre`.
2. Colonne `Trimestre` > Transformer > Date > Trimestre > **Trimestre de l'année**.
3. Même colonne > Transformer > Format > **Ajouter un préfixe** > `TRIM` > OK.

**Code M** : `powerquery/06_transactions_2018_trimestre.m`. Les dates sont du texte `jj/mm/aaaa` : si Power BI ne les reconnaît pas comme date, changer le type avec **Utiliser les paramètres régionaux... > Français (France)**. Sinon 02/01/2018 est lu comme le 1er février.

**Attendu** : 522 lignes x 5 colonnes ; valeurs `TRIM1`, `TRIM2`, `TRIM3`, `TRIM4`.

**Capture** : `captures/14_transactions_trimestre.png`.

### 2.8 Fusionner les colonnes nom et prénom (p. 21 à 23)

**Interface**

1. Table `clients` : cliquer sur `nom`, puis Ctrl + clic sur `prenom` (l'ordre compte).
2. Clic droit > **Fusionner les colonnes** > séparateur **Espace** > nom de la nouvelle colonne > OK.
3. Pour revenir en arrière, Transformer > **Fractionner la colonne** > Par le délimiteur (espace).

**Code M** : `powerquery/04_clients.m`, requête `clients_nom_complet`.

**Attendu** : 200 lignes x 5 colonnes après fusion ; première valeur « Oldridge Graeme » (nom d'abord). Le fractionnement redonne 2 colonnes (aucun nom ni prénom ne contient d'espace). Si on sélectionne `prenom` avant `nom`, on obtient « Graeme Oldridge ».

**Capture** : `captures/15_fusion_colonnes.png` (fenêtre de fusion).

### 2.9 Regrouper par trimestre (p. 23)

**Interface**

1. Clic droit sur `transactions_2018` > **Dupliquer** (la copie s'appelle `transactions_2018 (2)`).
2. Transformer > **Regrouper par** : champ `Trimestre` ; nouveau nom de colonne (par exemple « Quantité par trimestre ») ; opération **Somme** ; colonne `quantité` > OK.

**Code M** : `powerquery/07_regroupement_trimestre.m`.

**Attendu** : **4 lignes x 2 colonnes**.

| Trimestre | Somme de quantité |
|---|---|
| TRIM1 | 394 |
| TRIM2 | 365 |
| TRIM3 | 425 |
| TRIM4 | 352 |

Total 1536.

**Capture** : `captures/16_regroupement_trimestre.png`.

### 2.10 Colonne à partir d'exemples (p. 24 à 25)

**Interface** : table `produits` > Ajouter une colonne > **Colonne à partir d'exemples** > dans la première cellule, taper le premier produit puis la première couleur entre parenthèses (`Wheat Sedge (Blue)`) > Entrée > cliquer sur la cellule du dessous pour que Power BI propose la formule > OK.

**Code M** : `powerquery/05_produits.m`, étape `Colonne ajoutée` (équivalent : `Text.Combine({[nom_produit], " (", [couleur], ")"})`).

**Attendu** : 70 lignes x 7 colonnes. Faire l'exemple **après** la mise en majuscule (sinon la 1re couleur est « blue » et non « Blue »).

**Capture** : `captures/17_colonne_exemples.png`.

### 2.11 Fusionner deux requêtes : produits et fournisseurs (p. 26 à 27)

**Interface**

1. Table `produits` > Accueil > Combiner > **Fusionner des requêtes** (première option : dans la même table).
2. Colonne `id_fournisseur` de `produits`, table `fournisseurs`, colonne `id_fournisseur` de `fournisseurs`. Type de jointure : **Externe gauche** (par défaut). Une barre verte en bas indique que la jointure est bonne.
3. Une nouvelle colonne apparaît. Cliquer sur les deux flèches > cocher **uniquement** `nom_fournisseur` > décocher « Utiliser le nom de colonne d'origine comme préfixe » > OK.

**Code M** : `powerquery/05_produits.m`, étapes `Requêtes fusionnées` et `Fournisseurs développé`.

**Attendu** : la barre verte indique que les 70 lignes correspondent (0 produit sans fournisseur). Résultat : 70 lignes x 8 colonnes (6 + colonne exemple + nom_fournisseur).

**Captures** : `captures/18_fusion_requetes.png`, `captures/19_fusion_developpee.png`.

### 2.12 Ajouter des requêtes : 2018 + 2019 (p. 28)

**Interface** : table `transactions_2018` > Accueil > Combiner > **Ajouter des requêtes** > table `transactions_2019` > OK.

**Code M** : `powerquery/08_ajout_2018_2019.m`.

**Attendu** : **1000 lignes** (522 + 478). 5 colonnes si `Trimestre` existe sur 2018 (la colonne vaut `null` pour les 478 lignes de 2019). Quantité totale 2956.

**Capture** : `captures/20_ajout_requetes.png`.

### 2.13 Importer un dossier (p. 29 à 33)

**Interface**

1. Fichier > Obtenir les données > **Dossier** > Parcourir > sélectionner `ressources\05_01_transactions_par_annee` > OK.
2. Cliquer sur **Combiner** > **Combiner et transformer les données** > choisir la feuille `transactions` > OK.

**Code M** : `powerquery/09_import_dossier.m` (une seule requête, sans les requêtes auxiliaires).

**Attendu** : **1000 lignes x 5 colonnes** (`Source.Name`, `id_client`, `id_produit`, `quantité`, `date`). 522 lignes viennent de `partiel_2018.xlsx`, 478 de `partiel_2019.xlsx`. Avec l'assistant, Power BI crée en plus des requêtes auxiliaires (Paramètre, Exemple de fichier, Transformer le fichier) : noter leurs noms.

**Captures**

- `captures/21_dossier_choix.png` : fenêtre du dossier.
- `captures/22_dossier_combiner.png` : fenêtre « Combiner les fichiers ».
- `captures/23_dossier_resultat.png` : table finale (1000 lignes).

---

## 3. Importation de différents types de données (p. 34 à 43)

### 3.1 CSV avec séparateur virgule (p. 34)

**Interface** : Obtenir les données > Texte/CSV > `05_02_client_csv_comma.csv`. L'aperçu détecte le délimiteur virgule (modifiable dans la liste « Délimiteur »).

**Code M** : `powerquery/10_csv_virgule.m`.

**Attendu** : **100 lignes x 6 colonnes** (`id`, `first_name`, `last_name`, `email`, `gender`, `ip_address`), encodage UTF-8.

**Capture** : `captures/24_csv_apercu.png`.

### 3.2 Fichier texte : source.txt (p. 35 à 38)

**Interface**

1. Obtenir les données > Texte/CSV > `source.txt`. Au chargement, tout est dans **une seule colonne** (249 lignes). Encodage proposé : 1252 (Europe de l'Ouest).
2. Transformer les données. Au-dessus de la table : **Extraire une table à partir d'exemples**.
3. Colonne 1 : cliquer sur la première cellule et taper `Mainland China`, Entrée. Colonne 2 : taper `80270`. Colonne 3 : taper `2981`. Power BI ne comprend pas tout de suite : continuer d'entrer les exemples.
4. Transformer les données ou Charger.

**Code M** : `powerquery/11_source_txt.m` (regroupe les lignes 3 par 3).

**Attendu** : **83 lignes x 3 colonnes** (pays, cas, décès). Première ligne : Mainland China, 80270, 2981. Dernière ligne : Ukraine, 1, 0. Sommes : 94974 et 3254.

**Captures** : `captures/25_texte_une_colonne.png`, `captures/26_texte_exemples.png`, `captures/27_texte_resultat.png`.

### 3.3 Page web : ISO 3166-1 (p. 39 à 40)

**Interface** : copier `https://fr.wikipedia.org/wiki/ISO_3166-1` > Obtenir les données > **Web** > coller l'adresse > OK > Se connecter. Par défaut, cocher le **premier tableau** (« Table 0 ») puis Charger.

**Code M** : `powerquery/12_web_iso_3166.m`.

**Attendu** : environ 249 lignes de données et 8 colonnes pour le premier tableau de la page (relevé HTML du 2026-11-04). **Chiffres exacts à relever dans Power BI** : la page change.

**Captures** : `captures/28_web_navigateur.png`, `captures/29_web_resultat.png`.

### 3.4 PDF : Fichier clientele.pdf (p. 41 à 42)

**Interface** : Obtenir les données > Plus... > **PDF** > `Fichier clientele.pdf` > cocher les tables voulues (Table001, etc.).

**Code M** : `powerquery/13_pdf_clientele.m`.

**Attendu** : le navigateur propose Table001 (page 1), Table002 (page 2), Table003 (page 2), Page001, Page002. Table001 : 12 lignes (France) x 5 colonnes (`Pays`, `Ville`, `Latitude`, `Longitude`, `Base_clientele`). Table002 : 5 lignes (Germany) et Table003 : 8 lignes (United Kingdom) d'après le texte du PDF : à vérifier à l'écran.

**Captures** : `captures/30_pdf_choix_fichier.png`, `captures/31_pdf_navigateur.png`.

---

## 4. Modélisation des données (p. 44 à 45)

L'énoncé indique que, à ce stade, les tables sont indépendantes. On crée les relations.

**Interface**

1. Fichier > Ouvrir le rapport > Parcourir le rapport > `02_02.pbix`.
2. Trois vues à gauche : **Rapport** (graphiques, indicateurs, cartes), **Données** (visuel de chaque table), **Modèle** (relations).
3. Vue Modèle : glisser `numéro client` de la table `Clients` sur `id_client` de la table `Transactions globales`.
4. Glisser `id_produit` de la table `Produit-fournisseur` sur `id_produit` de `Transactions globales`.

Vocabulaire : `numéro client` est la clé primaire, `id_client` la clé étrangère (secondaire).

**Attendu** : deux relations. Cardinalité attendue : un à plusieurs (« 1 » côté `Clients` et `Produit-fournisseur`, « * » côté `Transactions globales`). Je n'ai pas pu lire le modèle de `02_02.pbix` (voir `attendus.md`, section 8) : cardinalité, direction du filtre et noms exacts de colonnes sont **à relever dans Power BI**. Il n'y a ni transaction sans client ni transaction sans produit dans les données (0 orphelin calculé).

**Captures**

- `captures/32_vues_rapport_donnees_modele.png` : les trois onglets à gauche.
- `captures/33_modele_relations.png` : la vue Modèle avec les deux relations.

---

## 5. Visualisation des données (p. 46 à 57)

Fichier : `08_01.pbix` (table `activité_2019` avec mesures `qté` et `montant`, table `Datum`). Mesures reconstituées dans `dax.md`.

**Attendu général** : qté totale 1420, montant total 71588.

### 5.1 Histogramme empilé (p. 46 à 48)

**Interface** : Visualisations > **Histogramme empilé** > glisser `Annee mois` dans **Axe** et `montant` dans **Valeurs**. Pour la taille, la couleur et le titre : onglet Format > Axe (taille, couleur), Valeurs, Titre. Titre proposé : « Montant par mois ».

**Attendu** : **11 barres** (201901 à 201911, pas de décembre). Premier mois 8621, dernier 5315. Le plus haut est 201901 (8621), le plus bas 201910 (5039). Sur la capture de l'énoncé les mois sont triés du plus récent au plus ancien : trier par `Annee mois` croissant (Trois petits points > Trier l'axe).

**Captures** : `captures/34_histogramme_champs.png`, `captures/35_histogramme_format.png`.

### 5.2 Graphique en courbe (p. 49 à 51)

**Interface**

1. Visualisation **Graphique en courbes** > `Semaine ISO` dans **Axe**, `qté` dans **Valeurs**.
2. Mettre en forme pour afficher toutes les semaines (Format > Axe X > type Catégoriel, étendre le visuel).
3. Trois petits points > **Trier l'axe** > Semaine ISO, croissant.
4. Glisser `montant` dans **Valeurs secondaires** (autre unité : axe à droite).

**Attendu** : **48 points** (semaines 1 à 48). Semaine 1 : qté 25, montant 1038. Semaine 2 : qté 50, montant 2397. Semaine 5 : qté 55, montant 2510.

**Captures** : `captures/36_courbe_qte.png`, `captures/37_courbe_qte_montant.png`.

### 5.3 Graphique en secteurs (p. 52)

**Interface** : **Graphique en secteurs** > `pays` dans **Légende**, `qté` dans **Valeurs**.

**Attendu** : 9 parts. China 824 (58,03 %), USA 166 (11,69 %), Japan 118 (8,31 %), Sweden 96 (6,76 %), Finland 70 (4,93 %), Canada 69 (4,86 %), France 50 (3,52 %), Netherlands 17, Norway 10.

**Capture** : `captures/38_secteurs_pays.png`.

### 5.4 Titre, images et mise en page (p. 53 à 54)

**Interface**

1. Replacer les graphiques en les glissant dans la page.
2. Insérer > **Zone de texte** > écrire `RainForest`, choisir taille, couleur et arrière-plan.
3. Insérer > **Image** > `ressources/icons8-bamboo-96_bw.png` > la placer sur le texte. Copier-coller l'image de chaque côté du titre.

**Attendu** : en-tête bleu avec le titre et 4 images de bambou (la mise en page de `08_01.pbix` en a 4).

**Capture** : `captures/39_titre_images.png`.

### 5.5 Segment Trimestre (p. 55 à 56)

**Interface** : Visualisation **Segment** > glisser `Trimestre` (table `Datum`) dans **Champ**. Cocher T3 : tous les graphiques sont filtrés.

**Attendu avec T3** : qté **360**, montant **18687**. Les autres trimestres : T1 qté 472 / montant 24243 ; T2 358 / 18304 ; T4 230 / 10354.

**Captures** : `captures/40_segment_champ.png`, `captures/41_segment_t3.png`.

### 5.6 DAX (p. 57)

L'énoncé donne seulement deux liens (apprendre les bases de DAX, liste des fonctions DAX). Les mesures utiles sont dans `dax.md`.

**Capture** : `captures/42_mesure_dax.png` (barre de formule d'une mesure).

---

## 6. Consultation des rapports depuis le web et le téléphone (p. 58 à 65)

Cette partie demande le compte **viacesi** de Marine. Elle n'est pas faite ici : seules les étapes sont décrites.

1. Dans Power BI Desktop : **Publier** > se connecter avec le compte viacesi (ou un compte professionnel) : adresse mail, puis mot de passe.
2. Choisir **Mon espace de travail** > Sélectionner > OK. Attendre « Publication réussie ».
3. Sur `https://powerbi.microsoft.com/fr-fr/`, se connecter avec les mêmes identifiants > **Mon espace de travail** : le rapport publié y figure. L'ouvrir.
4. Mobile : installer l'application Power BI (Play Store pour Android, App Store pour Apple), se connecter avec le même compte > **Mon espace de travail** > ouvrir le rapport.

**Attendu** : le rapport s'affiche avec les mêmes visuels que dans Desktop. Si la publication est refusée, c'est souvent une licence ou un compte sans accès : noter le message exact.

**Captures**

- `captures/43_publier_dialogue.png`
- `captures/44_espace_travail_web.png`
- `captures/45_rapport_web.png`
- `captures/46_rapport_mobile.png` (capture d'écran du téléphone)

---

## 7. Bibliographie (p. 66)

Reprendre telle quelle depuis l'énoncé : Power BI Desktop (André Meyer-Roussilhon, 2e édition) et Business Intelligence avec SQL Server 2019 et Power BI (Sébastien Fantini). Ajouter les deux liens DAX de l'énoncé.

## Liste des captures

| # | Fichier | Section |
|---|---|---|
| 1 | `00_version_powerbi.png` | 1 |
| 2 | `01_navigateur_activite_2019.png` | 2.1 |
| 3 | `02_editeur_pq_activite_2019.png` | 2.1 |
| 4 | `03_enregistrement_pbix.png` | 2.1 |
| 5 | `04_navigateur_rainforest_inc.png` | 2.2 |
| 6 | `05_tcd_brut.png` | 2.3 |
| 7 | `06_tcd_transpose_rempli.png` | 2.3 |
| 8 | `07_tcd_filtre_totaux.png` | 2.3 |
| 9 | `08_tcd_depivote.png` | 2.3 |
| 10 | `09_qualite_colonne.png` | 2.4 |
| 11 | `10_changement_type.png` | 2.4 |
| 12 | `11_clients_lignes_vides.png` | 2.5 |
| 13 | `12_clients_apres_nettoyage.png` | 2.5 |
| 14 | `13_produits_couleur_majuscule.png` | 2.6 |
| 15 | `14_transactions_trimestre.png` | 2.7 |
| 16 | `15_fusion_colonnes.png` | 2.8 |
| 17 | `16_regroupement_trimestre.png` | 2.9 |
| 18 | `17_colonne_exemples.png` | 2.10 |
| 19 | `18_fusion_requetes.png` | 2.11 |
| 20 | `19_fusion_developpee.png` | 2.11 |
| 21 | `20_ajout_requetes.png` | 2.12 |
| 22 | `21_dossier_choix.png` | 2.13 |
| 23 | `22_dossier_combiner.png` | 2.13 |
| 24 | `23_dossier_resultat.png` | 2.13 |
| 25 | `24_csv_apercu.png` | 3.1 |
| 26 | `25_texte_une_colonne.png` | 3.2 |
| 27 | `26_texte_exemples.png` | 3.2 |
| 28 | `27_texte_resultat.png` | 3.2 |
| 29 | `28_web_navigateur.png` | 3.3 |
| 30 | `29_web_resultat.png` | 3.3 |
| 31 | `30_pdf_choix_fichier.png` | 3.4 |
| 32 | `31_pdf_navigateur.png` | 3.4 |
| 33 | `32_vues_rapport_donnees_modele.png` | 4 |
| 34 | `33_modele_relations.png` | 4 |
| 35 | `34_histogramme_champs.png` | 5.1 |
| 36 | `35_histogramme_format.png` | 5.1 |
| 37 | `36_courbe_qte.png` | 5.2 |
| 38 | `37_courbe_qte_montant.png` | 5.2 |
| 39 | `38_secteurs_pays.png` | 5.3 |
| 40 | `39_titre_images.png` | 5.4 |
| 41 | `40_segment_champ.png` | 5.5 |
| 42 | `41_segment_t3.png` | 5.5 |
| 43 | `42_mesure_dax.png` | 5.6 |
| 44 | `43_publier_dialogue.png` | 6 |
| 45 | `44_espace_travail_web.png` | 6 |
| 46 | `45_rapport_web.png` | 6 |
| 47 | `46_rapport_mobile.png` | 6 |
