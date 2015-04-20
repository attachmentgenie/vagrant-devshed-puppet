class profile_puppetagent (
  $puppetmaster      = 'puppet',
) {
  class { '::puppet':
    puppetmaster => $puppetmaster,
    runmode      => 'none',
    server       => false,
  }
}