---
layout: slate
title: Installing a Service Manager
---

## {{ page.title }}

This page describes how to install the Service Manager, one of the two main elements of a LAPPS Server.

<div class="image">
<img src="https://lapps.github.io/installation/images/lapps-service-manager.png" width="600">
<div class="caption"></div>
</div>


### Short version

To install the Service Manager get the [setup.sh](http://downloads.lappsgrid.org/service-manager/setup.sh) script and run it as root:

```
$ wget http://downloads.lappsgrid.org/service-manager/setup.sh
$ chmod +x setup.sh
$ sudo ./setup.sh
```


### More details

See the readme file at [https://github.com/lappsgrid-incubator/service-manager-installation](https://github.com/lappsgrid-incubator/service-manager-installation).

These notes are written with a virgin Ubuntu machine in mind. The install script is currently being updated to deal with CentOS and RHEL.

NOTE: The following needs to be updated given the name change of one-step-install to setup.

Dowloads are at [http://www.anc.org/downloads/langrid/](http://www.anc.org/downloads/langrid/). You should get the [one-step-install.sh](http://www.anc.org/downloads/langrid/one-step-install.sh) script.

Running this script will download LappsPackages-1.2.3.zip from [http://www.anc.org/downloads/langrid/](http://www.anc.org/downloads/langrid/) and run install scripts included in that package. If needed, those install scripts will also download the latest service manager war file.

Active BPEL is still in there, check this because it is most likely not needed (the Brandeis server never had Active BPEL installed). 

It installs Java 7 from Oracle, not the JDK, it even removes the OpenJDK. This is because of some JDBC errors when both existed side-by-side (but this was a problem in 2012, it may have been solved by now).

Running the script should work, but it does not set JAVA_HOME

Here are some [historical notes](http://wiki.lappsgrid.org/manuals/service-manager/install-service-manager/index.html) from 2014. 

The one-step-install.sh script is maintained in the [https://github.com/lappsgrid-incubator/jetstream-scripts](https://github.com/lappsgrid-incubator/jetstream-scripts) repository. It may be moved to [https://github.com/lappsgrid-incubator/service-manager-installation](https://github.com/lappsgrid-incubator/service-manager-installation).

Now an easier proces:

- requires postgress, tomcat 7 installation, Java 8 (latest manager (Jan 2017)
- get the service manager war and put it on tomcat
- start/stop tomcat to create database, using tomcat scripts
- there are two sql scripts that need to be run to set up tables in postgress
- service-manager.xml needs to be edited


Last steps:

- test last one step install script from Keith on JetStream
- script needs to be tuned a bit
- including RHEL flavours
