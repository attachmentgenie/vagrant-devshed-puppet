# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

###############################################################################
# Base box                                                                    #
###############################################################################
    config.vm.box         = "puppetlabs/centos-6.6-64-puppet"
    config.vm.box_version = '1.0.1'

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

###############################################################################
# Global Provisioning settings                                                #
###############################################################################
    env  = 'production'
    R10K = "r10k deploy environment -pv"

###############################################################################
# Global VirtualBox settings                                                  #
###############################################################################
    config.vm.provider 'virtualbox' do |v|
    v.customize [
      'modifyvm', :id,
      '--groups', '/Vagrant/multi-master'
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
    config.vm.define :puppetca do |puppetca_config|
      config.vm.provider "virtualbox" do |v|
        v.memory = 2048
        v.cpus   = 2
      end
      puppetca_config.vm.host_name = "puppetca.multimaster.vagrant"
      puppetca_config.vm.network :forwarded_port, guest: 22, host: 2130
      puppetca_config.vm.network :private_network, ip: "192.168.43.130"
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

    config.vm.define :puppetmaster do |puppetmaster_config|
      puppetmaster_config.vm.host_name = "puppetmaster.multimaster.vagrant"
      puppetmaster_config.vm.network :forwarded_port, guest: 22, host: 2140
      puppetmaster_config.vm.network :private_network, ip: "192.168.43.140"
      puppetmaster_config.vm.synced_folder 'files/', '/opt/files'
      puppetmaster_config.vm.provision :shell, inline: 'sudo cp /opt/files/hiera.pm.yaml /etc/puppet/hiera.yaml'
      puppetmaster_config.vm.provision :puppet_server do |puppet|
        puppet.options = "-t --environment #{env} --profile"
        puppet.puppet_server = "puppetca.multimaster.vagrant"
      end
      puppetmaster_config.vm.provision :shell, inline: R10K
    end

    config.vm.define :proxy do |proxy_config|
      proxy_config.vm.host_name = "proxy.multimaster.vagrant"
      proxy_config.vm.network :forwarded_port, guest: 22, host: 2150
      proxy_config.vm.network :private_network, ip: "192.168.43.150"
      proxy_config.vm.provision :puppet_server do |puppet|
        puppet.options = "-t --environment #{env}"
        puppet.puppet_server = "puppetca.multimaster.vagrant"
      end
    end

    config.vm.define :node do |node_config|
      node_config.vm.host_name = "node.multimaster.vagrant"
      node_config.vm.network :forwarded_port, guest: 22, host: 2160
      node_config.vm.network :private_network, ip: "192.168.43.160"
      node_config.vm.provision :puppet_server do |puppet|
        puppet.options = "-t --environment #{env}"
        puppet.puppet_server = "proxy.multimaster.vagrant"
      end
    end
end