import { useState, useEffect } from "react";
import Modal from "./Modal.jsx";

// Modal contenant le formulaire d'ajout / d'edition d'un fruit.
// - `fruit` non nul  -> mode edition (champs pre-remplis)
// - `fruit` nul      -> mode ajout (champs vides)
const empty = { name: "", price: "", quantity: "", image: "" };

export default function FruitFormModal({ open, onClose, onSubmit, fruit }) {
  const [form, setForm] = useState(empty);
  const [submitting, setSubmitting] = useState(false);

  // useEffect : a chaque ouverture, on (re)remplit le formulaire selon le
  // fruit a editer, ou on le vide pour un ajout.
  useEffect(() => {
    if (!open) return;
    setForm(
      fruit
        ? {
            name: fruit.name ?? "",
            price: fruit.price ?? "",
            quantity: fruit.quantity ?? "",
            image: fruit.image ?? "",
          }
        : empty
    );
  }, [open, fruit]);

  const handleChange = (e) => {
    const { name, value } = e.target;
    setForm((prev) => ({ ...prev, [name]: value }));
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setSubmitting(true);
    try {
      await onSubmit({
        ...form,
        price: Number(form.price),
        quantity: Number(form.quantity) || 0,
      });
    } finally {
      setSubmitting(false);
    }
  };

  const field =
    "w-full border border-slate-300 rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-emerald-400";

  return (
    <Modal open={open} onClose={onClose} title={fruit ? "Edit Product" : "Create a Product"}>
      <form onSubmit={handleSubmit} className="space-y-4">
        <div>
          <label className="block text-sm font-medium mb-1">Name *</label>
          <input name="name" value={form.name} onChange={handleChange} required className={field} />
        </div>
        <div className="grid grid-cols-2 gap-4">
          <div>
            <label className="block text-sm font-medium mb-1">Price ($) *</label>
            <input type="number" step="0.01" min="0" name="price" value={form.price} onChange={handleChange} required className={field} />
          </div>
          <div>
            <label className="block text-sm font-medium mb-1">Quantity</label>
            <input type="number" min="0" name="quantity" value={form.quantity} onChange={handleChange} className={field} />
          </div>
        </div>
        <div>
          <label className="block text-sm font-medium mb-1">Image (URL)</label>
          <input name="image" value={form.image} onChange={handleChange} className={field} placeholder="https://..." />
        </div>
        <div className="flex justify-end gap-2 pt-2">
          <button type="button" onClick={onClose} className="px-4 py-2 rounded-lg border border-slate-300 hover:bg-slate-50 transition">
            Cancel
          </button>
          <button type="submit" disabled={submitting} className="bg-blue-600 hover:bg-blue-700 disabled:opacity-50 text-white font-medium px-4 py-2 rounded-lg transition">
            {submitting ? "Saving…" : fruit ? "Save" : "Create"}
          </button>
        </div>
      </form>
    </Modal>
  );
}
