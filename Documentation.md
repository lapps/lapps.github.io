---
layout: slate
title: Documentation
---

## {{ page.title }}

Some notes going into the Documentation meeting at Brandeis, 1/1/2017-2/2/2017.

We already agreed that:

- Documentation will live in [lappsgrid.github.io](lappsgrid.github.io), which will be redesigned
- The domain wiki.lappsgrid.org points to lappsgrid.github.io. The github.io page is technically not a wiki but close enough.

Start with a blank slate and figure out the exact procedures for creating a LAPPS Grid. In particular, what needs to be done for the following to happen:

- Installing a service manager - requirements (debian, rhel, osx), start with virgin machine (JetStream instance)
  - Quick applicatin process to get 200K service units, which should allow us to run the grid for a year
  - [http://wiki.lappsgrid.org/manuals/service-manager/install-service-manager/index.html](http://wiki.lappsgrid.org/manuals/service-manager/install-service-manager/index.html)
  
- How to create services - wrapping, discriminators, LIF, WSEV, registering
  - [Wrapping services](https://github.com/lapps/org.lappsgrid.examples) - README.md file in org.lappsgrid.examples repository
  - [LIF specifications](interchange/index.html)
  - [LIF JSON-schema](schema/lif-schema.json)
  - [WSEV at http://vocab.lappsgrid.org/](http://vocab.lappsgrid.org/)
  - [WSEV discussion](http://wiki.lappsgrid.org/vocabulary/current_issues.html)
  - [WSEV issues](https://github.com/lapps/vocabulary-pages/issues)
  - [Creating vocabulary pages](https://github.com/lapps/vocabulary-pages)

- Setting up Galaxy
  - [http://wiki.lappsgrid.org/technical/galaxy.html](http://wiki.lappsgrid.org/technical/galaxy.html)
  - [installation and setup scripts](http://downloads.lappsgrid.org/scripts/)
  - Two repos with Galaxy code:
    - We have a fork [https://github.com/lappsgrid-incubator/Galaxy](https://github.com/lappsgrid-incubator/Galaxy) of [https://github.com/galaxyproject/galaxy](https://github.com/galaxyproject/galaxy) with some lapps specific modifications
    - The LAPPS Grid modifications to core Galaxy are in the [GalaxyMods](https://github.com/lappsgrid-incubator/GalaxyMods) repository
    - There are Galaxy webhooks for extending the Galaxy client without changing the Galaxy code base at [https://docs.galaxyproject.org/en/latest/admin/webhooks.html](https://docs.galaxyproject.org/en/latest/admin/webhooks.html)
    - Planemo
    - Visualization

- Federation
  - No documentation available
  - We first need to get everything on the latest service manager

- Making services run on https
  - Some MV notes somewhere

- Authorization of data services (LDC)
  - This is actually just a token header that is put in ...

- How to create Docker images
  - manual at ...
  - [https://github.com/lappsgrid-incubator/docker-service-manager](https://github.com/lappsgrid-incubator/docker-service-manager)
  - [https://github.com/lappsgrid-incubator/docker-masc](https://github.com/lappsgrid-incubator/docker-masc)
  - [https://github.com/lappsgrid-incubator/docker-vassar](https://github.com/lappsgrid-incubator/docker-vassar)
  - [https://github.com/lappsgrid-incubator/docker-brandeis](https://github.com/lappsgrid-incubator/docker-brandeis)
  - [https://github.com/lappsgrid-incubator/docker-oaqa](https://github.com/lappsgrid-incubator/docker-oaqa)

- Running on AWS
  - [Discovery course](https://github.com/lappsgrid-incubator/discovery-course)

- Running on JetStream
  - [https://github.com/lappsgrid-incubator/jetstream-scripts](https://github.com/lappsgrid-incubator/jetstream-scripts)
  
- Creating a lappsgrid with appliances
  - A system for configuring a network of LAPPS Grid Docker images
  - [https://github.com/lappsgrid-incubator/galaxy-appliance](https://github.com/lappsgrid-incubator/galaxy-appliance)

- Ansible
  - [https://github.com/lappsgrid-incubator/lapps-container](https://github.com/lappsgrid-incubator/lapps-container)

- Conda, toolshed and friends

- Using Jupyter

Other questions:

- The roles of LDDL and LSD
  - LDDL - LAPPS Database Definition Language
  - Configuration scripts for the LAPPS grid at [https://github.com/lappsgrid-incubator/org.anc.lapps.lddl](https://github.com/lappsgrid-incubator/org.anc.lapps.lddl)
  - LDDL scripts at [https://github.com/lappsgrid-incubator/lddl-scripts](https://github.com/lappsgrid-incubator/lddl-scripts)

- Where are all the repositories, what do they do and what is their role in the bigger picture
  - The LAPPS Grid incubator organization at [https://github.com/lappsgrid-incubator](https://github.com/lappsgrid-incubator)
  - The LAPPS organization at [https://github.com/lapps](https://github.com/lapps)
  - The Galaxy NLP organization at [https://github.com/galaxy-nlp](https://github.com/galaxy-nlp)
  - The Brandeis NLP organization at [https://github.com/brandeis-nlp](https://github.com/brandeis-nlp)
    - code for wrappers created at Brandeis
  - The OANC organization at [https://github.com/oanc](https://github.com/oanc)
    - code for wrappers created at Vassar
 
  
### Goals for first day

Do not get lost in details, expand on the list above and get an overview of each item, filling in all we know and collecting in the wiki, by copying in text or by providing links, all information that is relevant and noting what information is missing.

Layout of basic redesign of lappsgrid.github.io.

Come up with scenarios of what somebody may want to do given some configuration. For example:

- I have a server and want to have a Lapps Grid
- I want something running in AWS
- I want to add my tool to a grid

