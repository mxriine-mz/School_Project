// Directive obligatoire : ce composant utilise des hooks (useState/useEffect),
// il doit donc être un Client Component
"use client";

import ProductList from "../components/ProductList";

export default function Home() {
  return (
    <div className="container mx-auto p-4">
      <ProductList />
    </div>
  );
}