class nats::install {
  include systemd

  file {
    default:
      owner  => "root",
      group  => "root",
      mode   => "0755";

    $nats::binpath:
      source => $nats::binary_source;

    $nats::configdir:
      ensure => "directory";
  }

  systemd::unit_file {"${nats::service_name}.service":
    content => epp("nats/systemd_service.epp")
  }

  Class[$name] ~> Class["nats::service"]
}
