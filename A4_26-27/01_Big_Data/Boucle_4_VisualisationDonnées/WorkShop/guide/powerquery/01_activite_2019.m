// ATTENTION : code NON TESTE dans Power BI (ecrit sans acces a Power BI Desktop).
// Si une etape echoue, comparer avec ce que genere l interface et corriger le nom de l etape.
// Usage : Accueil > Obtenir les donnees > Requete vide > Editeur avance, coller le bloc.
// Chaque bloc "===== Requete : NOM =====" est une requete separee, a renommer NOM.
// A faire d abord : adapter la ligne Dossier (chemin Windows de ressources, avec le \ final).

// Section 2 de l'enonce : Excel 02_01_rainforest_global_2019.xlsx, feuille activité_2019.
// Resultat attendu (resultats/attendus.md, section 2) : 478 lignes, 13 colonnes apres suppression
// de id_produit et id_fournisseur (15 colonnes avant). Quantite totale 1420.

// ===== Requete : activité_2019 =====
let
    Dossier = "C:\Users\mazou\Documents\WorkShop\ressources\",
    Source = Excel.Workbook(File.Contents(Dossier & "02_01_rainforest_global_2019.xlsx"), null, true),
    activité_2019_Sheet = Source{[Item="activité_2019",Kind="Sheet"]}[Data],
    #"En-têtes promus" = Table.PromoteHeaders(activité_2019_Sheet, [PromoteAllScalars=true]),
    // Dates au format jj/mm/aaaa (texte dans le classeur) : culture fr-FR obligatoire.
    #"Type modifié" = Table.TransformColumnTypes(#"En-têtes promus",{{"id_client", type text}, {"prenom", type text}, {"nom", type text}, {"code_pays", type text}, {"pays", type text}, {"ville", type text}, {"id_produit", Int64.Type}, {"nom_produit", type text}, {"famille_produit", type text}, {"couleur", type text}, {"prix_unitaire", Int64.Type}, {"id_fournisseur", Int64.Type}, {"nom_fournisseur", type text}, {"quantité", Int64.Type}, {"date", type date}}, "fr-FR"),
    // Meme choix que 02_01.pbix : on retire les colonnes inutiles (clic droit > Supprimer).
    #"Colonnes supprimées" = Table.RemoveColumns(#"Type modifié",{"id_produit", "id_fournisseur"})
in
    #"Colonnes supprimées"
