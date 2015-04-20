class profile_puppetca () {
  class { '::puppet':
    puppetmaster                 => $::fqdn,
    server                       => true,
    server_external_nodes        => '',
    server_foreman               => false,
    server_reports               => 'store, puppetdb',
    server_storeconfigs_backend  => 'puppetdb',
  }
}