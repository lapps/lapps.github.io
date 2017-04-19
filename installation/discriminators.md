---
layout: default
title: Discriminators and the Vocabulary
---


*Note: this page contains preliminary scribbles*


## {{ page.title }}

Everything in vocab is in discriminators but not vice versa (vocab ⊂ discriminator).

There is a vocab dsl and a discriminators dsl (both configuration files for transformations)
  1. [https://github.com/lappsgrid-incubator/vocabulary-dsl](https://github.com/lappsgrid-incubator/vocabulary-dsl)
  2. [https://github.com/lappsgrid-incubator/org.lappsgrid.discriminator.dsl](https://github.com/lappsgrid-incubator/org.lappsgrid.discriminator.dsl)

The input to 1 is `lapps.vocab` in [https://github.com/lapps/vocabulary-pages](https://github.com/lapps/vocabulary-pages) (there are also template files and other onput files for the mapping in there), it creates 
  - vocab.lappsgrid.org `html`, 
  - [org.lappsgrid.vocabulary](https://github.com/lapps/org.lappsgrid.vocabulary) (which is like the discriminator package and describes attribute names etcetera defined in the vocab), 
  - and a Groovy config DSL file with same content

The input to 2 is the config DSL file above and a file named [discriminators.config](https://github.com/lappsgrid-incubator/org.lappsgrid.discriminator.dsl/blob/master/src/main/resources/discriminators.config) in the org.lappsgrid.discriminator.dsl repository, the output is [http://vocab.lappsgrid.org/discriminators](http://vocab.lappsgrid.org/discriminators) page and parts of the java package in [https://github.com/lapps/org.lappsgrid.discriminator](https://github.com/lapps/org.lappsgrid.discriminator)

Automatically generated html page at http://vocab.lappsgrid.org/discriminators. Note that the IDs are not really IDs because they can change when new discriminators are added.


The repository is at https://github.com/lappsgrid-incubator/org.lappsgrid.discriminator.dsl/. In this repo, discriminators are manually defined in https://github.com/lappsgrid-incubator/org.lappsgrid.discriminator.dsl/blob/master/src/main/resources/discriminators.config.

Example 1:

```groovy
lif {
  uri media('jsonld#lif')
  description "LAPPS Interchange format. (LIF)"
  parents 'json-ld'
}
```

Note that `media` is a closure that expands to the full URI for media types. The link target does actually exist and has content, the value of `description` is in that page. The `parents` attribute is not used, but correct in this case.

Example 2:

```groovy
token {
   uri vocab('Token')
   description "Tokens"
   parents chunk
}
```

Here the `parents` value is actually wrong given the actualy hierarchy in the vocabulary. Note that the link from `token` to the `uri` value is manual, so if we add a new category to the vocab (Synonym for example), then we would need to add it to both the vocab and the discriminator config file.


### Updating the vocabulary

Repositories involved:

- [https://github.com/lapps/vocabulary-pages](https://github.com/lapps/vocabulary-pages)
- [https://github.com/lappsgrid-incubator/vocabulary-dsl](https://github.com/lappsgrid-incubator/vocabulary-dsl)

The former has `lapps.vocab`, which contains the actual vocabulary in some format. There is a Makefile and the command to use seems to be

```
$ make site
```

This relies on a jar `vocab-1.2.2.jar`, which happens to have (April 13th) a hard-coded path in the `vocab` bash script.

Create the jar from the second repository:

```
$ mvn package
```



### Updating the discriminator inventory

Repository needed: [https://github.com/lappsgrid-incubator/org.lappsgrid.discriminator.dsl](https://github.com/lappsgrid-incubator/org.lappsgrid.discriminator.dsl). This repository also has some notes on updating the pages.

To update the discriminators you first need to edit the (discriminators.config)[https://github.com/lappsgrid-incubator/org.lappsgrid.discriminator.dsl/blob/master/src/main/resources/discriminators.config] page. Then you generate the new HTML pages: 

```
$ git clone https://github.com/lappsgrid-incubator/org.lappsgrid.discriminator.dsl
$ cd org.lappsgrid.discriminator.dsl
$ make clean	# remove old build
$ make jar	# creates the jar needed to create the vocabulary
$ make html	# creates target/discriminators.html
$ make site	# creates target/vocab/ns and target/vocab/ns.zip, with pages to extend the vocab
```

The last step is to upload these to the server.
