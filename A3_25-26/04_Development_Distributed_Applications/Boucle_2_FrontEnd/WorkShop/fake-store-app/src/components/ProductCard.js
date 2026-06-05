// Importation du composant Image de Next.js pour un affichage optimisé des images
import Image from "next/image";
// Importation du composant Link pour naviguer vers la page de détail
import Link from "next/link";
// Bouton réutilisable qui gère l'ajout au panier et le sélecteur de quantité
import AddToCartButton from "./AddToCartButton";

// Définition et exportation du composant ProductCard
// Il reçoit en paramètre (prop) un objet "product" via la déstructuration { product }
// Doc : https://react.dev/learn/passing-props-to-a-component
export default function ProductCard({ product }) {
  return (
    // Carte du produit : fond blanc, coins arrondis, ombre et léger agrandissement au survol
    <div className="bg-white rounded-lg shadow-md p-4 flex flex-col hover:shadow-xl transition-shadow duration-300">

      {/* L'image et le titre mènent vers la page de détail /products/[id] */}
      <Link href={`/products/${product.id}`}>
        {/* Conteneur de l'image avec une hauteur fixe et l'image centrée */}
        <div className="relative h-48 w-full mb-4">
          <Image
            src={product.image}        // URL de l'image du produit
            alt={product.title}        // Texte alternatif (accessibilité)
            fill                       // L'image remplit son conteneur parent
            className="object-contain" // L'image garde ses proportions sans être rognée
            sizes="(max-width: 768px) 100vw, 25vw"
          />
        </div>

        {/* Titre du produit, limité à 2 lignes pour garder une mise en page homogène */}
        <h2 className="text-sm font-semibold text-gray-800 line-clamp-2 mb-2 hover:text-blue-600">
          {product.title}
        </h2>
      </Link>

      {/* Catégorie du produit affichée en plus petit et en gris */}
      <p className="text-xs text-gray-500 capitalize mb-2">
        {product.category}
      </p>

      {/* Bloc poussé en bas de la carte grâce à "mt-auto" */}
      <div className="mt-auto flex items-center justify-between">
        {/* Prix du produit formaté avec deux décimales */}
        <span className="text-lg font-bold text-gray-900">
          {product.price.toFixed(2)} $
        </span>

        {/* Note moyenne du produit (rating.rate) avec le nombre d'avis (rating.count) */}
        <span className="text-sm text-yellow-500">
          ★ {product.rating?.rate} ({product.rating?.count})
        </span>
      </div>

      {/* Bouton réutilisable : "Ajouter au panier" ou sélecteur de quantité − [qté] + */}
      <div className="mt-3">
        <AddToCartButton product={product} />
      </div>
    </div>
  );
}
