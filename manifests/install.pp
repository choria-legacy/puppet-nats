class nats::install {
  contain "nats::install::${nats::service_type}"

  file {
    default:
      owner => "root",
      group => "root",
      mode  => "0755";

    $nats::binpath:
      source => $nats::binary_source;

    $nats::configdir:
      ensure => "directory";
  }

  Class[$name] ~> Class["nats::service"]
}
