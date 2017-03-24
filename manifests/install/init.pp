class nats::install::sysvinit {

  file { "gnatsd.sysvinit":
    ensure  => "present",
    owner   => "root",
    group   => "root",
    mode    => "0755",
    path    => "/etc/init.d/${nats::service_name}",
    content => epp("nats/sysvinit.epp"),
  }

  # Ubuntu supports both SysV init and Upstart, so in case a users wants to
  # switch from one to the other make sure the Upstart Job does not remain
  # present on the system, or it may take precedence over the SysV init script.
  file { "gnatsd.upstart":
    ensure => "absent",
    path   => "/etc/init/${nats::service_name}.conf",
  }

  Class[$name] ~> Class["nats::service"]
}
