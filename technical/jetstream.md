---
layout: default
title: Jetstream
---

# {{ page.title }}

[Jetstream](http://jetstream-cloud.org) is a NSF funded cloud computing system used by the LAPPS Grid to provide compute resources.

## Prerequisites

To be able to make use of Jetstream you will need to:

1. Create an account on http://portal.xsede.org
1. Send your XSEDE username to a LAPPS Grid admin so you can be added to our allocation.
1. After you have been added to the LAPPS Grid allocation verify that you can log in to:
    1. http://use.jetstream-cloud.org
    1. http://jblb.jetstream-cloud.org/dashboard

Once you are able to log in to the Jetstream system you will need to generate the openrc.sh file that is used by the Open Stack API to communicate with Jetstream.

### openrc.sh

1. Sign on to the [Jetstream Dashboard](https://jblb.jetstream-cloud.org/dashboard)
1. Go to *Compute -> Access & Security*
1. Select the *API Access* tab
1. Click on the *Download OpenStack RC File v3* button
1. Rename the downloaded file to *openrc.sh* and move it someplace convenient.

**NOTE:** The first (non-comment) line of the *openrc.sh* file sets the `OS_AUTH_URL` variable to an incorrect URL.  You will be provided with the correct URL in a separate email.  Please do not make this URL public (i.e. save it anywhere other than your openrc.sh file).

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

