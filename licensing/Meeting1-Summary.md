---
layout: default
title: Licensing Meeting Summary
---

# {{ page.title }}

The following items were discussed (in no particular order):

1. **JSON Formats**
	* While defining a precise JSON format was beyond the scope of our 
meeting, we did discuss how licensing constraints might be expressed in the LAPPS formats.
	* Existing software for generating and consuming LAPPS Interchange Format (LEDS).
1. **Authentication and Authorization**
	* This is going to be hard, and to be done properly requires modifications to the
	service grid software.  An ad-hoc interim solution will be required in the short term.
	* How can LAPPS services use the existing
infrastructure already in use at the LDC.
1. **Licensing Calculus**
	* We need one. More specifically, we need an authorization 
calculus. If we want to reason about licensing then we need some formal rules.
1. **Workflow**
	* What will a typical conversation between the user, resource provider, and services
	look like.

## Questions

Many questions still need to be answered before we can implement the licensing model:

1. Are we to distinguish between transformative uses and derivative uses?
	* Does this mean services will be required to state if they create transformative or derivative 
works?
	* Do any LDC resources prohibit derivative or transformative uses?
1. How much information about users is LDC willing to share with the grid?
	* During authentication is the LDC willing to return a list of a user's permissions and access
	rights? Or should the LDC simply return a yes/no response to an authorization request.
	* Should the composer collect the username/password and send those to the LDC,
	or should the composer redirect to a LDC hosted form that returns an access token?
		* Having the composer collect the username/password is less secure.
		* Having the composer collect the username/password is less work for the LDC.
1. The *Fee* constraint; is that a fee the user must pay to use the resource, or does
it grant the user the right to sell the pipeline output?
1. Do we need to distinguish between *user* types and *usage* types, eg. can a *commerical*
user (ie. a company) use a resource for *research* purposes?
		
### Possible Technologies

None of the security standards we discussed will be able to assist us until the Service
Grid software supports them natively.  For OAuth or WS-Security to work the service needs
low level access to the HTTP request (OAuth) or to the SOAP-Envelope (WS-Security). That
can only be done by the service grid.

## Workflow

1. User logs in to composer/planner
1. User selects a (LDC) data source	
	* Authorized at LDC
	* LDC returns access token, user permissions, and resource permissions
1. User creates a pipeline.
1. Composer/planner validates pipeline
	* Get metadata from services.
	* Check permissions.  If insufficient rights then:
		1. Display list of problems to the user.
		1. Go back to step #3.
1. Displays licensing agreement user must agree to.
	* Is a simple click through sufficient?
1. Run pipeline.
	* Add licensing metadata to the output.

## Roadmap

1. Get everything running on HTTPS
1. Calculus for Licensing permissions.
	* Some constraints can not be enforced at runtime and only need to be displayed to the user 
	so they can agree (or not) to the conditions.
	* Some permissions must be enforced, e.g. users must specify their intended use.
	* Some permissions are *permitted*, e.g. redistribution.  Just because a resource
	allows redistribution does not mean users *must* redistribute their results. 
1. JSON licensing data returned by LDC
	* What dimensions are required.
	* What metadata is added by services.
1. User authorization
	* Login using current LDC authentication system.
	* Service Grid modified to consume OAuth services.
	* LDC to implement OAuth authentication services.

## Developer Guidelines

1. Don't ask the user anything until we have to.

