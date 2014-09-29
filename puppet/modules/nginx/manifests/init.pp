# Class: nginx
#
#
class nginx {
  # resources

  $bin = '/usr/bin:/usr/sbin'

  exec { "update-inicial":
    command => "apt-get update"
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
}
