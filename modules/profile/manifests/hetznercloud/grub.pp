class profile::hetznercloud::grub (

) {

  ensure_resource('exec','update-grub', {
    command     => '/usr/sbin/grub2-mkconfig --output /etc/grub2.cfg',
    refreshonly => true,
  })

  file { '/boot/grub2/user.cfg':
    ensure  => present,
    content => 'GRUB2_PASSWORD=grub.pbkdf2.sha512.10000.A8F6537E44221968F135508800E8DDD22AC0CCE2665B649C6596E7E627864DB38D494761CF797C14109D0569ED65F14D87D55CE1D638F7D4EFBB35EAEC0CE5C8.D4736453E31920F70B1B16F2D6673C30D40096F43C05175D61E867AAE49F37C4CD3777650CFF9E3169DB0FDC839D1A0A7C62317511943942CA0CCE627B642865',
    notify => Exec['update-grub'],
  }

}
