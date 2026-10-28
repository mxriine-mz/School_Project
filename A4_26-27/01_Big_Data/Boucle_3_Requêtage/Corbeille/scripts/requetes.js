// Corbeille MongoDB - les 16 requetes
// Execution : mongosh corbeille --quiet --file requetes.js
// (base "corbeille" ; collections netflix, restaurants, height)

function titre(n, texte) { print("\n=== Q" + n + " : " + texte + " ==="); }

// Q1 : liste des collections de la base corbeille
titre(1, "collections de la base");
printjson(db.getCollectionNames());

// Q2 : nombre de documents des collections netflix et restaurants
titre(2, "nombre de documents");
print("netflix     : " + db.netflix.countDocuments({}));
print("restaurants : " + db.restaurants.countDocuments({}));

// Q3 : un document de chaque collection et la liste de leurs champs
titre(3, "un document par collection + champs");
const docNetflix = db.netflix.findOne();
printjson(docNetflix);
print("Champs netflix : " + Object.keys(docNetflix).join(", "));
const docResto = db.restaurants.findOne();
printjson(docResto);
print("Champs restaurants : " + Object.keys(docResto).join(", "));

// Verification du type de release_year (numerique apres import ?)
print("\n[info] type de release_year : " + db.netflix.aggregate([
  { $group: { _id: { $type: "$release_year" }, n: { $sum: 1 } } }
]).toArray().map(x => x._id + "=" + x.n).join(", "));

// Q4 : films (type Movie) sortis en 2016
titre(4, "films sortis en 2016");
print("Movie, release_year 2016        : " + db.netflix.countDocuments({ type: "Movie", release_year: 2016 }));
print("[info] tous types, release_year 2016 : " + db.netflix.countDocuments({ release_year: 2016 }));

// Q5 : documents de type "films"
titre(5, "nombre de films (type Movie)");
print(db.netflix.countDocuments({ type: "Movie" }));

// Q6 : documents de type "series TV"
titre(6, "nombre de series TV (type TV Show)");
print(db.netflix.countDocuments({ type: "TV Show" }));

// Q7 : films francais de 90 min (country peut contenir plusieurs pays separes par ", ")
titre(7, "films francais de 90 min");
print("Movie, country contient France, duration '90 min' : " +
  db.netflix.countDocuments({ type: "Movie", country: /France/, duration: "90 min" }));
print("[variante] country exactement 'France'            : " +
  db.netflix.countDocuments({ type: "Movie", country: "France", duration: "90 min" }));

// Q8 : films americains sortis depuis 2020
titre(8, "films americains sortis depuis 2020");
print("Movie, country contient United States, release_year >= 2020 : " +
  db.netflix.countDocuments({ type: "Movie", country: /United States/, release_year: { $gte: 2020 } }));

// Q9 : liste des types de cuisine
titre(9, "liste des cuisines");
const cuisines = db.restaurants.distinct("cuisine");
printjson(cuisines);
print("Nombre de cuisines distinctes : " + cuisines.length);

// Q10 : restaurants dans le Queens
titre(10, "restaurants dans le Queens");
print(db.restaurants.countDocuments({ borough: "Queens" }));

// Q11 : liste des quartiers (borough)
titre(11, "liste des quartiers");
const boroughs = db.restaurants.distinct("borough");
printjson(boroughs);
print("Nombre de quartiers distincts : " + boroughs.length);

// Q12 : nombre de pays distincts ayant au moins un film
// (country decoupe sur "," puis trim ; vides/null exclus)
titre(12, "nombre de pays avec au moins un film");
function nbPays(filtre) {
  const r = db.netflix.aggregate([
    { $match: filtre },
    { $match: { country: { $type: "string" } } },
    { $project: { pays: { $split: ["$country", ","] } } },
    { $unwind: "$pays" },
    { $project: { pays: { $trim: { input: "$pays" } } } },
    { $match: { pays: { $ne: "" } } },
    { $group: { _id: "$pays" } },
    { $count: "n" }
  ]).toArray();
  return r.length ? r[0].n : 0;
}
print("Movie (reponse)             : " + nbPays({ type: "Movie" }));
print("[variante] tous types       : " + nbPays({}));

// Q13 : taille moyenne des hommes (cm), tous pays confondus
titre(13, "taille moyenne des hommes (cm)");
const moyH = db.height.aggregate([{ $group: { _id: null, m: { $avg: "$Male Height in Cm" } } }]).toArray()[0].m;
print(Math.round(moyH * 100) / 100 + " cm (brut : " + moyH + ")");

// Q14 : taille moyenne des femmes (cm), tous pays confondus
titre(14, "taille moyenne des femmes (cm)");
const moyF = db.height.aggregate([{ $group: { _id: null, m: { $avg: "$Female Height in Cm" } } }]).toArray()[0].m;
print(Math.round(moyF * 100) / 100 + " cm (brut : " + moyF + ")");

// Q15 : pays aux hommes les plus petits
titre(15, "pays aux hommes les plus petits");
printjson(db.height.find({}, { _id: 0, "Country Name": 1, "Male Height in Cm": 1 })
  .sort({ "Male Height in Cm": 1 }).limit(3).toArray());
print("(le premier element est la reponse ; les suivants sont donnes pour verifier l'absence d'ex aequo)");

// Q16 : pays aux femmes les plus grandes
titre(16, "pays aux femmes les plus grandes");
printjson(db.height.find({}, { _id: 0, "Country Name": 1, "Female Height in Cm": 1 })
  .sort({ "Female Height in Cm": -1 }).limit(3).toArray());
print("(le premier element est la reponse ; les suivants sont donnes pour verifier l'absence d'ex aequo)");
