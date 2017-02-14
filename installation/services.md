---
layout: slate
title: Installing Services
---

## {{ page.title }}

This page describes how to create services.

<div class="image">
<img src="https://lapps.github.io/installation/images/lapps-services.png" width="600">
<div class="caption"></div>
</div>

Adding a service involves various things:

1. Wrapping the service as a Web Application. This is not just about creating a war file but also requires the developer to use
  - discriminators,
  - the LAPPS Interchange Format (LIF), 
  - the Web Sevices Exchange Vocabulary (WSEV)
2. Deploying the service.
3. Registering the service with the Service Manager.


### Wrapping a Service

There are extensive notes on how to wrap a service at [https://github.com/lapps/org.lappsgrid.examples](https://github.com/lapps/org.lappsgrid.examples). Those notes are set up as a series of steps and each time you click a next step then the code associated with that step will be presened in the repository. The result of all those steps can be obtained as follows:

```
$ git clone https://github.com/lapps/org.lappsgrid.examples
$ git checkout step5
$ mvn clean package
```

This will create a war file named `target/YOUR_ARTIFACT_NAME.war` since we have not changed any of the defaults.



#### LIF and WSEV:

- output of wrapped components should follow LIF specifications and use elements from WSEV
- [LIF specifications](interchange/index.html)
- [LIF JSON-schema](schema/lif-schema.json)
- [WSEV at http://vocab.lappsgrid.org/](http://vocab.lappsgrid.org/)
- [WSEV discussion](http://wiki.lappsgrid.org/vocabulary/current_issues.html)
- [WSEV issues](https://github.com/lapps/vocabulary-pages/issues)

#### Vocabulary and Discriminators:

- everything in vocab is in discriminators but not vice versa (vocab ⊂ discriminator)
- there is a vocab dsl and a discriminators dsl (both configuration files for transformations)
  1. [https://github.com/lappsgrid-incubator/vocabulary-dsl](https://github.com/lappsgrid-incubator/vocabulary-dsl)
  2. [https://github.com/lappsgrid-incubator/org.lappsgrid.discriminator.dsl](https://github.com/lappsgrid-incubator/org.lappsgrid.discriminator.dsl)
- the input to 1 is `lapps.vocab` in [https://github.com/lapps/vocabulary-pages](https://github.com/lapps/vocabulary-pages) (there are also template files and other onput files for the mapping in there), it creates 
  1. vocab.lappsgrid.org `html`, 
  1. [org.lappsgrid.vocabulary](https://github.com/lapps/org.lappsgrid.vocabulary) (which is like the discriminator package and describes attribute names etcetera defined in the vocab), 
  1. and a Groovy config DSL file with same content
- the input to 2 is the config DSL file above and a file named [discriminators.config](https://github.com/lappsgrid-incubator/org.lappsgrid.discriminator.dsl/blob/master/src/main/resources/discriminators.config) in the org.lappsgrid.discriminator.dsl repository, the output is [http://vocab.lappsgrid.org/discriminators](http://vocab.lappsgrid.org/discriminators) page and parts of the java package in [https://github.com/lapps/org.lappsgrid.discriminator](https://github.com/lapps/org.lappsgrid.discriminator)

**check whether this all still works**

Discriminators are used in the produces and requires sections of a tool wrapper's metadata. It is up to the tool wrapper to check whether input has what it needs (searching the contains section of the metadata section of a view. THere is also a discriminator handed in with the Data structure, which has a discriminator and a payload section. The dicriminator there is one of the dozen or so media discriminators in [http://vocab.lappsgrid.org/discriminators](http://vocab.lappsgrid.org/discriminators) (for example, the discriminator gate	which refers to http://vocab.lappsgrid.org/ns/media/xml#gate).


### Deploying:

Simply put the war file in the `webapps` directory under a Tomcat server set up for the service. This is also explained in the wrapping manual in [github.com/lapps/org.lappsgrid.examples](https://github.com/lapps/org.lappsgrid.examples) under step 4 near the end. After deploying a war file to Tomcat the new war will be deployed automatically (however, if you changed Java versions while running a tomcat server then you do need to restart Tomcat).


### Registering:

You register services with the Service Manager by using LDDL scripts like the ones at [https://github.com/lappsgrid-incubator/lddl-scripts](https://github.com/lappsgrid-incubator/lddl-scripts). LDDL is the LAPPS Database Description Language, which is a Groovy DSL (Domain Specific Language) that can be used to initialize a LAPPS Grid database. See [http://www.lappsgrid.org/software/lddl/] (http://www.lappsgrid.org/software/lddl/) for more information on LDDL.

To run LDDL scripts you need the LDDL jar that you can create from the code at [https://github.com/lappsgrid-incubator/org.anc.lapps.lddl](https://github.com/lappsgrid-incubator/org.anc.lapps.lddl).

```
$ git clone https://github.com/lappsgrid-incubator/org.anc.lapps.lddl
$ cd org.anc.lapps.lddl/
$ make jar
$ cp target/lddl-1.3.4.jar ~/bin
```

You can now take the main LDDL script at `src/main/resources` and edit it by replacing `__VERSION__` by the current version number. Then put the `lddl` script somewhere and make sure that location is on the path.

```
$ sed 's/__VERSION__/1.3.4/g' src/main/resources/lddl > lddl
$ chmod +x lddl
$ mv lddl ~/bin
$ export PATH=~/bin:$PATH
```

[https://github.com/lappsgrid-incubator/org.anc.lapps.lddl](https://github.com/lappsgrid-incubator/org.anc.lapps.lddl)

Use the lddl-scripts in [https://github.com/lappsgrid-incubator/lddl-scripts](https://github.com/lappsgrid-incubator/lddl-scripts)

Register using LDDL to update the service on the service manager on vassar or brandeis servers. Using Brandeis.lddl for Brandeis in lddl-scripts. Brandeis.lddl refers to lddl scripts in the brandeis subdirectory, thise would typically be changed or scripts would be added there for deploying new tools. There is a fork of this on brandeis-nlp, will probably rplace that by using a brandeis branch on lappsgrid-incubator.

We are still assuming old version of the service manager

The lddl-scripts/Update.lddl script takes another script from brandeis or vassar and installs/updates just that module

**check whether this works with new service manager**

- there is a cleanup script that cleans out the database but with the new database there may be new fields that ar enot cleaned up.
