---
layout: slate
title: LiveSite
---

# LAPPS Live Site

Functionality available on the site:

* Accessing specifications and vocabulary

* Viewing all available services

* Putting text in a text box and sending it off to a service

* Running a service on a MASC data source

* Instructions on how to programmatically access services and data sources

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
  to specifications and vocabulary


### Showing available services on website

Need list of services, but want to show these from outside the service manager.

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

