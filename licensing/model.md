---
layout: slate
title: Data Model for LAPPS Licensing
---

# {{ page.title }}

<div class="note">
<span style="color:red">NOTE:</span> This is a rapidly evolving topic and this documentation
is most likely already out of date...
</div>

This page serves as a "worksheet" to sketch out the data structures and algorithms that
will be used to implement the LAPPS licensing model.

## Permissions 

The permissions for a DataSource can be modeled as a set of *permission values*. Allowable
values and how those values are interpreted will depend on the type of permissions.

### Required Permissions

Some permissions are required. For example, if a user wants to redistribute the pipeline 
output and charge a fee then the original resource must explicitly grant permission to 
charge a fee.

### Permitted Permissions

Some permissions allow a certain activity but do not require it.  For example, if a resource
specifies the `SHARE_ALIKE` permission does not mean the user is required to redistribute
their work, only that if they do they must *share alike*.

### Dependent Permissions

Some permissions depend on other permissions.  For example, permissions like `ATTTRIBUTION`
and `SHARE_ALIKE` are not relevant if `REDISTRIBUTION` is not allowed.

1. COMMERCIAL
1. RESEARCH
1. EDUCATION
1. PERSONAL

Some permissions must be conveyed to the user but can not be enforced in software; e.g.
*Attribution*, *ShareAlike*, *Fee*, *Redistribution*.

### Permissions Class

The set of permission values will be managed by a *Permissions* class which will consist of:

* a set of values from the `Permission` enum
* methods to add/remove elements from the set.
* methods to serialize the set to/from JSON

A `DataSource`'s `getMetadata()` method should return the JSON for the licensing permissions
as part of its response.

## Pipelines

1. The user provides credentials to an authorization server 
Every processing transaction on the Lappsgrid begins with the user providing credentials to
an authorization server.

