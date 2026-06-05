// La Navbar lit le panier via le hook useCart : elle doit être un Client Component
"use client";

// Importation du composant Link de Next.js pour permettre la navigation entre les pages
import Link from "next/link";

// Importation d'une icône de panier d'achat depuis la bibliothèque React Icons
import { AiOutlineShoppingCart } from 'react-icons/ai';

// Importation du hook personnalisé pour accéder au panier
import { useCart } from "../context/CartContext";
// Importation du hook personnalisé pour accéder à l'authentification
import { useAuth } from "../context/AuthContext";

// Définition et exportation du composant Navbar
export default function Navbar() {
  // On récupère le contenu du panier depuis le contexte
  const { cart } = useCart();

  // On récupère l'état de connexion et la fonction de déconnexion
  const { isLoggedIn, logout } = useAuth();

  // Nombre total d'articles = somme des quantités de chaque produit du panier
  // reduce() additionne item.quantity pour tous les produits, en partant de 0
  const itemCount = cart.reduce((total, item) => total + item.quantity, 0);

  return (
    // Barre de navigation avec un fond gris foncé, texte blanc et un peu de padding
    <nav className="bg-gray-800 text-white p-4">
      {/* Conteneur centré horizontalement avec des éléments espacés et alignés verticalement */}
      <div className="container mx-auto flex justify-between items-center">

        {/* Lien vers la page d'accueil "/" */}
        <Link href="/">
          {/* Titre du site, stylisé en gros et en gras, avec le curseur qui change au survol */}
          <span className="text-2xl font-bold cursor-pointer">Fake Store</span>
        </Link>

        {/* Zone de droite : panier + authentification, espacés horizontalement */}
        <div className="flex items-center gap-6">

          {/* Lien vers la page du panier "/cart" */}
          {/* "relative" sert de repère pour positionner la pastille du compteur */}
          <Link href="/cart" className="relative">
            {/* Icône de panier d'achat avec une taille et un curseur stylisés */}
            <AiOutlineShoppingCart className="text-2xl cursor-pointer" />

            {/* Pastille du compteur : affichée seulement s'il y a au moins un article */}
            {itemCount > 0 && (
              <span className="absolute -top-2 -right-2 bg-red-500 text-white text-xs font-bold rounded-full h-5 w-5 flex items-center justify-center">
                {itemCount}
              </span>
            )}
          </Link>

          {/* Authentification : on affiche un bouton différent selon l'état de connexion */}
          {isLoggedIn ? (
            // Si connecté : bouton de déconnexion qui appelle logout()
            <button
              onClick={logout}
              className="cursor-pointer hover:text-gray-300"
            >
              Déconnexion
            </button>
          ) : (
            // Si non connecté : lien vers la page de connexion
            <Link href="/login" className="hover:text-gray-300">
              Connexion
            </Link>
          )}
        </div>
      </div>
    </nav>
  );
}