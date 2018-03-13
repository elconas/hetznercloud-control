# Author: Jonas Keidel <jonas.keidel@hetzner.de>
#
# This file is part of cloud-init. See LICENSE file for license information.

import json
import random

from cloudinit import log as logging
from cloudinit import net as cloudnet
from cloudinit import url_helper
from cloudinit import util

LOG = logging.getLogger(__name__)

def read_metadata(url, timeout=2, sec_between=2, retries=30):
    response = url_helper.readurl(url, timeout=timeout,
                                  sec_between=sec_between, retries=retries)
    if not response.ok():
        raise RuntimeError("unable to read metadata at %s" % url)
    return util.load_yaml(response.contents.decode())

def read_userdata(url, timeout=2, sec_between=2, retries=30):
    response = url_helper.readurl(url, timeout=timeout,
                                  sec_between=sec_between, retries=retries)
    if not response.ok():
        raise RuntimeError("unable to read metadata at %s" % url)
    return response.contents.decode()

def add_local_ip(nic=None):
    nic = get_local_ip_nic()
    LOG.debug("selected interface '%s' for reading metadata", nic)

    if not nic:
        raise RuntimeError("unable to find interfaces to access the"
                           "meta-data server. This droplet is broken.")

    ip_addr_cmd = ['ip', 'addr', 'add', '169.254.0.1/16', 'dev', nic]
    ip_link_cmd = ['ip', 'link', 'set', 'dev', nic, 'up']

    if not util.which('ip'):
        raise RuntimeError("No 'ip' command available to configure local ip "
                           "address")

    try:
        (result, _err) = util.subp(ip_addr_cmd)
        LOG.debug("assigned local ip to '%s'", nic)

        (result, _err) = util.subp(ip_link_cmd)
        LOG.debug("brought device '%s' up", nic)
    except Exception:
        util.logexc(LOG, "local ip address assignment to '%s' failed.", nic)
        raise

    return nic


def get_local_ip_nic():
    nics = [f for f in cloudnet.get_devicelist() if cloudnet.is_physical(f)]
    if not nics:
        return None
    return min(nics, key=lambda d: cloudnet.read_sys_net_int(d, 'ifindex'))

def remove_local_ip(nic=None):
    ip_addr_cmd = ['ip', 'addr', 'flush', 'dev', nic]
    ip_link_cmd = ['ip', 'link', 'set', 'dev', nic, 'down']
    try:
        (result, _err) = util.subp(ip_addr_cmd)
        LOG.debug("removed all addresses from %s", nic)
        (result, _err) = util.subp(ip_link_cmd)
        LOG.debug("brought device '%s' down", nic)
    except Exception as e:
        util.logexc(LOG, "failed to remove all address from '%s'.", nic, e)

