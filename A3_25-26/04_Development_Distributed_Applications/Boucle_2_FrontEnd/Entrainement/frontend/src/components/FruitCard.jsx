// Carte d'un produit (grande image en haut, infos + boutons en bas).
// Reproduit la presentation en cartes de la video.
export default function FruitCard({ fruit, onEdit, onDelete }) {
  return (
    <div className="bg-white rounded-xl shadow-md overflow-hidden flex flex-col">
      <img
        src={fruit.image || "https://upload.wikimedia.org/wikipedia/commons/1/15/Red_Apple.jpg"}
        alt={fruit.name}
        className="h-48 w-full object-cover"
      />
      <div className="p-4 flex flex-col gap-1">
        <h3 className="text-xl font-bold">{fruit.name}</h3>
        <p className="text-slate-600">Quantity: {fruit.quantity}</p>
        <p className="text-slate-600">Price: ${fruit.price}</p>
        <div className="grid grid-cols-2 gap-3 mt-3">
          <button
            onClick={() => onEdit(fruit)}
            className="bg-slate-800 hover:bg-slate-900 text-white font-semibold py-2 rounded-lg transition"
          >
            Edit
          </button>
          <button
            onClick={() => onDelete(fruit)}
            className="bg-red-600 hover:bg-red-700 text-white font-semibold py-2 rounded-lg transition"
          >
            Delete
          </button>
        </div>
      </div>
    </div>
  );
}
