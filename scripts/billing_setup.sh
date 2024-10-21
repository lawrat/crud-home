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

# Création de l'utilisateur lsall dans RabbitMQ
echo "Création de l'utilisateur 'lsall' dans RabbitMQ..."
if sudo rabbitmqctl list_users | grep -q "lsall"; then
    echo "L'utilisateur 'lsall' existe déjà dans RabbitMQ."
else
    sudo rabbitmqctl add_user lsall lsall2024
    echo "Utilisateur 'lsall' créé avec succès dans RabbitMQ."
fi

# Octroi des permissions à l'utilisateur lsall sur le vhost par défaut (/)
echo "Octroi des permissions à l'utilisateur 'lsall' sur le vhost par défaut dans RabbitMQ..."
sudo rabbitmqctl set_user_tags lsall administrator
sudo rabbitmqctl set_permissions -p / lsall ".*" ".*" ".*"

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

# Chemin du dossier de l'application d'inventaire
APP_DIR="/home/vagrant/billing-app"

# Vérifier si le dossier billing-app existe
if [ ! -d "$APP_DIR" ]; then
    echo "Erreur : Le dossier $APP_DIR n'existe pas. Assurez-vous qu'il est synchronisé correctement."
    exit 1
fi

# Changer la propriété des fichiers pour l'utilisateur vagrant
echo "Changement de propriété des fichiers pour l'utilisateur vagrant..."
sudo chown -R vagrant:vagrant "$APP_DIR"

# Exécution des commandes en tant qu'utilisateur vagrant
sudo -u vagrant -H bash << EOF

# Installation des dépendances de l'application
echo "Installation des dépendances de l'application de facturation..."
cd "$APP_DIR" || { echo "Erreur : Impossible de changer de répertoire vers $APP_DIR"; exit 1; }
npm install || { echo "Erreur : L'installation des dépendances a échoué."; exit 1; }

# Démarrer l'application avec PM2 sous l'utilisateur vagrant
echo "Démarrage de l'application avec PM2..."
if [ -f "server.js" ]; then
    pm2 start server.js --name billing-app || { echo "Erreur : Échec du démarrage de l'application."; exit 1; }
else
    echo "Erreur : Le fichier server.js n'existe pas dans $APP_DIR."
    exit 1
fi

# Enregistrer PM2 pour redémarrer automatiquement au reboot
pm2 save
pm2 startup | sudo tee /dev/null > /dev/null
sudo env PATH=\$PATH:/usr/bin pm2 startup systemd -u vagrant --hp /home/vagrant || { echo "Erreur : PM2 n'a pas pu être configuré pour redémarrer automatiquement."; exit 1; }

EOF

echo "Provisionnement de l'application d'inventaire terminé avec succès."
