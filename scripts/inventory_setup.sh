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

# Créer le dossier pour l'application Inventory si nécessaire
echo "Création du dossier pour l'application Inventory..."
if [ ! -d "/home/vagrant/inventory-app" ]; then
    mkdir /home/vagrant/inventory-app
    echo "Dossier /home/vagrant/inventory-app créé."
else
    echo "Le dossier /home/vagrant/inventory-app existe déjà."
fi

# Copier le code de l'API Inventory
echo "Copie du code de l'API Inventory..."
if [ -d "./srcs/inventory-app" ]; then
    cp -r ./srcs/inventory-app/* /home/vagrant/inventory-app
else
    echo "Erreur : Le répertoire ./srcs/inventory-app n'existe pas."
    exit 1
fi

# Installer les dépendances de l'API Inventory
echo "Installation des dépendances de l'API Inventory..."
cd /home/vagrant/inventory-app || { echo "Erreur : Impossible de changer de répertoire vers /home/vagrant/inventory-app"; exit 1; }
npm install

# Démarrer l'application avec PM2
echo "Démarrage de l'application avec PM2..."
if [ -f "server.js" ]; then
    pm2 start server.js --name "inventory-app"
else
    echo "Erreur : Le fichier server.js n'existe pas dans /home/vagrant/inventory-app."
    exit 1
fi

echo "Provisionnement terminé."
