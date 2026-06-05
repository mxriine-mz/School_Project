// Directive obligatoire : ce composant utilise des hooks (useState/useEffect),
// il doit donc être un Client Component
"use client";

import ProductCard from "./ProductCard";
// Importation des hooks React et de la fonction qui récupère les produits
import { useState, useEffect } from "react";
import { getProducts } from "../utils/api";

export default function ProductList() {
  // État local qui contiendra la liste des produits (vide au départ)
  const [products, setProducts] = useState([]);

  // useEffect s'exécute une seule fois après le premier rendu (tableau de dépendances vide [])
  useEffect(() => {
    // Fonction locale renommée "fetchProducts" pour NE PAS masquer la fonction importée getProducts
    const fetchProducts = async () => {
      const data = await getProducts();
      setProducts(data);
    };
    fetchProducts();
  }, []);

  return (
    <div className="container mx-auto p-4">
      <h1 className="text-2xl font-bold text-white mb-4">Nos Produits</h1>
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
        {products.map((product) => (
          <ProductCard key={product.id} product={product} />
        ))}
      </div>
    </div>
  );
}