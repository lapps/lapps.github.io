## {{ page.title }}

### Problem Statements

1. Allowing the LDC's resources to be made available on the LAPPS Grid is a top priority. 
1. Code changes are required to the Service Manager to address the LDC's requirements.
1. We can't wait for changes to the Service Manager.

### Meeting Topics

1. Licensing Workflow
	* Jonathan to provide a recap of the LDC licensing workflow.
	* Dimensions: How many do we need?	
1. Infrastructure
	* LDC already has an authorization/authentication system in place.
		* What does the LDC use internally?
		* How do we expose this to the world?
	* LDC must be able to provide authorizations token for whatever system we implement.
	* How do other LAPPS services use this?
	* What changes to the JSON formats are required?
1. Quick and Dirty Prototype
	* Can we:
		* authorize at the LDC
		* run a protected service at the ANC
		* prevent an unauthorized user from running a protected service
			* unregistered user
			* user with incorrect permissions
		
### Roadmap

1. Creating a road map is the #1 work item for this meeting.


### Themes

* [Default](Licensing-default.html)
* [Slate](Licensing-slate.html)
* [Modernist](Licensing-modernist.html)
