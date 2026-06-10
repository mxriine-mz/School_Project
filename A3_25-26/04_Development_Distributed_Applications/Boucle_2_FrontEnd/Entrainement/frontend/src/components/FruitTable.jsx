// Tableau des produits. Colonnes : Name, Price, Quantity, Image, Action.
// Affiche les memes donnees que les cartes, sous forme de tableau (comme la video).
export default function FruitTable({ fruits, onEdit, onDelete }) {
  return (
    <div className="bg-white rounded-xl shadow-md overflow-hidden w-full max-w-2xl">
      <table className="w-full text-left">
        <thead className="text-slate-700">
          <tr className="border-b border-slate-200">
            <th className="px-5 py-4 font-bold">Name</th>
            <th className="px-5 py-4 font-bold">Price</th>
            <th className="px-5 py-4 font-bold">Quantity</th>
            <th className="px-5 py-4 font-bold">Image</th>
            <th className="px-5 py-4 font-bold">Action</th>
          </tr>
        </thead>
        <tbody>
          {fruits.map((fruit) => (
            <tr key={fruit._id} className="border-b border-slate-100 last:border-0">
              <td className="px-5 py-4">{fruit.name}</td>
              <td className="px-5 py-4">${fruit.price}</td>
              <td className="px-5 py-4">{fruit.quantity}</td>
              <td className="px-5 py-4">
                <img
                  src={fruit.image || "https://upload.wikimedia.org/wikipedia/commons/1/15/Red_Apple.jpg"}
                  alt={fruit.name}
                  className="h-10 w-12 rounded object-cover"
                />
              </td>
              <td className="px-5 py-4">
                <div className="flex gap-2">
                  <button
                    onClick={() => onEdit(fruit)}
                    className="bg-blue-500 hover:bg-blue-600 text-white text-sm font-medium px-3 py-1.5 rounded-md transition"
                  >
                    Edit
                  </button>
                  <button
                    onClick={() => onDelete(fruit)}
                    className="bg-red-500 hover:bg-red-600 text-white text-sm font-medium px-3 py-1.5 rounded-md transition"
                  >
                    Delete
                  </button>
                </div>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}
