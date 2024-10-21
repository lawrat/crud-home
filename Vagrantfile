Vagrant.configure("2") do |config|

  # Configuration de la machine gateway-vm
  config.vm.define "gateway-vm" do |gateway|
    gateway.vm.box = "ubuntu/bionic64"
    
    # Redirection de port : le port 4000 de la VM vers le port 4000 de l'hôte
    gateway.vm.network "forwarded_port", guest: 4000, host: 4000
    
    # Dossier synchronisé 
    gateway.vm.synced_folder "./srcs/api-gateway", "/home/vagrant/api-gateway"
    
    # Adresse IP privée pour la communication entre les machines
    gateway.vm.network "private_network", ip: "192.168.56.10"
    
    # Allocation des ressources : 2 CPU et 1 Go de RAM
    gateway.vm.provider "virtualbox" do |vb|
      vb.memory = 1024
      vb.cpus = 2
    end
    
    # Script de provisionnement pour installer les dépendances et démarrer le service
    gateway.vm.provision "shell", path: "./scripts/gateway_setup.sh"
  end

  # Configuration de la machine inventory-vm
  config.vm.define "inventory-vm" do |inventory|
    inventory.vm.box = "ubuntu/bionic64"
    
    # Redirection de port : le port 8080 de la VM vers le port 8080 de l'hôte
    inventory.vm.network "forwarded_port", guest: 8080, host: 8080
    
    # Dossier synchronisé 
    inventory.vm.synced_folder "./srcs/inventory-app", "/home/vagrant/inventory-app"
    
    # Adresse IP privée pour la communication entre les machines
    inventory.vm.network "private_network", ip: "192.168.56.11"
    
    # Allocation des ressources : 2 CPU et 1 Go de RAM
    inventory.vm.provider "virtualbox" do |vb|
      vb.memory = 1024
      vb.cpus = 2
    end
    
    # Script de provisionnement pour installer les dépendances et démarrer le service
    inventory.vm.provision "shell", path: "./scripts/inventory_setup.sh"
  end

  # Configuration de la machine billing-vm
  config.vm.define "billing-vm" do |billing|
    billing.vm.box = "ubuntu/bionic64"
    
    # Redirection de port : le port 3000 de la VM vers le port 3000 de l'hôte
    billing.vm.network "forwarded_port", guest: 3000, host: 3000
    
    # Dossier synchronisé 
    billing.vm.synced_folder "./srcs/billing-app", "/home/vagrant/billing-app"
    
    # Adresse IP privée pour la communication entre les machines
    billing.vm.network "private_network", ip: "192.168.56.12"
    
    # Allocation des ressources : 2 CPU et 1 Go de RAM
    billing.vm.provider "virtualbox" do |vb|
      vb.memory = 1024
      vb.cpus = 2
    end
    
    # Script de provisionnement pour installer les dépendances et démarrer le service
    billing.vm.provision "shell", path: "./scripts/billing_setup.sh"
  end

  # Plugin pour configurer le démarrage automatique de VirtualBox Guest Additions
  if Vagrant.has_plugin?("vagrant-vbguest")
    config.vbguest.auto_update = true
  end
end
