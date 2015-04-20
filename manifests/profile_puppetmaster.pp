class profile_puppetmaster (
  $ca_server    = 'puppet',
  $certname     = 'puppet',
  $puppetdb     = 'puppet',
  $puppetmaster = 'puppet',
) {
  class { '::puppet':
    puppetmaster                => $puppetmaster,
    server                      => true,
    server_ca                   => false,
    server_ca_proxy             => "https://${ca_server}:8140",
    server_external_nodes       => '',
    server_foreman              => false,
    server_puppetdb_host        => $puppetdb,
    server_reports              => 'store, puppetdb',
    runmode                     => 'none',
    server_storeconfigs_backend => 'puppetdb',
  }
}