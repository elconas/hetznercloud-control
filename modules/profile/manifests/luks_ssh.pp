## Install dracut-ssh for remote unlocking of LUKS volumes
## See https://github.com/dracut-crypt-ssh/dracut-crypt-ssh
class profile::luks_ssh (
  $ssh_key = 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCnyCvFNQJ5S1rnf39xxmc/K+AZK9k7EiwFGGVD787IyT/wvCDwsLLIQ8WJV91qK70Xkk02H8BFSBJpCKh4WAokpuYNnLPAsm/nhrXhXcc+Ugktxl4mYkxIobKuxvYZCGYLBEijH9W91EQX6FbI1mFicerIA57Z0AE+J6pXCUWTcvJHeOZNvMFCv1EcMCWbHOVKVn7d/5saTOhZoTgBOTnREM7NENos0mP+9QK1sUAJuoz4RhPX9QnFWFOWHARgYl5MUWcbcM2sxV8zC2HQn4tT7vD6NdL1XVReaKHaeADlEXc+89AhKGaxO5DJTCcCxfvosopi0aMfiCLmvFzYMl5g8f2PY3kzPxat7lNqgjwW0VkyCTfo0MDvb/qZyh6He9/X5ZR4kem3ED3ZBEqyP4O8hASXae2tY6lh2Olv2fCjdJYkkgRm35NoqYUYEot7w+AkwuqeFTy5jWefISOjcXUYOpeOHE9PcbY0q6ba7Pr18mxYhKqP2jz5Ubu9PmhH8ZGjMj6sk3JtYB0R7SG0N802+VjVi9zn3e3RJ3aGb6EvhA+mfhW9xJoAXRGKyfUw4NZK1WpfxzO/YWfU9aCNR1lLrKNFMUVC8M4clyfyUZIPRvZ4HIDlSwoGWKPG8AYSBFKhV1DQhkPyiJLfnVMtQIg3Jafdzr51V6LgyegUX0+CbQ== Unlock Luks',
  $config = { "dropbear_port" => "222", "dropbear_ecdsa_key" => "/etc/dropbear/key.ecdsa", "dropbear_rsa_key" => "/etc/dropbear/key.rsa", "dropbear_acl" => "/etc/dropbear/authorized_keys" },
) {

  package { 'epel-release':
    ensure => present,
  }

  yumrepo { "rbu-dracut-crypt-ssh":
    baseurl             => 'https://copr-be.cloud.fedoraproject.org/results/rbu/dracut-crypt-ssh/epel-7-$basearch/',
    descr               => "Copr repo for dracut-crypt-ssh owned by rbu",
    enabled             => 1,
    skip_if_unavailable => true,
    gpgkey              => 'https://copr-be.cloud.fedoraproject.org/results/rbu/dracut-crypt-ssh/pubkey.gpg',
    gpgcheck            => 1,
  }

  package { 'dracut-crypt-ssh':
    ensure  => present,
    require => Yumrepo['rbu-dracut-crypt-ssh'],
    notify  => Exec['update-dracut'],
  }

  # Kernel Parameters
  kernel_parameter { 'rd.neednet':
    value => '1',
  }
  #kernel_parameter { 'ip':
  #  value => 'dhcp',
  #}
  ensure_resource('exec','update-grub', {
    command     => '/usr/sbin/grub2-mkconfig --output /etc/grub2.cfg',
    refreshonly => true,
  })
  Kernel_parameter <| |> ~> Exec['update-grub']
  Grub_config <| |> ~> Exec['update-grub']


  # Dracut
  exec { 'update-dracut':
    command     => '/usr/sbin/dracut --force',
    refreshonly => true,
  }

  exec { 'generate_dropbear_ssh_key-rsa':
    command => "/usr/bin/ssh-keygen -t rsa -N '' -b 4096 -f /etc/dropbear/key.rsa",
    creates => "/etc/dropbear/key.rsa",
    notify  => Exec['update-dracut'],
    require => Package['dracut-crypt-ssh'],
  }

  exec { 'generate_dropbear_ssh_key-ecdsa':
    command => "/usr/bin/ssh-keygen -t ecdsa -N '' -b 521 -f /etc/dropbear/key.ecdsa",
    creates => "/etc/dropbear/key.ecdsa",
    notify  => Exec['update-dracut'],
    require => Package['dracut-crypt-ssh'],
  }

  file { '/etc/dropbear/authorized_keys':
    ensure  => file,
    content => "command=\"unlock\" ${ssh_key}\n",
    owner   => 0,
    mode    => '0644',
    notify  => Exec['update-dracut'],
    require => Package['dracut-crypt-ssh'],
  }

  $config.each |String $key, String $value| {
    file_line { "/etc/dracut.conf.d/crypt-ssh.conf-${key}":
      path    => '/etc/dracut.conf.d/crypt-ssh.conf',
      line    => "${key}='${value}'",
      match   => "^${key}=",
      notify  => Exec['update-dracut'],
      require => Package['dracut-crypt-ssh'],
    }
  }
}
