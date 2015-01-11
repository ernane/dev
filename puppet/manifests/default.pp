exec { "update":
    command => "/usr/bin/apt-get update"
}

node mysql{
	class { 'nginx': } ->
	class { 'mysql':}
}

node oracle{
	include oracle::server
	include oracle::swap
	include oracle::xe
	
	user { "vagrant":
		groups  => "dba",
		require => Service["oracle-xe"],
	}
}

