---
layout: slate
title: The LAPPS Grid on Jetstream
---

### Running on JetStream

There is a quick application process to get 200K service units, which should allow us to run the grid for a year.

Log in to JestStream, you need:

- the pem file
- the jetstream script
- the openrc.sh, using keith and his password (hard coded, see Keith's email from yesterday)
- the openstack client

```
./jetstream.sh list
./jetstream.sh ssh proxy
```

then ssh into any other instance using the local network id.

Uses OpenStack, which seems to be what AWS is using too.

Some notes at [http://wiki.lappsgrid.org/technical/jetstream.html](http://wiki.lappsgrid.org/technical/jetstream.html).

There are bash scripts at [http://downloads.lappsgrid.org/scripts](http://downloads.lappsgrid.org/scripts/), which is a copy of the contents of the repository [https://github.com/lappsgrid-incubator/jetstream-scripts](https://github.com/lappsgrid-incubator/jetstream-scripts). Note that [downloads.lappsgrid.org/scripts](downloads.lappsgrid.org/scripts) is hosted on the proxy used on Jetstream. Also note that the repository is called jetstream-scripts, but all scripts except for jetstream are generic ubuntu scripts, should probably .

Get onto JetStream at [https://jblb.jetstream-cloud.org/dashboard/auth/login/?next=/dashboard/](https://jblb.jetstream-cloud.org/dashboard/auth/login/?next=/dashboard/), login with TACC as the domain and use your TACC username and password (username is not the same as on XCEDE). 

Create an instance by running the [jetstream](http://downloads.lappsgrid.org/scripts/jetstream) script, which has several requirements.

1. You need the lappsgrid-shared-key.pem somewhere (with 400 permissions) and edit a line in the jetstream script depending where you put it, the default location is in the .ssh directory:
  ```
  PEM=$HOME/.ssh/lappsgrid-shared-key.pem
  ```

2. You need openrc.sh, see [http://wiki.lappsgrid.org/technical/jetstream](http://wiki.lappsgrid.org/technical/jetstream) on how to get it

3. You need the openstack client (see [OpenStack documentation](http://docs.openstack.org/user-guide/common/cli-install-openstack-command-line-clients.html))
  ```
  pip install python-openstackclient
  ``` 

There is an issue with step 1 in that full access is only granted to the person who created the key.

