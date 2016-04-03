# Use hiera as a ENC
hiera_include('classes',[''])

# Set some general wisdoms
Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }

Package {
  allow_virtual => true,
}

# Create and register a local rpm repo.
createrepo { 'localhost':
  repository_dir => '/vagrant/repo',
  repo_cache_dir => '/var/cache/localhost',
  repo_group     => 'vagrant',
  repo_owner     => 'vagrant',
} ->
yumrepo { 'localhost':
  enabled  => 1,
  descr    => 'Local repo holding rpm packages',
  baseurl  => 'file:///vagrant/repo',
  gpgcheck => 0,
}

# Set the system up for puppet development.
package { 'puppet-lint':
  ensure   => 'present',
  provider => 'gem',
}