---
layout: default
title: Installing a Service Grid on RHEL6
---

# Installing a Service Grid on RHEL6

Version 1, Marc Verhagen, March 2013.

[ 
    [sources](#sources) | 
    [postgres](#postgres) | 
    [database creation](#database) ]

This document describes how to install the service grid
    software on Red Hat Enterpris Linux 6. The process is mostly
    the same as described for 
    [Mac OSX](00-readme-osx.html), this document only
    describes the differences.
[](null)
## Downloading Sources

All sources are the same excpet that you need to get the
    linux version of Postgres. In what follows, I assume that a
    recent version of postgres is installed.
[](null)
## Postgres Settings

In our case, after Postgres was installed it did not have
    access control set up the right way and no matter what we did
    when defing roles, the service manager was not able to access
    the dababase. So before service manager installation you have
    to fix this. We ended palying with the two following files:

```

/var/lib/pgsql/9.2/data/pg_hba.conf
/var/lib/pgsql/9.2/data/pg_ident.conf
```

I am not quites sure on what the minimal necessary steps
    are, therefore I'll simply present what worked in the end, then
    give some intermediate alternative steps. Towards the end of
    the first file, there are a couple of lines that start with
    'local' and 'host'. You can edit these and make them look like
    the following (whitespace was changed a bit to reflect the
    concept that these lines have five columns, with the columns
    representing type, database, user, address and method; so do
    not cut and paste from here because that will not work since
    the tabs are off):

```

local   all   all                  trust
host    all   all   127.0.0.1/32   trust
host    all   all   ::1/128        trust
```

This worked, but may be a bit rough since it does make for
    rather liberal access control. Originally, we just edited the
    first line:

```

local   all   all                  peer map="local"
```

And we edited the end of the second file and made look
    like:

```

local    /(.*)    \1
local    /.*      lapps
```

Unfortunately, this did not solve the problem, although it
    did make local access from the command line with psql a lot
    better.
[](null)
## Dababase Creation

For OSX, the install script did not work and it forced us
    into using pgAdmin. Here is a quicker way to do this from the
    command line. Note that you have to be the postgres user to do
    this.

```

$ sudo su - postgres
$ createuser -S -D -R -P lapps
$ createdb servicegrid -O lapps -E 'UTF8'
$ createlang plpgsql lapps
$ psql servicegrid <
sources/langrid/langrid-corenode-p2p-2.0.0-20120718/postgresql/create_storedproc.sql
$ psql servicegrid -c "ALTER FUNCTION
\"AccessStat.increment\"(character varying, character varying,
        character varying, character varying, character varying,
timestamp without time zone,
        timestamp without time zone, integer, timestamp without
time zone, integer, timestamp
        without time zone, integer, integer, integer, integer)
OWNER TO lapps"
```

The last command was mangled a bit for display purposes by
    adding in some whitespace.
