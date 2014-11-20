---
layout: slate_numbered
title: Data Model for LAPPS Licensing
---

# {{ page.title }}

<div class="note">
<span style="color:red">NOTE:</span> This is a rapidly evolving topic and this documentation
is most likely already out of date...
</div>

This page serves as a "worksheet" to sketch out the data structures and algorithms that
will be used to implement the LAPPS licensing model.

<a name="toc"/>
## Table of Contents

* [Definitions](#definitions)
* [JSON Structures](#json)
	1. [License](#license)
	1. [Request for Access](#access)
	1. [Access Denied](#denied)
	1. [Access Granted](#grant)
* [Algorithms and Workflows](#algorithms)
	* [Logging In](#login)
	
<a name="definitions"></a>
## Definitions

**AAS**<br/>
An Authentication and Authorization Service. Any service that can authenticate a user and
determine if they are authorized to access a particular *protected resource*.  The *AAS*
must also return any *access constraints* that apply to the *protected resource*.<br/>

<a name="json"></a>
## JSON Structures

<a name="license"></a>
### License

Contains the name of a license, a URI to the full text of the license, and a short
description of the license.

```json
{
	"name":"Kitten",
	"uri":"http://www.example.com/TheKittenLicense.html",
	"description":"You must be nice to kittens."
}
```

<div style="text-align:right; padding-top:10px;">
<a href="#toc">toc</a>
</div>

<a name="request"></a>
### Request for Access

To access a protected resource the client will first get an authorization token from the 
DataSource AAS that must be presented with future requests.

```json
{
	"userid":"Alice",
	"resource":"switchboard",
	"redirect": "http://grid.anc.org:8080/PipelinePlanner/login"
}
```

The *redirect* field indicates the URL that the user should be redirected to after the
authorization process has completed, either successfully or unsuccessfully.

<div class="note">
<span style="color:red">NOTE:</span> The exact workflow used during the authentication
and authorization process is still an open work item.
</div>

<div style="text-align:right; padding-top:10px;">
<a href="#toc">toc</a>
</div>

<a name="denied"></a>
### Access Denied

If the user can not be authenticated the data source should return a simple access denied
message. For security reasons the reason for the denial should be as vague as possible:

1. Access Denied. The user's credentials could not be verified by the data source. For example
the user is not known to the data source or the user could not provide the correct password.
1. Unauthorized. The user's credentials could be verified, but the user does not have permission
to access the requested resource.

```json
{
	"error":"Unauthorized"
}
```

<div class="note"><span class="red">NOTE:</span> During development and testing data sources
may wish to return more detailed information regarding authorization failures. However,
in production the response to a request for access should be a simple yes or no.</div>

<div style="text-align:right; padding-top:10px;">
<a href="#toc">toc</a>
</div>

<a name="grant"></a>
### Resource Authorization

Upon authenticating a user a DataSource AAS will return, amongst other things:

1. an access token
1. a timestamp (GMT relative to the Unix epoch)
1. a list of licenses users must agree to

```json
{
	"userid":"Alice",
	"access_token":"9acc8ca4-2506-4d3c-b7ea-3d2a100814f9",
	"timestamp":1415992228527,
	"lifetime":86400000,
	"resource":"switchboard",
	"restrictions": [
		{
			"name":"Kitten",
			"uri":"http://www.example.com/TheKittenLicense.html",
			"description","You must be nice to kittens."
		},
		{
			"name":"CC Attribution",
			"uri":"http://creativecommons.org/licenses/by/4.0/legalcode",
			"description":"Attribution must be given to the original author or authors."
		}
	]
}
```

<a name="algorithms"></a>
## Algorithms and Workflows

<a name="login"></a>
### Logging In

1. DataSources will provided a "login" page.
1. Clients wishing to access a protected resource on behalf of a user will forward the
user to the datasource's AAS.
1. The AAS will either grant or deny access and return one of the above JSON payloads.

<div style="text-align:right; padding-top:10px;">
<a href="#toc">toc</a>
</div>

## Notes

This is left here solely as a reminder of how to use % \\latex % math mode in Markdown
pages.

* methods to compare instances of the *Permissions* class.
	* For example, if user % U % has permissions % U\_p % and resource % R % requires 
	permissions % R\_p % to allow access, the user % U % may access the
	resource % R % *iff* % U\_p\\bigcap R\_p = R\_p %

