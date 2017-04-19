---
layout: slate
title: Creating and Using Docker Images
---

## {{ page.title }}

<div class="image">
<img src="https://lapps.github.io/installation/images/lapps-docker.png" width="500">
<div class="caption"></div>
</div>


### Using Docker images

The easiest way to build a functioning LAPPS Grid is to rely on pre-built Docker images and use the scripts at [https://github.com/lappsgrid-incubator/galaxy-appliance](https://github.com/lappsgrid-incubator/galaxy-appliance). The [README](https://github.com/lappsgrid-incubator/galaxy-appliance/blob/master/README.md) file in that repository has some instructions on how to use the scripts. For redundancy's sake, here is yet another overview, with command examples tailored to Mac OSX 10.11.

First you need to meet the prerequisites, which are:

1. [Docker](https://www.docker.com/) must be installed and running. Make sure that [docker-compose](https://docs.docker.com/compose/) is part of the Docker installation, which would be the case if you are a Windows or Mac user and you installed Docker.

2. Install the Tool Config Editor (tce). See instructions at (https://github.com/oanc/tool-conf-editor) or get a [pre-built binary distribution](http://www.anc.org/downloads/ToolConfEditor-latest.tgz). One way to use tce is to put the tce script and the associated jar (ToolConfEditor-1.0.1.jar or some later version) from the download in the `galaxy-appliance` directory and to temporarily set the path in your terminal window with
```
 $ export PATH=$PATH:.
```

3. Install groovy and wget if you do not already have them.
```
$ brew install groovy
$ brew install wget
```

With the above in place you can simply run

```
$ ./make-appliance module [module ...]
$ docker-compose up
```


### Building Docker images



### Scribbles

There are notes at [http://wiki.lappsgrid.org/technical/docker](http://wiki.lappsgrid.org/technical/docker).

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
