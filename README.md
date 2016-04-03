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
    
## Puppet Development

### Hiera

the puppet master deploys a fairly default hiera.yaml

    [vagrant@puppetmaster ~]$ cat /etc/puppet/hiera.yaml 
    ---
    # Managed by puppet
    :backends:
      - yaml
    :hierarchy:
      - "node/%{::hostname}"
      - "environment/%{::environment}"
      - "common"
    :yaml:
      :datadir: "/var/lib/hiera"

### Manifests

Place your own manifests in this directory. A fairly standard default.pp is already present which also creates and registers
a local yum repository called 'localhost'

### Modules

Place your own modules in this directory. 2 modules are alreayd present which are required to create the local repository, one 
of which is the much used stdlib.

### Repo

Place rpms you wish to provide to your systems in this directory. this provides a light weight way of not having to do local rpm installs
but not having to setup your full blown rpm repo.

After placing a (new) rpm, the metadata needs to be generated.

    createrepo-update-localhost
