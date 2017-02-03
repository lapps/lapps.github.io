---
layout: slate
title: Creating and Using Docker Images
---

## {{ page.title }}


### How to create Docker images

There is a manual at ...

Notes at [http://wiki.lappsgrid.org/technical/docker](http://wiki.lappsgrid.org/technical/docker).

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
