class role_proxy () {
  class { '::profile_ntp': }
  class { '::profile_firewall': } ->
  class { '::profile_haproxy': }
}