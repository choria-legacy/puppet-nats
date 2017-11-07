|Date      |Issue |Description                                                                                              |
|----------|------|---------------------------------------------------------------------------------------------------------|
|2017|11/07|61    |Support disabling TLS                                                                                    |
|2017/10/19|      |Release 0.2.0                                                                                            |
|2017/10/12|59    |Allow latest systemd module to be used                                                                   |
|2017/10/03|52    |Allow `write_deadline` to be configured                                                                  |
|2017/10/03|54    |Update to NATS 1.0.4                                                                                     |
|2017/09/21|      |Release 0.1.0                                                                                            |
|2017/09/08|50    |Support FreeBSD                                                                                          |
|2017/07/25|      |Release 0.0.12                                                                                           |
|2017/06/12|      |Make the TLS timeouts configurable using `tls_timeout` and `cluster_tls_timeout`                         |
|2017/07/14|46    |Update NATS to 1.0.0                                                                                     |
|2017/06/12|45    |Add `listen_address` option                                                                              |
|2017/06/01|      |Release 0.0.11                                                                                           |
|2017/06/01|40    |Use Hiera 5 to avoid deprecation notices and require Puppet >= 4.9.0                                     |
|2017/05/29|38    |Notify instead of fail when Hiera data is missing                                                        |
|2017/05/22|37    |Improve handling of passwords containing special characters                                              |
|2017/05/19|      |Release 0.0.10                                                                                           |
|2017/05/17|33    |Allow NATS to run as a user                                                                              |
|2017/03/17|      |Release 0.0.9                                                                                            |
|2017/04/13|28    |Allow setting number of open files for systemd based machines using `limit_nofile`                       |
|2017/03/28|      |Release 0.0.8                                                                                            |
|2017/03/24|25    |Fix NATS installation on RedHat based non systemd nodes                                                  |
|2017/03/24|23    |Default to clientcert rather than FQDN for certs                                                         |
|2017/03/05|      |Release 0.0.7                                                                                            |
|2017/03/02|20    |Fix the selection of service provider                                                                    |
|2017/02/11|      |Release 0.0.6 and move to `choria-io` project                                                            |
|2016/12/21|      |Release 0.0.5                                                                                            |
|2016/12/21|16    |Update NATS to 0.9.6                                                                                     |
|2016/12/21|15    |Support `sysvinit` and `upstart` init systems (thank you @antaflos)                                      |
|2016/10/26|      |Release 0.0.4                                                                                            |
|2016/10/26|8,9   |Make max_connections, max_payload and max_pending_size configurable                                      |
|2016/08/19|      |Release 0.0.3                                                                                            |
|2016/08/19|5     |Support NATS 0.9.4 cluster announce feature, off by default                                              |
|2016/08/19|3     |Upgrade NATS to 0.9.4                                                                                    |
|2016/07/30|1     |Optionally write collectd configuration to fetch stats from NATS                                         |
