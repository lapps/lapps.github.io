---
layout: default
title: Installing LAPPS/Galaxy - local install
---


# Installing a local LAPPS/Galaxy instance

This page describes setting up a local LAPPS Grid Galaxy instance for quick experimentation. There is considerable overlap with the page on installing a [production instance](galaxy.html) and it would be a good idea to skim through that page as well, but this page should be mostly stand on its own. The main difference with installing a production in stance is that no PostgreSQL installation is needed here.

For a list of known issues and workarounds see [galaxy-known-issues.html](galaxy-known-issues.html).


### Prerequisites

The following are required:

- Python 2.7 and pip
- Bash shell
- Java 8
- SQLite
- Git
- LSD

Install scripts for some of the above are available at [http://downloads.lappsgrid.org/scripts](http://downloads.lappsgrid.org/scripts), these scripts are only tested for Ubuntu though. The only esoteric prerequisite is LSD (LAPPS Services DSL, a Groovy based Domain Specific Language for scripting services on the LAPPS Grid). You can access the LSD repository at https://github.com/lappsgrid-incubator/org.anc.lapps.dsl. There is a link to get a zip archive with the latest binary which includes a jar and a file named `lsd` which you should make available as a command by putting it on your shell path. You could also peek at the install scripts at https://downloads.lappsgrid.org/scripts/install-lsd.sh for hints.


### Installing the instance

First you get the code in the [Galaxy](http://github.com/lappsgrid-incubator/Galaxy.git) and [GalaxyMods](http://github.com/lappsgrid-incubator/GalaxyMods.git) repositories:

```bash
$> cd /home/galaxy
$> git clone http://github.com/lappsgrid-incubator/Galaxy.git galaxy
$> git clone http://github.com/lappsgrid-incubator/GalaxyMods.git mods
```

It does not matter where on the the local file system you do this, but you need to save these in directories named `galaxy` and `mods` (later steps depend on those exact names) and the two repositories need to be in the same directory. For this example we use `/home/galaxy`.

You need to determine what branches to use for both repositories. Unfortunately, there is not a lot of help on this in those repositories and there is no published list of dependencies. The page for installing a production instance says to use the `lapps` branch of the Galaxy repository and the `master` branch of the GalaxyMods repository.

Next you need to run the patch script at https://downloads.lappsgrid.org/scripts/patch-galaxy-ini.sh. This needs to be done from the directory where `galaxy` and `mods` are located:

```bash
$> cd /home/galaxy
$> chmod +x patch-galaxy-ini.sh
$> ./patch-galaxy-ini.sh /home/galaxy
```

This script takes `mods/config/galaxy.ini`, makes some changes to it and saves the result in `galaxy/config/galaxy.ini`. Part of what this script does is technically not necessarily needed for a local install (for example, it gets a password for the PostgreSQL database) but that is okay.

For the simplest install we use SQLite instead of PostgreSQL. Unfortunately, the `mods/config/galaxy.ini` configuration file in `mods/config/galaxy.ini` assumes PostgreSQL so we need to change a few lines in `mods/config/galaxy.ini`:


```
#database_connection = sqlite:///./database/universe.sqlite?isolation_level=IMMEDIATE
database_connection = postgresql://galaxy:SA4.rY5l0kP!EYkjM%2l8.s!@localhost/galaxy
==>
database_connection = sqlite:///./database/universe.sqlite?isolation_level=IMMEDIATE
#database_connection = postgresql://galaxy:SA4.rY5l0kP!EYkjM%2l8.s!@localhost/galaxy
```

```
database_engine_option_server_side_cursors = True
==>
#database_engine_option_server_side_cursors = True
```

Finally, you start galaxy from the root galaxy directory:

```bash
$> cd /home/galaxy/galaxy
$> ./run.sh
```

First time you run this a lot of Python modules will be downloaded and the whole process takes a while. Also the first time the SQLite database will be set up and modified many times. After the first time start up should be much faster. After executing the `runs.sh` script a LAPPS/Galaxy instance should be running at http://127.0.0.1:8000.
