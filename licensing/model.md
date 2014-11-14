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

## Licensing Calculus


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

Some permissions depend on other permissions.  For example, permissions like <tt>ATTTRIBUTION</tt>
and <tt>SHARE_ALIKE</tt> are not relevant if <tt>REDISTRIBUTION</tt> is not allowed.

### Enforcable vs Nonenforcable 

Some permissions must be conveyed to the user but can not be enforced in software; e.g.
*Attribution*, *ShareAlike*, *Redistribution*. Some restrictions can be enforced, e.g. 
*Did the user sign license* x *?*

## Permissions Class

The set of permission values should be managed by a *Permissions* class which will consist of:

* a set of *permission values*
* methods to add/remove elements from the set.
* methods to serialize the permissions to/from JSON.
* methods to compare instances of the *Permissions* class.
	* For example, if user % U % has permissions % U\_p % and resource % R % requires 
	permissions % R\_p % to allow access, the user % U % may access the
	resource % R % *iff* % U\_p\\bigcap R\_p = R\_p %

A <tt>DataSource</tt>'s <tt>getMetadata()</tt> method should return the JSON for the licensing permissions
as part of its response.
