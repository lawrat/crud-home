#!/bin/bash

# Arrêter le script en cas d'erreur
set -e

# Mise à jour des packages
echo "Mise à jour des packages..."
sudo apt-get update

# Installation de PostgreSQL
if ! command -v psql > /dev/null 2>&1; then
    echo "Installation de PostgreSQL..."
    sudo apt-get install -y postgresql postgresql-contrib
else
    echo "PostgreSQL est déjà installé."
fi

# Démarrage du service PostgreSQL
echo "Démarrage du service PostgreSQL..."
sudo service postgresql start

# Connexion et création de la base de données
echo "Création de la base de données movies..."
if sudo -u postgres psql -c "CREATE DATABASE movies;" 2>/dev/null; then
    echo "Base de données 'movies' créée avec succès."
else
    echo "Erreur lors de la création de la base de données 'movies'."
fi

echo "Création de l'utilisateur lsall..."
if sudo -u postgres psql -c "CREATE USER lsall WITH PASSWORD 'lsall2024';" 2>/dev/null; then
    echo "Utilisateur 'lsall' créé avec succès."
else
    echo "Erreur lors de la création de l'utilisateur 'lsall'. Vérifiez s'il existe déjà."
fi

echo "Octroi des privilèges à l'utilisateur lsall sur la base de données movies..."
if sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE movies TO lsall;" 2>/dev/null; then
    echo "Privilèges accordés à l'utilisateur 'lsall' avec succès."
else
    echo "Erreur lors de l'octroi des privilèges à l'utilisateur 'lsall'."
fi

# Création de la table movies si elle n'existe pas
echo "Création de la table movies si elle n'existe pas..."
if sudo -u postgres psql -d movies -c "CREATE TABLE IF NOT EXISTS movies (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT
);" 2>/dev/null; then
    echo "Table 'movies' créée avec succès ou elle existe déjà."
else
    echo "Erreur lors de la création de la table 'movies'."
fi

# Octroi des privilèges à l'utilisateur 'lsall' sur la table 'movies'
echo "Octroi des privilèges à l'utilisateur lsall sur la table movies..."
if sudo -u postgres psql -d movies -c "GRANT ALL PRIVILEGES ON TABLE movies TO lsall;" 2>/dev/null; then
    echo "Privilèges accordés à l'utilisateur 'lsall' sur la table 'movies' avec succès."
else
    echo "Erreur lors de l'octroi des privilèges à l'utilisateur 'lsall' sur la table 'movies'."
fi

# Octroi des privilèges sur la séquence movies_id_seq
echo "Octroi des privilèges à l'utilisateur 'lsall' sur la séquence 'movies_id_seq'..."
if sudo -u postgres psql -d movies -c "GRANT ALL PRIVILEGES ON SEQUENCE movies_id_seq TO lsall;" 2>/dev/null; then
    echo "Privilèges accordés à l'utilisateur 'lsall' sur la séquence 'movies_id_seq'."
else
    echo "Erreur lors de l'octroi des privilèges à l'utilisateur 'lsall' sur la séquence 'movies_id_seq'."
fi

# Vérifier si Node.js est déjà installé
if ! command -v node > /dev/null 2>&1; then
    echo "Installation de Node.js et npm..."
    curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
    sudo apt-get install -y nodejs
else
    echo "Node.js est déjà installé."
fi

# Vérifier si PM2 est déjà installé
if ! command -v pm2 > /dev/null 2>&1; then
    echo "Installation de PM2..."
    sudo npm install -g pm2
else
    echo "PM2 est déjà installé."
fi

# Chemin du dossier de l'application d'inventaire
APP_DIR="/home/vagrant/inventory-app"

# Vérifier si le dossier inventory-app existe
if [ ! -d "$APP_DIR" ]; then
    echo "Erreur : Le dossier $APP_DIR n'existe pas. Assurez-vous qu'il est synchronisé correctement."
    exit 1
fi

# Installation des dépendances de l'application
echo "Installation des dépendances de l'application d'inventaire..."
cd "$APP_DIR" || { echo "Erreur : Impossible de changer de répertoire vers $APP_DIR"; exit 1; }
if npm install; then
    echo "Dépendances installées avec succès."
else
    echo "Erreur : L'installation des dépendances a échoué."
    exit 1
fi

# Démarrer l'application avec PM2
echo "Démarrage de l'application avec PM2..."
if [ -f "server.js" ]; then
    if pm2 start server.js --name inventory-app; then
        echo "Application démarrée avec succès."
    else
        echo "Erreur : Échec du démarrage de l'application."
        exit 1
    fi
else
    echo "Erreur : Le fichier server.js n'existe pas dans $APP_DIR."
    exit 1
fi

sudo env PATH=$PATH:/usr/bin /usr/lib/node_modules/pm2/bin/pm2 startup systemd -u vagrant --hp /home/vagrant
pm2 startup
pm2 save
echo "Provisionnement de l'application d'inventaire terminé avec succès."
