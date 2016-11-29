---
layout: slate
title: Galaxy
---

# {{ page.title }}

The easiest way to run a LAPPS Grid Galaxy instance is to use one of the Docker images
available from the Docker Hub.  However at times it is required to run the Galaxy instance
from the GitHub repository.

The LAPPS Grid Galaxy instance it stored in two repositories on GitHub:
1. https://github.com/ksuderman/Galaxy.git<br/>
The is a fork of the [main Galaxy repository](https://github.com/galaxyproject/galaxy). We
try to leave this repository alone as much as possible, but currently it contains several 
modified JavaScript files for the Galaxy client to configure the masthead and allow
tools to be connected in the workflow editor if a converter exists (e.g. connecting a GATE
tool to a tool that expects LIF).
1. https://github.com/ksuderman/GalaxyMods.git<br/>
Currently this repository contains the datatype definitions, tool wrappers, and other
 files that can be stored externally and then configured in the `galaxy.ini` file.
A sample `galaxy.ini` file is included as a starting point.

## System Setup

For the purposes of this document we will assume a brand new OS install (Ubuntu 14.04 LTS) 
with the following packages also installed.

```bash
$> curl -sSL http://downloads.lappsgrid.org/scripts/install-common.sh | sh
$> curl -sSL http://downloads.lappsgrid.org/scripts/install-postgres.sh | sh
$> useradd -r galaxy
$> mkdir /home/galaxy
$> cd /home/galaxy
$> git clone http://github.com/lappsgrid-incubator/Galaxy.git galaxy
$> git clone http://github.com/lappsgrid-incubator/GalaxyMods.git mods


```




