---
layout: slate
title: Current Docker Images
---

# {{ page.title }}

The following Docker images are available on [GitHub](https://github.com/lappsgrid-incubator).


1. [lappsgrid/ubuntu](https://github.com/lappsgrid-incubator/docker-ubuntu) : Docker image based on Ubuntu 14.04 with Java 7 and Postgres 9.3 included. Also includes emacs, nano, zip, wget, and curl.  
1. [lappsgrid/tomcat](https://github.com/lappsgrid-incubator/docker-tomcat) : Includes Tomcat 7 in the *lappsgrid/ubuntu* image
1. [lappsgrid/service-manager](https://github.com/lappsgrid-incubator/docker-service-manager) : Extends the *lappsgrid/ubuntu* image with a Service Manager installation. Also includes the
LSD and the LDDL interpreter for configuring services in the service manager.  However, the
actual LDDL initialization scripts are include in the packages below.
1. [lappsgrid/brandeis](https://github.com/lappsgrid-incubator/docker-brandeis) : Docker image of the Brandeis processing node.
1. [lappsgrid/vassar](https://github.com/lappsgrid-incubator/docker-vassar) : Docker image of the Brandeis processing node.
1. [lappsgrid/gigaword](https://github.com/lappsgrid-incubator/docker-gigaword) : A Docker image that provides Gigaword as a DataSource service. **NOTE** The image does not
container Gigaword.  The Gigaword corpora must in an externally mounted VOLUME the container
can read to serve files.
1. [lappsgrid/oaqa](https://github.com/lappsgrid-incubator/docker-oaqa) : Docker image with running the OAQA EvaluationService.
1. [lappsgrid/galaxy](https://github.com/lappsgrid-incubator/docker-galaxy-lappsgrid) : Docker image with the LAPPS Galaxy instance.  Two versions of the *lappgrid/galaxy* image is
available; one that calls services on the Brandies, CMU, and Vassar nodes, and another that
calls the services running in the Docker containers.
