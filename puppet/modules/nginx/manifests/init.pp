# Class: nginx
#
#
class nginx {
  # resources

   Exec {
      path => ["/usr/bin", "/bin", "/usr/sbin", "/sbin", "/usr/local/bin", "/usr/local/sbin"]
   }

  exec { "apt-key":
    command => "apt-key adv --keyserver keyserver.ubuntu.com --recv-keys ABF5BD827BD9BF62",
     unless => "service nginx status",
    require => Exec["apt-update"],
  }

  exec { "trusty-nginx":
    command => "echo 'deb http://nginx.org/packages/ubuntu/ trusty nginx' >> /etc/apt/sources.list",
     unless => "service nginx status",
    require => Exec["apt-key"],
  }

  exec { "update-nginx":
    command => "apt-get update",
    require => Exec["trusty-nginx"],
  }

  if ! defined(Package['nginx']) {
    package { 'nginx':
       ensure => 'present',
      require => Exec["update-nginx"],
    }
  }

  service { 'nginx':
    enable => 'true',
    ensure => 'running',
   require => Package['nginx'],
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

  file { "/etc/nginx/conf.d/homologacao.conf":
    ensure  => file,
    owner   => "root",
    group   => "root",
    mode    => 0644,
    source  => "puppet:///modules/nginx/homologacao.conf",
    require => Package["nginx"],
    notify  => Service["nginx"]
  }

  file { "/etc/nginx/conf.d/default.conf":
    ensure => absent,
    notify => Service["nginx"]
  }

}
