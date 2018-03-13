## Harden the OS
class profile::hardening (
  $ipv6 = true,
) {
  class { 'os_hardening':
    enable_ipv6 => $ipv6,
  }

  class { 'ssh_hardening':
    allow_root_with_key => true,
    ipv6_enabled => $ipv6,
    use_pam => true,
  }

  [ 'rpcbind' ].each |String $pkg| {
    package { $pkg:
      ensure => absent,
    }
  }

}
