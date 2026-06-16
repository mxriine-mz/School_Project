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

  // État d'erreur GLOBAL : centralise les messages renvoyés par l'API.
  // Tout composant (formulaire, page protégée…) peut lire cette erreur via useAuth().
  const [error, setError] = useState(null);

  // Indique si la vérification initiale du token (localStorage) est terminée.
  // Utile pour les pages protégées : on évite de rediriger AVANT de savoir
  // si un token existait déjà (sinon l'utilisateur connecté serait éjecté au refresh).
  const [isLoading, setIsLoading] = useState(true);

  // Au premier chargement, on tente de récupérer un token déjà stocké dans le navigateur.
  // Ainsi, l'utilisateur reste connecté même après avoir rafraîchi la page.
  useEffect(() => {
    const storedToken = localStorage.getItem("token");
    if (storedToken) {
      setToken(storedToken);
    }
    // La vérification initiale est terminée : les pages protégées peuvent décider.
    setIsLoading(false);
  }, []);

  // Fonction de connexion : appelle l'API, stocke le token reçu
  const login = async (username, password) => {
    // On repart d'une erreur vierge à chaque nouvelle tentative
    setError(null);
    try {
      // Appel à l'API ; si les identifiants sont faux, une erreur est levée
      const data = await loginUser(username, password);

      // On garde le token en mémoire (état) ET dans le navigateur (localStorage)
      setToken(data.token);
      localStorage.setItem("token", data.token);

      return data;
    } catch (err) {
      // On centralise le message d'erreur dans le provider…
      setError("Identifiant ou mot de passe incorrect.");
      // …et on relève l'erreur pour que l'appelant (le formulaire) puisse réagir.
      throw err;
    }
  };

  // Fonction de déconnexion : on libère l'access token et on réinitialise l'état d'auth
  const logout = () => {
    setToken(null);
    setError(null);
    localStorage.removeItem("token");
  };

  // Permet à un composant d'effacer manuellement le message d'erreur global
  const clearError = () => setError(null);

  // Fournit le token, un booléen pratique "isLoggedIn", l'erreur globale,
  // l'état de chargement et les fonctions login/logout/clearError
  return (
    <AuthContext.Provider
      value={{
        token,
        isLoggedIn: !!token,
        isLoading,
        error,
        login,
        logout,
        clearError,
      }}
    >
      {children}
    </AuthContext.Provider>
  );
};

// Hook personnalisé pour accéder facilement au contexte d'authentification
export const useAuth = () => useContext(AuthContext);
