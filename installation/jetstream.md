---
layout: slate
title: The LAPPS Grid on Jetstream
---

## {{ page.title }}

This page describes how to create a LAPPS Grid instance on Jetstream. Many of these notes are specific to LAPPS developers at Vassar and Brandeis, but the general flavor is the same for everyone. There are some notes at [http://wiki.lappsgrid.org/technical/jetstream.html](http://wiki.lappsgrid.org/technical/jetstream.html).

To get a working LAPPS Grid on Jetstream you need to do the following:

1. Create a Ubuntu instance ready for LAPPS Grid install
2. Install the LAPPS Grid on that instance, either by installing the LAPPS Grid form scratch or by using Docker images

### Starting an Ubuntu instance

While not always necessary for installing a LAPPS Grid on a Jetstream instance, it is useful to get onto the JetStream dashboard at [https://jblb.jetstream-cloud.org/dashboard/auth/login/?next=/dashboard/](https://jblb.jetstream-cloud.org/dashboard/auth/login/?next=/dashboard/), login with TACC as the domain and use your TACC username and password (password is the same as on XCEDE but username is different). You need to have service units allocated. There is a quick application process to get 200K service units allocated, which should allow you to run a grid for about a year.

You can create an instance from a local terminal by running the [jetstream](http://downloads.lappsgrid.org/scripts/jetstream) script. To run the script you first need to put three things in place.

<ol>

<li>You need to install the OpenStack client, see the [OpenStack Installation](http://docs.openstack.org/user-guide/common/cli-install-openstack-command-line-clients.html) notes for details, but it should suffice to do the following:

<div class="highlighter-rouge">
<pre class="highlight">
<code>$ pip install python-openstackclient</code>
</pre>
</div>
</li>

<li>You need a shell script named <code class="highlighter-rouge">openrc.sh</code> to configure the OpenStack API. See [http://wiki.lappsgrid.org/technical/jetstream](http://wiki.lappsgrid.org/technical/jetstream) on how to get it. This script will set some environment variables in your shell and it needs to be sourced before your run jetstream, when sourced it will ask for your OpenStack password. </li>

<li>You need a key file created on the [Jetstream dashboard/](https://jblb.jetstream-cloud.org/dashboard/auth/login/?next=/dashboard/) (at Compute > Access &amp; Security > Key Pairs). Let's say this file is named  <code class="highlighter-rouge">jetstream.pem</code>. The jetstream script uses two variables, KEY and PEM, to control access to Jetstream. The PEM variable stores the location of the key file and the KEY variable has the base name of the file without the .pem extension. The jetstream script itself uses a default for KEY named <code class="highlighter-rouge">lappsgrid-shared-key</code>, but you can overrule this with an environment variable (see below). Put the key file either in the same directory as the jetstream script or put it in the ~/.ssh directory. If you insist in putting it elsewhere you will have to edit the jetstream script and set the PEM variable manually.</li>

</ol>

We can now run the jetstream script. In the example below we assume that openrc.sh has not been sourced yet and we assume you are not using the default key name but instead use the key file named `jetstream.pem`.

```
$ source openrc.sh
$ export OS_KEY=jetstream
$ wget http://downloads.lappsgrid.org/scripts/jetstream
$ ./jetstream.sh list
$ ./jetstream.sh ssh proxy
```

The first two commands only need to be done only once after you have opened a new terminal and obviously you only need to run the third command if you had not already downloaded `jetstream`. The list command gives you a list of instances and the ssh command gets you into an instance (you can either give an IP address or a name from the instance as printed by the list command, it can actually be a substring of the name, so `proxy` in our case will match `lappsgrid-proxy`). The `proxy` instance is a special instance that allows you to log on to all the other instances even if those instances do not have a public IP address.

<!--
There is an issue with step 3 in that full access is only granted to the person who created the lappsgrid-shared-key.pem key for the group. You can get a listing and you can access an instance through ssh, but you cannot do many of the other things that the jetstream script provides like launching a new instance. Creating a personal key does not work either. For now we have a temporary hack to get on where we use an openrc.sh script which has the user name and password of the user who created the shared key.

**Note**. This issue seems to have been solved. The problem was that the jetstream script relied on a hard-coded KEY variable which was set to the name of the shared key. Without that you can:

1. Get the openrc.file
2. Get a key that you create yourself
3. Run the jetstream script as intended
-->

You can start a new instance by doing one of the following:

```
$ ./jetstream launch test
$ ./jetstream launch --ip free test
$ ./jetstream launch --ip alloc test
```

All three will create a new instance named `lappsgrid-test` based on an existing image or snapshot, which by default is the ubuntu image (see below). In the first case the instance will not have a public IP address whereas in the second and third case either one of the avaiable floating IP addresses will be used or a new floating IP address will be allocated. Use the third only when the second invocation does not work (either because there are no free floating IPs or because your version of the OpenStack client does not include `neutron` which is a known issue). See [http://wiki.lappsgrid.org/technical/jetstream.html](http://wiki.lappsgrid.org/technical/jetstream.html) or run `./jetsream help` for more details.

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

The download directory at [http://downloads.lappsgrid.org/scripts](http://downloads.lappsgrid.org/scripts/) is a copy of the contents of the repository [https://github.com/lappsgrid-incubator/jetstream-scripts](https://github.com/lappsgrid-incubator/jetstream-scripts). Note that [downloads.lappsgrid.org/scripts](downloads.lappsgrid.org/scripts) is hosted on the proxy used on Jetstream. Also note that the repository is called jetstream-scripts, but all scripts except for jetstream are generic ubuntu scripts.
