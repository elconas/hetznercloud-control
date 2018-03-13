## Configure Hetznercloud Sepcifics

## FIXME: root usernaname and password
class profile::hetznercloud (

) {

  include ::profile::hetznercloud::kernel
  include ::profile::hetznercloud::cloud_init
  include ::profile::hetznercloud::qemu_gest_agent

}
