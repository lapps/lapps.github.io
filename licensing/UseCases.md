---
layout: default
title: Licensing Use Cases
---

# {{ page.title }}

To help us determine the proper work flows to use during user authentication and 
authorization it will be helpful to run though several typical usage scenarios.

## Abbreviations 

The following terms and abbreviations will be used in the remainder of this document:

**protected resource**<br/>
Any resource that requires specific authorization before a user can be granted access.
<br/>
**access constraints**<br/>
A set of constraints end users **must** agree to before they are allowed to access to
a particular *protected resource*.
<br/>
**access token**<br/>
Essentially a session id. An access token allows an authorized user to access a 
*protected resource* for a limited time (e.g. 24 hours) without having to 
authenticate with every request.
<br/>
**application**<br/>
The application (composer or pipeline planner) the end user is using to access a
*protected resource*.
<br/>
**AAS**<br/>
An authentication and authorization service. Any service that can authenticate a user and
determine if they are authorized to access a particular *protected resource*.  The *AAS*
must also return any *access constraints* that apply to the *protected resource*.<br/>
**LAAS**<br/>
The LDC's Authentication and Authorization Service.  

## Authorization Use Cases

### Authorized User Requests a Gigaword Document

Jane Austen has signed the required licenses and paid all required fees. Jane creates a pipeline and selects
Gigaword as the data source.

1. Since Gigaword is a resource at the LDC the *application* forwards Jane to the *LAAS*
with the ID of the document she wishes to access.
1. The *LAAS* requests Jane's username and password and determines if Jane has access to the
requested resource.
1. Since Jane is an authorized user of the resource the *LAAS* returns a JSON document
containing an *access token* and any *access constraints* required by the resource.
1. When Jane attempts to run her pipeline the *application* will validate the pipeline by:
	1. Ensuring none of the selected web services violate the *access constraints* specified
	by the *protected resource*.
	1. Asking Jane to agree to any *access constraints* that must be agreed to at runtime. For example,
	not to redistribute the output.
1. If the pipeline is valid then the *application* will begin running the pipeline:
	1. The *application* will send a request to the LDC datasource with the *access token* 
	and desired document ID.
	1. The LDC will verify that the *access token* has not expired and is valid for
	the requested *protected resource*. If the *access token* is valid the LDC will return 
	the requested document, otherwise the LDC will return an error message.
	1. The *application* will check that the request succeeded.
		* If the request succeeded the *application* will invoke each web service in turn.
		* If the request failed the error message will be displayed and Jane will be 
		returned to the pipeline construction page.

### Unauthorized User Requests a Protected Resource

Alice Cooper is a member of the LDC but has not paid the required fees to access *CorpusX*, 
which is a *protected resource*.

1. The *application* will forward Alice to the *LAAS* with ID of the document he wishes
to access.
1. The *LAAS* prompts Alice for his username and password and determines that he is not an
authorized user of *CorpusX*.
	+ The *LAAS* returns an "permission denied" message.

## Access Constraints Use Cases

<!--
### Authorized User Access Constraints

Joni Mitchell is an authorized and paid member of the LDC. Joni would like to 
-->

### Authorized User Constraints Violation

Dave Bowman is a registered member of the LDC with authorization at access *CorpusX*. Dave
has constructed a pipeline that creates a derivative work but *CorpusX* does not allow
derivative works.

1. The *application* will forward Dave to the *LAAS* with the ID of the document he wishes
to access.
1. Since Dave is an authorized user the *LAAS* returns a JSON document containing an
*access token* and the *access constraints* <tt>NO_DERIVATIVES</tt>.
1. When the *application* validates the pipeline it will notify Dave that the *protected resource*
does not permit derivative works.



