#!/bin/bash

# Mise à jour des packages
echo "Mise à jour des packages..."
sudo apt-get update

# Installer Node.js et npm
echo "Installation de Node.js et npm..."
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt-get install -y nodejs

# Installer PM2
echo "Installation de PM2..."
sudo npm install -g pm2

# Créer le dossier pour l'application Billing si nécessaire
echo "Création du dossier pour l'application Billing..."
if [ ! -d "/home/vagrant/billing-app" ]; then
    mkdir -p /home/vagrant/billing-app
    echo "Dossier /home/vagrant/billing-app créé."
else
    echo "Le dossier /home/vagrant/billing-app existe déjà."
fi

# Copier le code de l'API Billing
echo "Copie du code de l'API Billing..."
if [ -d "./srcs/billing-app" ]; then
    cp -r ./srcs/billing-app/* /home/vagrant/billing-app
else
    echo "Erreur : Le répertoire ./srcs/billing-app n'existe pas."
    exit 1
fi

# Installer les dépendances de l'API Billing
echo "Installation des dépendances de l'API Billing..."
cd /home/vagrant/billing-app || { echo "Erreur : Impossible de changer de répertoire vers /home/vagrant/billing-app"; exit 1; }
npm install

# Démarrer l'application avec PM2
echo "Démarrage de l'application avec PM2..."
if [ -f "server.js" ]; then
    pm2 start server.js --name "billing-app"
else
    echo "Erreur : Le fichier server.js n'existe pas dans /home/vagrant/billing-app."
    exit 1
fi

echo "Provisionnement terminé avec succès."
