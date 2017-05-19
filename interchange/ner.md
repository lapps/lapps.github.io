---
layout: default
title: LIF Chunks and Named Entities
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

## Chunks and Named Entities

Last updated: May 5<sup>th</sup>, 2017

Many annotations, including chunks and named entities, have a LIF realization that is similar to that of tags and tokens. In general, what they have in common is that the annotation is a sub type of Region where the annotation points at a span of text (or spans of text) and sets some attributes for that span.


### Chunks

The vocabulary defines two annotations:

1. http://vocab.lappsgrid.org/NounChunk.html
2. http://vocab.lappsgrid.org/VerbChunk.html

These are direct subtypes of http://vocab.lappsgrid.org/Region.html and thus inherit the `begin`, `end` and `targets` attributes. No other properties are defined by the vocabulary, but you are always allowed to add other properties to the `features` dictionary. Here is an example of what a chunk could look like in LIF:

```
{
  "@context": "http://vocab.lappsgrid.org/context-1.0.0.jsonld",
  "text": { "@value": "Fido barks." },
  "views": [
    {
      "id": "v1",
      "metadata": {
        "contains": {
          "NounChunk": {
            "producer": "GATE NounPhraseChunker v2.2.0 ",
            "type": "chunker:gate" }}},
      "annotations": [
         { "@type": "NounChunk", "id": "c0", "start": 0, "end": 4 }
      ]
    }
  ]
}
```

The extent of a Region tag can be defined by the `begin` and `end` attributes, but it is also possible to use the `targets` attribute instead and use it to refer to other annotations:

```
{
  "@context": "http://vocab.lappsgrid.org/context-1.0.0.jsonld",
  "text": { "@value": "Fido barks." },
  "views": [
    {
      "id": "v1",
      "metadata": {
        "contains": {
          "Token": {
            "producer": "org.anc.lapps.stanford.SATokenizer:1.4.0",
            "type": "tokenization:stanford" }}},
      "annotations": [
        { "@type": "Token", "id": "tok0", "start": 0, "end": 4 },
        { "@type": "Token", "id": "tok1", "start": 5, "end": 10 },
        { "@type": "Token", "id": "tok2", "start": 10, "end": 11 }
      ]
    },
    {
      "id": "v2",
      "metadata": {
        "contains": {
          "NounChunk": {
            "producer": "GATE NounPhraseChunker v2.2.0 ",
            "type": "chunker:gate" }}},
      "annotations": [
         { "@type": "NounChunk", "id": "c0", "targets": "v1:tok0" }
      ]
    }
  ]
}
```

In general, this choice is available to any extent annotation. Note that in this case the chunker ran on top of a tokenizer and referred to the tokenizer input. It is totally legal for the chunker itself to create the tokenization itself and generate one view with both tokens and chunks.


### Named Entities

The vocabulary item involved is http://vocab.lappsgrid.org/beta/NamedEntity.html. The vocabulary used to have subtypes of NamedEntity like Person, Organization and Location. These are now deprecated so a named entity annotation now looks as follows.

```
{
  "@context": "http://vocab.lappsgrid.org/context-1.0.0.jsonld",
  "text": { "@value": "Jill sleeps." },
  "views": [
    {
      "id": "v1",
      "metadata": {
        "contains": {
          "http://vocab.lappsgrid.org/NamedEntity": {
            "producer":"edu.brandeis.cs.lappsgrid.stanford.corenlp.NamedEntityRecognizer:2.0.3",
            "namedEntityCategorySet": "ner:stanford" }}}
      "annotations": [
         { "@type": "NamedEntity", "id": "c0", "start": 0, "end": 4,
          "features": { "category": "person", "gender": "female" } } ]
    }
  ]
}
```

The thing to note here is the `category` attribute. Possible values are expected to be defined in the vocabulary in the `ner:stanford` section.

<div class="note">
This latter statement needs to be explained more and we also need to add the section involved to the vocabulary (which in this case would actually be to the discriminators).
</div>
