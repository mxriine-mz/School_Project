# Import des 3 jeux de donnees dans la base "corbeille" (rejouable grace a --drop).
# Usage (PowerShell) : .\import.ps1
# Note : l'enonce ne cite que netflix et restaurants, mais les Q13 a Q16 portent sur les tailles :
# la collection "height" est donc importee aussi.

$ErrorActionPreference = "Stop"
$mongoimport = "C:\Users\mazou\mongodb-tools\database-tools\bin\mongoimport.exe"
$uri  = "mongodb://localhost:27017"
$data = Join-Path $PSScriptRoot "..\data"

# CSV : premiere ligne = noms de colonnes
& $mongoimport --uri $uri --db corbeille --collection netflix --drop --type csv --headerline --file (Join-Path $data "netflix_dataset.csv")
& $mongoimport --uri $uri --db corbeille --collection height  --drop --type csv --headerline --file (Join-Path $data "heightbycountry_dataset.csv")

# JSON : un document par ligne (pas de --jsonArray)
& $mongoimport --uri $uri --db corbeille --collection restaurants --drop --file (Join-Path $data "restaurants.json")
