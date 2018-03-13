# Author: Jonas Keidel <jonas.keidel@hetzner.de>
#
# This file is part of cloud-init. See LICENSE file for license information.

from cloudinit import log as logging
from cloudinit import sources
from cloudinit import util

import cloudinit.sources.helpers.hetzner as ho_helper
import os.path

LOG = logging.getLogger(__name__)

BUILTIN_DS_CONFIG = {
    'metadata_url': 'http://169.254.169.254/hetzner/v1/metadata',
    'userdata_url': 'http://169.254.169.254/hetzner/v1/userdata',
}

MD_RETRIES = 60
MD_TIMEOUT = 2
MD_WAIT_RETRY = 2

class DataSourceHetzner(sources.DataSource):
    def __init__(self, sys_cfg, distro, paths):
        sources.DataSource.__init__(self, sys_cfg, distro, paths)
        self.distro = distro
        self.metadata = dict()
        self.ds_cfg = util.mergemanydict([
            util.get_cfg_by_path(sys_cfg, ["datasource", "Hetzner"], {}),
            BUILTIN_DS_CONFIG])
        self.metadata_address = self.ds_cfg['metadata_url']
        self.userdata_address = self.ds_cfg['userdata_url']
        self.retries = self.ds_cfg.get('retries', MD_RETRIES)
        self.timeout = self.ds_cfg.get('timeout', MD_TIMEOUT)
        self.wait_retry = self.ds_cfg.get('wait_retry', MD_WAIT_RETRY)
        self._network_config = None
        self.dsmode = sources.DSMODE_NETWORK

    def get_data(self):
        local_ip_nic = ho_helper.add_local_ip()

        md = ho_helper.read_metadata(
                self.metadata_address, timeout=self.timeout,
                sec_between=self.wait_retry, retries=self.retries)

        ud = ho_helper.read_userdata(
                self.userdata_address, timeout=self.timeout,
                sec_between=self.wait_retry, retries=self.retries)
        self.userdata_raw = ud

        self.metadata_full = md
        self.metadata['instance-id'] = md.get('instance-id', None)
        self.metadata['local-hostname'] = md.get('hostname', None)
        self.metadata['network-config'] = md.get('network-config', None)
        self.metadata['public-keys'] = md.get('public-keys', None)
        self.vendordata_raw = md.get("vendor_data", None)

        ho_helper.remove_local_ip(local_ip_nic)

        return True

    @property
    def network_config(self):
        """Configure the networking. This needs to be done each boot, since
           the IP information may have changed due to snapshot and/or
           migration.
        """

        if self._network_config:
            return self._network_config

        _net_config = self.metadata['network-config']
        if not _net_config:
            raise Exception("Unable to get meta-data from server....")

        self._network_config = _net_config

        return self._network_config

# Used to match classes to dependencies
datasources = [
    (DataSourceHetzner, (sources.DEP_FILESYSTEM, )),
]


# Return a list of data sources that match this set of dependencies
def get_datasource_list(depends):
    return sources.list_from_depends(depends, datasources)

# vi: ts=4 expandtab
