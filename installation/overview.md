---
layout: slate
title: Overview of the LAPPS Grid Universe
---

## {{ page.title }}

The core of the LAPPS Grid consists of a Service Manager that connects to web services and a LAPPS Galaxy frontend that connects to one or more Service Managers. The main LAPPS/Galaxy site at [http://galaxy.lappsgrid.org/](http://galaxy.lappsgrid.org/) is a Galaxy frontend that points to several Service Managers. The LAPPS Grid has also been deployed using Docker images on Jetstream ([https://jetstream-cloud.org/](https://jetstream-cloud.org/)) and on Amazon Web Services ([https://aws.amazon.com/](https://aws.amazon.com/)). This page gives an overview on the structure of a LAPPS Grid and gives pointers to installation notes.


### The Service Manager and its NLP Services

The Service Manager handles requests for service invocations and controls access to services. It also allows federation with other Service Managers so that services accross Service Managers can be accessed through a single point. The image below shows a LAPPS Server with two Tomcat instances and a Postgres database. On Tomcat instance hosts the Service Manager web application which has access to a PostgreSQL database as well as another Tomcat instance with NLP components wrapped as web applications. The PostgreSQL database stores information on what services there are and where they reside. The NLP services do not have to be on a different Tomcat instance on the same server, they could be on the same Tomcat instance as the Service Manager or on a Tomcat instance on a different server. It is also not required that the Tomcat server is used, but all our implementations have used Tomcat.

<div class="image">
<img src="https://lapps.github.io/installation/images/lapps-universe.png" widt="500">
<!--
NOTE: add the following once you have figured out the styles so it displays well
<div class="caption">LAPPS Server with two Tomcat instances and a Postgres database</div>
-->
</div>

The dotted boxes give some indication on what was used to create the Service Manager and the NLP Services. See the following two pages for details on this, in particular details on how to install and maintain the servers:

- [Installing a Service Manager](service_manager.html)
- [Installing Services](services.html)

With the Service Manager and its services in place, you can access and run services using something like [SoapUI](https://www.soapui.org/) or other tools (given the proper credentials). But for the LAPPS Grid the best way to access the services is through a Galaxy portal.


### The LAPPS/Galaxy Frontend

[Galaxy](https://galaxyproject.org/) is used by the LAPPS Grid as the interface for creating workflows and for evaluating and sharing results. The LAPPS/Galaxy server points at one or more Service Managers, as shown below.

<div class="image">
<img src="https://lapps.github.io/installation/images/lapps-galaxy.png" widt="500">
<div class="caption"></div>
</div>

<!--
[https://www.nginx.com](https://www.nginx.com)
-->
