---
layout: slate
title: Documentation
---

## {{ page.title }}

Some notes going into the Documentation meeting at Brandeis, 1/1/2017-2/2/2017.

We already agreed that:

- Documentation will live in lappsgrid.github.io, which will be redesigned
- The domain wiki.lappsgrid.org will point to lappsgrid.github.io. The github.io page is technically not a wiki but close enough.

Start with a blank slate and figure out the exact procedures for creating a LAPPS Grid. In particular, what needs to be done for the following to happen:

- Installing a  service manager -	requirements (debian, rhel, osx), start with virgin machine (morbius)
- How to create services - wrapping, discriminators, LIF, WSEV, registering
- Setting up Galaxy
- Federation
- Making services run on https
- Authorization of data services (LDC)
- How to create Docker images
- Running on AWS
- Running on JetStream
- Creating a lappsgrid with appliances

Other questions:

- The roles of LDDL and LSD
- Where are all the repositories, what do they do and what is their role in the bigger picture

  
### Goals for first day

Do not get lost in details, expand on the list above and get an overview of each item, filling in all we know and collecting in the wiki, by copying in text or by providing links, all information that is relevant and noting what information is missing.

Layout of basic redesign of lappsgrid.github.io.

Come up with scenarios of what somebody may want to do given some configuration. For example:

- I have a server and want to have a Lapps Grid
- I want something running in AWS
- I want to add my tool to a grid

