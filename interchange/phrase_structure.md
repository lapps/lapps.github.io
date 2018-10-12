---
layout: default
title: LIF PhraseStructure
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

## Phrase Structure

Last updated: May 5<sup>st</sup>, 2017

We use two annotation objects from the vocabulary, PhraseStructure and Constituent:

* [http://vocab.lappsgrid.org/PhraseStructure.html](http://vocab.lappsgrid.org/PhraseStructure.html)
* [http://vocab.lappsgrid.org/Constituent.html](http://vocab.lappsgrid.org/Constituent.html)

The PhraseStructure object contains a single parse tree for some text span, typically for a sentence. It introduces a feature named constituents which contains a list of identifiers referring to (1) annotations of @type Constituent in the same view or (2) annotations of @type Token that may live in another view. A Constituent has a label reflecting the category and in the features dictionary a pointer to the parent (null for the root node) and a list of children.

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
          "PhraseStructure": {
            "producer": "edu.brandeis.cs.lappsgrid.SimpleParser:1.0.0",
            "categorySet": "ns/types/PTBcategories",
            "type": "PhraseStructure:SimpleParser" },
          "Constituent": {
            "producer": "edu.brandeis.cs.lappsgrid.SimpleParser:1.0.0",
            "categorySet": "ns/types/PTBcategories",
            "type": "PhraseStructure:SimpleParser" }}},
      "annotations": [
         { "@type": "PhraseStructure",
           "id": "phrase0",
           "start": 0,
           "end": 16,
           "features": {
              "constituents": [ "c0", "c1", "c2", "v1:tok0", "v1:tok1", "v1:tok2" ] }},
         { "@type": "Constituent",
           "id": "c0",
           "features": {
             "label": "S",
             "parent": null,
             "children": [ "c1", "c2"] } },
         { "@type": "Constituent",
           "id": "c1",
           "features": {
             "label": "NP",
             "parent": "c0",
             "children": [ "v1:tok0" ] }},
         { "@type": "Constituent",
           "id": "c2",
           "features": {
             "label": "VP",
             "parent": "c0",
             "children": [ "v1:tok1", "v1:tok2" ] }}]}]
}
```

In the example tree above we have three Constituents and three Tokens (the three leaf nodes). Since we have the parent feature on Constituents and not on Tokens (where we do not want it) we have a tree where the non-terminals have an explicit parent, but the terminals don't.

NOTE: we are currently discussing whether "root" should be added to PhraseStructure as a property, it would contain the identifier of the top node of the tree.
