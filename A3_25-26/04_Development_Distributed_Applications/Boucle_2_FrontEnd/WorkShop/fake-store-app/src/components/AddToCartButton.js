// Ce composant utilise le contexte du panier (hooks) : c'est un Client Component
"use client";

// Hook personnalisé pour accéder au panier et à ses fonctions
import { useCart } from "../context/CartContext";

// Composant réutilisable : reçoit un produit en prop.
// - Si le produit n'est PAS dans le panier  -> bouton "Ajouter au panier"
// - Si le produit EST déjà dans le panier    -> sélecteur de quantité  − [qté] +
export default function AddToCartButton({ product }) {
  // On récupère le panier et toutes les fonctions de modification
  const { cart, addToCart, updateQuantity, removeFromCart } = useCart();

  // On cherche si ce produit est déjà présent dans le panier
  const itemInCart = cart.find((item) => item.id === product.id);

  // Quantité actuelle, calculée de façon sûre :
  // si le produit n'est pas dans le panier, itemInCart est undefined -> on retombe sur 0
  // (l'opérateur ?. évite "can't access property quantity of undefined")
  const quantity = itemInCart?.quantity ?? 0;

  // Diminuer la quantité.
  // Si on est déjà à 1, descendre revient à retirer le produit du panier.
  const decrease = () => {
    if (quantity <= 1) {
      removeFromCart(product.id);
    } else {
      updateQuantity(product.id, quantity - 1);
    }
  };

  // CAS 1 : le produit n'est pas encore dans le panier -> bouton classique
  if (!itemInCart) {
    return (
      <button
        onClick={() => addToCart(product)}
        className="w-full bg-gray-800 text-white py-2 rounded-md hover:bg-gray-700 transition-colors duration-200 cursor-pointer"
      >
        Ajouter au panier
      </button>
    );
  }

  // CAS 2 : le produit est dans le panier -> sélecteur de quantité − [qté] +
  return (
    <div className="w-full flex items-center justify-between bg-gray-800 text-white rounded-md">
      {/* Bouton − : diminue la quantité (ou retire le produit si on atteint 0) */}
      <button
        onClick={decrease}
        className="px-4 py-2 hover:bg-gray-700 rounded-l-md cursor-pointer"
      >
        −
      </button>

      {/* Quantité actuelle de ce produit dans le panier */}
      <span className="font-semibold">{quantity}</span>

      {/* Bouton + : augmente la quantité */}
      <button
        onClick={() => updateQuantity(product.id, quantity + 1)}
        className="px-4 py-2 hover:bg-gray-700 rounded-r-md cursor-pointer"
      >
        +
      </button>
    </div>
  );
}
