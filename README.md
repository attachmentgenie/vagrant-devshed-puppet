# Creating a disposable test environment

## Requirements
    Virtualbox       => https://www.virtualbox.org
    Vagrant          => http://www.vagrantup.com
    librarian-puppet => gem install librarian-puppet

## Setup
    librarian-puppet install
    vagrant up
    vagrant ssh puppet
    sudo puppet cert clean puppetmaster.foreman.vagrant
    exit
    vagrant ssh puppetmaster
    sudo rm -rf /var/lib/puppet/ssl
    exit
    vagrant provision puppetmaster
    vagrant ssh puppet
    sudo puppet cert --allow-dns-alt-names sign puppetmaster.foreman.vagrant
    exit
    vagrant provision puppetmaster
    vagrant ssh puppetmaster
    sudo /etc/init.d/httpd restart
    exit
    vagrant provision node
    
## Interfaces

### puppetdb

http://192.168.21.130:8080
