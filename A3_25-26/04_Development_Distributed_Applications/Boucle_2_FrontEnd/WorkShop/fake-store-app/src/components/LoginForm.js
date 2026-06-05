// Le formulaire gère un état local et utilise le contexte : c'est un Client Component
"use client";

// Hook React pour gérer les champs du formulaire
import { useState } from "react";
// Hook de navigation de Next.js pour rediriger après la connexion
import { useRouter } from "next/navigation";
// Hook personnalisé pour accéder à la fonction de connexion
import { useAuth } from "../context/AuthContext";

export default function LoginForm() {
  // On récupère la fonction login depuis le contexte d'authentification
  const { login } = useAuth();
  // Permet de changer de page une fois connecté
  const router = useRouter();

  // États contrôlés : chaque champ du formulaire est lié à une variable d'état
  const [username, setUsername] = useState("");
  const [password, setPassword] = useState("");
  // Message d'erreur affiché si la connexion échoue
  const [error, setError] = useState("");

  // Fonction appelée à la soumission du formulaire
  const handleSubmit = async (e) => {
    // Empêche le rechargement complet de la page (comportement par défaut d'un <form>)
    e.preventDefault();
    setError("");

    try {
      // Tentative de connexion via l'API
      await login(username, password);
      // Si succès : on redirige vers la page d'accueil
      router.push("/");
    } catch {
      // Si l'API renvoie une erreur (mauvais identifiants), on affiche un message
      setError("Identifiant ou mot de passe incorrect.");
    }
  };

  return (
    <form
      onSubmit={handleSubmit}
      className="max-w-sm mx-auto mt-10 bg-white p-6 rounded-lg shadow flex flex-col gap-4"
    >
      <h1 className="text-2xl font-bold text-gray-800">Connexion</h1>

      {/* Affichage du message d'erreur, seulement s'il y en a un */}
      {error && (
        <p className="text-red-500 text-sm bg-red-50 p-2 rounded">{error}</p>
      )}

      {/* Champ identifiant */}
      <div className="flex flex-col gap-1">
        <label htmlFor="username" className="text-sm text-gray-600">
          Identifiant
        </label>
        <input
          id="username"
          type="text"
          value={username}                               // valeur liée à l'état
          onChange={(e) => setUsername(e.target.value)}  // met à jour l'état à chaque frappe
          required
          className="border border-gray-300 rounded px-3 py-2 text-black focus:outline-none focus:ring-2 focus:ring-gray-400"
        />
      </div>

      {/* Champ mot de passe */}
      <div className="flex flex-col gap-1">
        <label htmlFor="password" className="text-sm text-gray-600">
          Mot de passe
        </label>
        <input
          id="password"
          type="password"
          value={password}
          onChange={(e) => setPassword(e.target.value)}
          required
          className="border border-gray-300 rounded px-3 py-2 text-black focus:outline-none focus:ring-2 focus:ring-gray-400"
        />
      </div>

      {/* Bouton de soumission */}
      <button
        type="submit"
        className="bg-gray-800 text-white py-2 rounded-md hover:bg-gray-700 transition-colors duration-200 cursor-pointer"
      >
        Se connecter
      </button>
    </form>
  );
}
