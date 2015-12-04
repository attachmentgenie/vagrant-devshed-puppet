# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

###############################################################################
# Base box                                                                    #
###############################################################################
    config.vm.box              = "puppetlabs/centos-6.6-64-puppet"
    config.vm.box_version      = '1.0.1'
    config.vm.box_check_update = false

###############################################################################
# Global plugin settings                                                      #
###############################################################################
    plugins = ["vagrant-hostmanager"]
    plugins.each do |plugin|
      unless Vagrant.has_plugin?(plugin)
        raise plugin << " has not been installed."
      end
    end

    # Configure cached packages to be shared between instances of the same base box.
    if Vagrant.has_plugin?("vagrant-cachier")
      config.cache.scope = :machine
    end

    # When destroying a node, delete the node from the puppetmaster
    if Vagrant.has_plugin?("vagrant-triggers")
      config.trigger.after [:destroy] do
        target = @machine.config.vm.hostname.to_s
        puppetmaster = "puppetmaster"
        if target != puppetmaster
          system("vagrant ssh #{puppetmaster} -c 'sudo /usr/bin/puppet cert clean #{target}'" )
        end
      end
    end

###############################################################################
# Global provisioning settings                                                #
###############################################################################
    env = 'development'
    SCRIPT = "sudo puppet agent -t --environment #{env} --server puppet.testlab.vagrant; echo $?"

###############################################################################
# Global VirtualBox settings                                                  #
###############################################################################
    config.vm.provider 'virtualbox' do |v|
    v.customize [
      'modifyvm', :id,
      '--groups', '/Vagrant/devshed-puppet'
    ]
    end

###############################################################################
# Global /etc/hosts file settings                                             #
###############################################################################
    config.hostmanager.enabled = true
    config.hostmanager.manage_host = true
    config.hostmanager.ignore_private_ip = false
    config.hostmanager.include_offline = true

###############################################################################
# VM definitions                                                              #
###############################################################################
    config.vm.synced_folder ".", "/vagrant", disabled: true
    config.vm.synced_folder ".", "/vagrant", disabled: true
    config.vm.define :puppetca do |puppetca_config|
      config.vm.provider "virtualbox" do |v|
        v.memory = 2048
        v.cpus   = 2
      end
      puppetca_config.vm.host_name = "puppetca.devshed.vagrant"
      puppetca_config.vm.network :forwarded_port, guest: 22, host: 24230
      puppetca_config.vm.network :private_network, ip: "192.168.242.130"
      puppetca_config.vm.synced_folder 'manifests/', "/etc/puppet/environments/#{env}/manifests"
      puppetca_config.vm.synced_folder 'modules/', "/etc/puppet/environments/#{env}/modules"
      puppetca_config.vm.synced_folder 'hiera/', '/var/lib/hiera'
      puppetca_config.vm.provision :puppet do |puppet|
          puppet.options           = "--environment #{env} --profile"
          puppet.manifests_path    = "manifests"
          puppet.manifest_file     = ""
          puppet.module_path       = "modules"
          puppet.hiera_config_path = "files/hiera.yaml"
      end
    end

    config.vm.define :node do |node_config|
      node_config.vm.host_name = "node.devshed.vagrant"
      node_config.vm.network :forwarded_port, guest: 22, host: 24240
      node_config.vm.network :private_network, ip: "192.168.242.140"
      node_config.vm.provision :puppet_server do |puppet|
        puppet.options = "-t --environment #{env}"
        puppet.puppet_server = "puppetca.devshed.vagrant"
      end
    end
end