// ATTENTION : code NON TESTE dans Power BI (ecrit sans acces a Power BI Desktop).
// Si une etape echoue, comparer avec ce que genere l interface et corriger le nom de l etape.
// Usage : Accueil > Obtenir les donnees > Requete vide > Editeur avance, coller le bloc.
// Chaque bloc "===== Requete : NOM =====" est une requete separee, a renommer NOM.
// A faire d abord : adapter la ligne Dossier (chemin Windows de ressources, avec le \ final).

// Section 3 (TCD) : 02_03_rainforest_inc_TCD.xlsx, feuille TCD_activité, aplatie.
// Chaque etape correspond a un clic de l'enonce. Lignes x colonnes attendues (attendus.md, section 5) :
//   brut 45 x 197 | sans 1re ligne 44 | sans derniere ligne 43 | transpose 197 x 43
//   apres filtre "tot" 180 x 43 | apres en-tetes 179 x 43 | apres depivotage 454 lignes x 4 colonnes
// Controle : somme de Valeur = 1420.

// ===== Requete : TCD activité =====
let
    Dossier = "C:\Users\mazou\Documents\WorkShop\ressources\",
    // useHeaders = null : les colonnes s'appellent Column1, Column2, ... (comme dans l'enonce).
    Source = Excel.Workbook(File.Contents(Dossier & "02_03_rainforest_inc_TCD.xlsx"), null, true),
    TCD_activité_Sheet = Source{[Item="TCD_activité",Kind="Sheet"]}[Data],
    // Accueil > Reduire les lignes > Supprimer les lignes > Supprimer les premieres lignes : 1
    #"Premières lignes supprimées" = Table.Skip(TCD_activité_Sheet, 1),
    // Idem pour les dernieres lignes : 1 (la ligne "Total general")
    #"Dernières lignes supprimées" = Table.RemoveLastN(#"Premières lignes supprimées", 1),
    // Transformer > Transposer
    #"Table transposée" = Table.Transpose(#"Dernières lignes supprimées"),
    // Colonne 1 (pays) : Transformer > Renseigner > Vers le bas
    #"Rempli vers le bas" = Table.FillDown(#"Table transposée", {"Column1"}),
    // Filtre texte sur la colonne 1 : on enleve les valeurs contenant "tot" (Total Canada, ..., Total general).
    // On garde la ligne d'en-tetes, dont Column1 est null.
    #"Lignes filtrées" = Table.SelectRows(#"Rempli vers le bas", each [Column1] = null or not Text.Contains([Column1], "tot", Comparer.OrdinalIgnoreCase)),
    // Accueil > Utiliser la premiere ligne comme en-tetes
    #"En-têtes promus" = Table.PromoteHeaders(#"Lignes filtrées", [PromoteAllScalars=true]),
    // Selection des 2 premieres colonnes > Transformer > Depivoter les autres colonnes
    #"Autres colonnes dépivotées" = Table.UnpivotOtherColumns(#"En-têtes promus", {"Column1", "Étiquettes de lignes"}, "Attribut", "Valeur"),
    #"Type modifié" = Table.TransformColumnTypes(#"Autres colonnes dépivotées",{{"Column1", type text}, {"Étiquettes de lignes", type text}, {"Attribut", type text}, {"Valeur", Int64.Type}})
in
    #"Type modifié"
