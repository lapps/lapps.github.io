---
layout: slate
title: The LAPPS Grid on Jetstream
---

## {{ page.title }}

Note: most of these notes are specific to LAPPS developers at Vassar and Brandeis.

There is a quick application process to get 200K service units allocated, which should allow you to run a grid for about a year.

Jetstream uses the OpenStack client.
<!-- which seems to be what AWS is using too -->

There are some notes at [http://wiki.lappsgrid.org/technical/jetstream.html](http://wiki.lappsgrid.org/technical/jetstream.html).

There are bash scripts at [http://downloads.lappsgrid.org/scripts](http://downloads.lappsgrid.org/scripts/), which is a copy of the contents of the repository [https://github.com/lappsgrid-incubator/jetstream-scripts](https://github.com/lappsgrid-incubator/jetstream-scripts). Note that [downloads.lappsgrid.org/scripts](downloads.lappsgrid.org/scripts) is hosted on the proxy used on Jetstream. Also note that the repository is called jetstream-scripts, but all scripts except for jetstream are generic ubuntu scripts, should probably .

Get onto JetStream at [https://jblb.jetstream-cloud.org/dashboard/auth/login/?next=/dashboard/](https://jblb.jetstream-cloud.org/dashboard/auth/login/?next=/dashboard/), login with TACC as the domain and use your TACC username and password (username is not the same as on XCEDE). 

Create an instance from a local terminal by running the [jetstream](http://downloads.lappsgrid.org/scripts/jetstream) script, which has several requirements.

First you need the lappsgrid-shared-key.pem somewhere (with 400 permissions) and edit a line in the jetstream script depending where you put it. You will not have to edit the script if you put your pem file in the directory you will run the jetstream script from or if you put it in the ~/.ssh directory. If you insist in putting the pem file elsewhere you will have to add a line below the code where the script sets the PEM variable:

```
PEM=YOUR_PATH_TO_PEM/lappsgrid-shared-key.pem
```

Then you need openrc.sh, see [http://wiki.lappsgrid.org/technical/jetstream](http://wiki.lappsgrid.org/technical/jetstream) on how to get it

Finally ou need the openstack client (see [OpenStack documentation](http://docs.openstack.org/user-guide/common/cli-install-openstack-command-line-clients.html))

```
pip install python-openstackclient
``` 

There is an issue with step 1 in that full access is only granted to the person who created the key. So for now we have a temporary way to get on where to log in to Jetstream from the terminal you need:

- the jetstream script
- the openrc.sh, this is a hack with hard-coded username and password
- the openstack client

The openrc.sh is not the same script as the one you get following the instructions linked to above. But once you have it you can log in without a pem file:

```
source openrc.sh
./jetstream.sh list
./jetstream.sh ssh proxy
```

And now you can ssh into any other instance using the local network id.
