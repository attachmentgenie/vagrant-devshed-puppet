class profile_puppetagent (
  $puppetmaster      = 'puppet',
) {
  class { '::puppet':
    puppetmaster      => $puppetmaster,
    server            => false,
  }
}