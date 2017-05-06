---
layout: default
title: LIF DependencyStructure
---

# LAPPS Interchange Format

[
[Index](index.html) |
[Overview](overview.html) |
[Tokens](tokens.html) |
[Chunks &amp; NER](ner.html) |
[Coreference](coref.html) |
[Phrase Structure](phrase_structure.html) |
[Dependencies](dependencies.html)
]


# Dependency Structure

Last updated: October 29 <sup>th</sup>, 2015

We use two annotation types from the vocabulary, DependencyStructure and Dependency:

* [http://vocab.lappsgrid.org/DependencyStructure.html](http://vocab.lappsgrid.org/DependencyStructure.html)
* [http://vocab.lappsgrid.org/Dependency.html](http://vocab.lappsgrid.org/Dependency.html))

The DependencyStructure object contains a list of dependencies, typically for a sentence. It introduces a feature named dependencies which contains a list of identifiers referring to annotations of @type Dependency in the same view. A Dependency has a label reflecting the dependency name and in its feature dictionary it has references to the governor and dependent. Note that the ROOT node has no governor.

```
{
  "text": "Sue sees herself",
  "views": [
    { "id": "v1",
      "metadata": {
        "contains": {
          "Token": {
            "producer": "edu.brandeis.cs.lappsgrid.opennlp.Tokenizer:n.n.n",
            "type": "tokenizer:opennlp" }}},
      "annotations": [
         { "@type": "Token", "id": "tok0", "start": 0, "end": 3 },
         { "@type": "Token", "id": "tok1", "start": 4, "end": 8 },
         { "@type": "Token", "id": "tok2", "start": 9, "end": 16 }
      ]
    },
    { "id": "v2",
      "metadata": {
        "contains": {
          "DependencyStructure": {
            "producer": "edu.brandeis.cs.lappsgrid.SimpleDependencyParser:1.0.0",
            "dependencySet": "ns/types/StanfordDependencies",
            "type": "DependencyStructure:SimpleDependencyParser" },
          "Dependency": {
            "producer": "edu.brandeis.cs.lappsgrid.SimpleDependencyParser:1.0.0",
            "type": "DependencyStructure:SimpleDependencyParser" }}},
      "annotations": [
         { "@type": "DependencyStructure",
           "id": "depstructure0",
           "start": 0,
           "end": 16,
           "features": {
              "type": "basic-dependencies",
              "dependencies": [ "dep0", "dep1", "dep2" ],
        { "@type": "Dependency",
          "label": "ROOT",
          "id": "dep0",
          "features":    {
            "governor": null,
            "dependent": "v1:tok1" }},
        { "@type": "Dependency",
          "label": "nsubj",
          "id": "dep1",
          "features":    {
            "governor": "v1:tok1",
            "dependent": "v1:tok0" }},
        { "@type": "Dependency",
          "label": "nobj",
          "id": "dep2",
          "features":    {
            "governor": "v1:tok1",
            "dependent": "v1:tok2" }}]}]}]
}
```
