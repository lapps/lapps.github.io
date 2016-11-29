---
layout: slate
title: Jetstream
---

# {{ page.title }}

The Language Application Grid recently received a startup allocation on 
[Jetstream](http://jetstream-cloud.org), a NSF funded cloud computing system.  This 
gives us access to a huge amount of on demand computing power and network access.

## Prerequisites

To be able to make use of Jetstream you will need to:

1. Create an account on http://portal.xsede.org
1. Send your XSEDE username to a LAPPS Grid admin so you can be added to our allocation.
1. After you have been added to the LAPPS Grid allocation check that you can log in to:
    1. http://use.jetstream-cloud.org
    1. http://jblb.jetstream-cloud.org/dashboard

Once you are able to log in to the Jetstream system you will need to generate the
openrc.sh file that is used by the Open Stack API to communicate with Jetstream.

1. Sign on to the [Jetstream Dashboard](https://jblb.jetstream-cloud.org/dashboard)
1. Go to *Compute -> Access & Security*
1. Select the *API Access* tab
1. Click on the *Download OpenStack RC File v3* button
1. Rename the downloaded file to *openrc.sh* and move it someplace convenient.

**NOTE:** The first (non-comment) line of the *openrc.sh* file sets the `OS_AUTH_URL`
variable to an incorrect URL.  You will be provided with the correct URL in a separate 
email.  Please do not make this URL public (i.e. save it anywhere other than your openrc.sh
file).

