// ATTENTION : code NON TESTE dans Power BI (ecrit sans acces a Power BI Desktop).
// Si une etape echoue, comparer avec ce que genere l interface et corriger le nom de l etape.
// Usage : Accueil > Obtenir les donnees > Requete vide > Editeur avance, coller le bloc.
// Chaque bloc "===== Requete : NOM =====" est une requete separee, a renommer NOM.
// A faire d abord : adapter la ligne Dossier (chemin Windows de ressources, avec le \ final).

// Section 3 : Accueil > Combiner > Ajouter des requetes (transactions_2018 + transactions_2019).
// Attendu : 1000 lignes (522 + 478). 5 colonnes si transactions_2018 contient deja Trimestre
// (478 valeurs null pour 2019), 4 colonnes avec les versions brutes. Quantite totale 2956.
// Dans l'interface, choisir "Ajouter les requetes en tant que nouvelles" pour garder les deux tables d'origine.

// ===== Requete : transactions_2018_2019 =====
let
    Source = Table.Combine({transactions_2018, transactions_2019})
    // Pour obtenir 4 colonnes meme si Trimestre existe : Table.SelectColumns(Source, {"id_client", "id_produit", "quantité", "date"})
in
    Source
