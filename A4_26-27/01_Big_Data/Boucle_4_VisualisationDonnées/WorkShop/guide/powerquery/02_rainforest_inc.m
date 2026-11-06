// ATTENTION : code NON TESTE dans Power BI (ecrit sans acces a Power BI Desktop).
// Si une etape echoue, comparer avec ce que genere l interface et corriger le nom de l etape.
// Usage : Accueil > Obtenir les donnees > Requete vide > Editeur avance, coller le bloc.
// Chaque bloc "===== Requete : NOM =====" est une requete separee, a renommer NOM.
// A faire d abord : adapter la ligne Dossier (chemin Windows de ressources, avec le \ final).

// Section 3 : 02_02_rainforest_inc.xlsx (5 feuilles). Chargement "brut" avec en-tetes promus et types.
// Resultat attendu (attendus.md, section 3) : transactions_2018 522 x 4 ; transactions_2019 478 x 4 ;
// clients 203 x 6 (1 ligne vide) ; fournisseurs 20 x 2 ; produits : voir 05_produits.m (feuille a part).
// Les requetes clients, produits et transactions_2018 sont completees dans les fichiers 04, 05 et 06.

// ===== Requete : transactions_2018 (version brute, sans Trimestre) =====
let
    Dossier = "C:\Users\mazou\Documents\WorkShop\ressources\",
    Source = Excel.Workbook(File.Contents(Dossier & "02_02_rainforest_inc.xlsx"), null, true),
    transactions_2018_Sheet = Source{[Item="transactions_2018",Kind="Sheet"]}[Data],
    #"En-têtes promus" = Table.PromoteHeaders(transactions_2018_Sheet, [PromoteAllScalars=true]),
    #"Type modifié" = Table.TransformColumnTypes(#"En-têtes promus",{{"id_client", Int64.Type}, {"id_produit", Int64.Type}, {"quantité", Int64.Type}, {"date", type date}}, "fr-FR")
in
    #"Type modifié"

// ===== Requete : transactions_2019 =====
let
    Dossier = "C:\Users\mazou\Documents\WorkShop\ressources\",
    Source = Excel.Workbook(File.Contents(Dossier & "02_02_rainforest_inc.xlsx"), null, true),
    transactions_2019_Sheet = Source{[Item="transactions_2019",Kind="Sheet"]}[Data],
    #"En-têtes promus" = Table.PromoteHeaders(transactions_2019_Sheet, [PromoteAllScalars=true]),
    #"Type modifié" = Table.TransformColumnTypes(#"En-têtes promus",{{"id_client", Int64.Type}, {"id_produit", Int64.Type}, {"quantité", Int64.Type}, {"date", type date}}, "fr-FR")
in
    #"Type modifié"

// ===== Requete : fournisseurs =====
let
    Dossier = "C:\Users\mazou\Documents\WorkShop\ressources\",
    Source = Excel.Workbook(File.Contents(Dossier & "02_02_rainforest_inc.xlsx"), null, true),
    fournisseurs_Sheet = Source{[Item="fournisseurs",Kind="Sheet"]}[Data],
    #"En-têtes promus" = Table.PromoteHeaders(fournisseurs_Sheet, [PromoteAllScalars=true]),
    #"Type modifié" = Table.TransformColumnTypes(#"En-têtes promus",{{"id_fournisseur", Int64.Type}, {"nom_fournisseur", type text}})
in
    #"Type modifié"
