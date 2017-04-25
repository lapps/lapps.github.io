---
layout: default
title: Roadmap
nav:
 - Mellon Grant
 - Vocabulary
 - Wiki
 - Edit
---

# LAPPS Roadmap

## Mellon Grant
  
1. Shibboleth/SAML authentication
  - Galaxy modifications
    - Modify `user.py` to add saml authentication method(s)
    - Add REST endpoints so IdP can POST credentials to Galaxy
1. Metadata collection
  - [Open Archives Initiative: Protocol for Metadata Harvesting](https://www.openarchives.org/pmh/)
    - [Roll our own](http://www.oaforum.org/tutorial/english/page4.htm)
      - Test/verify with the [Respository Explorer](http://re.cs.uct.ac.za)
    - [Use existing tools](https://www.openarchives.org/pmh/tools/)
      - Many tools listed above are no longer maintained
      - Most are difficult to setup and are tailored for libraries with large numbers of documents.

{{ site.top }}

## Vocabulary
	
1. Document the process
  - Vocabulary DSL
  - Discriminator DSL
  - DSL Processors
  - Updating (lapps.vocab schema)
  - Deploying
1. Changes
  - Named Entities
  - Outstanding issues (See the [waffle board](https://waffle.io/lapps/lapps.github.io?search=vocabulary))
  
{{ site.top }}

## Wiki

1. Style changes
1. Navigation
1. Update stale documents
  - [Vocabulary current issues](vocabulary/current_issues) is three years old (2014).
1. [Documentation](wiki)
  - GitHub Pages
  - Jekyll Basics
  - Style/theme modifications
  
{{ site.top }}
