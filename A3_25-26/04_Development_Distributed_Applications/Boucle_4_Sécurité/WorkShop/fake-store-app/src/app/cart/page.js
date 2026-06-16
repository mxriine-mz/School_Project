// Cette page lit et modifie le panier via des hooks : c'est un Client Component
"use client";

import Image from "next/image";
// Hook personnalisé pour accéder au panier et à ses fonctions
import { useCart } from "../../context/CartContext";

export default function Cart() {
  // On récupère le panier et les fonctions de modification depuis le contexte
  const { cart, updateQuantity, removeFromCart } = useCart();

  // Calcul du prix total : somme de (prix × quantité) pour chaque article
  const total = cart.reduce(
    (sum, item) => sum + item.price * item.quantity,
    0
  );

  // Si le panier est vide, on affiche un message et on s'arrête là
  if (cart.length === 0) {
    return (
      <div className="container mx-auto p-4">
        <h1 className="text-3xl font-bold mb-4">Votre Panier</h1>
        <p className="text-lg text-gray-600">
          Vous n&apos;avez encore ajouté aucun produit à votre panier.
        </p>
      </div>
    );
  }

  return (
    <div className="container mx-auto p-4">
      <h1 className="text-3xl font-bold mb-6">Votre Panier</h1>

      {/* Liste des articles du panier */}
      <div className="flex flex-col gap-4">
        {cart.map((item) => (
          // Une ligne par produit présent dans le panier
          <div
            key={item.id}
            className="flex items-center gap-4 bg-white rounded-lg shadow p-4"
          >
            {/* Image du produit */}
            <div className="relative h-20 w-20 flex-shrink-0">
              <Image
                src={item.image}
                alt={item.title}
                fill
                className="object-contain"
                sizes="80px"
              />
            </div>

            {/* Titre et prix unitaire */}
            <div className="flex-1">
              <h2 className="text-sm font-semibold text-gray-800 line-clamp-2">
                {item.title}
              </h2>
              <p className="text-gray-500 text-sm">
                {item.price.toFixed(2)} $ l&apos;unité
              </p>
            </div>

            {/* Sélecteur de quantité : - / valeur / + */}
            <div className="flex items-center gap-2">
              <button
                onClick={() => updateQuantity(item.id, item.quantity - 1)}
                className="px-2 py-1 bg-gray-200 rounded hover:bg-gray-300 cursor-pointer text-gray-500"
              >
                −
              </button>
              <span className="w-8 text-center text-gray-500">{item.quantity}</span>
              <button
                onClick={() => updateQuantity(item.id, item.quantity + 1)}
                className="px-2 py-1 bg-gray-200 rounded hover:bg-gray-300 cursor-pointer text-gray-500"
              >
                +
              </button>
            </div>

            {/* Sous-total de la ligne (prix × quantité) */}
            <span className="w-24 text-right font-bold text-gray-900">
              {(item.price * item.quantity).toFixed(2)} $
            </span>

            {/* Bouton pour supprimer complètement le produit du panier */}
            <button
              onClick={() => removeFromCart(item.id)}
              className="text-red-500 hover:text-red-700 cursor-pointer"
            >
              Supprimer
            </button>
          </div>
        ))}
      </div>

      {/* Total général du panier */}
      <div className="mt-6 flex justify-end">
        <p className="text-xl font-bold">
          Total : {total.toFixed(2)} $
        </p>
      </div>
    </div>
  );
}
