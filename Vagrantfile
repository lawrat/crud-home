Vagrant.configure("2") do |config|
    config.vm.define "gateway-vm" do |gateway|
      gateway.vm.box = "ubuntu/bionic64"
      gateway.vm.network "forwarded_port", guest: 4000, host: 4000
      gateway.vm.provision "shell", path: "scripts/gateway_setup.sh"
    end
  
    config.vm.define "inventory-vm" do |inventory|
      inventory.vm.box = "ubuntu/bionic64"
      inventory.vm.network "forwarded_port", guest: 8080, host: 8080
      inventory.vm.provision "shell", path: "scripts/inventory_setup.sh"
    end
  
    config.vm.define "billing-vm" do |billing|
      billing.vm.box = "ubuntu/bionic64"
      billing.vm.network "forwarded_port", guest: 3000, host: 3000
      billing.vm.provision "shell", path: "scripts/billing_setup.sh"
    end
  end
  