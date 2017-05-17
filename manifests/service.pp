#
class influxdb::service(
  $service_ensure  = $influxdb::service_ensure,
  $service_enabled = $influxdb::service_enabled,
  $manage_service  = $influxdb::manage_service,
){

  if $manage_service {
    if ($::osfamily == 'RedHat' and $::operatingsystemmajrelease == '7') or ($::operatingsystem == 'Ubuntu' and $::operatingsystemmajrelease >= '15.10') {
      exec { 'refresh_systemd':
        command     => 'systemctl daemon-reload',
        refreshonly => true,
      }
      service { 'influxdb':
        provider   => systemd,
        ensure     => $service_ensure,
        enable     => $service_enabled,
        hasrestart => true,
        hasstatus  => true,
        require    => Package['influxdb'],
      }
    }else {
      service { 'influxdb':
        ensure     => $service_ensure,
        enable     => $service_enabled,
        hasrestart => true,
        hasstatus  => true,
        require    => Package['influxdb'],
      }
    }
  }
}
