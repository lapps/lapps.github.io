---
layout: default
title: Installing LAPPS/Galaxy
---

# Installing LAPPS/Galaxy

This page describes setting up a production LAPPS Grid Galaxy instance on a fresh Ubuntu 14.04 LTS instance. The easiest way to run a LAPPS Grid Galaxy instance is to use one of the Docker images available from the [Docker Hub](https://hub.docker.com). However at times it is required to install and run a Galaxy instance from the sources in the GitHub repository.


For some pointers on how to do a local install for quick experimentation see [galaxy-local.html](galaxy-local.html). For a list of known issues and workarounds see [galaxy-known-issues.html](galaxy-known-issues.html). 


## TL;DR

On a fresh Ubuntu install run:

```bash
$> curl -sSL http://downloads.lappsgrid.org/scripts/galaxy-setup.sh | bash
$> cd /home/galaxy/galaxy
$> HOME=/home/galaxy sudo -u galaxy ./run.sh
```

## The Long Version

### Prerequisites

To run Galaxy and all of the LAPPS Grid tools the following packages are required:

1. Java
1. PostgreSQL
1. LSD
1. Galaxy

Install scripts are available from [http://downloads.lappsgrid.org/scripts](http://downloads.lappsgrid.org/scripts) to perform all of the above tasks.

### Common Packages

Install the common utilities, Postgres, Java, and LSD packages.  The database will be configured below:

```bash
$> curl -sSL http://downloads.lappsgrid.org/scripts/install-common.sh | bash
$> curl -sSL http://downloads.lappsgrid.org/scripts/install-postgres.sh | bash
$> curl -sSL http://downloads.lappsgrid.org/scripts/install-java.sh | bash
$> curl -sSL http://downloads.lappsgrid.org/scripts/install-lsd.sh | bash
```

**NOTE** The *install-common.sh* script may display some error messages when used on a [Jetstream](/technical/jetstream.html) instance.  This seems to be due to Jetstream/OpenStack not allowing some OS packages (i.e. firmware) to be updated.  It should be safe to ignore these errors.


### Galaxy User

Create a system account for running galaxy.  We want to create a system account as the *galaxy* user should not be able to login to the system.

```bash
$> adduser galaxy --system --group
```

### Selecting a Secure Password

Since both both the database setup script (see below) and the *galaxy.ini* file are available from publicly accessible repositories we will need to change the passwords stored in these files.  Currently both files use *\__DB_PASSWORD\__* as the database password to make it easier to update both via a `sed` command.

For production use it is **highly recommended** to use a strong password.  The web service [http://api.lappsgrid.org/password](http://api.lappsgrid.org/password) can be used to generate cryptographically strong random passwords of any length.  We can use this web service to generate a password and then store it someplace secure on the server (*/root* is a good location) in case an administrator needs to connect to the database later.

```bash
$> curl -sSL http://api.lappsgrid.org/password?length=24 > /root/postgres.passwd
$> export PASSWORD=`cat /root/postgres.passwd`
```

We store the generated password in the environment variable **$PASSWORD** to make it easier to use below.

### Galaxy

The LAPPS Grid Galaxy instance it stored in two repositories on GitHub:

1. **https://github.com/lappsgrid-incubator/Galaxy.git**<br/>
This is a fork of the [main Galaxy repository](https://github.com/galaxyproject/galaxy). We try to leave this repository alone as much as possible, but currently it contains several modified JavaScript files for the Galaxy client to configure the masthead and allow tools to be connected in the workflow editor if a converter exists (e.g. connecting a GATE tool to a tool that expects LIF).
1. **https://github.com/lappsgrid-incubator/GalaxyMods.git**<br/>
Currently this repository contains the datatype definitions, tool wrappers, and other files that can be stored externally and then configured in the *galaxy.ini* file. A sample *galaxy.ini* file is included as a starting point.

When the repositories have been checked out to a local system it is important to ensure you are working from the correct branch.

| Repository | Branch |
|------------|--------|
| Galaxy.git | lapps |
| GalaxyMods.git | master|


Clone the Git repositories into */home/galaxy*.  The default *galaxy.ini* configuration file assumes that the Galaxy configuration files (tool_conf.xml, datatypes_conf.xml etc.) can all be found in */home/galaxy/mods*. If the Galaxy repository is checked out to a location other that */home/galaxy* then the *galaxy.ini* file will need to be updated accordingly.

```bash
$> cd /home/galaxy
$> HOME=/home/galaxy sudo -u galaxy git clone http://github.com/lappsgrid-incubator/Galaxy.git galaxy
$> HOME=/home/galaxy sudo -u galaxy git clone http://github.com/lappsgrid-incubator/GalaxyMods.git mods
$> cd galaxy
$> git checout lapps
$> cd -
```

**NOTE:** We must set `HOME=/home/galaxy` when using `sudo -u` as sudo does not update the environment and will leave `HOME=/root`, which the *galaxy* user can not read/write.

#### Securing Galaxy

There are four values that have been parameterized in the default *galaxy.ini* file that will need to be replaced before Galaxy can be started.  They are:

- **\__PORT__**<br/>
The port that Galaxy will listen on.
- **\__INSTALL_DIR__**<br/>
The directory containing the two GitHub repositories.
- **\__DB_PASSWORD__**<br/>
The password to access the *galaxy* database.
- **\__ID_SECRET__**<br/>
Galaxy's "secret" that it uses to encrypt sensitive data.

You can either edit the *galaxy.ini* directly and replace all occurrences of the above or you can use the [http://downloads.lappsgrid.org/scripts/patch-galaxy-ini.sh](http://downloads.lappsgrid.org/scripts/patch-galaxy-ini.sh) script to replace the occurrences for you.

The *patch-galaxy-ini.sh* script accepts one parameter: the path to the directory containing the *galaxy* and *mods* directories; */home/galaxy* in this case.  The script will also use the environment variables **PORT**, **PASSWORD**, and **SECRET** if defined.  The **PORT** will default to 8000 if not defined, and the **PASSWORD** and **SECRET** will be generated with the password web service if not defined.  Recall that we did define **PASSWORD** above.

```bash
$> wget http://downloads.lappsgrid.org/scripts/patch-galaxy-ini.sh
$> chmod +x patch-galaxy-ini.sh
$> PORT=80 ./patch-galaxy-ini.sh /home/galaxy
```

### Database Setup

Use the script [http://downloads.lappsgrid.org/scripts/db-setup.sql](http://downloads.lappsgrid.org/scripts/db-setup.sql) to configure the Postgres database.  Galaxy will create and populate the tables it needs when it starts for the first time, we just need to create the database and database user (role) for Galaxy to use.

The *db-setup.sql* script does three things

1. Create a database named **galaxy**
1. Create a user (role) also named **galaxy**
1. Make the **galaxy** user the owner of the **galaxy** database.

Before running the script we will also have to replace the *\__DB_PASSWORD__* string just as we did for the *galaxy.ini* file.

```bash
$> curl -sSL http://downloads.lappsgrid.org/scripts/db-setup.sql | sed "s/__DB_PASSWORD__/$PASSWORD/" | sudo -u postgres psql
```

### Starting Galaxy

For the purposes of this example we will launch galaxy using the *run.sh* script in the root galaxy directory.

```bash
$> chown -R galaxy:galaxy /home/galaxy
$> cd /home/galaxy/galaxy
$> HOME=/home/galaxy sudo -u galaxy ./run.sh
```

The above is useful during development and development as the Galaxy log is displayed in the console window.  However, in production Galaxy should be configured to run as a proper service. Galaxy includes example supervisord conf and SysV style init scripts in the contrib/ directory.  For example, on Debian/Ubuntu systems:

``` 
# Run as sudo
$> cp /home/galaxy/galaxy/contrib/galaxy.debian-init /etc/init.d/galaxy
$> update-rc.d galaxy defaults
$> service galaxy start
```

# Migrating Galaxy

To migrate a Galaxy installation to a new server requires three steps

1. Install Galaxy on the new server
1. Export data from the current Galaxy server
1. Install the data on the new Galaxy server

Both Galaxy servers should have the same set of tools installed, same datatypes, and any other custom configurations.  This usually just means both servers have the same branches checked out in Git.


### Exporting Data

All of the files in Galaxy's `database` directory (`/home/galaxy/galaxy/database` by default) need to be copied as well as the contents of the Postgres database.

``` 
$> cd /home/galaxy/galaxy
$> sudo -u postgres pg_dump -U postgres -O galaxy > galaxy.sql
$> tar czf galaxy-files.tgz galaxy.sql database/
```

Transfer the *galaxy-files.tgz* to the `/home/galaxy/galaxy` directory on the new server.

### Importing Data

If Galaxy has been started, or Galaxy was installed using the scripts above then there will already be a database named *galaxy* in Postgres. This database needs to be dropped and recreated before data is imported from the old server.

``` 
$> sudo -u postgres psql
psql (9.6.10)
Type "help" for help.

postgres=# drop database galaxy;
DROP
postgres=# create database galaxy;
CREATE
postgres=# grant all privileged on database galaxy to galaxy;
GRANT
postgres=# \quit

$>
```

If the *galaxy-files.tgz* archive if unpacked in `/home/galaxy/galaxy` then the `database/` directory will be recreated, but the current `database/` directory should be renamed or removed.  Then the Postgres database can be recreated.
``` 
$> cd /home/galaxy/galaxy
$> sudo -u galaxy tar xzf galaxy-files.tgz
$> sudo -u galaxy psql -U galaxy -d galaxy -f galaxy.sql
$> sudo service start galaxy
``` 

**Note** This procedure does not take into account any customizations (datatypes, galaxy.ini etc) or installed tools.
 
# TODO

1. Explain installing and using **supervisord** to run Galaxy as a proper service.
