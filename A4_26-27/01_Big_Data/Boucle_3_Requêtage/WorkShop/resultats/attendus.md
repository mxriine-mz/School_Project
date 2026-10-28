# Résultats attendus du WS Hive

Statut : **calculés en Python** (`python3 -I`) à partir des fichiers de `data/`. Ils n'ont **pas** été obtenus sur la VM Cloudera : à comparer avec la sortie réelle de `hive -f` sur chaque script.

Hypothèses : année courante = **2026** (expérience = 2026 - annee_embauche) ; date de référence pour l'âge = 2026-10-28. Les résultats Q4, Q8, Q9, Q10 et la colonne `age` changent avec la date d'exécution. L'ordre des lignes sans ORDER BY et l'ordre interne de `collect_set` ne sont pas garantis par Hive.

## Volumes

| Table | Lignes |
|---|---|
| htables.log_emploi_population | 12 |
| htables.emploi_population | 12 |
| htables.personne | 12 |
| htables.population_genre | 12 (F : 6, M : 6) |
| htables.log_internautes | 17 |
| htables.log_internautes_buckets | 17 |
| htables.log_internautes_buckets2 | 17 |
| analyse_salaires.employes | 33 |
| analyse_salaires.fonction_employes | 33 |
| analyse_salaires.salaire_employes | 33 |

## Partie 1 : emploi_population (âge au 2026-10-28)

| sexe | age | fonction | salaire | code_postal | id_empl |
|---|---|---|---|---|---|
| F | 38 | Aide-soignant | 20000euro/an | 59000 | 1 |
| M | 45 | Informaticien | 35000euro/an | 80000 | 2 |
| F | 59 | Infermiere | 22000euro/an | 77000 | 3 |
| F | 70 | Professeur | 30000euro/an | 95000 | 4 |
| M | 26 | Mecanicien | 45000euro/an | 80200 | 5 |
| M | 38 | Avocat | 70000euro/an | 59000 | 6 |
| M | 29 | Veterinaire | 45000euro/an | 75780 | 7 |
| F | 71 | Pericultrice | 38000euro/an | 76000 | 8 |
| F | 54 | Informaticienne | 45000euro/an | 91000 | 9 |
| M | 57 | Agriculture | 30000euro/an | 14000 | 10 |
| M | 42 | Coach sportif | 55000euro/an | 78000 | 11 |
| F | 31 | Musicienne | 41000euro/an | 6000 | 12 |

`SHOW PARTITIONS population_genre` : `sexe=F`, `sexe=M` (2 partitions). `SELECT DISTINCT(sexe)` : F, M.

## Partie 2 : buckets

Règle de Hive : bucket = (hash(colonne) & Integer.MAX_VALUE) % 4 ; hash d'un INT = sa valeur, hash d'une STRING = `String.hashCode()`. Fichiers nommés `000000_0` à `000003_0`. Calcul théorique, à vérifier avec `dfs -ls -R`.

### log_internautes_buckets (partitions par date, bucket sur id_internaute)

| Partition date_consultation | Lignes bucket 0 | bucket 1 | bucket 2 | bucket 3 | Total |
|---|---|---|---|---|---|
| 27-04-2016 | 1 | 4 | 0 | 0 | 5 |
| 28-04-2016 | 2 | 0 | 4 | 2 | 8 |
| 29-04-2016 | 1 | 1 | 0 | 2 | 4 |

Les partitions sont 3. Pour **27-04-2016**, les buckets 2 et 3 sont vides (fichiers présents mais de taille 0), ce qui confirme la remarque de l'énoncé. Chaque partition contient 4 fichiers. Les partitions 28-04-2016 (bucket 1 vide) et 29-04-2016 (bucket 2 vide) ont aussi un bucket vide.

### log_internautes_buckets2 (4 buckets sur pays, pas de partition)

| Bucket | Pays (lignes) | Total |
|---|---|---|
| 0 | AUSTRALIA (2) | 2 |
| 1 | (vide) | 0 |
| 2 | JAPAN (3), UK (2), US (4) | 9 |
| 3 | CHINA (2), INDIA (4) | 6 |

6 pays répartis sur 4 buckets : le bucket 1 est vide, le bucket 2 regroupe trois pays (US, UK, JAPAN), le bucket 3 deux (CHINA, INDIA).

## Partie 3 : les 10 questions

### Q1. Embauchés après 2019 (annee_embauche > 2019)

**7** (id_empl 5, 11, 14, 15, 16, 17, 18).

### Q2. Paires employé-secteur avec salaire > 35000

| id_empl | nom | prenom | secteur | salaire_num |
|---|---|---|---|---|
| 5 | VANDENDRIESSCHE | HENRI PIERRE | industrie | 45000 |
| 6 | WACCUS | GUILLAUME AUGUSTIN | profession juridique privé | 70000 |
| 7 | CHARPENTIER | PIERRE | sante | 45000 |
| 8 | DEKYDTSPOTTER | PAULETTE OCTAVIE | soin et education | 38000 |
| 9 | SOLEYMIEUX | FRANCINE JEANNE | industrie | 45000 |
| 11 | TERZIS | PASCAL PIERRE | sante | 55000 |
| 12 | HOUMADI OILI | FATIMA | arts et spectacle | 41000 |
| 13 | LALLEMANT | ETIENNE BERNARD PIERRE | transports aeriens | 144000 |
| 14 | PIGOT | ROSE | sante | 41000 |
| 15 | BAUDIES | ANNE | pharmaceutique | 75000 |
| 17 | LEICK | ELFRIEDE | expert comptable | 37000 |
| 18 | CHATELLENAZ | DOUGLAS LOUIS LEON | transport | 80000 |
| 20 | PECOURT | RENE EMILE VICTOR | fabrication et distribution des patisserie-viennoiserie | 65000 |
| 22 | HUSSON | SIMON GABRIEL CAMILLE | sante | 80000 |
| 23 | DEVEZE | JULE | agriculture | 57000 |
| 24 | DOUSSIERE | RAYMOND LEONCE URBAIN | commerce | 38000 |
| 25 | BASSET | GISELE LUCIE DENISE | transport et entroposage | 40000 |
| 26 | MATIAS DA SILVA | MARIA LISETE | pharmaceutique | 42000 |
| 28 | SIMOES | CLAUDIA CRISTI CRISTINA | education | 45000 |
| 29 | GALLARD | BERTRAND HENRI MARIE JOSEPH | transport | 90000 |
| 30 | LUYAT | PIERRE BRUNO | profession juridique privé | 200000 |
| 31 | PIGEON | JEAN-PIERRE | transports aeriens | 120000 |
| 32 | FOUHL | ARMAND ADRIEN | education | 55000 |
| 33 | RODRIGUES DE TAMPOS | ALVARO | budgetisation | 40000 |

24 lignes (35000 exactement exclu : id 2 et 27).

### Q3. Employés du secteur education recrutés après 2010

| id_empl | nom | prenom | annee_embauche | fonction |
|---|---|---|---|---|
| 19 | CANSALADE | CHARLOTTE HENRIETTE | 2018 | ressource humaine |

### Q4. Plus d'expérience (2026 - annee_embauche)

| id_empl | nom | prenom | annee_embauche | fonction | experience |
|---|---|---|---|---|---|
| 4 | TODORIS | VASSILIKI | 1970 | professeur | 56 |

Pas d'ex-aequo.

### Q5. Salaire moyen

**55696.97** euro/an (somme 1 838 000 sur 33 employés).

### Q6. Fonctions des femmes par année d'embauche (sexe = F)

| annee_embauche | fonctions (collect_set) |
|---|---|
| 1970 | professeur |
| 1977 | pericultrice |
| 1984 | transporteur |
| 1987 | infermiere, professeur, secretaire |
| 1990 | pediatre |
| 2010 | informaticienne |
| 2011 | chercheur en chimie |
| 2015 | aide-soignant |
| 2018 | musicienne, ressource humaine |
| 2020 | comptable, infermiere |
| 2021 | phamacienne |
| 2022 | technicien |

### Q7. <prénom, fonction> avec code postal 75xxx

| prenom | fonction | code_postal |
|---|---|---|
| PIERRE | veterinaire | 75780 |
| DOUGLAS LOUIS LEON | taxi | 75000 |

Le champ `prenom` contient en réalité tous les prénoms de l'état civil (ex. « DOUGLAS LOUIS LEON »). 75780 est retenu par le filtre 75xxx.

### Q8. Femmes / hommes

| sexe | nb | somme_salaires | somme_experience | ratio salaire/expérience | salaire_moyen |
|---|---|---|---|---|---|
| F | 16 | 644000 | 379 | 1699.21 | 40250.0 |
| M | 17 | 1194000 | 332 | 3596.39 | 70235.29 |

Le ratio des hommes (3596.39) est 2.12 fois celui des femmes (1699.21). Salaire moyen : hommes 70235, femmes 40250. Les hommes gagnent plus, et l'écart persiste (même s'accentue) en rapportant à l'expérience : les femmes cumulent 379 années d'expérience contre 332 pour les hommes. Échantillon de 33 personnes, pas de test statistique.

### Q9. corr(experience, salaire)

**0.0886**. Corrélation positive très faible : sur ces données, l'expérience n'explique quasiment pas le salaire.

### Q10. Salaire moyen par secteur

| secteur | nb | salaire_moyen | experience_moyenne |
|---|---|---|---|
| profession juridique privé | 2 | 135000.00 | 27.50 |
| transports aeriens | 2 | 132000.00 | 11.50 |
| transport | 2 | 85000.00 | 26.50 |
| fabrication et distribution des patisserie-viennoiserie | 1 | 65000.00 | 8.00 |
| pharmaceutique | 2 | 58500.00 | 10.00 |
| agriculture | 2 | 43500.00 | 27.00 |
| sante | 7 | 42571.43 | 19.14 |
| arts et spectacle | 1 | 41000.00 | 8.00 |
| transport et entroposage | 1 | 40000.00 | 42.00 |
| budgetisation | 1 | 40000.00 | 26.00 |
| education | 4 | 39500.00 | 33.25 |
| soin et education | 1 | 38000.00 | 49.00 |
| commerce | 1 | 38000.00 | 20.00 |
| expert comptable | 1 | 37000.00 | 6.00 |
| industrie | 4 | 35000.00 | 10.25 |
| fonction publique | 1 | 35000.00 | 39.00 |

Les moyennes par secteur vont de 35 000 à 135 000. Part de la variance du salaire expliquée par le secteur (eta², calcul Python, pas une requête du WS) : 0.71. Corrélation entre expérience moyenne et salaire moyen par secteur : -0.16. Conclusion : le secteur influence nettement le salaire (juridique, transports aériens, transport en tête), alors que l'expérience seule n'a pas d'effet net (Q9). Réserve : 9 secteurs sur 16 n'ont qu'un ou deux employés.

