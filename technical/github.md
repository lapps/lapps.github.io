---
layout: slate
title: Developer Notes
---

## {{ page.title }}

### Git and GitHub

In general all Lappsgrid projects in GitHub should follow (more or less) the [Git Flow](http://nvie.com/posts/a-successful-git-branching-model/)
branching model.  Using the [Git extensions](https://github.com/nvie/gitflow) is highly
recommended, but is not required.

What this means is that:

1. The `master` branch should always contain the latest stable release. Basically, 
`master` and the latest `tag` point to the same commit.
1. The `develop` branch contains the current development version. 
 * If you want to submit a pull request please target the `develop` branch
1. Features are developed in `feature` branches and merged into `develop` when they are complete.
1. We do not really use `hotfix` or `support` branches at this time.

### Continuous Integration and Deployment

The LAPPS Grid project uses [Travis](https://travis-ci.org/lapps) for continuous integration and deployment.
While there are many plugins available for performing a release, none fit in easily with our
workflow and tool chain.  In particular, most plugins for deployment want to do everything for
everyone all the time.  It ends up being a lot of work to perform what is essentially:

```bash
$> mvn package javadoc:jar source:jar deploy
```
Of course, deploying artifacts to Maven Central is slightly more complicated, but only slightly.

The LAPPS Grid already uses [Travis](https://travis-ci.org/lapps) for continuous integration 
so configuring Travis to perform the release was a logical choice.

Travis watches both `develop` and `master` branches and build both when changes are detected.
However, when code is pushed to the `master` branch Travis will also:

1. Generate the Javadoc and Source jar files.
1. Generate the PGP signatures for everything.
1. Deploy all artifacts to the Sonatype staging repository.
1. Generate the Maven site (API documentation) and deploy it to lapps.github.io
