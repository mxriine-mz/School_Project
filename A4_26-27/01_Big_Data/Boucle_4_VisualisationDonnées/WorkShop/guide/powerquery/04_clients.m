// ATTENTION : code NON TESTE dans Power BI (ecrit sans acces a Power BI Desktop).
// Si une etape echoue, comparer avec ce que genere l interface et corriger le nom de l etape.
// Usage : Accueil > Obtenir les donnees > Requete vide > Editeur avance, coller le bloc.
// Chaque bloc "===== Requete : NOM =====" est une requete separee, a renommer NOM.
// A faire d abord : adapter la ligne Dossier (chemin Windows de ressources, avec le \ final).

// Section 3 : table clients de 02_02_rainforest_inc.xlsx.
// Attendu (attendus.md, section 3) : brut 203 lignes x 6 | sans lignes vides 202 | sans les 2 dernieres lignes 200.
// Variante "Supprimer les doublons" a la place des 2 dernieres lignes : 201 (la ligne de test 999 reste).

// ===== Requete : clients =====
let
    Dossier = "C:\Users\mazou\Documents\WorkShop\ressources\",
    Source = Excel.Workbook(File.Contents(Dossier & "02_02_rainforest_inc.xlsx"), null, true),
    clients_Sheet = Source{[Item="clients",Kind="Sheet"]}[Data],
    #"En-têtes promus" = Table.PromoteHeaders(clients_Sheet, [PromoteAllScalars=true]),
    #"Type modifié" = Table.TransformColumnTypes(#"En-têtes promus",{{"id", Int64.Type}, {"prenom", type text}, {"nom", type text}, {"code_pays", type text}, {"pays", type text}, {"ville", type text}}),
    // Reduire les lignes > Supprimer les lignes > Supprimer les lignes vides (202 lignes attendues)
    #"Lignes vides supprimées" = Table.SelectRows(#"Type modifié", each not List.IsEmpty(List.RemoveMatchingItems(Record.FieldValues(_), {"", null}))),
    // Reduire les lignes > Supprimer les lignes > Supprimer les dernieres lignes : 2 (doublon id 200 + test id 999)
    #"Dernières lignes supprimées" = Table.RemoveLastN(#"Lignes vides supprimées", 2)
    // Variante : #"Doublons supprimés" = Table.Distinct(#"Lignes vides supprimées")  // 201 lignes
in
    #"Dernières lignes supprimées"

// ===== Requete : clients_nom_complet (fusionner puis fractionner, page 21-22 de l'enonce) =====
// Attendu : fusion => 200 lignes x 5 colonnes (id, nom_complet, code_pays, pays, ville) avec
// la valeur "Oldridge Graeme" en 1re ligne (nom d'abord car selectionne en premier).
// Aucun nom ni prenom ne contient d'espace : le fractionnement redonne bien 2 colonnes.
// A partir de la requete clients ci-dessus (clic droit > Dupliquer ou Reference).
let
    Source = clients,
    // Selectionner nom puis prenom (Ctrl) > clic droit > Fusionner les colonnes, separateur Espace
    #"Colonnes fusionnées" = Table.CombineColumns(Source, {"nom", "prenom"}, Combiner.CombineTextByDelimiter(" ", QuoteStyle.None), "nom_complet"),
    // Transformer > Fractionner la colonne > Par le delimiteur (espace, chaque occurrence)
    #"Colonne fractionnée" = Table.SplitColumn(#"Colonnes fusionnées", "nom_complet", Splitter.SplitTextByDelimiter(" ", QuoteStyle.Csv), {"nom_complet.1", "nom_complet.2"})
in
    #"Colonne fractionnée"
