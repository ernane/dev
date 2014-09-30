# Class: nginx
#
#
class nginx {
  # resources

  $lsbdistcodename = 'trusty'

   Exec {
      path => ["/usr/bin", "/bin", "/usr/sbin", "/sbin", "/usr/local/bin", "/usr/local/sbin"]
   }

  # exec { "apt-key":
  #   command => "apt-key adv --keyserver keyserver.ubuntu.com --recv-keys ABF5BD827BD9BF62",
  #    unless => "service nginx status",
  #   require => Exec["apt-update"],
  # }

  # exec { "trusty-nginx":
  #   command => "echo 'deb http://nginx.org/packages/ubuntu/ trusty nginx' >> /etc/apt/sources.list",
  #    unless => "service nginx status",
  #   require => Exec["apt-key"],
  # }

  exec { "add-apt-repository ppa:nginx/stable && apt-get update":
      alias => "nginx_repository",
    require => Package["python-software-properties"],
    creates => "/etc/apt/sources.list.d/nginx-stable-${lsbdistcodename}.list",
  }

  # exec { "update-nginx":
  #   command => "apt-get update",
  #   require => Exec["trusty-nginx"],
  # }

  package { "python-software-properties":
    ensure => installed,
  }

  if ! defined(Package['nginx']) {
    package { 'nginx':
       ensure => 'present',
      require => Exec["nginx_repository"],
    }
  }

  service { 'nginx':
    enable => 'true',
    ensure => 'running',
   require => Package['nginx'],
  }

  # Add a vhost template
  file { 'nginx-vhost':
    path    => '/etc/nginx/sites-available/homologacao.conf',
    ensure  => file,
    require => Package['nginx'],
    source  => 'puppet:///modules/nginx/homologacao.conf',
  }

  file { "/etc/nginx/nginx.conf":
    ensure  => file,
    owner   => "root",
    group   => "root",
    mode    => 0644,
    source  => "puppet:///modules/nginx/nginx.conf",
    require => Package["nginx"],
    notify  => Service["nginx"]
  }

  # Disable the default nginx vhost
  file { 'default-nginx-disable':
       path => '/etc/nginx/sites-enabled/default',
     ensure => absent,
    require => Package['nginx'],
  }


   # Symlink our vhost in sites-enabled to enable it
  file { 'vagrant-nginx-enable':
       path => '/etc/nginx/sites-enabled/homologacao.conf',
     target => '/etc/nginx/sites-available/homologacao.conf',
     ensure => link,
     notify => Service['nginx'],
    require => [
      File['nginx-vhost'],
      File['default-nginx-disable'],
    ],
  }


}
