# Copyright 2014 Red Hat, Inc., All rights reserved.
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#
class openshift_origin::firewall::node {
  #lokkit::custom { 'openshift_node_rules':
  #  type   => 'ipv4',
  #  table  => 'filter',
  #  source => 'puppet:///modules/openshift_origin/firewall/node_iptables.txt',
  #}
  lokkit::custom { 'system-config-firewall-compat':
    type    => 'ipv4',
    table   => 'filter',
    source  => '/etc/openshift/system-config-firewall-compat',
    require => Package['rubygem-openshift-origin-node'],
  }
  lokkit::custom { 'iptables.filter.rules':
    type    => 'ipv4',
    table   => 'filter',
    source  => '/etc/openshift/iptables.filter.rules',
    require => Package['rubygem-openshift-origin-node'],
  }
  lokkit::custom { 'iptables.nat.rules':
    type    => 'ipv4',
    table   => 'nat',
    source  => '/etc/openshift/iptables.nat.rules',
    require => Package['rubygem-openshift-origin-node'],
  }

  # Make sure the <code>openshift-iptables-port-proxy</code> is restarted any time that <code>lokkit</code> restarts
  # the firewall when it updates.
  Exec['lokkit_update'] ~> Service['openshift-iptables-port-proxy']
}
