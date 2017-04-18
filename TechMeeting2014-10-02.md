---
layout: slate
title: LAPPS Technical Meeting
---

# LAPPS Technical Meeting

**Date** October 2-3, 2014 <br/>
**Place** Vassar College, Poughkeepsie NY<br/>

## Licensing

1. Service Grid support
1. Actual mechanisms we will use
1. Security
	* Start using https ASAP.
	* WS-Trust
	* WS-Federation
 
## The Service Grid
1. REST/JSON services
1. User authorization (See Licensing)
1. Collecting and collating usage statistics.

### Interim Hacks
What do we need to do until the Service Grid catches up?

* LAPPS Composer
* LAPPS Pipeline Planner
* Users invoking services
	1. via the language grid
	1. calling the service directly

## JSON-LD 
1. Vocabulary
	* URLs and namespaces
	* Markables
	* Discriminators ([current list](http://vocab.lappsgrid.org/discriminators.html))
	* Coreference
		* [v1](../interchange/coref-v1.html)
		* [v2](../interchange/coref-v2.html)
	* Phrase Structure
		* [v1](../interchange/phrase_structure-v1.html)
	  	 
1. LIF
	* experimental LEDs classes
		* **groupId:** org.lappsgrid.experimental
		* **artifactId:** serialization
		* **version:** 1.0.0-SNAPSHOT
1. Metadata
	* Services
	* DataSources
	* Passing parameters to services
1. Validation and Schemata


## Road map and Milestones

Set some...

## Work Items 

If we have time:

1. Get existing services online
2. Pipeline for competition
3. Security/Licensing
