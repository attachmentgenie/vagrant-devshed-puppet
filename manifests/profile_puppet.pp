class profile_puppet (
  $allow_any_crl_auth    = false,
  $dns_alt_names         = [],
  $puppetmaster          = undef,
  $server                = false,
  $server_ca             = true,
  $server_ca_proxy       = undef,
  $server_puppetdb_host  = undef,
) {
  class { '::puppet':
    allow_any_crl_auth          => $allow_any_crl_auth,
    dns_alt_names               => $dns_alt_names,
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
  if !$server_ca {
    @@haproxy::balancermember { "puppetmaster-${::hostname}":
      listening_service => 'puppetmaster',
      server_names      => $::hostname,
      ipaddresses       => $::ipaddress_eth1,
      ports             => '8140',
      options           => 'check',
    }
  }
}