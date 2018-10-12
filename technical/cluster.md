---
layout: default
title: Clustering
---

# Clusters

There is currently one cluster running on the [Jetstream IU cloud](https://iu.jetstream-cloud.org/dashboard).  The cluster uses [Rancher](http://rancher.com) for setup and management and [Docker Swarm](https://docs.docker.com/engine/swarm/) as the Orchestration Engine (OE).

1. [Create Nodes](#create)
1. [Assign IP Addresses](#assign)
1. [Install Docker](#docker)
1. [Launch Rancher](#rancer)
1. [Secure Rancher](#secure) Very important! Do not skip this step.
1. [Add Worker Nodes](#workers)

**Note** Additional worker nodes can be added at any time by running the `sudo docker run` command from [Step 6](#workers) on the new nodes.

## Initial Setup

To set up a cluster you will need to create one node (m1.small) for the Rancher service and one or more nodes (m1.medium or larger) as worker nodes.  The number and size of the worker nodes will depend on the anticipated number and size of the services to be deployed.  Services that require a large amount of memory or a large number of CPUs should be deployed to a cluster with large worker nodes, while smaller services can be deployed to clusters with smaller worker nodes.

<a name="create"></a>
### 1. Create a master node

You can use the Jetstream OpenStack UI to create the nodes or the OpenStack CLI tools.  In either case use the following parameters to create the instances:

| Parameter | Value |
|-----------|-------|
| **Image** | lappsgrid-ubuntu-16.04 |
| **Network** | lappsgrid-network |
| **Key Pair** | <YOUR_KEY_PAIR_NAME>  |
| **Security Group** | lappsgrid-secgroup |

Name the `master` node something like `master` or `rancher` 
Later on we will add `worker` nodes that are controlled by the `master`. The `master` node will be running `rancher/server` docker container that manages the clusters and provides web console, while `worker`s will be running `rancher/agent` containers along with a container orchestration engine (OE).

``` bash
$> source ~/.secret/openrc.sh
$> openstack server create \
    --image lappsgrid-ubuntu-16.04 \
    --flavor m1.small \
    --network lappsgrid-network \
    --security-group lappsgrid-secgroup \
    --key-name <YOUR_KEY_PAIR_NAME> \
    master
``` 

If told that m1.small is too small for ubuntu-16.04 image, try m1.medium.

<a name="assign"></a>
### 2. Assign a floating ip to the node

You will need to assign a public floating IP address to the master node.

```bash
$> openstack floating ip create public
$> openstack server add floating ip master <IP-ADDRESS-FROM-ABOVE> 
```

The `openstack floating ip create public` will list the IP address that was allocated and this is the `<ip-address>` that is used in the subsequent command.

<a name="docker"></a>
### 3. Install Docker

You will need to install Docker 17.06-ce on the master node.
SSH into each node:
 
```bash
$> ssh -i ~/.ssh/<YOUR_KEY_PAIR_NAME>.pem root@<ip-address>
```

Run the following command:

```bash
$root> curl https://releases.rancher.com/install-docker/17.06.sh | sh
```

When ubuntu-16.04 image starts up for the first time `dpkg`, the built-in package manager used for docker installation, performs system update automatically. 
You might get an error as the update process prevents other `dpkg` operations, such as the installation of docker. 
If this happens, just for a couple minutes and try again.

<a name="rancher"></a>

### 4. Launch the Rancher server

SSH into the master node and run the following command to launcher the Rancher server:

```bash
$root> docker run -d -p 8000:8080 --name rancher rancher/server:stable
```

After a few minutes you should be able to access the Rancher server at http://<IP-ADDRESS>:8000 where `ip-address` is the public IP address we assigned to the `master` node above.

<a name="secure"></a>
### 5. Secure the Rancher Server

By default the Rancher server does no user authentication which means **anyone** on the Internet can deploy services to our cluster.  **THIS MUST BE CHANGED ASAP**.

#### 5a. Register Rancher with GitHub
1. Go to [Github application OAuth settings](https://github.com/organizations/lapps/settings/applications) and click the `Register an application` button.
1. Enter something meaningful as the `Application name` and `Application description`.
1. Enter `http://ip-address:8000` as the `Homepage URL` and `Authorization callback URL`, where `ip-address` is the public IP we assigned to the master (Rancher) node.
1. Click the `Register application` button.
1. Make a note of the `Client ID` and `Client Secret` as you will need them below.

#### 5b. Enable GitHub authentication in Rancher
1. Open http://ip-address:8000 in a browser.
1. Select `Access Control` from the `Admin` menu.
1. Scroll down to section 2 and paste in the `Client ID` and `Client Secret` you obtained above.
1. Click the `Save` button.
1. Click the `Authenticate with GitHub` button. This will attempt to log you into the Rancher application using your GitHub account.
1. A new broswer window will open.  This is GitHub asking your permission to allow Rancher application to authorize. Since this is what we want click the `Authorize` button.
1. The new browser window will close and you should be returned to the Rancher UI. In the `Site Access` area add the following GitHub users:
    1. ksuderman
    1. marcverhagen
    1. keighrim
 
Our Rancher server is now secure and only the GitHub users listed above can login to the server and deploy containers to our cluster.

A short (and slightly outdated) video showing the GitHub setup is available [here](http://rancher.com/rancher-now-supports-github-oauth/).

<a name="workers"></a>
### 6. Add Worker Nodes to the cluster.

Finally we add one or more worker nodes, which are called `host`s in Rancher manager, that actually runs micro Lapps services. 
Start with firing up some new openstack servers, assigning public IP addresses.

``` bash
$> openstack server create \
    --image lappsgrid-ubuntu-16.04 \
    --flavor m1.medium \
    --network lappsgrid-network \
    --security-group lappsgrid-secgroup \
    --key-name <YOUR_KEY_PAIR_NAME> \
    worker-1
...
$> openstack floating ip create public
$> openstack server add floating ip worker-1 <ip-address-from-above>
...
```

Here we name worker nodes `worker-1`, `worker-2`, ..., `worker-n`.

Next we need to create a new cluster that rancher has control over. We will do that by creating a new `enviroment`. While creating a new environment, you can select a container orchestration engine of your preference (Rancher has its native OE `Cattle` but also support docker swarm, Kubernetes and Mesos.
In this tutorial we will specify Docker Swarm as the OE (which comes with a `portainer` instance as a web-based manager application). First worker nodes need docker installed. 


```bash
$> ssh -i ~/.ssh/<YOUR_KEY_PAIR_NAME>.pem root@<ip-address>
$root> curl https://releases.rancher.com/install-docker/17.06.sh | sh 
# or $root> curl https://releases.rancher.com/install-docker/1.12.sh | sh
```

> **Note** The process to set up a cluster using Kubernetes as the OE is almost identical with one important difference; to use Kubernetes with Rancher you need to install an older version of Docker:
> 
> ```bash
> $> curl https://releases.rancher.com/install-docker/1.12.sh | sh
> ```
> 
> You can see all the supported versions of Docker [here](http://rancher.com/docs/rancher/latest/en/hosts/#supported-docker-versions).

Now in the Rancher manager (web browser), 

1. Go to `Default -> Manage environments`
1. Click the `Add environment` button.
1. Enter a `Name` and `Description` and select `Swarm` as the *Environment template*.
1. Click the `Create` button.

Don't worry if the Rancher UI claims our new environment is `Unhealthy`. It is unhealthy because it does not have any worker nodes so let's add some nodes.

1. Click the `Add a host` link at the top of the page.
1. Select `Custom` if it is not already selected.
1. Scroll down to *Section 5* and use the clipboard button to copy the entire `sudo docker run` command.
1. SSH into each worker node and paste in the above command:

```bash
$> ssh -i ~/.ssh/lappsgrid-shared-key.pem root@<ip-address>
...
$root> sudo docker run --rm --privileged \
    -v /var/run/docker.sock:/var/run/docker.sock \ 
    -v /var/lib/rancher:/var/lib/rancher \
    rancher/agent:v1.2.6 \
    http://149.165.169.90:8000/v1/scripts/A171767AD1C34F1F46BA:1483142400000:YXu6RtzQSIzcfx5dpLENWwJRY
```

**NOTE** The above command if for example purposes only.  The command you paste in will look similar, but the IP address and "join token" will be different.

It may take several minutes for Rancher/Docker to configure the worker nodes.  You can watch the setup progress by going to the `Infrastructure -> Hosts` page.
