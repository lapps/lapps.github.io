---
layout: slate
title: Roadmap
---

# LAPPS Roadmap

<div class="note">
<span class="red">Note</span> These tasks should be prioritized and assigned to
specific organizations/people.
</div>

There are several major goals to achieve:

* Updated LAPPS demo for the Kyoto workshop
* LAPPS version usable for CMU course
* LAPPS version usable for Brandeis course
* Implement licensing model
* Request changes to the service grid


### Updated LAPPS demo for the Kyoto workshop. 

This would be due a few days before Nancy leaves for the workshop. The workshow is January 22-23.

* Harmonize vocab pages with the LIF schema
	* Identifying disconnects <span class="green">Marc</span> (DONE, but ongoing).
	* Finish sytems that manages the vocab content <span class="green">Vassar</span>
	* Address problems that were identified. <span class="green">Brandeis/Vassar</span>

* Wrap coreference following the new LIF specification <span
  class="green">Chunqi</span>

* Wrap Stanford parsers (phrase structure and dependencies) <span
  class="green">Chunqi</span>

* Wrap HeidelTime annotator for adding Timex3 tags to text. <span
  class="green">Chunqi</span>

	* [https://code.google.com/p/heideltime/](https://code.google.com/p/heideltime/)

* Add pages to the LIF specifications for temporal processing <span class="green">Marc</span>

* Test and update existing services to conform to LIF and vocab. <span
  class="green">Vassar/Brandeis</span>

* Write script/service that test whether services generate well-formed LIF
  objects. <span class="green">Marc</span>

* Wrap a service that consumes the output of coref, phrase structure and
  dependency structure <span class="green">Brandeis</span>

	* This is partially to test the LIF of newly wrapped annotation types
	* One option is to simply provide a simplistic printout of the LIF conent
	* This could be a version of the current [BRAT visualization](http://eldrad.cs-i.brandeis.edu:8484/jld/visualization.html).

* Updates to Composer <span class="green">CMU</span>


### LAPPS version usable for CMU course

* Figure out what services are needed <span class="green">Di and Erik</span>


### LAPPS version usable for Brandeis course 

* Work out what needs to be done in order to integrate the LAPPS Grid into the
course. <span class="green">Brandeis (Chunqi + Te)</span>
	
* Specifications due December 12th. <span class="green">Brandeis</span>

* LAPPS Grid ready for this class by March 2015


### Implement licensing model

* Run Tomcat over HTTPS. <span class="green">Assigned to everyone</span>.
	1. Services **must** be reregistered with the Service Manager so the new, secure
	ports are used instead of the unsecured ports.
	1. Close unsecured ports so Tomcat **only** accepts secure connections.

* Prototype authentication system with LDC.	
	1. Finalize authorization workflow.
	1. Finalize JSON format(s).

* Common authentication/authorization service (See Security).

* Protect resources at LDC
	* Incoming LIF objects must contain appropriate *access token*. This is basically
	a session cookie included in the JSON.


Request changes to the service grid. For now, these are achanges to deal with REST
services and changes to support our licensing issues

* Contact Yohei with requests <span class="green">Keith</span>


### Other items on the roadmap

In no particular order. Some may need to be transferred to the above sections.

* Release 2.0.0 for Java modules. <span class="green">Assigned to Vassar</span>.
	1. Merge feature branches back into develop branches.
	1. Code review
	1. Bump version and release.
* Wrap some UIMA Services. 
	* Not assigned.
* Outstanding Issues
	* ID values in views.  Currently ID values are <span class="red">not</span> unique
	in a JSON document. E.g. a token will have the same ID in every view it appears in. How 
	do we say, *"I want token x from view y."*

