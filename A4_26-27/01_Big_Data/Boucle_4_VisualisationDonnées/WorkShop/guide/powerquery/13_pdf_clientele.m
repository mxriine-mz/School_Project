// ATTENTION : code NON TESTE dans Power BI (ecrit sans acces a Power BI Desktop).
// Si une etape echoue, comparer avec ce que genere l interface et corriger le nom de l etape.
// Usage : Accueil > Obtenir les donnees > Requete vide > Editeur avance, coller le bloc.
// Chaque bloc "===== Requete : NOM =====" est une requete separee, a renommer NOM.
// A faire d abord : adapter la ligne Dossier (chemin Windows de ressources, avec le \ final).

// Section "A partir d'un fichier PDF" : Fichier clientele.pdf (2 pages, texte parasite + 3 tableaux).
// Le navigateur propose : Table001 (page 1), Table002 (page 2), Table003 (page 2), Page001, Page002.
// Attendu d'apres le texte du PDF : Table001 = 12 lignes (France) x 5 colonnes
// (Pays, Ville, Latitude, Longitude, Base_clientele). Table002 = 5 lignes, Table003 = 8 lignes (a verifier a l'ecran).

// ===== Requete : Table001 (France) =====
let
    Dossier = "C:\Users\mazou\Documents\WorkShop\ressources\",
    Source = Pdf.Tables(File.Contents(Dossier & "Fichier clientele.pdf"), [Implementation="1.3"]),
    Table001_Table = Source{[Id="Table001"]}[Data],
    #"En-têtes promus" = Table.PromoteHeaders(Table001_Table, [PromoteAllScalars=true])
in
    #"En-têtes promus"

// ===== Requete : clientele_toutes_tables (optionnel : Table001 + Table002 + Table003 empilees) =====
let
    Dossier = "C:\Users\mazou\Documents\WorkShop\ressources\",
    Source = Pdf.Tables(File.Contents(Dossier & "Fichier clientele.pdf"), [Implementation="1.3"]),
    Tables = Table.SelectRows(Source, each [Kind] = "Table"),
    // Chaque tableau garde sa propre ligne d'en-tetes : on promeut puis on empile.
    Promues = List.Transform(Tables[Data], each Table.PromoteHeaders(_, [PromoteAllScalars=true])),
    Empilees = Table.Combine(Promues)
    // Si les 3 tableaux ont les memes en-tetes : 12 + 5 + 8 = 25 lignes attendues (a verifier a l'ecran).
in
    Empilees
