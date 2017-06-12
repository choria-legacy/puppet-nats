# Install and manage the NATS messaging system
class nats (
  Optional[String] $routes_password = undef,
  Array[String] $servers = [],
  String $client_port = "4222",
  String $monitor_port = "8222",
  String $cluster_port = "4223",
  String $listen_address = "::",
  Integer $max_payload_size = 1048576,
  Integer $max_pending_size = 10485760,
  Integer $max_connections = 65536,
  Boolean $debug = false,
  Boolean $trace = false,
  Boolean $announce_cluster = false,
  String $binpath = "/usr/sbin/gnatsd",
  String $configdir = "/etc/gnatsd",
  String $piddir = "/var/run",
  String $binary_source = "puppet:///modules/nats/gnatsd-0.9.6",
  String $service_name = "gnatsd",
  Enum["running", "stopped"] $service_ensure = "running",
  Nats::Service_type $service_type = "init",
  String $cert_file = "/etc/puppetlabs/puppet/ssl/certs/${trusted['certname']}.pem",
  String $key_file = "/etc/puppetlabs/puppet/ssl/private_keys/${trusted['certname']}.pem",
  String $ca_file = "/etc/puppetlabs/puppet/ssl/certs/ca.pem",
  Boolean $manage_collectd = false,
  Optional[Integer] $limit_nofile = undef,
  Boolean $manage_user = false,
  Boolean $manage_group = false,
  String $user = "root",
  String $group = "root"
) {
  if $servers.empty or $facts["networking"]["fqdn"] in $servers {
    if SemVer.new($facts["aio_agent_version"]) < SemVer.new("1.5.2") {
      fail("Puppet AIO Agent 1.5.2 or newer is needed by the ripienaar-nats module")
    }

    $peers = $servers.filter |$s| { $s != $facts["networking"]["fqdn"] }

    include nats::install
    include nats::config
    include nats::service

    if $manage_collectd {
      include nats::collectd
    }
  } else {
    notify{'Nats sanity check':
      message => sprintf("%s is not in the list of NATS servers %s", $facts["networking"]["fqdn"], $servers.join(", "))
    }
  }
}
