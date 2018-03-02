class nats::remove {
  service { $nats::service_name:
    ensure   => "stopped",
    enable   => false,
    provider => $nats::service_type
  }

  if $nats::manage_user and $nats::user != "root" {
    user { $nats::user:
      ensure => absent,
    }
  }

  if $nats::manage_group and $nats::group != "root" {
    group { $nats::group:
      ensure => absent,
    }
  }

  file { $nats::configfile:
    ensure => absent
  }

  case $nats::service_type {
    "init", "redhat": {
      file{"/etc/init.d/${nats::service_name}":
        ensure  => absent,
        require => Service[$nats::service_name],
      }
    }

    "systemd": {
      systemd::unit_file { "${nats::service_name}.service":
        ensure  => absent,
        require => Service[$nats::service_name],
      }
    }

    "upstart": {
      file { ["/etc/init/${nats::service_name}.conf", "/etc/init.d/${nats::service_name}"]:
        ensure  => absent,
        require => Service[$nats::service_name],
      }
    }

    default: { }
  }

  if $nats::manage_package {
    package { $nats::package_name:
      ensure => absent
    }
  } else {
    file { $nats::binpath:
      ensure  => absent,
      require => Service[$nats::service_name]
    }
  }
}
