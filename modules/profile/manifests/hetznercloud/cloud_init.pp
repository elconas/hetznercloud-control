class profile::hetznercloud::cloud_init (

) {

  package {'cloud-init':
    ensure => present,
  }

  ## Files
  [
    '/etc/cloud/cloud.cfg',
    '/etc/cloud/cloud.cfg.d/05_logging.cfg',
    '/etc/cloud/cloud.cfg.d/90-hetznercloud.cfg',
    '/etc/cloud/cloud.cfg.d/92-hetznercloud-ds.cfg',
    '/etc/cloud/cloud.cfg.d/93-hetznercloud.cfg',
    '/etc/cloud/cloud.cfg.d/94-elconas.cfg',
    '/usr/lib/python2.7/site-packages/cloudinit/sources/helpers/hetzner.py',
    '/usr/lib/python2.7/site-packages/cloudinit/sources/DataSourceHetzner.py'
  ].each |String $file| {
    file { $file:
      source  => "puppet:///modules/profile/hcloud/${file}",
      mode    => '0644',
      owner   => 0,
      group   => 0,
      require => Package['cloud-init'],
    }
  }


}
