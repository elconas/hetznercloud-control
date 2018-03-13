class profile::hetznercloud::qemu_gest_agent (

) {

  package {'qemu-guest-agent':
    ensure => latest,
    notify => Service['qemu-guest-agent'],
  }

  service {'qemu-guest-agent':
    ensure => running,
    enable => true,
  }


  ## Files
  [
    '/etc/sysconfig/qemu-ga',
  ].each |String $file| {
    file { $file:
      source  => "puppet:///modules/profile/hcloud/${file}",
      mode    => '0644',
      owner   => 0,
      group   => 0,
      require => Package['qemu-guest-agent'],
      notify  => Service['qemu-guest-agent'],
    }
  }


}
