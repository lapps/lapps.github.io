---
layout: default
title: Running the Lappsgrid
---

# Introduction

There are a number of services that run as Docker containers on Jetstream instances. These instructions can be used to launch new instances of these services, or to bring everything back online after a Jetstream outage.

Instructions for installing a Service Manager instance are [here](installation/service_manager) and instructions  are available for installing Galaxy via [shell scripts](installation/galaxy) or [ansible playbooks](https://github.com/lappsgrid-incubator/ansible-playbooks/blob/master/galaxy/README.md).

Almost all of the services described here are deployed as Docker containers to Jetstream instances and the projects follow is similar layout and structure.  In particular, all the projects contains `Makefile`s that can be used to build and deploy the Docker images.  The typical sequence of steps is almost always something like:

```
$> make clean jar docker tag push
```

The exceptions to this rule are third party Docker images (Docker registry, Solr, RabbitMQ) that we don't need to build ourselves.

# Services
1. [Docker Registry](#docker.lappsgrid.org)
2. [Sonatype Nexus](#sonatype_nexus)
3. [AskMe](#askme)
4. Nginx Proxy
5. Miscellaneous Services
  - API
  - UDPipe
  - PubAnnotation
  - Datasources 
# docker.lappsgrid.org

All of the services here are deployed to the Lappsgrid's Docker registry so we don't pollute the Lappsgrid namespace on Docker Hub with half-baked works in progress.  Currently the Lappsgrid Docker registry runs on the *services* node on the IU Jetstream cluster (149.165.157.51).  The Docker Registry runs as a Docker container managed by the `/root/registry.sh` script.

```
$> registry.sh [run|kill|start|stop] (registry|web|all|both)
```

### Commands
- **run** - Runs the Docker container.
- **kill** - Stops a running Docker container and removes the image from memory.
- **start** - Starts a previously stopped container.
- **stop** - Stops a running Docker container.

### Options

- **registry** Runs the Docker Registry container
- **web** Runs the web UI for the Docker Registry
- **all | both** Runs both the Docker Registyr container and the web UI container.

If no option is provided then both containers are started.

### Examples

```
$> ./registry.sh run
$> ./registry.sh stop web
$> ./registry.sh start web
$> ./registry.sh kill both
```

## Storage

By default the Docker Registry saves image data to `/var/lib/registry`. To persist data through container restarts a 256GB Jetstream volume is attached to `/dev/sdb` and mounted as `/data` on the *services* instance.  **WARNING** the volume is **NOT** listed in `/etc/fstab` and will need to be mounted whenever the server is rebooted:

```
mount /dev/sdb /data
```

The `registry.sh` script bind mounts `/data` on the host system to `/var/lib/registry` in the container so all images uploaded to docker.lappsgrid.org will be persisted outside the container and can be migrated to another instance if needed.

# Sonatype Nexus

# AskMe

# Services

## Proxy Server

- Uses nginx

## api.lappsgrid.org

## Solr

Runs as an `init.d` system service.

## RabbitMQ

Runs as an `init.d` system service.

