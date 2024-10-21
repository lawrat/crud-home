Voici le fichier `README.md` mis à jour, avec les sections réorganisées pour que la partie sur Vagrant soit à la fin :

````markdown
# CRUD Master

## Description

CRUD Master est une application de gestion d'inventaire de films, permettant aux utilisateurs de créer, lire, mettre à jour et supprimer des enregistrements de films. Ce projet adopte une architecture microservices, comprenant trois applications distinctes :

- **Inventory App** : Gère les opérations liées à l'inventaire des films.
- **Billing App** : Gère les transactions et la facturation.
- **API Gateway** : Sert d'interface unique pour interagir avec les différentes APIs des applications.

Ce système est conçu pour être extensible et maintenable, permettant une gestion efficace des données et une intégration facile de nouvelles fonctionnalités.

## Technologies Utilisées

- **Node.js** : Environnement d'exécution JavaScript côté serveur.
- **Express** : Framework web pour créer des applications et APIs.
- **Sequelize** : ORM pour interagir avec la base de données PostgreSQL.
- **PostgreSQL** : Système de gestion de base de données relationnelles.
- **CORS** : Middleware pour gérer les requêtes cross-origin.
- **Body-Parser** : Middleware pour analyser le corps des requêtes HTTP.
- **Nodemon** (optionnel) : Outil pour recharger automatiquement votre application pendant le développement.
- **PM2** : Gestionnaire de processus pour les applications Node.js.

## Prérequis

Avant de commencer, assurez-vous d'avoir installé les éléments suivants :

- [Node.js](https://nodejs.org/) (version 14 ou supérieure)
- [PostgreSQL](https://www.postgresql.org/download/)

## Installation

1. **Clonez le dépôt** :
   ```bash
   git clone https://github.com/yourusername/crud-master.git
   cd crud-master
   ```
````

2. **Installation des dépendances pour chaque application** :

   - **Inventory App** :

     ```bash
     cd srcs/inventory-app
     npm install
     ```

   - **Billing App** :

     ```bash
     cd ../billing-app
     npm install
     ```

   - **API Gateway** :
     ```bash
     cd ../api-gateway
     npm install
     ```

3. **Configuration de la Base de Données** :
   - Connectez-vous à PostgreSQL et créez la base de données :
   ```sql
   CREATE DATABASE movies;
   ```
   - Créez un utilisateur et accordez-lui les permissions :
   ```sql
   CREATE USER your_username WITH PASSWORD 'your_password';
   GRANT ALL PRIVILEGES ON DATABASE movies TO your_username;
   ```
   - Connectez-vous à la base de données et créez la table `movies` :
   ```sql
   \c movies
   CREATE TABLE movies (
       id SERIAL PRIMARY KEY,
       title VARCHAR(255) NOT NULL,
       description TEXT
   );
   ```

## Exécution des Applications

### Inventory App

Pour démarrer le serveur de l'inventaire, exécutez la commande suivante dans le répertoire `inventory-app` :

```bash
cd srcs/inventory-app
node server.js
```

### Billing App

Pour démarrer le serveur de facturation, exécutez la commande suivante dans le répertoire `billing-app` :

```bash
cd srcs/billing-app
node server.js
```

### API Gateway

Pour démarrer l'API Gateway, exécutez la commande suivante dans le répertoire `api-gateway` :

```bash
cd srcs/api-gateway
node server.js
```

#### Endpoints disponibles pour Billing App

- **POST** `/billing` : Créer une nouvelle transaction.
- **GET** `/billing` : Récupérer la liste des transactions.
- **GET** `/billing/:id` : Récupérer une transaction par son ID.

##### Exemple de requêtes pour Billing App

1. **Créer une transaction** :

   ```bash
   curl -X POST http://localhost:3001/billing \
   -H "Content-Type: application/json" \
   -d '{"amount": 29.99, "movieId": 1, "description": "Achat de Inception"}'
   ```

2. **Récupérer toutes les transactions** :

   ```bash
   curl -X GET http://localhost:3001/billing
   ```

3. **Récupérer une transaction par ID** :
   ```bash
   curl -X GET http://localhost:3001/billing/1
   ```

### API Gateway

L'API Gateway permet de centraliser l'accès aux différentes APIs des applications d'inventaire et de facturation. Les endpoints seront redirigés vers les services appropriés.

### Utilisation de l'API

#### Endpoints disponibles

##### Inventory App

- **POST** `/movies` : Créer un nouveau film
- **GET** `/movies` : Récupérer la liste de tous les films
- **GET** `/movies/:id` : Récupérer un film par son ID
- **PUT** `/movies/:id` : Mettre à jour un film par son ID
- **DELETE** `/movies/:id` : Supprimer un film par son ID

### Exemples de requêtes

Vous pouvez utiliser des outils comme **Postman** ou **cURL** pour tester les différentes API disponibles. Voici quelques exemples avec cURL :

1. **Créer un film** :

   ```bash
   curl -X POST http://localhost:3000/movies \
   -H "Content-Type: application/json" \
   -d '{"title": "Inception", "description": "Un film de science-fiction."}'
   ```

2. **Récupérer tous les films** :

   ```bash
   curl -X GET http://localhost:3000/movies
   ```

3. **Récupérer un film par ID** :

   ```bash
   curl -X GET http://localhost:3000/movies/1
   ```

4. **Mettre à jour un film** :

   ```bash
   curl -X PUT http://localhost:3000/movies/1 \
   -H "Content-Type: application/json" \
   -d '{"title": "Inception", "description": "Un film de science-fiction et d'action."}'
   ```

5. **Supprimer un film** :
   ```bash
   curl -X DELETE http://localhost:3000/movies/1
   ```

## Gestion des Erreurs

Les applications gèrent les erreurs de manière à renvoyer des messages clairs et des codes d'état HTTP appropriés. Voici quelques exemples de gestion des erreurs :

- **404 Not Found** : Renvoie cette erreur si un film ou une transaction n'est pas trouvé.
- **400 Bad Request** : Renvoie cette erreur si les données envoyées dans une requête POST ou PUT ne sont pas valides.
- **500 Internal Server Error** : Renvoie cette erreur si une erreur inattendue se produit dans le serveur.

## Gestion des Applications Node.js avec PM2

PM2 est un gestionnaire de processus pour les applications Node.js qui facilite la gestion et la mise à l'échelle de votre application. Il est conçu pour assurer le fonctionnement continu de votre application, même en cas de panne inattendue.

### Commandes PM2

Après avoir accédé à votre VM via SSH, vous pouvez exécuter les commandes suivantes :

- **Lister toutes les applications en cours d'exécution** :

  ```bash
  sudo pm2 list
  ```

- **Arrêter une application spécifique** :

  ```bash
  sudo pm2 stop <app_name>
  ```

- **Démarrer une application spécifique** :
  ```bash
  sudo pm2 start <app_name>
  ```

PM2 peut être utilisé pour tester la résilience des messages envoyés à l'API de facturation lorsque l'API n'est pas opérationnelle.

## Exécution des Applications avec Vagrant

Pour faciliter le déploiement et la gestion des applications, nous utilisons Vagrant. Cela vous permet de créer et de démarrer des machines virtuelles (VM) préconfigurées pour exécuter vos applications.

1. **Configurer Vagrant** :

   - Assurez-vous d'avoir un fichier `Vagrantfile` dans la racine de votre projet qui définit les trois machines virtuelles (Inventory, Billing et API Gateway).
   - Vous pouvez également avoir un répertoire `scripts` où vous stockez les scripts pour installer les outils nécessaires sur chaque VM.

2. **Commandes Vagrant** :
   - Démarrer toutes les machines virtuelles :
     ```bash
     vagrant up
     ```
   - Afficher l'état de toutes les machines virtuelles :
     ```bash
     vagrant status
     ```
   - Accéder à une VM via SSH :
     ```bash
     vagrant ssh <vm-name>
     ```

## Conclusion

CRUD Master est un projet qui met en avant les principes de conception d'API RESTful, la gestion d'inventaire et la facturation dans une architecture microservices. Grâce à des outils tels que Vagrant et PM2, il est facile de déployer et de gérer ce système. N'hésitez pas à explorer le code et à l'adapter selon vos besoins !
