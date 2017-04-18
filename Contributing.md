---
layout: slate
title: Language Application Grid
---

## Contributing

Contributions from the community are always welcome and encouraged.  All resources developed by the Language Application Grid are hosted on [GitHub](http://github.com) so the only thing needed to contribute is a GitHub account.

### Contributing Source Code

All source code produced by the Language Application Grid is released under the [Apache 2.0](https://www.apache.org/licenses/LICENSE-2.0) license and is available from one of our two GitHub organizations:

1. [https://github.com/lapps](https://github.com/lapps)<br/>
The *lapps* organization hosts the code for the official LAPPS Grid API modules deployed to [Maven Central](https://search.maven.org/#search%7Cga%7C1%7Corg.lappsgrid).
1. [https://github.com/lappsgrid-incubator](https://github.com/lappsgrid-incubator)<br/>
The *incubator* is the location for projects that are not a part of the LAPPS Grid API. For example the LAPPS Grid fork of the [Galaxy](https://github.com/galaxyproject/galaxy) project, Docker images, etc.

All of the LAPPS Grid repositories use the [Git Flow](http://nvie.com/posts/a-successful-git-branching-model/) branching model. What this means in practice is that all pull-requests should target the *develop* branch as the **base** of the pull request.  More information is available [here](technical/github.html), but pull requests against the *master* branch will be rejected as pushing code to *master* is the trigger for our [CI server](https://travis-ci.org/lapps) to perform a release to Maven Central.

### Contributing To The Wiki

This wiki is a [GitHub Pages](https://pages.github.com) site hosted from the repository [https://github.com/lapps/lapps.github.io](https://github.com/lapps/lapps.github.io). Anyone wanting to contribute to the wiki will need to:

1. [Fork](https://help.github.com/articles/fork-a-repo/) the *lapps.github.io* repository.
1. Edit the wiki files. Please use your own *topic branch* for your edits to the wiki.
1. Push your edits to GitHub and create a [pull request](https://help.github.com/articles/creating-a-pull-request/).

While you are editing the wiki locally you can use [Jekyll](https://jekyllrb.com/docs/quickstart/) to preview the wiki as you make changes. 

```bash
bundle exec jekyll serve --watch
```

The site will be available at http://localhost:4000

[Back](/wiki.html) \| [Home](/index.html)