exec { "apt-update":
    command => "/usr/bin/apt-get update"
}

class { 'ohmyzsh': }
# for a single user
ohmyzsh::install { 'vagrant': }->
ohmyzsh::upgrade { 'vagrant': }->

# senha padrao do banco 'sefa123' usuario 'root'
class { 'mysql': }
