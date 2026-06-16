# react-dark-light-toggle

Un petit composant React : un bouton pour basculer entre le **mode clair** et le
**mode sombre**. Le choix est mémorisé dans le `localStorage` et appliqué via la
classe `dark` sur la balise `<html>` (compatible Tailwind CSS en `darkMode: "class"`).

## Installation

```bash
npm install react-dark-light-toggle-zelphyris
```

## Utilisation

```jsx
import DarkLightToggle from "react-dark-light-toggle-zelphyris";

export default function Navbar() {
  return (
    <nav>
      <DarkLightToggle />
    </nav>
  );
}
```

## Pré-requis Tailwind CSS

Activez le mode sombre par classe.

- **Tailwind v3** — dans `tailwind.config.mjs` :

  ```js
  export default {
    darkMode: "class",
    // ...
  };
  ```

- **Tailwind v4** — dans votre fichier CSS principal :

  ```css
  @import "tailwindcss";
  @custom-variant dark (&:where(.dark, .dark *));
  ```

## Publication

```bash
npm login
npm publish
```
