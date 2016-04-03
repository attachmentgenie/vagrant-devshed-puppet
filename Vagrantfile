# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
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
  # Global Node list                                                            #
  ###############################################################################
  require 'yaml'
  if File.file?('nodes.yaml')
    nodes = YAML.load_file('nodes.yaml')
  elsif File.file?('nodes.yaml.dist')
    nodes = YAML.load_file('nodes.yaml.dist')
  end

  ###############################################################################
  # Global provisioning settings                                                #
  ###############################################################################
  env = 'production'

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
  config.vm.define :puppetmaster do |puppetmaster_config|
    config.vm.provider "virtualbox" do |v|
      v.memory = 2048
      v.cpus   = 2
    end
    puppetmaster_config.vm.box              = "puppetlabs/centos-6.6-64-puppet"
    puppetmaster_config.vm.box_version      = '1.0.1'
    puppetmaster_config.vm.box_check_update = false
    puppetmaster_config.vm.host_name        = "puppetmaster.devshed.vagrant"
    puppetmaster_config.vm.network :forwarded_port, guest: 22, host: 24230
    puppetmaster_config.vm.network :private_network, ip: "192.168.42.130"
    puppetmaster_config.vm.synced_folder 'devshed/', "/devshed"
    puppetmaster_config.vm.synced_folder 'manifests/', "/etc/puppet/environments/#{env}/manifests"
    puppetmaster_config.vm.synced_folder 'modules/', "/etc/puppet/environments/#{env}/modules"
    puppetmaster_config.vm.synced_folder 'hiera/', '/var/lib/hiera'
    puppetmaster_config.vm.provision :puppet do |puppet|
      puppet.options           = "--environment #{env} --profile"
      puppet.manifests_path    = "devshed/manifests"
      puppet.manifest_file     = ""
      puppet.module_path       = "devshed/modules"
      puppet.hiera_config_path = "devshed/hiera.yaml"
    end
  end

  nodes.each do |node|
    config.vm.define node["name"] do |srv|
      srv.vm.box                = node["box"]
      if node["box_version"]
        srv.vm.box_version      = node["box_version"]
      end
      if node["box_check_update"]
        srv.vm.box_check_update = node["box_check_update"]
      end
      srv.vm.hostname           = node["hostname"]
      if node["ports"]
        node["ports"].each do |port|
          srv.vm.network :forwarded_port, guest: port["guest"], host: port["host"]
        end
      end
      srv.vm.network :private_network, ip: node["ip"]
      if node["synced_folders"]
        node["synced_folders"].each do |folder|
          srv.vm.synced_folder folder["src"], folder["dst"]
        end
      end
      srv.vm.provision :puppet_server do |puppet|
        puppet.options = "-t --environment #{env}"
        puppet.puppet_server = "puppetmaster.devshed.vagrant"
      end
    end
  end
end
