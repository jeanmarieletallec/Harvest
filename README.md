# Harvest
Collection de requêtes Power Query pour Harvest API

Prérequis:

- Power Query (Excel / Power BI) capable d'utiliser des requêtes Web.Contents
- Variables attendues dans l'environnement Power Query :
	- `User_Agent` : chaîne user agent utilisée pour l'en-tête
	- `Harvest_Account_ID` : l'ID du compte Harvest (en-tête `Harvest-Account-ID`)
	- `Authorization` : token d'authentification (ex. `Bearer ...`)

Fichiers:

- `fnGetClients.pq` : fonction qui récupère une page de clients depuis l'API Harvest
- `Clients.pq` : itère les pages et assemble la table complète des clients
- `fnGetProjects.pq` : fonction qui récupère une page de projets depuis l'API Harvest
- `Projects.pq` : itère les pages et assemble la table complète des projets

Usage rapide (Power Query) :

1. Définir les variables `User_Agent`, `Harvest_Account_ID` et `Authorization` dans l'éditeur de requêtes (par exemple via une requête qui renvoie ces valeurs en tant que constantes).
2. Charger `Clients.pq` ou `Projects.pq` dans Power BI / Excel pour récupérer les données.

Notes et améliorations possibles:

- Gérer les en-têtes de pagination (si présents) plutôt que d'utiliser List.Generate infini pour arrêter proprement au dernier page.
- Ajouter gestion des erreurs réseau pour réessayer ou logger les réponses non-200.
- Valider et normaliser les types et valeurs manquantes (nulls) avant conversion finale.
