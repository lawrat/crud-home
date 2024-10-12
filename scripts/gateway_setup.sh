#!/bin/bash

# Arrêter le script en cas d'erreur
set -e

# Mise à jour des packages
echo "Mise à jour des packages..."
sudo apt-get update

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

# Chemin du dossier de l'application de passerelle
APP_DIR="/home/vagrant/api-gateway"

# Vérifier si le dossier api-gateway existe
if [ ! -d "$APP_DIR" ]; then
    echo "Erreur : Le dossier $APP_DIR n'existe pas. Assurez-vous qu'il est synchronisé correctement."
    exit 1
fi

# Installation des dépendances de l'application
echo "Installation des dépendances de l'application de passerelle..."
cd "$APP_DIR" || { echo "Erreur : Impossible de changer de répertoire vers $APP_DIR"; exit 1; }
npm install || { echo "Erreur : L'installation des dépendances a échoué."; exit 1; }

# Démarrer l'application avec PM2
echo "Démarrage de l'application avec PM2..."
if [ -f "server.js" ]; then
    pm2 start server.js --name api-gateway || { echo "Erreur : Échec du démarrage de l'application."; exit 1; }
else
    echo "Erreur : Le fichier server.js n'existe pas dans $APP_DIR."
    exit 1
fi

pm2 startup
pm2 save
echo "Provisionnement de l'application de passerelle terminé avec succès."
