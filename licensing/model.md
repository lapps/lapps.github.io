---
layout: slate
title: Data Model for LAPPS Licensing
---

### Permissions 

```
class Permissions {
	enum Uses { COMMERCIAL, RESEARCH, PERSONAL }
	boolean redistribution = true
	Set<Uses> uses = [] as Set<Uses>
	Set<Uses> derivative = [] as Set<Uses>
	Set<Uses> transformative = [] as Set<Uses>
	boolean attribution = true
	boolean shareAlike = false
	boolean fee = true
	// Not sure what this is supposed to do...
	List<String> requiredLicense = []
}
```
