---
layout: slate
title: Roadmap
---

# LAPPS Roadmap

<div class="note">
<span class="red">Note</span> These tasks should be prioritized and assigned to
specific organizations/people.
</div>

In no particular order.

* Release 2.0.0 for Java modules. <span class="green">Assigned to Vassar</span>.
	1. Merge feature branches back into develop branches.
	1. Code review
	1. Bump version and release.
* Run Tomcat over HTTPS. <span class="green">Assigned to everyone</span>.
	1. Services **must** be reregistered with the Service Manager so the new, secure
	ports are used instead of the unsecured ports.
	1. Close unsecured ports so Tomcat **only** accepts secure connections.
* Prototype authentication system with LDC.	
	1. Finalize authorization workflow.
	1. Finalize JSON format(s).
* Wrap coreference following the new LIF specification <span class="green">Assigned to Brandeis</span>
* Wrap Stanford parsers (phrase structure and dependencies)
* Wrap HeidelTime annotator for adding Timex3 tags to text. <span class="green">Assigned to Brandeis</span>
	* [https://code.google.com/p/heideltime/](https://code.google.com/p/heideltime/)
* Wrap some UIMA Services. 
	* Not assigned.
* Wrap a service that consumes the output of coref, phrase structure and dependency structure
	* This is partially to test the LIF of newly wrapped annotation types
	* One option is to simply provide a simplistic printout of the LIF conent
	* This could be a version of the current [BRAT visualization](http://eldrad.cs-i.brandeis.edu:8484/jld/visualization.html).
* Licensing
	* Common authentication/authorization service (See Security).
	* Protect resources at LDC
		* Incoming LIF objects must contain appropriate *access token*. This is basically
		a session cookie included in the JSON.
* Harmonize vocab pages with the LIF schema
	* Marc is identifying problems.
	* Address problems Marc has identified.
* Outstanding Issues
	* ID values in views.  Currently ID values are <span class="red">not</span> unique
	in a JSON document. E.g. a token will have the same ID in every view it appears in. How 
	do we say, *"I want token x from view y."*
	
	
	
	

	

