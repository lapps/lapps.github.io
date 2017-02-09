---
layout: slate
title: The LAPPS Grid on Jetstream
---

## {{ page.title }}

**Note: most of these notes are specific to LAPPS developers at Vassar and Brandeis.**

There is a quick application process to get 200K service units allocated, which should allow you to run a grid for about a year.

There are some notes at [http://wiki.lappsgrid.org/technical/jetstream.html](http://wiki.lappsgrid.org/technical/jetstream.html).

There are bash scripts at [http://downloads.lappsgrid.org/scripts](http://downloads.lappsgrid.org/scripts/), which is a copy of the contents of the repository [https://github.com/lappsgrid-incubator/jetstream-scripts](https://github.com/lappsgrid-incubator/jetstream-scripts). Note that [downloads.lappsgrid.org/scripts](downloads.lappsgrid.org/scripts) is hosted on the proxy used on Jetstream. Also note that the repository is called jetstream-scripts, but all scripts except for jetstream are generic ubuntu scripts, should probably .

Get onto JetStream at [https://jblb.jetstream-cloud.org/dashboard/auth/login/?next=/dashboard/](https://jblb.jetstream-cloud.org/dashboard/auth/login/?next=/dashboard/), login with TACC as the domain and use your TACC username and password (username is not the same as on XCEDE). 

Create an instance from a local terminal by running the [jetstream](http://downloads.lappsgrid.org/scripts/jetstream) script, which involves a couple of steps.

**Step 1**. First you need the lappsgrid-shared-key.pem somewhere (with 400 permissions) and edit a line in the jetstream script depending where you put it. You will not have to edit the script if you put your pem file in the directory you will run the jetstream script from or if you put it in the ~/.ssh directory. If you insist in putting the pem file elsewhere you will have to add a line below the code where the script sets the PEM variable:

```
PEM=YOUR_PATH_TO_PEM/lappsgrid-shared-key.pem 
```

**Step 2**. You need openrc.sh, see [http://wiki.lappsgrid.org/technical/jetstream](http://wiki.lappsgrid.org/technical/jetstream) on how to get it.

**Step 3**. You need to install the openstack client (see [OpenStack documentation](http://docs.openstack.org/user-guide/common/cli-install-openstack-command-line-clients.html))

```
pip install python-openstackclient
``` 

You should only need to do steps 1-3 once.

**Step 4**. If all went right you can now use the jetstream script and get a listing of available instances or log onto an instance:

```
source openrc.sh
./jetstream.sh list
./jetstream.sh ssh proxy
```

The list command gives you a list of instances and the ssh command gets you into an instance (you can either give an IP address or a name from the instance as printed by the list command, it can actually be a substring of the name, so `proxy` in our case will match `lappsgrid-proxy`). The `proxy` instance is a special instance that allows you to log on to all the other sinstances.

There is an issue with step 1 in that full access is only granted to the person who created the lappsgrid-shared-key.pem key for the group. You can get a listing and you can access an instance through ssh, but you cannot do many of the other things that the jetstream script provides like launching a new instance. Creating a personal key does not work either. For now we have a temporary hack to get on where we use an openrc.sh script which has the user name and password of the user who created the shared key.

With proper access you can start a new instance by doing the following:

```
./jetstream launch test
```

This will create a new instance based on an existing image or snapshot. See [http://wiki.lappsgrid.org/technical/jetstream.html](http://wiki.lappsgrid.org/technical/jetstream.html) for more details.

The jetstream script refers to four LAPPS Grid images on Jetstream:

```
CENTOS_IMAGE=217a24b4-2338-4802-8221-fff3bf3fc260
UBUNTU_IMAGE=d7fe3289-943f-4417-90e8-8a6b171677ca
DOCKER_IMAGE=f3847d59-6a90-43da-8666-b58699398b9a
MASTER_IMAGE=f9e0fa21-6cad-49fc-97db-efd3812fc199
```

When on the Dashboard you can list all the images available, which includes the four above (although they are not listed by the identifier, you have to select the image to see those details; there is also a bug in the display page for the images in that you may have to click the public tab when you get to what seems to be the last page). The image names associated with the lines above are:

| in jetstream script | in the images list         |
| ------------------- | -------------------------- |
| CENTOS_IMAGE        | Centos 7 (7.2) Development |
| UBUNTU_IMAGE        | Ubuntu 14.04.3 Development |
| DOCKER_IMAGE        | lappsgrid-docker-image     |
| MASTER_IMAGE        | lappsgrid-master-image     |

When you do a listing of the current instances the images are displayed with those names.

