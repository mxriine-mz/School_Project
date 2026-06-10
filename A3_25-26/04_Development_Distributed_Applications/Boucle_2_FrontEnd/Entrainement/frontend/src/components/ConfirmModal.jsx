import Modal from "./Modal.jsx";

// Popup de confirmation avant une action destructrice (suppression).
export default function ConfirmModal({ open, onClose, onConfirm, fruitName }) {
  return (
    <Modal open={open} onClose={onClose} title="Delete Product">
      <p className="text-slate-600">
        Are you sure you want to delete{" "}
        <span className="font-semibold">{fruitName}</span>? This action is permanent.
      </p>
      <div className="flex justify-end gap-2 pt-5">
        <button onClick={onClose} className="px-4 py-2 rounded-lg border border-slate-300 hover:bg-slate-50 transition">
          Cancel
        </button>
        <button onClick={onConfirm} className="bg-red-600 hover:bg-red-700 text-white font-medium px-4 py-2 rounded-lg transition">
          Delete
        </button>
      </div>
    </Modal>
  );
}
