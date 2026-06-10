# Application CRUD Full-Stack — Fruits (MERN)

Réalisée en suivant les trois tutoriels vidéo :

1. **API REST CRUD** avec Node.js + Express + MongoDB
2. **Refactor MVC + déploiement** de l'API
3. **Front-end React** connecté à l'API Node.js (tableau + popups)

Stack : **MongoDB · Express · React · Node.js** + **Tailwind CSS** + **Axios**.

```
Entrainement/
├── backend/     API REST Node/Express/MongoDB (architecture MVC)
└── frontend/    Application React (Vite + Tailwind + Axios)
```

L'interface affiche les fruits dans un **tableau** (Nom · Prix · Quantité · Image · Actions)
et utilise de **vrais popups** : modal d'ajout/édition, confirmation de suppression,
et toast de succès.

---

## 1. Pré-requis

- **Node.js** ≥ 18 (testé sur Node 24)
- **MongoDB** accessible (voir la section *Connexion MongoDB* plus bas)

---

## 2. Backend — `backend/`

### Architecture (MVC)

```
backend/src/
├── server.js                  Point d'entrée : connexion DB + démarrage HTTP
├── app.js                     Assemblage Express (middlewares + routes)
├── config/db.js               Connexion Mongoose
├── models/fruit.model.js      M — schéma Fruit + validation
├── controllers/fruit.controller.js   C — logique CRUD
├── routes/fruit.routes.js     Routage des URLs vers le contrôleur
├── middlewares/errorHandler.js Gestion centralisée des erreurs (404 / 500 / validation)
├── seed.js                    Jeu de données de démonstration (fruits)
└── dev-db.js                  MongoDB local sans installation système (pratique sous WSL)
```

### Lancement

```bash
cd backend
npm install
cp .env.example .env       # puis adapter MONGODB_URI si besoin
npm run seed               # (optionnel) insère 3 fruits de démo
npm run dev                # démarre sur http://localhost:5000
```

### API REST

| Méthode | URL                 | Rôle                     |
|---------|---------------------|--------------------------|
| GET     | `/api/fruits`       | Liste tous les fruits    |
| GET     | `/api/fruits/:id`   | Un fruit par son id      |
| POST    | `/api/fruits`       | Crée un fruit            |
| PUT     | `/api/fruits/:id`   | Met à jour un fruit      |
| DELETE  | `/api/fruits/:id`   | Supprime un fruit        |

Réponse type : `{ "success": true, "data": ... }`.

Exemple :

```bash
curl -X POST http://localhost:5000/api/fruits \
  -H "Content-Type: application/json" \
  -d '{"name":"Fraise","price":4.5,"quantity":40}'
```

---

## 3. Frontend — `frontend/`

### Structure

```
frontend/src/
├── main.jsx                   Montage React
├── App.jsx                    Page unique : tableau + état des popups + toast
├── api/axios.js               Instance Axios (URL de base de l'API)
├── services/fruitService.js   Appels HTTP CRUD
└── components/
    ├── FruitTable.jsx         Tableau des fruits (Nom/Prix/Quantité/Image/Actions)
    ├── Modal.jsx              Fenêtre modale réutilisable (fond sombre + Échap)
    ├── FruitFormModal.jsx     Modal d'ajout/édition (useState + useEffect)
    ├── ConfirmModal.jsx       Popup de confirmation de suppression
    └── Toast.jsx              Notification de succès temporaire
```

### Lancement

```bash
cd frontend
npm install
cp .env.example .env       # VITE_API_URL=http://localhost:5000/api
npm run dev                # ouvre http://localhost:5173
```

> Le backend doit tourner pour que le front affiche/modifie les données.

---

## 4. Connexion MongoDB (important sous WSL)

Le backend lit l'URI dans `backend/.env` (`MONGODB_URI`). Plusieurs options :

1. **MongoDB local sans installation (le plus simple ici)** :
   ```bash
   cd backend && npm run dev:db   # lance un MongoDB local sur 127.0.0.1:27017
   ```
   Les données sont conservées dans `backend/.mongo-data`. Laisser ce terminal ouvert.

2. **MongoDB Atlas (cloud)** — collez l'URI :
   `MONGODB_URI=mongodb+srv://<user>:<pass>@<cluster>/crud_demo`.

3. **MongoDB installé sous Windows** — par défaut il n'écoute que sur le
   `127.0.0.1` de Windows, **inaccessible depuis WSL2**. Préférez l'option 1 ou 2.

---

## 5. Démarrage rapide (3 terminaux)

```bash
# Terminal 1 — base de données
cd backend && npm run dev:db

# Terminal 2 — API
cd backend && npm run seed && npm run dev

# Terminal 3 — interface
cd frontend && npm run dev
```

Puis ouvrir **http://localhost:5173**.
