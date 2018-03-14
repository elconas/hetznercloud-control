## Configure Hetznercloud Sepcifics

## FIXME: root usernaname and password
class profile::hetznercloud (

) {

  include ::profile::hetznercloud::kernel
  include ::profile::hetznercloud::cloud_init
  include ::profile::hetznercloud::qemu_gest_agent
  include ::profile::hetznercloud::grub
  
  file { '/etc/rc.local':
    source  => "puppet:///modules/profile/hcloud/etc/rc.local",
    mode    => '0750',
    owner   => 0,
    group   => 0,
  }

}
