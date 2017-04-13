---
layout: slate
title: Discriminators and the Vocabulary
---


| Status of his page | preliminary scribbles |
| ------------------ | --------------------- |

## {{ page.title }}

- everything in vocab is in discriminators but not vice versa (vocab ⊂ discriminator)
- there is a vocab dsl and a discriminators dsl (both configuration files for transformations)
  1. [https://github.com/lappsgrid-incubator/vocabulary-dsl](https://github.com/lappsgrid-incubator/vocabulary-dsl)
  2. [https://github.com/lappsgrid-incubator/org.lappsgrid.discriminator.dsl](https://github.com/lappsgrid-incubator/org.lappsgrid.discriminator.dsl)
- the input to 1 is `lapps.vocab` in [https://github.com/lapps/vocabulary-pages](https://github.com/lapps/vocabulary-pages) (there are also template files and other onput files for the mapping in there), it creates 
  1. vocab.lappsgrid.org `html`, 
  1. [org.lappsgrid.vocabulary](https://github.com/lapps/org.lappsgrid.vocabulary) (which is like the discriminator package and describes attribute names etcetera defined in the vocab), 
  1. and a Groovy config DSL file with same content
- the input to 2 is the config DSL file above and a file named [discriminators.config](https://github.com/lappsgrid-incubator/org.lappsgrid.discriminator.dsl/blob/master/src/main/resources/discriminators.config) in the org.lappsgrid.discriminator.dsl repository, the output is [http://vocab.lappsgrid.org/discriminators](http://vocab.lappsgrid.org/discriminators) page and parts of the java package in [https://github.com/lapps/org.lappsgrid.discriminator](https://github.com/lapps/org.lappsgrid.discriminator)


**check whether this all still works**

Discriminators are used in the produces and requires sections of a tool wrapper's metadata. It is up to the tool wrapper to check whether input has what it needs (searching the contains section of the metadata section of a view. THere is also a discriminator handed in with the Data structure, which has a discriminator and a payload section. The dicriminator there is one of the dozen or so media discriminators in [http://vocab.lappsgrid.org/discriminators](http://vocab.lappsgrid.org/discriminators) (for example, the discriminator gate	which refers to http://vocab.lappsgrid.org/ns/media/xml#gate).


**Some new notes (March 16th, 2017)...**

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

**Updating the pages**

(Also described in https://github.com/lappsgrid-incubator/org.lappsgrid.discriminator.dsl, si perhaps just refer to that page).

```
$ git clone https://github.com/lappsgrid-incubator/org.lappsgrid.discriminator.dsl
$ cd org.lappsgrid.discriminator.dsl
$ make clean	# remove old build
$ make jar	# creates the jar needed to create the vocabulary
$ make html	# creates target/discriminators.html
$ make site	# creates target/vocab/ns and target/vocab/ns.zip, with pages to extend the vocab
```
