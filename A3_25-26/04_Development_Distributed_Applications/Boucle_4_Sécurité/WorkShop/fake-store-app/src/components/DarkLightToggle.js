"use client";
import { useState, useEffect } from "react";

// Bouton pour basculer entre le mode clair et le mode sombre.
// (Copie locale du composant publié sur NPM, pour tester dans l'app.)
// Le thème choisi est mémorisé dans le localStorage et appliqué en ajoutant
// (ou retirant) la classe "dark" sur la balise <html>.
const DarkLightToggle = () => {
  const [isDarkMode, setIsDarkMode] = useState(false);

  // Au montage : on applique le thème déjà enregistré par l'utilisateur.
  useEffect(() => {
    if (localStorage.getItem("theme") === "dark") {
      setIsDarkMode(true);
      document.documentElement.classList.add("dark");
    } else {
      setIsDarkMode(false);
      document.documentElement.classList.remove("dark");
    }
  }, []);

  // Au clic : on inverse le thème et on le sauvegarde.
  const toggleTheme = () => {
    if (isDarkMode) {
      document.documentElement.classList.remove("dark");
      localStorage.setItem("theme", "light");
    } else {
      document.documentElement.classList.add("dark");
      localStorage.setItem("theme", "dark");
    }
    setIsDarkMode(!isDarkMode);
  };

  return (
    <button
      onClick={toggleTheme}
      aria-label="Basculer entre le mode clair et sombre"
      className="p-2 rounded-full bg-gray-200 dark:bg-gray-700 text-gray-900 dark:text-white cursor-pointer"
    >
      {isDarkMode ? <span>🌙</span> : <span>🌞</span>}
    </button>
  );
};

export default DarkLightToggle;
