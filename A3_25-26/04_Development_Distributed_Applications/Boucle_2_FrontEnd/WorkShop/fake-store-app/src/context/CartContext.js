// Indique que ce code s'exécute côté client (Next.js)
"use client"

// Importation des hooks nécessaires depuis React
import { createContext, useContext, useState } from "react";

// Création du contexte pour le panier
const CartContext = createContext();

// Composant fournisseur du panier (englobe l'application)
export const CartProvider = ({ children }) => {

  // État contenant les produits du panier (tableau)
  const [cart, setCart] = useState([]);

  // Fonction pour ajouter un produit au panier
  const addToCart = (product) => {
    // Mise à jour du panier en fonction de l'état précédent
    setCart((prevCart) => {

      // Recherche si le produit existe déjà dans le panier
      const existingProduct = prevCart.find((item) => item.id === product.id);

      // Si le produit existe déjà
      if (existingProduct) {
        return prevCart.map((item) =>
          item.id === product.id
            // On incrémente la quantité
            ? { ...item, quantity: item.quantity + 1 }
            // Sinon, on laisse l'élément inchangé
            : item
        );
      }

      //  ... = copier. copie tous les éléments du tableau prevCart 
      //garde tous les produits déjà dans le panier 
      // Si le produit n'existe pas, on l'ajoute avec quantité = 1
      return [...prevCart, { ...product, quantity: 1 }];
    });
  };

  // Fonction pour mettre à jour la quantité d’un produit
  const updateQuantity = (id, quantity) => {
    setCart((prevCart) =>
      //item est un élément du tableau prevCart
      prevCart.map((item) =>
        //parcourir le tableau
        item.id === id
        //Si c’est le bon produit
        // On crée un nouvel objet produit : on garde toutes les valeurs (...item)
        //on change seulement la quantité
          // Mise à jour de la quantité (minimum 1)
          ? { ...item, quantity: Math.max(1, quantity) }
          : item
      )
    );
  };

  // Fonction pour supprimer un produit du panier
  const removeFromCart = (id) => {
    // Filtre tous les produits sauf celui qui correspond à l'id
    setCart((prevCart) => prevCart.filter((item) => item.id !== id));
  };

  // Fournit les données et fonctions du panier à tous les composants enfants
  return (
    <CartContext.Provider value={{ cart, addToCart, updateQuantity, removeFromCart }}>
      {children}
    </CartContext.Provider>
  );
};

// Hook personnalisé pour accéder facilement au contexte du panier
export const useCart = () => useContext(CartContext);