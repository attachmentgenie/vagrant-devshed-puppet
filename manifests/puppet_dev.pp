class puppet_dev {
  package { 'puppet-lint':
    ensure   => 'installed',
    provider => 'gem',
  }
}