# Notes - Corbeille MongoDB

Execution reelle le 2026-10-28 : mongosh 2.14.0, Database Tools 100.20.0 (C:\Users\mazou\mongodb-tools\), serveur 8.3 (localhost:27017).
Sorties brutes : sorties/import.txt, sorties/requetes.txt. Reference Python : sorties/verif_python.txt.

## Import
netflix 8807, restaurants 25357, height 199 documents, 0 echec. height est importee en plus (l'enonce ne cite que netflix et restaurants) car Q13-Q16 en ont besoin.

## Reponses (MongoDB = Python pour toutes les requetes verifiees, aucun ecart, aucune correction)
| Q | Reponse |
|---|---|
| 1 | restaurants, netflix, height |
| 2 | netflix 8807 ; restaurants 25357 |
| 3 | champs netflix : show_id, type, title, director, cast, country, date_added, release_year, rating, duration, listed_in, description ; restaurants : address, borough, cuisine, grades, name, restaurant_id (+ _id) |
| 4 | 658 films (Movie) en 2016 ; info tous types : 902 |
| 5 | 6131 |
| 6 | 2676 |
| 7 | 6 (country contient France) ; variante country exactement "France" : 0 |
| 8 | 265 |
| 9 | 85 cuisines distinctes |
| 10 | 5656 |
| 11 | 6 : Bronx, Brooklyn, Manhattan, Missing, Queens, Staten Island |
| 12 | 117 pays (films) ; variante tous types : 122 |
| 13 | 173.09 cm |
| 14 | 160.94 cm |
| 15 | Timor-Leste, 160.13 cm (pas d'ex aequo) |
| 16 | Netherlands, 170.36 cm (pas d'ex aequo) |

## Interpretations
- type = "Movie" / "TV Show" ; « films » = Movie (Q4, Q7, Q8).
- country multi-valeur ("France, Belgium") : Q7 et Q8 par regex /France/ et /United States/ ; Q12 apres $split, $trim, $unwind, vides exclus.
- release_year est bien numerique apres import (int : 8807/8807) ; tailles numeriques (la moyenne fonctionne).
- Q13-Q14 : moyenne simple sur les 199 pays (non ponderee par la population), arrondie a 2 decimales.

## Pieges
- borough "Missing" existe : ce n'est pas un vrai quartier (Q11 : 6 valeurs dont 5 vrais quartiers).
- cuisine : "American " avec espace final, et deux variantes de « Cafe/Coffee/Tea » (une mal encodee "CafÃ©", donnee source), donc 85 valeurs brutes.
- Q7 : le filtre exact "France" donne 0 car les films francais de 90 min ont plusieurs pays.
- Champs vides des CSV (director, cast, country...) importes comme chaines "" et non absents.
- findOne() sur netflix renvoie s2 (une serie), pas s1 : l'ordre naturel n'est pas garanti.
- Les noms height ont des espaces ("Male Height in Cm") : "$Male Height in Cm" fonctionne dans $avg.
