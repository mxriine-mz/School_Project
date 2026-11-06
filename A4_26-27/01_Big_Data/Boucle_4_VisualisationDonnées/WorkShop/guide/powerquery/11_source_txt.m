// ATTENTION : code NON TESTE dans Power BI (ecrit sans acces a Power BI Desktop).
// Si une etape echoue, comparer avec ce que genere l interface et corriger le nom de l etape.
// Usage : Accueil > Obtenir les donnees > Requete vide > Editeur avance, coller le bloc.
// Chaque bloc "===== Requete : NOM =====" est une requete separee, a renommer NOM.
// A faire d abord : adapter la ligne Dossier (chemin Windows de ressources, avec le \ final).

// Section "A partir d'un fichier texte" : source.txt (encodage Windows 1252, fins de ligne CRLF).
// Le fichier contient 3 lignes par enregistrement : pays, cas, deces. L'enonce utilise "Extraire une table
// avec des exemples" ; l'equivalent M ci-dessous regroupe les lignes 3 par 3.
// Attendu : 83 lignes x 3 colonnes ; 1re ligne Mainland China / 80270 / 2981 ; somme cas 94974 ; somme deces 3254.

// ===== Requete : source =====
let
    Dossier = "C:\Users\mazou\Documents\WorkShop\ressources\",
    Lignes = Lines.FromBinary(File.Contents(Dossier & "source.txt"), null, null, 1252),
    NbEnregistrements = Number.IntegerDivide(List.Count(Lignes), 3),
    Lignes3 = List.Transform({0..NbEnregistrements - 1}, each {Lignes{_ * 3}, Number.FromText(Lignes{_ * 3 + 1}, "en-US"), Number.FromText(Lignes{_ * 3 + 2}, "en-US")}),
    Source = Table.FromRows(Lignes3, type table [pays = text, cas = Int64.Type, deces = Int64.Type])
in
    Source
