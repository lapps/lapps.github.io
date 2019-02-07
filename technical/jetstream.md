---
layout: default
title: Jetstream
---

# {{ page.title }}

[Jetstream](http://jetstream-cloud.org) is a NSF funded cloud computing system used by the LAPPS Grid to provide compute resources.

Once the Jetstream has been configured you probably want to head over to the [Clusters](cluster.md) page to read about setting up a cluster using Docker Swarm or Kubernetes. [Apache Mesos](http://mesos.apache.org) is also an option, but has not been tested.

## Citing Jetstream

To acknowledge Jetstream in your work, please cite:

> Stewart, C.A., Cockerill, T.M., Foster, I., Hancock, D., Merchant, N., Skidmore, E., Stanzione, D., Taylor, J., Tuecke, S., Turner, G., Vaughn, M., and Gaffney, N.I., Jetstream: a self-provisioned, scalable science and engineering cloud environment. 2015, In Proceedings of the 2015 XSEDE Conference: Scientific Advancements Enabled by Enhanced Cyberinfrastructure. St. Louis, Missouri.  ACM: 2792774.  p. 1-8. https://dl.acm.org/citation.cfm?doid=2792745.2792774


## Prerequisites

To be able to make use of Jetstream you will need to:

1. Create an account on http://portal.xsede.org
1. Send your XSEDE username to a LAPPS Grid admin so you can be added to our allocation.
1. After you have been added to the LAPPS Grid allocation verify that you can log into:
    1. http://use.jetstream-cloud.org
    1. http://iu.jetstream-cloud.org/ (Indiana University)
    1. http://tacc.jetstream-cloud.org/ (Texas Advanced Computing Center)

Once you are able to log in to the Jetstream system you will need to generate the openrc.sh file that is used by the OpenStack API to communicate with Jetstream.

### openrc.sh

1. Sign on to the Jetstream Dashboard at [IU](https://iu.jetstream-cloud.org/dashboard) or [TACC](https://tacc.jetstream-cloud.org/dashboard).
1. Go to *Compute -> Access & Security*
1. Select the *API Access* tab
1. Click on the *Download OpenStack RC File v3* button

**NOTE** you will need separate openrc.sh files for each cloud (IU or TACC) *and* each allocation you are the manager of. It is recommended to copy the files someplace convenient and rename them so it is easy to distinguish between them.

## Initial Setup

Before we can launch instances on one of the clouds we need to do some initial setup:

1. Create a network and subnet.
1. Create a router.
1. Set the router's gateway to point to the external (public) network.
1. Add an interface to connect the router to the internal subnet created above.

### Detailed Setup

```bash
$ neutron net-create example-network
$ neutron subnet-create example-network 10.0.0.0/24
$ neutron router-create example-router
$ neutron router-gateway-set example-router public
$ neutron router-interface-add  example-router <subnet-id>
```

The output of the `neutron subnet-create` command will contain the *<subnet-id>* you need for the `neutron router-interface-add` command.

## Instance Management

The remainder of this document assumes you will be using the [jetstream](http://downloads.lappsgrid.org/scripts/jetstream) script to manage Jetstream instances.

### Launching

```bash
	jetstream launch [size] <name>
```

### Suspending

```bash
	jetstream suspend <name>
```

### Resuming

```bash
	jetstream resume <name>
```

### Deleting

```bash
	jetstream delete <name>
```

## The Proxy Server

Redirecting to a new server.

```bash
	jetstream proxy <ip address>
```

Disable the proxy. When the proxy is disabled jetstream.lappsgrid.org will redirect to a static *out of service* page.

```bash
	jetstream offline
```

Enable the proxy.  

```bash
	jetstream online
```

