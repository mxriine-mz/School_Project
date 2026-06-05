import Image from "next/image";
import Link from "next/link";
// Fonction qui récupère un seul produit depuis l'API grâce à son id
import { getProduct } from "../../../utils/api";
// Bouton réutilisable : ajout au panier / sélecteur de quantité
import AddToCartButton from "../../../components/AddToCartButton";

// Page de détail d'un produit.
// Le dossier s'appelle [id] : Next.js fournit donc cet id dans "params".
// En Next.js récent, params est asynchrone : on doit l'attendre avec await.
export default async function ProductDetail({ params }) {
  // On extrait l'id depuis l'URL (ex : /products/3 => id = "3")
  const { id } = await params;

  // On récupère les détails du produit correspondant
  const product = await getProduct(id);

  return (
    <div className="container mx-auto p-4">
      {/* Lien pour revenir à la liste des produits */}
      <Link href="/" className="text-gray-600 hover:underline">
        ← Retour aux produits
      </Link>

      {/* Mise en page en 2 colonnes sur grand écran : image | informations */}
      <div className="mt-4 flex flex-col md:flex-row gap-8 bg-white rounded-lg shadow p-6">

        {/* Colonne image */}
        <div className="relative h-80 w-full md:w-1/2">
          <Image
            src={product.image}
            alt={product.title}
            fill
            className="object-contain"
            sizes="(max-width: 768px) 100vw, 50vw"
          />
        </div>

        {/* Colonne informations */}
        <div className="flex flex-col md:w-1/2">
          {/* Catégorie */}
          <p className="text-sm text-gray-500 capitalize mb-2">
            {product.category}
          </p>

          {/* Titre */}
          <h1 className="text-2xl font-bold text-gray-900 mb-4">
            {product.title}
          </h1>

          {/* Note moyenne et nombre d'avis */}
          <p className="text-yellow-500 mb-4">
            ★ {product.rating?.rate} ({product.rating?.count} avis)
          </p>

          {/* Description complète */}
          <p className="text-gray-700 mb-6">{product.description}</p>

          {/* Prix */}
          <span className="text-3xl font-bold text-gray-900 mb-4">
            {product.price.toFixed(2)} $
          </span>

          {/* Bouton réutilisable : ajout au panier / sélecteur de quantité */}
          <AddToCartButton product={product} />
        </div>
      </div>
    </div>
  );
}
