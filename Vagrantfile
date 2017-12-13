# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrant.configure version 2.
Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/xenial64"

  # -----------------------------------------------------------------------------------------------
  # Port forwarding
  # -----------------------------------------------------------------------------------------------

  # Django port
  config.vm.network :forwarded_port, host: 8080, guest: 8080
  # AngularJS port
  config.vm.network :forwarded_port, host: 4200, guest: 4200

  # -----------------------------------------------------------------------------------------------
  # Virtual Box Settings (Docs: Docs: http://docs.vagrantup.com/v2/virtualbox/configuration.html)
  # -----------------------------------------------------------------------------------------------
  config.vm.provider "virtualbox" do |vb|
   vb.gui = false
   vb.memory = "2000"
   vb.name = "EGMA Dev Environment"
   vb.cpus = 2
  end

  # -----------------------------------------------------------------------------------------------
  # Shell provisioning (Docs: http://docs.vagrantup.com/v2/provisioning/shell.html)
  # -----------------------------------------------------------------------------------------------
  config.vm.provision "shell", path: "bootstrap.sh"
  # config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"
end
