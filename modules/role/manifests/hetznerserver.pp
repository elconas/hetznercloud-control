class role::hetznerserver (
) {
  include '::profile::hardening'
  include '::profile::hetznercloud'
  include '::profile::luks_ssh'
  include '::profile::yum_cron'
}
