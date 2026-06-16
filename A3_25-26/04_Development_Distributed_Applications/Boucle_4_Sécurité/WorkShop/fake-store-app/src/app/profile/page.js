// Page protégée : elle lit l'état d'authentification (hooks) -> Client Component
"use client";

import { useEffect } from "react";
// Hook de navigation pour rediriger un visiteur non connecté
import { useRouter } from "next/navigation";
// Hook personnalisé donnant accès au contexte d'authentification
import { useAuth } from "../../context/AuthContext";

export default function ProfilePage() {
  // On interroge le provider : a-t-on un token ? la vérif initiale est-elle finie ?
  const { token, isLoggedIn, isLoading, logout } = useAuth();
  const router = useRouter();

  // Garde de route : si la vérification initiale est terminée et qu'aucun
  // token n'existe, on renvoie l'utilisateur vers la page de connexion.
  useEffect(() => {
    // On attend que le provider ait fini de lire le localStorage (isLoading=false)
    // pour éviter d'éjecter un utilisateur connecté lors d'un rafraîchissement.
    if (!isLoading && !isLoggedIn) {
      router.replace("/login");
    }
  }, [isLoading, isLoggedIn, router]);

  // Tant qu'on ne sait pas (chargement) ou qu'on est en train de rediriger,
  // on n'affiche PAS les informations sensibles du profil.
  if (isLoading || !isLoggedIn) {
    return (
      <div className="container mx-auto p-4">
        <p className="text-gray-600 dark:text-gray-300">Vérification de votre session…</p>
      </div>
    );
  }

  // À partir d'ici, on est certain que l'utilisateur est authentifié.
  return (
    <div className="container mx-auto p-4">
      <div className="max-w-lg mx-auto bg-white dark:bg-gray-800 rounded-lg shadow p-6">
        <h1 className="text-3xl font-bold mb-4 text-gray-900 dark:text-gray-100">
          Mon Profil
        </h1>

        <p className="text-gray-700 dark:text-gray-300 mb-6">
          Bienvenue&nbsp;! Cette page est protégée : elle n&apos;est accessible
          qu&apos;avec un access token valide.
        </p>

        {/* Démonstration : on affiche l'access token courant (zone sensible) */}
        <div className="mb-6">
          <h2 className="text-sm font-semibold text-gray-500 dark:text-gray-400 mb-1">
            Votre access token
          </h2>
          <p className="break-all bg-gray-100 dark:bg-gray-900 text-gray-800 dark:text-gray-200 text-sm p-3 rounded">
            {token}
          </p>
        </div>

        {/* Déconnexion : libère le token et réinitialise l'état d'authentification */}
        <button
          onClick={logout}
          className="bg-red-500 text-white py-2 px-4 rounded-md hover:bg-red-600 transition-colors duration-200 cursor-pointer"
        >
          Se déconnecter
        </button>
      </div>
    </div>
  );
}
