// ATTENTION : code NON TESTE dans Power BI (ecrit sans acces a Power BI Desktop).
// Si une etape echoue, comparer avec ce que genere l interface et corriger le nom de l etape.
// Usage : Accueil > Obtenir les donnees > Requete vide > Editeur avance, coller le bloc.
// Chaque bloc "===== Requete : NOM =====" est une requete separee, a renommer NOM.
// A faire d abord : adapter la ligne Dossier (chemin Windows de ressources, avec le \ final).

// Section 3 : Obtenir les donnees > Dossier > Combiner et transformer.
// Equivalent M sans les requetes auxiliaires (Parametre, Exemple de fichier, Transformer le fichier) :
// a la place, une seule requete. Attendu : 1000 lignes x 5 colonnes
// (Source.Name, id_client, id_produit, quantité, date) ; partiel_2018.xlsx 522 lignes, partiel_2019.xlsx 478.

// ===== Requete : 05_01_transactions_par_annee =====
let
    Dossier = "C:\Users\mazou\Documents\WorkShop\ressources\05_01_transactions_par_annee",
    Source = Folder.Files(Dossier),
    #"Seulement xlsx" = Table.SelectRows(Source, each [Extension] = ".xlsx"),
    // Chaque classeur a une feuille "transactions" avec les 4 memes colonnes.
    #"Données lues" = Table.AddColumn(#"Seulement xlsx", "Data", each Excel.Workbook([Content], true, true){[Item="transactions",Kind="Sheet"]}[Data]),
    #"Colonnes conservées" = Table.SelectColumns(#"Données lues", {"Name", "Data"}),
    #"Colonne renommée" = Table.RenameColumns(#"Colonnes conservées", {{"Name", "Source.Name"}}),
    #"Données développées" = Table.ExpandTableColumn(#"Colonne renommée", "Data", {"id_client", "id_produit", "quantité", "date"}),
    #"Type modifié" = Table.TransformColumnTypes(#"Données développées", {{"Source.Name", type text}, {"id_client", Int64.Type}, {"id_produit", Int64.Type}, {"quantité", Int64.Type}, {"date", type date}}, "fr-FR")
in
    #"Type modifié"
