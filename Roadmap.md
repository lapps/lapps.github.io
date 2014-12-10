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
* Add pages to the LIF specifications for temporal processing <span class="green">Marc</span>
* Wrap HeidelTime annotator for adding Timex3 tags to text. <span
  class="green">Chunqi</span>
	* [https://code.google.com/p/heideltime/](https://code.google.com/p/heideltime/)
* Test and update existing services to conform to LIF and vocab. <span
  class="green">Vassar/Brandeis</span>
* Write script/service that tests whether services generate well-formed LIF
  objects. <span class="green">Marc</span>
* Wrap a service that consumes the output of coref, phrase structure and
  dependency structure services <span class="green">Brandeis</span>
	* This is partially to test the LIF of newly wrapped annotation types
	* One option is to simply provide a simplistic printout of the LIF conent
	* This could be a version of the current [BRAT
          visualization](http://eldrad.cs-i.brandeis.edu:8484/jld/visualization.html).
* Updates to Composer <span class="green">CMU</span>


### LAPPS version usable for CMU MIIS Seminar course

The MIIS seminar course (capstone project planning for M.S. in Intelligent
Information Systems) will include a project on "automatically building
customized search engines with LAPPS". In this project, students will setup
their crawlers, indexers, and searchers as LAPPS services. For a new domain, the
crawler will fetch relevant documents to construct a domain-specific corpus,
then send to the indexer. The index searchers can be part of information
retrieval pipeline with testing queries and gold standards as inputs. Students
will experiment with different ways of document discovery, query formulation,
and ranking methods. By comparing retrieved documents with gold standards, they
can then evaluate the effectiveness of newly built search engines.

* Figure out what services are needed <span class="green">Di and Erik</span>


### LAPPS version usable for CMU Question Answering course

The LAPPS Grid will be used to support the development of a world history
question-answering pipeline. Students will incorporate exiting LAPPS annotators
(e.g. Time annotators) to their system. When students develops a "heavy"
component and wants other team members to use it, they can deploy it as a LAPPS
service. For example, a Wikibook corpus searcher or DBPedia spotlight (knowledge
entity recognizer) is not usually able to run on a laptop. We will make the
LAPPS Grid more attractive to students by including major LDC-held resources
like Gigaword corpus available in the grid.

* Figure out what services are needed <span class="green">Di and Erik</span>
* Provide documentation on wrapping services


### LAPPS version usable for Brandeis Computational Linguistics course

The Fundamentals in Computational Linguistics (COSI 114) class is offered in
Spring 2014, and will focus on five modules, each of them involving a
fundamental area of computational linguistics. For the final three projects of
the class, the Language Grid will be deployed as the development, testing, and
evaluation platform. These topics are: Part of speech tagging, including running
the Viterbi algorithm for part of speech tagger for twitter data; Lexical
Semantics, including Distributional word similarity for thesaurus generation,
and statistical testing (log-likelihood ratio, t-test, chi-squared test); and
Machine translation, running the IBM model 1, including the EM algorithm.

* Work out what needs to be added to the LAPPS Grid to meet the above needs.
  <span class="green">Brandeis (Chunqi + Te)</span>
* Specifications due December 12th. <span class="green">Brandeis</span>
* LAPPS Grid needs to be ready for this class by March 2015
* Test and check robustness of previously wrapped services
* Implement/find a POS tagger that uses the viterbi algorithm and wrap it
* Decide what word similarity measures to use (cosine, latent semantic analysis,
  single value decomposition, mutual information)
* Explore whether Twitter data and LAPPS Grid can co-exist
* Select bilingual data and wrap them as Data Sources
* Wrap IBM model 1 and Expectation Maximization


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


### Request changes to the service grid. 

For now, these are achanges to deal with REST services and changes to support
our licensing issues

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

