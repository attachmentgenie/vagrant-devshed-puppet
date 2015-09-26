# Creating a disposable test environment

## Requirements
    Virtualbox                 => https://www.virtualbox.org
    Vagrant                    => http://www.vagrantup.comva
    vagrant-hostmanager        => vagrant plugin install vagrant-hostmanager
    vagrant-cachier (optional) => vagrant plugin install vagrant-cachier

## Preparation
    git submodule update --init
    
## Setup
    vagrant up puppetca
    login to foreman and change the following settings
    administer, settings, puppetdb, puppetdb_address, puppetdb_dashboard_address, puppetdb_enabled => true
    infrastructure, smart proxies, certificates, autosign entries, new =. *.multimaster.vagrant
    vagrant up  puppetmaster proxy
    vagrant ssh puppetca
    sudo puppet cert clean puppetmaster.multimaster.vagrant
    exit
    vagrant ssh puppetmaster
    sudo rm -rf /var/lib/puppet/ssl
    exit
    vagrant provision puppetmaster
    vagrant ssh puppetca
    sudo puppet cert --allow-dns-alt-names sign puppetmaster.multimaster.vagrant
    exit
    vagrant provision puppetmaster
    vagrant ssh puppetmaster
    sudo /etc/init.d/httpd restart
    exit
    vagrant provision node
    
    foreman  => https://puppetca.multimaster.vagrant
    username: admin
    passwd  : secret
    puppetdb => http://puppetca.multimaster.vagrant:8080
## Interfaces

### puppetdb

http://puppet.multimaster.vagrant:8080
