# CER Boucle 4 : Visualisation des données (prosit « Raconte moi une histoire »)

Compilation : `make` (latexmk, `-shell-escape` pour minted), nettoyage : `make clean`.

## Images

- `contents/img/powerbi_logo.png` : logo Power BI.
  - Source : Wikimedia Commons, fichier `New_Power_BI_Logo.svg`
    (https://commons.wikimedia.org/wiki/File:New_Power_BI_Logo.svg), indiqué « Public domain »
    sur Commons, avec la mention « trademarked » (marque de Microsoft).
  - Le PNG est la miniature de 500 px générée par Wikimedia Commons à partir du SVG, recadrée avec
    `convert -trim`. La conversion directe du SVG avec `convert` donnait un rendu faux (dégradés et
    filtres non gérés), d'où cette miniature.
- Les schémas (cube OLAP, structure du récit, chaîne Hive vers Power BI, lecture en Z, maquette du tableau
  de bord) sont dessinés en TikZ dans `contents/researches.tex`. Aucune capture d'écran n'est incluse.
