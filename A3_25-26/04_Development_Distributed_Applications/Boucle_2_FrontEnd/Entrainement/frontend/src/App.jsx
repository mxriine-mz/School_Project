import { useState, useEffect } from "react";
import FruitCard from "./components/FruitCard.jsx";
import FruitTable from "./components/FruitTable.jsx";
import FruitFormModal from "./components/FruitFormModal.jsx";
import ConfirmModal from "./components/ConfirmModal.jsx";
import Toast from "./components/Toast.jsx";
import { getFruits, createFruit, updateFruit, deleteFruit } from "./services/fruitService.js";

// Page unique reproduisant la video : en-tete "React CRUD", bouton "Create a
// Product", une grille de cartes PUIS un tableau, avec popups (modal de
// formulaire, confirmation de suppression) et toast de succes.
export default function App() {
  const [fruits, setFruits] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  // Etat des popups
  const [formOpen, setFormOpen] = useState(false);
  const [editing, setEditing] = useState(null); // produit en cours d'edition (ou null = ajout)
  const [toDelete, setToDelete] = useState(null); // produit a supprimer (ouvre la confirmation)
  const [toast, setToast] = useState("");

  // Chargement asynchrone initial (useEffect + etat loading).
  useEffect(() => {
    const fetchData = async () => {
      try {
        setLoading(true);
        setFruits(await getFruits());
        setError(null);
      } catch {
        setError("Unable to load products. Is the API running?");
      } finally {
        setLoading(false);
      }
    };
    fetchData();
  }, []);

  const openAdd = () => {
    setEditing(null);
    setFormOpen(true);
  };
  const openEdit = (fruit) => {
    setEditing(fruit);
    setFormOpen(true);
  };

  // Soumission du formulaire (cree ou met a jour selon le mode)
  const handleSubmit = async (data) => {
    try {
      if (editing) {
        const updated = await updateFruit(editing._id, data);
        setFruits((prev) => prev.map((f) => (f._id === updated._id ? updated : f)));
        setToast("Product updated");
      } else {
        const created = await createFruit(data);
        setFruits((prev) => [created, ...prev]);
        setToast("Product created");
      }
      setFormOpen(false);
    } catch (err) {
      alert(err.response?.data?.message || "Save failed.");
    }
  };

  // Confirmation de suppression
  const handleDelete = async () => {
    try {
      await deleteFruit(toDelete._id);
      setFruits((prev) => prev.filter((f) => f._id !== toDelete._id));
      setToast("Product deleted");
    } catch {
      alert("Delete failed.");
    } finally {
      setToDelete(null);
    }
  };

  return (
    <div className="min-h-screen bg-slate-400">
      <header className="bg-slate-800 text-white py-5 px-6">
        <h1 className="text-2xl font-bold">React CRUD</h1>
      </header>

      <main className="px-6 py-6">
        <button
          onClick={openAdd}
          className="bg-blue-600 hover:bg-blue-700 text-white font-bold px-5 py-3 rounded-lg shadow transition"
        >
          Create a Product
        </button>

        {loading && <p className="mt-8 text-center text-white">Loading…</p>}
        {error && <p className="mt-8 text-center text-red-700">{error}</p>}

        {!loading && !error && (
          <>
            {/* Grille de cartes */}
            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6 mt-6">
              {fruits.map((fruit) => (
                <FruitCard key={fruit._id} fruit={fruit} onEdit={openEdit} onDelete={setToDelete} />
              ))}
            </div>

            {/* Tableau */}
            {fruits.length > 0 && (
              <div className="mt-12 flex justify-center">
                <FruitTable fruits={fruits} onEdit={openEdit} onDelete={setToDelete} />
              </div>
            )}

            {fruits.length === 0 && (
              <p className="mt-8 text-center text-white">No product yet. Create one!</p>
            )}
          </>
        )}
      </main>

      {/* Popups */}
      <FruitFormModal
        open={formOpen}
        onClose={() => setFormOpen(false)}
        onSubmit={handleSubmit}
        fruit={editing}
      />
      <ConfirmModal
        open={Boolean(toDelete)}
        onClose={() => setToDelete(null)}
        onConfirm={handleDelete}
        fruitName={toDelete?.name}
      />
      <Toast message={toast} onClose={() => setToast("")} />
    </div>
  );
}
