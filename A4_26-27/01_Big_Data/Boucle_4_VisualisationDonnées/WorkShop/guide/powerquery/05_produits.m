// ATTENTION : code NON TESTE dans Power BI (ecrit sans acces a Power BI Desktop).
// Si une etape echoue, comparer avec ce que genere l interface et corriger le nom de l etape.
// Usage : Accueil > Obtenir les donnees > Requete vide > Editeur avance, coller le bloc.
// Chaque bloc "===== Requete : NOM =====" est une requete separee, a renommer NOM.
// A faire d abord : adapter la ligne Dossier (chemin Windows de ressources, avec le \ final).

// Section 3 : table produits (majuscules, colonne a partir d'exemples, fusion avec fournisseurs).
// Attendu (attendus.md, section 3) : 70 lignes x 6 colonnes apres en-tetes ; 19 couleurs distinctes ;
// colonne exemple => 7 colonnes ; apres fusion => 8 colonnes, toujours 70 lignes, 0 fournisseur manquant.
// La requete "fournisseurs" doit exister (voir 02_rainforest_inc.m).

// ===== Requete : produits =====
let
    Dossier = "C:\Users\mazou\Documents\WorkShop\ressources\",
    Source = Excel.Workbook(File.Contents(Dossier & "02_02_rainforest_inc.xlsx"), null, true),
    produits_Sheet = Source{[Item="produits",Kind="Sheet"]}[Data],
    // La feuille commence par un titre ("Catalogue 2018-2019") et une ligne vide : on saute jusqu'a la ligne "id".
    Position = List.PositionOf(Table.Column(produits_Sheet, "Column1"), "id"),
    #"Lignes du haut supprimées" = Table.Skip(produits_Sheet, Position),
    #"En-têtes promus" = Table.PromoteHeaders(#"Lignes du haut supprimées", [PromoteAllScalars=true]),
    #"Type modifié" = Table.TransformColumnTypes(#"En-têtes promus",{{"id", Int64.Type}, {"nom_produit", type text}, {"famille_produit", type text}, {"couleur", type text}, {"prix_unitaire", Int64.Type}, {"id_fournisseur", Int64.Type}}),
    // Transformer > Format > Mettre en majuscule chaque mot (Text.Proper).
    // Text.Trim est AJOUTE (hors enonce) : 8 couleurs "Green" ont des espaces devant.
    #"Couleur en majuscules" = Table.TransformColumns(#"Type modifié", {{"couleur", each Text.Proper(Text.Trim(_)), type text}}),
    // Ajouter une colonne > Colonne a partir d'exemples : "Wheat Sedge (Blue)". Equivalent M :
    #"Colonne ajoutée" = Table.AddColumn(#"Couleur en majuscules", "Produit (couleur)", each Text.Combine({[nom_produit], " (", [couleur], ")"}), type text),
    // Accueil > Fusionner les requetes : jointure gauche id_fournisseur = id_fournisseur
    #"Requêtes fusionnées" = Table.NestedJoin(#"Colonne ajoutée", {"id_fournisseur"}, fournisseurs, {"id_fournisseur"}, "fournisseurs", JoinKind.LeftOuter),
    // Developper la colonne : uniquement nom_fournisseur, sans prefixe
    #"Fournisseurs développé" = Table.ExpandTableColumn(#"Requêtes fusionnées", "fournisseurs", {"nom_fournisseur"}, {"nom_fournisseur"})
in
    #"Fournisseurs développé"
