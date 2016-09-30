About
------
[![Build Status](https://travis-ci.org/opentable/etcd.png)](https://travis-ci.org/opentable/etcd)

This puppet module installs and configures etcd-v3.

It is designed around the current version of etcd (at time of this writing), 3.X.X

Examples
---------
Simplest invocation, installs etcd via packages, manages a user, puts data in
`/var/lib/etcd/` and makes sure it runs on localhost:

    class { 'etcd': }

Parameters
----------
See init.pp for all parameters and their defaults.

Requirements
-----------
It assumes you have a package available called etcd. If you don't have one
[go make one](https://github.com/solarkennedy/etcd-packages)

Contact
-------
Chris Cartlidge <ccartlidge@opentable.com>, Rob Luong <rluong@opentable.com>

Support
-------
Please log tickets and issues on [GitHub](https://github.com/opentable/etcd/issues)

Credit
-------
 Shout-out to Kyle Anderson <kyle@xkyle.com> for which this work was based on https://github.com/solarkennedy/puppet-etcd
