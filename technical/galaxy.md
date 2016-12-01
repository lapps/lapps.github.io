---
layout: slate
title: Galaxy
---

# {{ page.title }}

The easiest way to run a LAPPS Grid Galaxy instance is to use one of the Docker images available from the Docker Hub.  However at times it is required to run the Galaxy instance from the GitHub repository.

The LAPPS Grid Galaxy instance it stored in two repositories on GitHub:

1. **https://github.com/lappsgrid-incubator/Galaxy.git**<br/>
This is a fork of the [main Galaxy repository](https://github.com/galaxyproject/galaxy). We try to leave this repository alone as much as possible, but currently it contains several modified JavaScript files for the Galaxy client to configure the masthead and allow tools to be connected in the workflow editor if a converter exists (e.g. connecting a GATE tool to a tool that expects LIF).
1. **https://github.com/lappsgrid-incubator/GalaxyMods.git**<br/>
Currently this repository contains the datatype definitions, tool wrappers, and other files that can be stored externally and then configured in the *galaxy.ini* file. A sample *galaxy.ini* file is included as a starting point.

When the repositories have been checked out to a local system it is important to ensure you are working from the correct branch.

| Repository | Branch |
|------------|--------|
| Galaxy.git | lappsdev |
| GalaxyMods.git | master|

## System Setup

For the purposes of this document we will assume a brand new OS install (Ubuntu 14.04 LTS).

### Common Utilities and Postgres

Install the common utilities and Postgres database package.  The database will be configured below:

```bash
$> curl -sSL http://downloads.lappsgrid.org/scripts/install-common.sh | sh
$> curl -sSL http://downloads.lappsgrid.org/scripts/install-postgres.sh | sh
```

**NOTE** The *install-common.sh* script may display some error messages when used on a [Jetstream](/technical/jetstream.html) instance.  This seems to be due to Jetstream/OpenStack not allowing some OS packages (i.e. firmware) to be updated.  It should be safe to ignore these errors.

### Galaxy User

Create a user for running galaxy.  The `useradd -r` command creates a system account, that is, no home directory is created and the user can not login.

```bash
$> useradd -r galaxy
```

Since the `useradd -r` command does not create a home directory for the user we will need to do that manually and then make the *galaxy* user the owner of the */home/galaxy* directory.

```bash
$> mkdir /home/galaxy
$> chown galaxy:galaxy galaxy
```

### Selecting a Secure Password

Since both both the database setup script (see below) and the *galaxy.ini* file are available from publicly accessible repositories we will need to change the passwords stored in these files.  Currently both files use *\__DB_PASSWORD\__* as the database password to make it easier to update both via a `sed` command.

For production use it is **highly recommended** to use a strong password.  The web service [http://grid.anc.org:9080/password](http://grid.anc.org:9080/password) uses the Java class *java.security.SecureRandom* to generate cryptographically strong random passwords of any length.  We can use this web service to generate a password and then store it someplace secure on the server (*/root* is a good location) in case an administrator later needs to connect to the database.

```bash
$> curl -sSL http://grid.anc.org:9080/password?length=24 > /root/postgres.passwd
$> PASSWORD=`cat /root/postgres.passwd`
```

We store the generated password in the environment variable **$PW** to make it easier to use below.

### Galaxy 
Clone the Git repositories into */home/galaxy*.  The default *galaxy.ini* configuration file assumes that the Galaxy configuration files (tool_conf.xml, datatypes_conf.xml etc.) can all be found in */home/galaxy/mods*. If the Galaxy repository is checked out to a location other that */home/galaxy* then the *galaxy.ini* file will need to be updated accordingly.

```bash
$> cd /home/galaxy
$> git clone http://github.com/lappsgrid-incubator/Galaxy.git galaxy
$> git clone http://github.com/lappsgrid-incubator/GalaxyMods.git mods
```

#### Securing Galaxy

As mentioned above we will need to update the database password as will as the *id_secret* value in the *galaxy.ini* file.  We can use the following Python command to generate the *id_secret*:

```bash
$> SECRET=$(python -c 'import time; print time.time()' | md5sum | cut -f1 -d ' ')
```

Now we can use `sed` to replace the database password and *id_secret* when making a copy in */home/galaxy/galaxy/config/galaxy.ini*:

```bash
$> cd /home/galaxy
$> cat mods/config/galaxy.ini | sed "s/__DB__PASSWORD/$PASSWORD/" | sed "s/__ID_SECRET__/$SECRET/" > galaxy/config/galaxy.ini 
```

### Database Setup

Use the script [http://downloads.lappsgrid.org/scripts/db-setup.sql](http://downloads.lappsgrid.org/scripts/db-setup.sql) to configure the Postgres database.  Galaxy will create and populate the tables it needs when it starts for the first time, we just need to create the database and database user (role) for Galaxy to use.

The *db-setup.sql* script does three things

1. Create a database named **galaxy**
1. Create a user (role) also named **galaxy**
1. Make the **galaxy** user the owner of the **galaxy** database.

Before running the script we will also have to replace the *\__DB_PASSWORD__* string just as we did for the *galaxy.ini* file.

```bash
$> curl -sSL http://downloads.lappsgrid.org/script/db-setup.sql | sed "s/__DB_PASSWORD__/$PASSWORD" | sudo -u postgres psql
```







