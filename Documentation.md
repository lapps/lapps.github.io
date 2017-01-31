---
layout: slate
title: Documentation
---

## {{ page.title }}

Some notes going into the Documentation meeting at Brandeis, 1/31/2017-2/2/2017.

### Location of documentation

Documentation will live in [lappsgrid.github.io](lappsgrid.github.io), which will be redesigned. The wiki.lappsgrid.org domain points to lappsgrid.github.io. The github.io page is technically not a wiki but close enough.


### Overview

Start with a blank slate and figure out the exact procedures for creating a LAPPS Grid. 

In particular, what needs to be done for the following to happen:


### Installing a service manager

Requirements (debian, rhel, osx), start with virgin machine (JetStream instance)

Here are some [historical notes] from (http://wiki.lappsgrid.org/manuals/service-manager/install-service-manager/index.html) from 2014. 

There is a one-step-install script (written by Keith for debian/ubuntu, Keigh had a RHEL version).
 
Now an easier proces:
- requires postgress, tomcat 7 installation, Java 8 (latest manager (Jan 2017)
- get the service manager war and put it on tomcat
- start/stop tomcat to create database, using tomcat scripts
- there are two sql scripts that need to be run to set up tables in postgress
- vevice-manager.xml needs to be edited

**set up new service manager on Jetstream**


### Creating and adding services

How to create services - wrapping, discriminators, LIF, WSEV, deploying, registering

Wrapping:

- [Wrapping services](https://github.com/lapps/org.lappsgrid.examples) - README.md file in org.lappsgrid.examples repository

LIF and WSEV:

- output of wrapped components should follow LIF specifications and use elements from WSEV
- [LIF specifications](interchange/index.html)
- [LIF JSON-schema](schema/lif-schema.json)
- [WSEV at http://vocab.lappsgrid.org/](http://vocab.lappsgrid.org/)
- [WSEV discussion](http://wiki.lappsgrid.org/vocabulary/current_issues.html)
- [WSEV issues](https://github.com/lapps/vocabulary-pages/issues)

Vocabulary and Discriminators:

- everything in vocab is in discriminators but not vice versa
- there is a vocab dsl and a discriminators dsl (both configuration files for transformations)
 1. [https://github.com/lappsgrid-incubator/vocabulary-dsl](https://github.com/lappsgrid-incubator/vocabulary-dsl)
 2. [https://github.com/lappsgrid-incubator/org.lappsgrid.discriminator.dsl](https://github.com/lappsgrid-incubator/org.lappsgrid.discriminator.dsl)
- the input to 1 is lapps.vocab in [https://github.com/lapps/vocabulary-pages](https://github.com/lapps/vocabulary-pages) (there are also template files and other onput files for the mapping in there), it creates vocab.lappsgrid.org html, [org.lappsgrid.vocabulary](https://github.com/lapps/org.lappsgrid.vocabulary) (which is like the discriminator package and describes attribute names etcetera defined in the vocab), and a Groovy config DSL file with same content
- the input to 2 is the config DSL file above and a file named [discriminators.config](https://github.com/lappsgrid-incubator/org.lappsgrid.discriminator.dsl/blob/master/src/main/resources/discriminators.config) in the org.lappsgrid.discriminator.dsl repository, the output is [http://vocab.lappsgrid.org/discriminators](http://vocab.lappsgrid.org/discriminators) and parts of the java package in [https://github.com/lapps/org.lappsgrid.discriminator](https://github.com/lapps/org.lappsgrid.discriminator)

**check whether this all still works**

Discriminators are used in the produces and requires sections of a tool wrapper's metadata. It is up to the tool wrapper to check whether input has what it needs (searching the contains section of the metadata section of a view. THere is also a discriminator handed in with the Data structure, which has a discriminator and a payload section. The dicriminator there is one of the dozen or so media discriminators in [http://vocab.lappsgrid.org/discriminators](http://vocab.lappsgrid.org/discriminators) (for example, the discriminator gate	which refers to http://vocab.lappsgrid.org/ns/media/xml#gate).

Deploying:

THis is explained in the wrapping manual in [github.com/lapps/org.lappsgrid.examples](https://github.com/lapps/org.lappsgrid.examples), which was listed above. 

After deploying a war file to tomcat the new war will be deployed automatically, but if you changed Java versions while running a tomcat server then you do need to restart Tomcat.


Registering:

- Using lddl-scripts in [https://github.com/lappsgrid-incubator/lddl-scripts](https://github.com/lappsgrid-incubator/lddl-scripts)

- Register using LDDL to update the service on the service manager on vassar or brandeis servers. Using Brandeis.lddl for Brandeis in lddl-scripts. Brandeis.lddl refers to lddl scripts in the brandeis subdirectory, thise would typically be changed or scripts would be added there for deploying new tools. There is a fork of this on brandeis-nlp, will probably rplace that by using a brandeis branch on lappsgrid-incubator.

- We are still assuming old version of the service manager

- The lddl-scripts/Udate.lddl script takes another script from brandeis or vassar and installs/updates just that module

- **check whether this works with new service manager**


### Setting up Galaxy

Documentation is in [http://wiki.lappsgrid.org/technical/galaxy.html](http://wiki.lappsgrid.org/technical/galaxy.html).

This uses scripts in [installation and setup scripts](http://downloads.lappsgrid.org/scripts/). Which has a bunch of ubuntu style setup scripts.

There are two repos with Galaxy code:
    
- We have a fork [https://github.com/lappsgrid-incubator/Galaxy](https://github.com/lappsgrid-incubator/Galaxy) of [https://github.com/galaxyproject/galaxy](https://github.com/galaxyproject/galaxy) with some lapps specific modifications

- The LAPPS Grid modifications to core Galaxy are in the [GalaxyMods](https://github.com/lappsgrid-incubator/GalaxyMods) repository

In additoin, there are Galaxy webhooks for extending the Galaxy client without changing the Galaxy code base at [https://docs.galaxyproject.org/en/latest/admin/webhooks.html](https://docs.galaxyproject.org/en/latest/admin/webhooks.html)

- Planemo

- Visualization
   
   **find chunqi paper**
.. [https://wiki.galaxyproject.org/Develop/Visualizations](https://wiki.galaxyproject.org/Develop/Visualizations)


### Federation

No documentation available. We first need to get everything on the latest service manager.


### Making services run on https

Some MV notes somewhere, **find them**


### Authorization of data services (LDC)

This is actually just a token header that is put in ...


### How to create Docker images

There is a manual at ...

Repositories:
- [https://github.com/lappsgrid-incubator/docker-service-manager](https://github.com/lappsgrid-incubator/docker-service-manager)
- [https://github.com/lappsgrid-incubator/docker-masc](https://github.com/lappsgrid-incubator/docker-masc)
- [https://github.com/lappsgrid-incubator/docker-vassar](https://github.com/lappsgrid-incubator/docker-vassar)
- [https://github.com/lappsgrid-incubator/docker-brandeis](https://github.com/lappsgrid-incubator/docker-brandeis)
- [https://github.com/lappsgrid-incubator/docker-oaqa](https://github.com/lappsgrid-incubator/docker-oaqa)

The Docker repos tend to have branches that are not intended to be merged again. For example, the vassar, brandeis, service-manager, galaxy-lappsgrid et al all have a discovery branch. In addition, they also have a tag named discovery that tags a particular commit on the discovery branch.

The docker-service-manager repo on the discovery branch has a file Dockerfile.discovery, which clones https://github.com/ksuderman/lddl-scripts.git (which actually was moved to lappsgrid-incubator.

On the docker repos, there is a tag named discovery, which gets to the images created from commits with the discovery tag.

The split with brandeis/vassar is historical, we may want to do something along the lines of docker-stanford, docker-lingpipe etcetera.



### Running on AWS
  
- [Discovery course](https://github.com/lappsgrid-incubator/discovery-course)


### Running on JetStream

Quick applicatin process to get 200K service units, which should allow us to run the grid for a year

Uses OpenStack, which seems to be what AWS is using too.

There is a bash script at [downloads.lappsgrid.org/scripts](downloads.lappsgrid.org/scripts).

**Keigh + Marc: review how to do that from Keith's example of a few months ago**

Repositories:
- [https://github.com/lappsgrid-incubator/jetstream-scripts](https://github.com/lappsgrid-incubator/jetstream-scripts)


### Creating a lappsgrid with appliances

- A system for configuring a network of LAPPS Grid Docker images
- [https://github.com/lappsgrid-incubator/galaxy-appliance](https://github.com/lappsgrid-incubator/galaxy-appliance)


### Using Ansible

Like bash scripts but more portable.

[https://github.com/lappsgrid-incubator/lapps-container](https://github.com/lappsgrid-incubator/lapps-container)


### Conda, toolshed and friends



### Using Jupyter

- [https://github.com/lappsgrid-incubator/jupyter-groovy-kernel](https://github.com/lappsgrid-incubator/jupyter-groovy-kernel)

- [https://github.com/lappsgrid-incubator/jupyter-lsd-kernel](https://github.com/lappsgrid-incubator/jupyter-lsd-kernel)
  


### LDDL and LSD

- Both are Groovy DSLs

- LSD - Lapps Services DSL, a DSL for invoking LAPPS web services (possibly pipelined).

- The code base for LSD is at [https://github.com/lappsgrid-incubator/org.anc.lapps.dsl](https://github.com/lappsgrid-incubator/org.anc.lapps.dsl)

- LDDL - LAPPS Database Definition Language

- Configuration scripts for the LAPPS grid at [https://github.com/lappsgrid-incubator/org.anc.lapps.lddl](https://github.com/lappsgrid-incubator/org.anc.lapps.lddl)

- LDDL scripts at [https://github.com/lappsgrid-incubator/lddl-scripts](https://github.com/lappsgrid-incubator/lddl-scripts)

- [http://www.lappsgrid.org/software/](http://www.lappsgrid.org/software/) has some notes on LDDL and LSD

- Description of LDDL: [http://www.lappsgrid.org/software/lddl/](http://www.lappsgrid.org/software/lddl/)

- There is an outdated wiki at [https://github.com/ksuderman/lsd-scripts/wiki](https://github.com/ksuderman/lsd-scripts/wiki)


### Repositories

Where are all the repositories, what do they do and what is their role in the bigger picture
  
- The LAPPS Grid incubator organization at [https://github.com/lappsgrid-incubator](https://github.com/lappsgrid-incubator)

- The LAPPS organization at [https://github.com/lapps](https://github.com/lapps)

- The Galaxy NLP organization at [https://github.com/galaxy-nlp](https://github.com/galaxy-nlp)

- The Brandeis NLP organization at [https://github.com/brandeis-nlp](https://github.com/brandeis-nlp)
    - code for wrappers created at Brandeis

- The OANC organization at [https://github.com/oanc](https://github.com/oanc)
    - code for wrappers created at Vassar
 
  
### Goals for first day

Layout of basic redesign of lappsgrid.github.io.

Come up with scenarios of what somebody may want to do given some configuration. For example:

- I have a server and want to have a Lapps Grid
- I want something running in AWS
- I want to add my tool to a grid

