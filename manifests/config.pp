# Manage the NATS config file
class nats::config {
  file { $nats::configfile:
    owner   => $nats::user,
    group   => $nats::group,
    mode    => "0640",
    content => epp("nats/nats.cfg.epp"),
    notify  => Class["nats::service"],
  }
}
