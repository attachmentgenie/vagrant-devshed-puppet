class profile_puppetdb () {
  class { '::puppetdb':
    ssl_listen_address => '0.0.0.0',
    manage_firewall    => false,
  }
  class { '::puppetdb::master::config':
    manage_storeconfigs => false,
    puppetdb_server     => $::fqdn,
    restart_puppet      => false,
  }
}
