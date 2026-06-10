import axios from "axios";

// Instance Axios centralisee (video 3) : on definit une seule fois l'URL de
// base de l'API. L'URL provient de la variable d'environnement Vite, avec
// une valeur de repli pour le developpement local.
const api = axios.create({
  baseURL: import.meta.env.VITE_API_URL || "http://localhost:5000/api",
  headers: { "Content-Type": "application/json" },
});

export default api;
