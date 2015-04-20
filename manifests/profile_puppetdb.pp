class profile_puppetdb () {
  class { '::puppetdb':
    listen_address  => $::fqdn,
    manage_firewall => false,
  }
  class { '::puppetdb::master::config':
    restart_puppet      => false,
    manage_storeconfigs => false,
  }
}
