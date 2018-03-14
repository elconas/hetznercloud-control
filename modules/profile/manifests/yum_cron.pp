## Automatic Securtiy Updates
class profile::yum_cron (

) {

  package { 'yum-cron':
    ensure => present,
    notify => Service['yum-cron'],
  }

  file { '/etc/yum/yum-cron.conf':
    source  => "puppet:///modules/profile/etc/yum/yum-cron.conf",
    mode    => '0644',
    owner   => 0,
    group   => 0,
    require => Package['yum-cron'],
    notify  => Service['yum-cron'],
  }

  service {'yum-cron':
    ensure => running,
    enable => true,
    require => Package['yum-cron'],
  }

}
