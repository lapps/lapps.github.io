---
layout: slate
title: Maven Modules
---

## {{ page.title }}

The following modules have been deployed to the ANC's Nexus repository:

| Group Id | Artifact ID | Version |
|:---------|:------------|:--------|
| org.lappsgrid | api | 2.0.0 |
| org.lappsgrid | core | 2.0.0-SNAPSHOT |
| org.lappsgrid | client | 2.0.0-SNAPSHOT |
| org.lappsgrid | discriminator | 2.0.1 |
| org.lappsgrid | serialization | 2.0.0-SNAPSHOT |
| org.lappsgrid | vocabulary | 1.0.0-SNAPSHOT |

### Maven Repository Settings

To access the ANC's Nexus repository you will need to add the following to the projects
`pom.xml` or to your `/.m2/settings.xml` file:

```xml
<repository>
  <id>anc-releases</id>
  <url>http://www.anc.org:8080/nexus/content/repositories/releases/</url>
  <releases>
	<enabled>true</enabled>
  </releases>
  <snapshots>
	<enabled>false</enabled>
  </snapshots>
</repository>
<repository>
  <id>anc-snapshots</id>
  <url>http://www.anc.org:8080/nexus/content/repositories/snapshots/</url>
  <releases>
	<enabled>false</enabled>
  </releases>
  <snapshots>
	<enabled>true</enabled>
	<updatePolicy>always</updatePolicy>
  </snapshots>
</repository>
```
