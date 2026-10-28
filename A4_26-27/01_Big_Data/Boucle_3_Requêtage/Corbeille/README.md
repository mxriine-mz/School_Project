# Corbeille d'exercices MongoDB

Compte-rendu de la corbeille MongoDB de la Boucle 3 (Big Data) : installation, import de trois jeux de données dans la base `corbeille`, puis seize requêtes dans mongosh (serveur 8.3, mongosh 2.14.0, Database Tools 100.20.0).

| Fichier | Contenu |
| :--- | :--- |
| [`main.pdf`](./main.pdf) | Compte-rendu complet (étude des données, installation, import, Q1 à Q16, synthèse et écarts à l'énoncé) |
| `scripts/` | `import.ps1` (import PowerShell) et `requetes.js` (les 16 requêtes) |
| `resultats/` | Notes et sorties réelles (`import.txt`, `requetes.txt`, vérification Python) |
| `data/` | Les trois fichiers de données (restaurants, netflix, height) |

Compilation : `make` (nécessite `-shell-escape` pour minted, déjà configuré).

## Logos et captures

- `contents/img/logos/mongodb.svg` : logo MongoDB, Wikimedia Commons, <https://commons.wikimedia.org/wiki/File:MongoDB_Logo.svg> (fichier `https://upload.wikimedia.org/wikipedia/commons/9/93/MongoDB_Logo.svg`). `mongodb.png` en est la conversion (ImageMagick). Logo et marque appartiennent à MongoDB, Inc. ; usage illustratif dans ce rapport scolaire.
- `contents/img/captures/` : captures réelles d'une console PowerShell (recadrées sur la seule fenêtre), prises le 28 octobre 2026 en rejouant `import.ps1` et les requêtes Q1-Q2, Q7, Q10, Q12, Q15 et Q16 avec `mongosh` 2.14.0 sur le serveur 8.3.
