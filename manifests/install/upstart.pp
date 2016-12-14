class nats::install::upstart {

  file { "gnatsd.upstart":
    ensure  => "present",
    owner   => "root",
    group   => "root",
    mode    => "0644",
    path    => "/etc/init/${nats::service_name}.conf",
    content => epp("nats/upstart_job.epp"),
  }

  # Create an init.d symlink for convenience:
  # ln -s /lib/init/upstart-job /etc/init.d/gnatsd
  file { "gnatsd upstart initd symlink":
    ensure => "link",
    target => "/lib/init/upstart-job",
    path   => "/etc/init.d/${nats::service_name}",
  }

  Class[$name] ~> Class["nats::service"]
}
