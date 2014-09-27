exec { "apt-update":
    command => "/usr/bin/apt-get update"
}

# senha padrao do banco 'sefa123' usuario 'root'
class { 'mysql': }
