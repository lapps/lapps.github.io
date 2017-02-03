---
layout: slate
title: Installing a Service Manager
---

## {{ page.title }}


These notes are written with a virgin Ubuntu machine in mind. 


Dowloads at [http://www.anc.org/downloads/langrid/](http://www.anc.org/downloads/langrid/). Get the following onto the jetstream instance.

- one-step-install.sh

Running this will download LappsPackages-1.2.3.zip from [http://www.anc.org/downloads/langrid/](http://www.anc.org/downloads/langrid/) if needed, it will also download the latest service manager war file and other things that are needed.

Active BPEL is still in there, check this because it is most likely not needed (the Brandeis server never had Active BPEL installed). 

It installs Java 7 from Oracle, not the JDK, it even removes the OpenJDK. This is because of some JDBC errors when both existed side-by-side (but this was a problem in 2012, it may have been solved by now).

Running the script should work, but it does not set JAVA_HOME

Here are some [historical notes](http://wiki.lappsgrid.org/manuals/service-manager/install-service-manager/index.html) from 2014. 

There is a one-step-install script (written by Keith for debian/ubuntu, Keigh had an RHEL version - that is lost).
 
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
