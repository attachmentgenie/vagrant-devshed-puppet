# Creating a disposable development environment

## Requirements
    Virtualbox                  => https://www.virtualbox.org
    Vagrant                     => http://www.vagrantup.com
    vagrant-hostmanager         => vagrant plugin install vagrant-hostmanager
    vagrant-cachier  (optional) => vagrant plugin install vagrant-cachier
    vagrant-triggers (optional) => vagrant plugin install vagrant-triggers
    
## Preparation
    git submodule update --init
    
## Setup
    vagrant up puppetmaster
    login to foreman and change the following settings
    administer, settings, puppet, enc_environment => false
    administer, settings, puppetdb, puppetdb_address, puppetdb_dashboard_address, puppetdb_enabled => true
    infrastructure, smart proxies, certificates, autosign entries, new =. *.devshed.vagrant
    vagrant up node
    
    foreman  => https://puppetmaster.devshed.vagrant
    username: admin
    passwd  : secret
    puppetdb => http://puppetmaster.devshed.vagrant:8080

## Node definitions

Copy the example file and modify to your needs.

    cp nodes.yaml.dist nodes.yaml