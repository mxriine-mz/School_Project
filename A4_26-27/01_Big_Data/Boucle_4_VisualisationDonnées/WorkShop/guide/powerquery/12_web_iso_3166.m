// ATTENTION : code NON TESTE dans Power BI (ecrit sans acces a Power BI Desktop).
// Si une etape echoue, comparer avec ce que genere l interface et corriger le nom de l etape.
// Usage : Accueil > Obtenir les donnees > Requete vide > Editeur avance, coller le bloc.
// Chaque bloc "===== Requete : NOM =====" est une requete separee, a renommer NOM.
// A faire d abord : adapter la ligne Dossier (chemin Windows de ressources, avec le \ final).

// Section "A partir d'un URL (web)" : https://fr.wikipedia.org/wiki/ISO_3166-1, premier tableau.
// Page vivante : le contenu peut changer. Releve le 2026-11-04 en lisant le HTML : 249 lignes de donnees,
// 8 colonnes pour le 1er tableau. Le resultat exact dans Power BI est a relever a l'ecran.
// Requiert un acces Internet depuis Power BI Desktop.

// ===== Requete : ISO 3166-1 =====
let
    Source = Web.Page(Web.Contents("https://fr.wikipedia.org/wiki/ISO_3166-1")),
    // Source liste les tables detectees (Data0, Data1, ...). Le premier tableau = ligne 0.
    Data0 = Source{0}[Data]
in
    Data0
