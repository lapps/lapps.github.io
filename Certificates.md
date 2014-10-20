---
layout: slate
title: LAPPS Certificate Authority
---

# {{ page.title }}

## Problem

1. Each server needs a security certificate.
1. If a server's security certificate is not signed by a trusted authority the user's 
browser is likely to complain.
	* Self-signed certificates (which is all the ANC has)
# Solution

Create our own *Certificate
A *Certificate Authority* (CA) is an organization trusted to "sign"