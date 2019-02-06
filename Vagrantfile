# encoding: utf-8
# -*- mode: ruby -*-
# vi: set ft=ruby :

# Box / OS
VAGRANT_BOX = 'ubuntu/trusty64'

# Memorable name for your
VM_NAME = 'Dspace2'

# VM User — 'vagrant' by default
VM_USER = 'vagrant'

# Username on your Mac
MAC_USER = 'anaperez'

# Host folder to sync
#HOST_PATH = '/home/' + MAC_USER + '/' + VM_NAME

# Where to sync to on Guest — 'vagrant' is the default user name
#GUEST_PATH = '/home/' + VM_USER + '/' + VM_NAME

# # VM Port — uncomment this to use NAT instead of DHCP
# VM_PORT = 8080

Vagrant.configure(2) do |config|

  # Vagrant box from Hashicorp
  config.vm.box = VAGRANT_BOX
  
  # Actual machine name
  config.vm.hostname = VM_NAME

  # Set VM name in Virtualbox
  config.vm.provider "virtualbox" do |v|
    v.name = VM_NAME
    v.memory = 2048#change if your computer  not have enougth
    v.cpus = 3
  end
   
  #DHCP — comment this out if planning on using NAT instead
  # config.vm.network "private_network", type: "dhcp"
   # Port forwarding
  config.vm.boot_timeout = 300
 
  config.vm.network :forwarded_port, guest: 3000, host: 3001 
  config.vm.network :forwarded_port, guest: 8080, host: 8080  


  # # Port forwarding — uncomment this to use NAT instead of DHCP
  # config.vm.network "forwarded_port", guest: 80, host: VM_PORT
  # Disable default Vagrant folder, use a unique path per project
  config.vm.synced_folder '.', '/home/'+VM_USER+'', :mount_options => ["dmode=777,fmode=777"]
  # Sync folder






  # Install Docker-ce
   config.vm.provision "shell", privileged: false, run: "once",
  path: "setup/box_setup.sh",
  env: {
    "LC_ALL"   => "en_US.UTF-8",
    "LANG"     => "en_US.UTF-8",
    "LANGUAGE" => "en_US.UTF-8",
  }
end
