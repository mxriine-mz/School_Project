import { useEffect } from "react";

// Petite notification temporaire (toast) affichee en bas a droite.
// Disparait toute seule au bout de 3 secondes.
export default function Toast({ message, onClose }) {
  useEffect(() => {
    if (!message) return;
    const timer = setTimeout(onClose, 3000);
    return () => clearTimeout(timer);
  }, [message, onClose]);

  if (!message) return null;

  return (
    <div className="fixed bottom-6 right-6 z-50 bg-emerald-600 text-white px-5 py-3 rounded-lg shadow-lg animate-[fadeIn_0.2s_ease-out]">
      ✅ {message}
    </div>
  );
}
