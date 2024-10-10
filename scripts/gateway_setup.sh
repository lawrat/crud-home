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

# Créer le dossier pour l'application API Gateway si nécessaire
echo "Création du dossier pour l'application API Gateway..."
if [ ! -d "/home/vagrant/api-gateway" ]; then
    mkdir /home/vagrant/api-gateway
    echo "Dossier /home/vagrant/api-gateway créé."
else
    echo "Le dossier /home/vagrant/api-gateway existe déjà."
fi

# Copier le code de l'API Gateway
echo "Copie du code de l'API Gateway..."
if [ -d "./srcs/api-gateway" ]; then
    cp -r ./srcs/api-gateway/* /home/vagrant/api-gateway
else
    echo "Erreur : Le répertoire ./srcs/api-gateway n'existe pas."
    exit 1
fi

# Installer les dépendances de l'API Gateway
echo "Installation des dépendances de l'API Gateway..."
cd /home/vagrant/api-gateway || { echo "Erreur : Impossible de changer de répertoire vers /home/vagrant/api-gateway"; exit 1; }
npm install

# Démarrer l'application avec PM2
echo "Démarrage de l'application avec PM2..."
if [ -f "server.js" ]; then
    pm2 start server.js --name "api-gateway"
else
    echo "Erreur : Le fichier server.js n'existe pas dans /home/vagrant/api-gateway."
    exit 1
fi

echo "Provisionnement terminé."
