# Manage the NATS config file
class nats::config {
  file { "${nats::configdir}/${nats::service_name}.cfg":
    owner   => $nats::user,
    group   => $nats::group,
    mode    => "0640",
    content => epp("nats/nats.cfg.epp"),
    notify  => Class["nats::service"],
  }
}
