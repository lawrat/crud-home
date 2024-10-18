#!/bin/bash
set -e

# Mise à jour des packages
echo "Mise à jour des packages..."
sudo apt-get update

# Installation de PostgreSQL
if ! command -v psql > /dev/null 2>&1; then
    echo "Installation de PostgreSQL..."
    sudo apt-get install -y postgresql postgresql-contrib
fi

# Démarrage du service PostgreSQL
echo "Démarrage du service PostgreSQL..."
sudo service postgresql start

# Connexion et création de la base de données
echo "Création de la base de données 'orders'..."
if sudo -u postgres psql -c "CREATE DATABASE orders;" 2>/dev/null; then
    echo "Base de données 'orders' créée avec succès."
else
    echo "Erreur lors de la création de la base de données 'orders'."
fi

# Création de l'utilisateur lsall avec les privilèges appropriés
echo "Création de l'utilisateur 'lsall'..."
if sudo -u postgres psql -c "CREATE USER lsall WITH PASSWORD 'lsall2024';" 2>/dev/null; then
    echo "Utilisateur 'lsall' créé avec succès."
else
    echo "Erreur lors de la création de l'utilisateur 'lsall'. Vérifiez s'il existe déjà."
fi

# Octroi des privilèges à l'utilisateur lsall sur la base de données orders
echo "Octroi des privilèges à l'utilisateur 'lsall' sur la base de données 'orders'..."
if sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE orders TO lsall;" 2>/dev/null; then
    echo "Privilèges accordés à l'utilisateur 'lsall' sur la base de données 'orders'."
else
    echo "Erreur lors de l'octroi des privilèges à l'utilisateur 'lsall' sur la base de données 'orders'."
fi

# Création de la table orders si elle n'existe pas
echo "Création de la table 'orders' si elle n'existe pas..."
if sudo -u postgres psql -d orders -c "CREATE TABLE IF NOT EXISTS orders (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    number_of_items INT NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL
);" 2>/dev/null; then
    echo "Table 'orders' créée avec succès ou elle existe déjà."
else
    echo "Erreur lors de la création de la table 'orders'."
fi

# Octroi des privilèges à l'utilisateur lsall sur la table orders
echo "Octroi des privilèges à l'utilisateur lsall sur la table orders..."
if sudo -u postgres psql -d orders -c "GRANT ALL PRIVILEGES ON TABLE orders TO lsall;" 2>/dev/null; then
    echo "Privilèges accordés à l'utilisateur 'lsall' sur la table 'orders'."
else
    echo "Erreur lors de l'octroi des privilèges à l'utilisateur 'lsall' sur la table 'orders'."
fi

# Octroi des privilèges sur la séquence orders_id_seq
echo "Octroi des privilèges à l'utilisateur 'lsall' sur la séquence 'orders_id_seq'..."
if sudo -u postgres psql -d orders -c "GRANT ALL PRIVILEGES ON SEQUENCE orders_id_seq TO lsall;" 2>/dev/null; then
    echo "Privilèges accordés à l'utilisateur 'lsall' sur la séquence 'orders_id_seq'."
else
    echo "Erreur lors de l'octroi des privilèges à l'utilisateur 'lsall' sur la séquence 'orders_id_seq'."
fi

# Installation de RabbitMQ
if ! command -v rabbitmqctl > /dev/null 2>&1; then
    echo "Installation de RabbitMQ..."
    sudo apt install -y rabbitmq-server
    sudo systemctl enable rabbitmq-server
fi

# Démarrage du service RabbitMQ
echo "Démarrage du service RabbitMQ..."
sudo service rabbitmq-server start

# Installation de Node.js et PM2
if ! command -v node > /dev/null 2>&1; then
    echo "Installation de Node.js..."
    curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
    sudo apt-get install -y nodejs
fi

if ! command -v pm2 > /dev/null 2>&1; then
    echo "Installation de PM2..."
    sudo npm install -g pm2
fi

# Chemin de l'application de facturation
APP_DIR="/home/vagrant/billing-app"

# Installation des dépendances
echo "Installation des dépendances de l'application de facturation..."
cd "$APP_DIR" || { echo "Erreur : Impossible de changer de répertoire vers $APP_DIR"; exit 1; }
if npm install; then
    echo "Dépendances installées avec succès."
else
    echo "Erreur : L'installation des dépendances a échoué."
    exit 1
fi

# Démarrage de l'application
echo "Démarrage de l'application avec PM2..."
if pm2 start server.js --name billing-app; then
    echo "Application démarrée avec succès."
else
    echo "Erreur : Échec du démarrage de l'application."
    exit 1
fi

pm2 startup
pm2 save

echo "Provisionnement de l'application de facturation terminé."
