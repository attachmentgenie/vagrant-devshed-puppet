# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

###############################################################################
# Base box                                                                    #
###############################################################################
    config.vm.box = "puppetlabs/centos-6.6-64-puppet"

###############################################################################
# Global plugin settings                                                #
###############################################################################
    unless Vagrant.has_plugin?("vagrant-hostmanager")
      raise 'vagrant-hostmanager is not installed!'
    end

###############################################################################
# Global provisioning settings                                                #
###############################################################################
    default_env = 'production'
    ext_env = ENV['VAGRANT_PUPPET_ENV']
    env = ext_env ? ext_env : default_env

###############################################################################
# Global VirtualBox settings                                                  #
###############################################################################
    config.vm.provider 'virtualbox' do |v|
    v.customize [
      'modifyvm', :id,
      '--groups', '/Vagrant/foreman'
    ]
    end

###############################################################################
# Global /etc/hosts file settings                                                  #
###############################################################################
    config.hostmanager.enabled = true
    config.hostmanager.manage_host = true
    config.hostmanager.ignore_private_ip = false
    config.hostmanager.include_offline = true

###############################################################################
# VM definitions                                                              #
###############################################################################

    config.vm.define :puppet do |puppet_config|
      puppet_config.vm.host_name = "puppet.foreman.vagrant"
      puppet_config.vm.network :private_network, ip: "192.168.21.130"
      puppet_config.vm.synced_folder 'manifests/', "/etc/puppet/environments/#{env}/manifests"
      puppet_config.vm.synced_folder 'modules/', "/etc/puppet/environments/#{env}/modules"
      puppet_config.vm.synced_folder 'hiera/', '/var/lib/hiera'
      puppet_config.vm.provision :shell, inline: 'sudo cp /vagrant/files/hiera.yaml /etc/puppet/hiera.yaml'
      puppet_config.vm.provision :shell, inline: 'sudo cp /vagrant/files/autosign.conf /etc/puppet/autosign.conf'
      puppet_config.vm.provision :puppet do |puppet|
          puppet.options = "--environment #{env}"
          puppet.manifests_path = "manifests"
          puppet.manifest_file  = ""
          puppet.module_path = "modules"
          puppet.hiera_config_path = "files/hiera.yaml"
      end
    end

    config.vm.define :puppetmaster do |puppetmaster_config|
      puppetmaster_config.vm.host_name = "puppetmaster.foreman.vagrant"
      puppetmaster_config.vm.network :forwarded_port, guest: 22, host: 2140
      puppetmaster_config.vm.network :private_network, ip: "192.168.21.140"
      puppetmaster_config.vm.synced_folder 'manifests/', "/etc/puppet/environments/#{env}/manifests"
      puppetmaster_config.vm.synced_folder 'modules/', "/etc/puppet/environments/#{env}/modules"
      puppetmaster_config.vm.synced_folder 'hiera/', '/var/lib/hiera'
      puppetmaster_config.vm.provision :shell, inline: 'sudo cp /vagrant/files/hiera.yaml /etc/puppet/hiera.yaml'
      puppetmaster_config.vm.provision 'shell', inline: "sudo puppet agent -t --environment #{env}; echo $?"
    end

    config.vm.define :proxy do |proxy_config|
      proxy_config.vm.host_name = "proxy.foreman.vagrant"
      proxy_config.vm.network :forwarded_port, guest: 22, host: 2150
      proxy_config.vm.network :private_network, ip: "192.168.21.150"
      proxy_config.vm.synced_folder 'manifests/', "/etc/puppet/environments/#{env}/manifests"
      proxy_config.vm.synced_folder 'modules/', "/etc/puppet/environments/#{env}/modules"
      proxy_config.vm.synced_folder 'hiera/', '/var/lib/hiera'
      proxy_config.vm.provision :shell, inline: 'sudo cp /vagrant/files/hiera.yaml /etc/puppet/hiera.yaml'
      proxy_config.vm.provision 'shell', inline: "sudo puppet agent -t --environment #{env}; echo $?"
    end

    config.vm.define :node do |node_config|
      node_config.vm.host_name = "node.foreman.vagrant"
      node_config.vm.network :forwarded_port, guest: 22, host: 2160
      node_config.vm.network :private_network, ip: "192.168.21.160"
      node_config.vm.provision 'shell', inline: "sudo puppet agent -t --environment #{env} --server proxy.foreman.vagrant; echo $?"
    end
end
