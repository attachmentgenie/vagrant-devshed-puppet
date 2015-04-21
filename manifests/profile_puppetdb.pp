class profile_puppetdb () {
  class { '::puppetdb':
    listen_address     => '0.0.0.0',
    manage_firewall    => false,
    ssl_listen_address => '0.0.0.0',
  }
  class { '::puppetdb::master::config':
    manage_storeconfigs => false,
    puppetdb_server     => $::fqdn,
    restart_puppet      => false,
  }
}
