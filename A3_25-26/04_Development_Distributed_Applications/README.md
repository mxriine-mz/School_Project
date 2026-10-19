# Development of Distributed Applications

Ce module porte sur la conception d'applications web distribuées : exposition de données via une **API REST**, consommation côté **Front-End**, authentification par **JWT**, conteneurisation **Docker** et sécurisation de bout en bout.

## Boucles d'apprentissage

| # | Boucle | Focus |
| :---: | :--- | :--- |
| 1 | [API](./Boucle_1_API/) | Conception d'API REST (Node.js / Express). |
| 2 | [Front-End](./Boucle_2_FrontEnd/) | Consommation d'API et interface (Fake Store App). |
| 3 | [JWT & Docker](./Boucle_3_JWT_Docker/) | Authentification par jetons et conteneurisation. |
| 4 | [Sécurité](./Boucle_4_Sécurité/) | Sécurisation des échanges et bonnes pratiques. |

Chaque boucle contient son CER (compte-rendu LaTeX) et un WorkShop de mise en pratique.

## Projet — [Breezy](./_Project_Breezy/)

Réseau social léger et scalable inspiré de Twitter/X, pensé pour les environnements à faibles ressources (mobile-first), avec un back-end découpé en microservices conteneurisés.

- Stack : Next.js / React, Node.js / Express (TypeScript), Nginx (API Gateway), PostgreSQL + MongoDB, Docker Compose.
- Sécurité : JWT en cookies `httpOnly` (access + refresh), bcrypt, RBAC (user < moderator < admin).
- Dépôt : [DAD-G4/Breezy](https://github.com/DAD-G4/Breezy), intégré ici en sous-module git, figé sur sa version finale (projet terminé).

## Compétences clés

- Conception et exposition d'API REST.
- Développement Front-End et consommation de services.
- Authentification et autorisation via JWT.
- Conteneurisation Docker et déploiement.
- Sécurité des applications distribuées.
