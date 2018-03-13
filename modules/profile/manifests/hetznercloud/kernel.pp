class profile::hetznercloud::kernel (

) {

  kernel_parameter { 'elevator':
    ensure  => present,
    value   => 'noop',
  }

  kernel_parameter { 'console':
    value => 'tty1',
  }

  ensure_resource('exec','update-grub', {
    command     => '/usr/sbin/grub2-mkconfig --output /etc/grub2.cfg',
    refreshonly => true,
  })

  Kernel_parameter <| |> ~> Exec['update-grub']
  Grub_config <| |> ~> Exec['update-grub']

}
