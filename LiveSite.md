---
layout: slate
title: LiveSite
---

# LAPPS Live Site

The overview Marc produced is a start but does not prioritize nor set deadlines. I propose we follow the task timeline below. This puts some items at lower priority and tries to take advantage of what we have to work with now. This way, we  very quickly get a rough cut at something that we can improve. 

TIMELINE:

(1) ***April 1***: The following available (not live but at a universally accessible URL):

* Web page front, minimal for now, use material from lapps.anc.org
* Place to click for USE THE LAPPS GRID

USE THE LAPPS GRID:

* Composer front end interface, providing the ability to:
   - View all available services, which should include ALL the  services (including OpenNLP that need to be updated) we have wrapped so far (splitters, tokenizers, taggers, coreferencers, named entity recognizers, parsers (Stanford?)
   - Compose a pipeline from available services and run it
   - Run a pipeline on a MASC data source or text in a text box
   - Evaluate results against another service or gold standard (if Di can get this done)

This is effectively what we showed last year in Reykjavik. Keith says this is doable by April 1.

(2) ***April 15***

* Add access to (at least some) LDC data, with authorization capabilities
* Improve interface (Find someone with some skills in this area? And/or in making nice web pages?)

(3) ***April 30***

* Improved interface, web page front finalized
* Go live, soft opening (but enlist some users to test--maybe people in James' class?)

------------------------------------------------------------
Eventual functionality available on the site (low priority items are simply those we do not focus on first, but are necessary for going live) :

* Accessing specifications and vocabulary (low priority)

* Viewing all available services (in composer: high priority; elsehwere: low priority)

* Putting text in a text box and sending it off to a service

* Running a service on a MASC data source

* Instructions on how to programmatically access services and data sources (low priority)

* Run a service and evaluate its results against another service or gold standard

* Compose a life pipeline from available services and run it (not necessarily
  with an evaluation backend)

Here is the current incomplete understanding on what would be needed for this.


### Basic Services

To be made availabe on LAPPSGrid:

* Certainly: splitters, tokenizers, taggers

* Definitely: coreference, named entity

* Really nice: time expressions, dependencies

Needed:

* Update services to 2.0.0 and wrap them

* Test services, including for LIF compliance

* Confirm services have the correct discriminators in the produces and requires
  area of the meta data

* Time expressions and dependencies were never wrapped before, may need tweaks
  to specifications and vocabulary (lowest priority--not needed to go live)


### Showing available services on website

Need list of services, but want to show these from outside the service manager. (low priority)

Not sure how to access those directly from the service manager database.

For now, it would be acceptable to scrape all the end points from the service
managers and store them separately.

Need to create a page that displays these services, possibly grouped under what
kind of data they produce and require.

* create a library that categorizes services
* create the front end that accesses this library


### Running a service from a webpage

* Input selection (document or paste in)
* Service selection

One complication here is that you cannot just run any service on raw input, a
pos tagger may require split input for example. So this would almost require the
code that we have talked about before, namely the pipeline planner.

In general, we need to come up with a functionaly specification of a library
that facilitates composition and planning, including perhaps the functionality
mentioned above:

* service categorization

* service selection

* testing compatibilty of output produced and input required

* backward chaining from a goal as expressed by a discriminator (which stands
  for a vocabulary category)


### Evaluating the results of a service

Di is working on an evaluation service that takes a JSON structure with both
system and gold data as well as some configuration parameters. The result is
another JSON structure with evaluation data in an added view.

This service needes to be used somehow and accessed by web-based script.


### Service composition

Given that we have a library as specified before, we could slap any interface on
top of that. It could be Di's composer or something else. Instead of drag and
drop it could be done with checkboxes, or defined by a goal as specified by the
user (backward chaining). Not sure what the most convincing interface would be.

(spurious change)
