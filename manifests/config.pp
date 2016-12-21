class nats::config {
  file{"${nats::configdir}/${nats::service_name}.cfg":
    owner   => "root",
    group   => "root",
    mode    => "0640",
    content => epp("nats/nats.cfg.epp"),
    notify  => Class["nats::service"],
  }
}
