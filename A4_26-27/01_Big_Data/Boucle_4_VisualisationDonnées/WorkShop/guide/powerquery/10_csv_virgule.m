// ATTENTION : code NON TESTE dans Power BI (ecrit sans acces a Power BI Desktop).
// Si une etape echoue, comparer avec ce que genere l interface et corriger le nom de l etape.
// Usage : Accueil > Obtenir les donnees > Requete vide > Editeur avance, coller le bloc.
// Chaque bloc "===== Requete : NOM =====" est une requete separee, a renommer NOM.
// A faire d abord : adapter la ligne Dossier (chemin Windows de ressources, avec le \ final).

// Section "Importation d'un fichier .csv avec le separateur virgule" : 05_02_client_csv_comma.csv.
// Attendu : 100 lignes x 6 colonnes (id, first_name, last_name, email, gender, ip_address). UTF-8.

// ===== Requete : 05_02_client_csv_comma =====
let
    Dossier = "C:\Users\mazou\Documents\WorkShop\ressources\",
    Source = Csv.Document(File.Contents(Dossier & "05_02_client_csv_comma.csv"), [Delimiter=",", Columns=6, Encoding=65001, QuoteStyle=QuoteStyle.Csv]),
    #"En-têtes promus" = Table.PromoteHeaders(Source, [PromoteAllScalars=true]),
    #"Type modifié" = Table.TransformColumnTypes(#"En-têtes promus",{{"id", Int64.Type}, {"first_name", type text}, {"last_name", type text}, {"email", type text}, {"gender", type text}, {"ip_address", type text}})
in
    #"Type modifié"
