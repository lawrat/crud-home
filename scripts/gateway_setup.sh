#!/bin/bash

# Arrêter le script en cas d'erreur
set -e

# Mise à jour des packages
echo "Mise à jour des packages..."
sudo apt-get update

# Installation de RabbitMQ
if ! command -v rabbitmqctl > /dev/null 2>&1; then
    echo "Installation de RabbitMQ..."
    sudo apt install -y rabbitmq-server
    sudo systemctl enable rabbitmq-server
fi

# Démarrage du service RabbitMQ
echo "Démarrage du service RabbitMQ..."
sudo service rabbitmq-server start


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

# Vérifier si le dossier de l'application existe
if [ ! -d "$APP_DIR" ]; then
    echo "Erreur : Le dossier $APP_DIR n'existe pas. Veuillez vérifier le chemin."
    exit 1
fi

# Changer la propriété des fichiers pour l'utilisateur vagrant
echo "Changement de propriété des fichiers pour l'utilisateur vagrant..."
sudo chown -R vagrant:vagrant /home/vagrant/api-gateway

# Exécution des commandes en tant qu'utilisateur vagrant
sudo -u vagrant -H bash << EOF

# Installation des dépendances de l'application
cd "$APP_DIR"
echo "Installation des dépendances de l'application..."
npm install express http-proxy-middleware dotenv amqplib node-fetch@2 cors body-parser || { echo "Erreur : L'installation des dépendances a échoué."; exit 1; }

# Démarrer l'application avec PM2 sous l'utilisateur vagrant
echo "Démarrage de l'application avec PM2..."
pm2 start server.js --name api-gateway || { echo "Erreur : Échec du démarrage de l'application."; exit 1; }

# Enregistrer PM2 pour redémarrer automatiquement au reboot
pm2 save
pm2 startup | sudo tee /dev/null > /dev/null
sudo env PATH=\$PATH:/usr/bin pm2 startup systemd -u vagrant --hp /home/vagrant || { echo "Erreur : PM2 n'a pas pu être configuré pour redémarrer automatiquement."; exit 1; }

EOF

echo "L'application de passerelle API a été démarrée avec succès sous l'utilisateur vagrant."
