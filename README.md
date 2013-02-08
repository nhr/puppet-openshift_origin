# puppet-openshift_origin

Author: Jamey Owens
Author: Ben Klang
Author: Ben Langfeld
Author: Krishna Raman

# About

This module helps install [OpenShift Origin](https://openshift.redhat.com/community/open-source) Platform As A Service.
Through the declaration of the `openshift_origin` class, you can configure the OpenShift Origin Broker, Node and support
services including ActiveMQ, Qpid, MongoDB, named and OS settings including firewall, startup services, and ntp.

# Requirements

* Puppet >= 2.7
* Facter >= 1.6.17
* Puppetlabs/stdlib module.  Can be obtained
  [here](http://forge.puppetlabs.com/puppetlabs/stdlib) or with the command
  `puppet module install puppetlabs/stdlib`
* Puppetlabs/ntp module.  Can be obtained
  [here](http://forge.puppetlabs.com/puppetlabs/ntp) or with the command
  `puppet module install puppetlabs/ntp`

# Installation

The module can be obtained from the
[github repository](https://github.com/kraman/puppet-openshift_origin).

1. Download the [Zip file from github](https://github.com/kraman/puppet-openshift_origin/archive/master.zip)
1. Upload the Zip file to your Puppet Master.
1. Unzip the file.  This will create a new directory called puppet-openshift_origin-<commit hash>
1. Rename this directory to just `openshift_origin` and place it in your
	   [modulepath](http://docs.puppetlabs.com/learning/modules1.html#modules).

# Configuration

There is one class (`openshift_origin`) that needs to be declared on all nodes managing
any component of OpenShift Origin. These nodes are configured using the parameters of
this class.

## Using Parameterized Classes

[Using Parameterized Classes](http://docs.puppetlabs.com/guides/parameterized_classes.html)

Declaration example:

```puppet
  class { 'openshift_origin':
	  configure_ntp              => true,
	  configure_activemq         => true,
	  configure_qpid             => false,
	  configure_mongodb          => true,
	  configure_named            => true,
	  configure_broker           => true,
	  configure_node             => true,
  }
```

## Parameters

The following lists all the class parameters the `openshift_origin` class accepts.

### create_origin_yum_repos

True if OpenShift Origin dependencies and OpenShift Origin nightly yum repositories should be created on this node.

### install_client_tools

True if OpenShift Client tools be installed on this node.

### enable_network_services

True if all support services be enabled. False if they are enabled by other classes in your recipe.

### configure_firewall

True if firewall should be configured for this node (Will blow away any existing configuration)

### configure_ntp

True if NTP should be configured on this node. False if ntp is configured by other classes in your recipe.

### configure_activemq

True if ActiveMQ should be installed and configured on this node (Used by m-collective)

### configure_qpid

True if Qpid message broker should be installed and configured on this node. (Optionally, used by m-collective. Replaced ActiveMQ)

### configure_mongodb

True if Mongo DB should be installed and configured on this node.

### configure_named

True if a Bind server should be configured and run on this node.

### configure_broker

True if an OpenShift Origin broker should be installed and configured on this node.

### configure_node

True if an OpenShift Origin node should be installed and configured on this node.
                            
### named_ipaddress

IP Address of DNS Bind server (If running on a different node)

### mongodb_fqdn

FQDN of node running the MongoDB server (If running on a different node)

### mq_fqdn

FQDN of node running the message queue (ActiveMQ or Qpid) server (If running on a different node)

### broker_fqdn

FQDN of node running the OpenShift OpenShift broker server (If running on a different node)

### cloud_domain

DNS suffix for applications running on this PaaS. 
Eg. cloud.example.com
	Applications will be <app>-<namespace>.cloud.example.com
       
### configure_fs_quotas

Enables quotas on the local node. Applicable only to OpenShift OpenShift Nodes.
If this setting is set to false, it is expected that Quotas are configured elsewhere in the
Puppet recipe

### oo_device

Device on which gears are stored (/var/lib/openshift)

### oo_mount

Base mount point for /var/lib/openshift directory
                            
### configure_cgroups

Enables cgoups on the local node. Applicable only to OpenShift OpenShift Nodes.
If this setting is set to false, it is expected that cgroups are configured elsewhere in the
Puppet recipe

### configure_pam

Updates PAM settings on the local node to secure gear logins. Applicable only to
OpenShift OpenShift Nodes. If this setting is set to false, it is expected that 
cgroups are configured elsewhere in the Puppet recipe

### broker_auth_plugin

The authentication plugin to use with the OpenShift OpenShift Broker. Supported
values are 'mongo' and 'basic-auth'

### broker_auth_pub_key

Public key used to authenticate communication between node and broker. If left blank,
this file is auto generated.

### broker_auth_priv_key

Private key used to authenticate communication between node and broker. If 
`broker_auth_pub_key` is left blank, this file is auto generated.

### broker_auth_key_password

Password for `broker_auth_priv_key` private key

### broker_auth_salt

Salt used to generate authentication tokens for communication between node and broker.

### broker_rsync_key

TODO

### mq_provider

Message queue plugin to configure for mcollecitve. Defaults to 'activemq'
Acceptable values are 'activemq', 'stomp' and 'qpid'

### mq_server_user

User to authenticate against message queue server

### mq_server_password

Password to authenticate against message queue server

### mongo_auth_user

User to authenticate against Mongo DB server

### mongo_auth_password

Password to authenticate against Mongo DB server

### mongo_db_name

name of the MongoDB database

### named_tsig_priv_key

TSIG signature to authenticate against the Bind DNS server.
                            
### update_network_dns_servers

True if Bind DNS server specified in `named_ipaddress` should be added as first DNS server
for application name resolution.

Known Issues
============

## Ruby

The ruby runtime currently distributed with Fedora 17 (1.9.3.362-24.fc17) has some issues which causes
mcollective to arbitrarily disconnect from the message queue server.

Please update the ruby runtime from `updates-testing` repository

```
yum update --enablerepo updates-testing ruby ruby-libs ruby-irb ruby-devel
```

## Facter

Facter broken on Fedora 17. http://projects.puppetlabs.com/issues/15001

```puppet
yumrepo { 'puppetlabs-products':
  name     => 'puppetlabs-products',
  descr    => 'Puppet Labs Products Fedora 17 - $basearch',
  baseurl  => 'http://yum.puppetlabs.com/fedora/f17/dependencies/\$basearch',
  gpgkey   => 'http://yum.puppetlabs.com/RPM-GPG-KEY-puppetlabs',
  enabled  => 1,
  gpgcheck => 1,
}

yumrepo { 'puppetlabs-deps':
  name     => 'puppetlabs-deps',
  descr    => 'Puppet Labs Dependencies Fedora 17 - $basearch',
  baseurl  => 'http://yum.puppetlabs.com/fedora/f17/products/\$basearch',
  gpgkey   => 'http://yum.puppetlabs.com/RPM-GPG-KEY-puppetlabs',
  enabled  => 1,
  gpgcheck => 1,
}

package { 'facter':
  ensure  => latest,
  require => [Yumrepo['puppetlabs-products'],Yumrepo['puppetlabs-deps']],
}
```