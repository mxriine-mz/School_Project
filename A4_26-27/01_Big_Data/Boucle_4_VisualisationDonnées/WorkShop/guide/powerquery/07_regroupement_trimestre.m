// ATTENTION : code NON TESTE dans Power BI (ecrit sans acces a Power BI Desktop).
// Si une etape echoue, comparer avec ce que genere l interface et corriger le nom de l etape.
// Usage : Accueil > Obtenir les donnees > Requete vide > Editeur avance, coller le bloc.
// Chaque bloc "===== Requete : NOM =====" est une requete separee, a renommer NOM.
// A faire d abord : adapter la ligne Dossier (chemin Windows de ressources, avec le \ final).

// Section 3 : regrouper par trimestre, somme de quantite (sur une COPIE de transactions_2018).
// Attendu : 4 lignes x 2 colonnes : TRIM1 394 | TRIM2 365 | TRIM3 425 | TRIM4 352 (total 1536).
// Dans l'interface : clic droit sur transactions_2018 > Dupliquer (ou Reference), puis Transformer > Regrouper par.

// ===== Requete : quantite_par_trimestre_2018 =====
let
    // Requete transactions_2018 de 06_transactions_2018_trimestre.m
    Source = transactions_2018,
    #"Lignes groupées" = Table.Group(Source, {"Trimestre"}, {{"Quantité par trimestre", each List.Sum([quantité]), type nullable number}})
in
    #"Lignes groupées"
