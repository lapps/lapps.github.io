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

The exceptions to this rule are third party Docker images (Docker Registry, Solr, RabbitMQ) that we pull from Docker Hub.

# Services
1. [Docker Registry](#dockerlappsgridorg)
2. [Sonatype Nexus](#sonatype-nexus)
3. [AskMe](#askme)
4. [Nginx Proxy](#proxy-server)
5. [Miscellaneous Services](#services)
    - api.lappsgrid.org
    - UDPipe
    - PubAnnotation
    - Misc Datasources 
1. [Solr](#solr)
2. [RabbitMQ](#rabbitmq)

# docker.lappsgrid.org

Most of the services described here are deployed to the [Lappsgrid's Docker registry](https://api.lappsgrid.org/docker) so we don't pollute the *lappsgrid* namespace on Docker Hub.  Currently the Lappsgrid Docker registry runs on the *services* node on the IU Jetstream cluster (149.165.157.51).  The Docker Registry runs as a Docker container managed by the `/root/registry.sh` script.

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
- **all** | **both** Runs both the Docker Registyr container and the web UI container.

If no option is provided then both containers are started, stopped, or killed.

### Examples

```
$> registry.sh run
$> registry.sh stop web
$> registry.sh start web
$> registry.sh kill both
```

## Storage

By default the Docker Registry saves image data to `/var/lib/registry`. To persist data through container restarts a 256GB Jetstream volume is attached to `/dev/sdb` and mounted as `/data` on the *services* instance.  

**WARNING** the volume is **NOT** listed in `/etc/fstab` and will need to be mounted whenever the server is rebooted:

```
mount /dev/sdb /data
```

The `registry.sh` script bind mounts `/data` on the host system to `/var/lib/registry` in the container so all images uploaded to docker.lappsgrid.org will be persisted outside the container and can be migrated to another instance if needed.

# Sonatype Nexus
The Sonatype Nexus server was used when working with the CDC and Lappsgrid artifacts are not deployed here.  However, it is available at `maven.lappsgrid.org` should the need to use it again arises.

Nexus runs on the *services* instance on the IU Jetstream cluster (149.165.157.51) and is managed with the `/root/nexus.sh` script.

```
$> nexus.sh [start|stop]
```

Like the Docker Registry the Nexus server stores its data outside the container so it can be persisted between container restarts. Unlike the Docker Registry the Nexus server uses a [Docker volume](https://docs.docker.com/storage/volumes/) to persist data.  In practice this means the repository data can be found in `/var/lib/docker/volumes` on the host machine.  The drawback to this approach is that the data is stored on the host machine rather than on external physical storage that is independent of the Jetstream instance.

# AskMe

The [AskMe service](https://services.lappsgrid.org/eager/ask) consists of four micro-services that each run in Docker containers. 

The AskMe service depends on the [Solr](#solr)  and [RabbitMQ](#rabbitmq) servers and will fail to start is either is unavailable.  If AskMe fails to start the inability to connect with Solr and/or RabbitMQ is the most likely culprit.



# Proxy Server

- Uses nginx

# Services

## api.lappsgrid.org

# Solr

Runs as an `init.d` system service on its own instance.

# RabbitMQ

Runs as an `init.d` system service on its own instance.

