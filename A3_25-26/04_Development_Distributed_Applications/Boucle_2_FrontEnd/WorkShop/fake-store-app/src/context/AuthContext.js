// Indique que ce code s'exécute côté client (Next.js)
"use client";

// Importation des hooks nécessaires depuis React
import { createContext, useContext, useState, useEffect } from "react";
// Fonction qui appelle l'API d'authentification
import { loginUser } from "../utils/api";

// Création du contexte d'authentification
const AuthContext = createContext();

// Composant fournisseur d'authentification (englobe l'application)
export const AuthProvider = ({ children }) => {

  // État contenant le token de connexion (null = personne n'est connecté)
  const [token, setToken] = useState(null);

  // Au premier chargement, on tente de récupérer un token déjà stocké dans le navigateur.
  // Ainsi, l'utilisateur reste connecté même après avoir rafraîchi la page.
  useEffect(() => {
    const storedToken = localStorage.getItem("token");
    if (storedToken) {
      setToken(storedToken);
    }
  }, []);

  // Fonction de connexion : appelle l'API, stocke le token reçu
  const login = async (username, password) => {
    // Appel à l'API ; si les identifiants sont faux, une erreur est levée (gérée dans le formulaire)
    const data = await loginUser(username, password);

    // On garde le token en mémoire (état) ET dans le navigateur (localStorage)
    setToken(data.token);
    localStorage.setItem("token", data.token);

    return data;
  };

  // Fonction de déconnexion : on efface le token partout
  const logout = () => {
    setToken(null);
    localStorage.removeItem("token");
  };

  // Fournit le token, un booléen pratique "isLoggedIn", et les fonctions login/logout
  return (
    <AuthContext.Provider value={{ token, isLoggedIn: !!token, login, logout }}>
      {children}
    </AuthContext.Provider>
  );
};

// Hook personnalisé pour accéder facilement au contexte d'authentification
export const useAuth = () => useContext(AuthContext);
