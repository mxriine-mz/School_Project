// ATTENTION : code NON TESTE dans Power BI (ecrit sans acces a Power BI Desktop).
// Si une etape echoue, comparer avec ce que genere l interface et corriger le nom de l etape.
// Usage : Accueil > Obtenir les donnees > Requete vide > Editeur avance, coller le bloc.
// Chaque bloc "===== Requete : NOM =====" est une requete separee, a renommer NOM.
// A faire d abord : adapter la ligne Dossier (chemin Windows de ressources, avec le \ final).

// Section 3 : trimestre dans transactions_2018 (dupliquer date, trimestre de l'annee, prefixe TRIM).
// Attendu : 522 lignes x 5 colonnes (id_client, id_produit, quantité, date, Trimestre) ; valeurs TRIM1 a TRIM4.
// Cette requete REMPLACE la version brute de transactions_2018 (ou en est une copie : "Reference" ou "Dupliquer").

// ===== Requete : transactions_2018 =====
let
    Dossier = "C:\Users\mazou\Documents\WorkShop\ressources\",
    Source = Excel.Workbook(File.Contents(Dossier & "02_02_rainforest_inc.xlsx"), null, true),
    transactions_2018_Sheet = Source{[Item="transactions_2018",Kind="Sheet"]}[Data],
    #"En-têtes promus" = Table.PromoteHeaders(transactions_2018_Sheet, [PromoteAllScalars=true]),
    #"Type modifié" = Table.TransformColumnTypes(#"En-têtes promus",{{"id_client", Int64.Type}, {"id_produit", Int64.Type}, {"quantité", Int64.Type}, {"date", type date}}, "fr-FR"),
    // Ajouter une colonne > Dupliquer la colonne, renommee Trimestre
    #"Colonne dupliquée" = Table.DuplicateColumn(#"Type modifié", "date", "Trimestre"),
    // Transformer > Date > Trimestre > Trimestre de l'annee (resultat 1 a 4)
    #"Trimestre extrait" = Table.TransformColumns(#"Colonne dupliquée", {{"Trimestre", Date.QuarterOfYear, Int64.Type}}),
    // Transformer > Format > Ajouter un prefixe : TRIM
    #"Préfixe ajouté" = Table.TransformColumns(#"Trimestre extrait", {{"Trimestre", each "TRIM" & Text.From(_), type text}})
in
    #"Préfixe ajouté"
