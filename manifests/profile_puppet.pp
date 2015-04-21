class profile_puppet (
  $allow_any_crl_auth    = false,
  $puppetmaster          = undef,
  $server                = false,
  $server_ca             = true,
  $server_ca_proxy       = undef,
  $server_puppetdb_host  = undef,
) {
  class { '::puppet':
    allow_any_crl_auth          => $allow_any_crl_auth,
    puppetmaster                => $puppetmaster,
    server                      => $server,
    server_ca                   => $server_ca,
    server_ca_proxy             => $server_ca_proxy,
    server_external_nodes       => '',
    server_foreman              => false,
    server_puppetdb_host        => $server_puppetdb_host,
    server_reports              => 'store, puppetdb',
    runmode                     => 'none',
    server_storeconfigs_backend => 'puppetdb',
  }
}