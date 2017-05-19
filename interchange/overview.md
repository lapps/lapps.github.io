---
layout: default
title: LIF Overview
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


## Overview

Last updated: May 5<sup>th</sup>, 2017

### The structure of LIF objects

A LIF object contains the text, a list of annotation views, a reference to an external context file and optional metadata. The top-level structure of a LIF object is as follows:

```
{
  "@context": "http://vocab.lappsgrid.org/context-1.0.0.jsonld",
  "metadata": { },
  "text": { },
  "views": [ ]
}
```

There are four top-level keys: `@context`, `metadata`, `text` and `views`. The following sub sections will describe the values of these four keys.

#### The @context key

The value here is the fixed URL [http://vocab.lappsgrid.org/context-1.0.0.jsonld](http://vocab.lappsgrid.org/context-1.0.0.jsonld) which leads to a document with a JSON object that points to various parts of the LAPPS vocabulary. We allow people to provide their own context, but we do not allow services to changes this top-level context and turn it into a list. Instead, we allow services to add contexts to individual views or to add elements to contexts in individual views. However, we strongly caution against redefining terms that are defined in the external context or the vocabulary since then some annotation objects or properties would have different meanings depending on what view they are in. Note that this sentiment is shared by the [JSON-LD
    recommendation](http://www.w3.org/TR/json-ld/#advanced-context-usage): *this is rarely a good authoring practice and is typically used when working with legacy applications that depend on a specific structure of the JSON object*.

#### The metadata key

All examples of output of our services have an empty object here. There is no current use case for what could be in this metadata object. The LIF object is created and consumed by wrappers and metadata information added should be relevant to and usable by these wrappers. All metadata we have so far are relevant to individual views only and are included in the views key. Nevertheless, we will allow a metadata key here for future use.

#### The text key

This is a JSON [value
    object](http://www.w3.org/TR/json-ld/#dfn-value-object) containing a `@value` and a `@language` key. The value associated with `@value` is a string and the value associated with `@language` follows the rules in [BCP47](http://www.w3.org/TR/json-ld/#bib-BCP47), which for our current purposes boils down to using the ISO 639 code (also see the [Document
    section](http://vocab.lappsgrid.org/Document.html#language) in the vocabulary).

#### The views key

This is where all the annotations and associated information live. The value is a JSON array of views where each view specifies what information it contains and what service created that information. Views are similar to annotation layers and annotation tasks as used by several annotation tools, formalisms and frameworks. They contain structured information about a text but are separate from that text. They also provide flexibility in structuring annotations.

First a note on the nature of the views array. JSON-LD arrays are by default unordered lists, but we decided to make this an ordered list. The order is interpreted to reflect when views were added. So we require that any view added by a service that generates LIF has to be appended to the end.

There are a few general principles:

1. There is no limit to the number of views.
1. Each view has a unique identifier. Annotation elements in the view have identifiers unique to the view and these elements can be uniquely referred to from outside the view by using the view identifier and the annotation element identifier.
1. The view's metadata specify what kind of information objects are in the view.
1. Services may create as many new views as they want.
1. Services may add information to existing views, both to the metadata section and the annotations. We have considered making views read only, which has some advantages, see the [Tokens and Tags](tokens.html) section for a discussion.
1. Services may not overwrite or delete information in existing views. This holds for the view's metadata as well as the annotations.

Here is a minimal example of a view with just one annotation element.

```
"views": [
   {
      "@context": {},
      "id": "v0",
      "metadata": {
        "contains": {
          "Token": {
            "producer": "edu.brandeis.cs.lappsgrid.opennlp.Tokenizer:0.0.4",
            "type": "tokenization:opennlp",
            "rules": "tokenization:opennlp_basic"
          }
        }
      },
      "annotations": [
         { "@type": "Token",
           "id": "t0",
           "start": 0,
           "end": 5,
           "features": {}
         }
      ]
   }
]
```

There are four keys in the view object: `@context`, `id`, `metadata` and `annotations`.

The **@context** key is an optional key used for user-defined context elements. As noted before, this is one of two possible choices on how to do this. One of the general principles listed above was that services may add information to existing views. Typically this would involve adding a feature to the Annotation element dictionary or adding an Annotation element.

The question is what we do when the newly added feature or annotation element is not defined in our vocabulary or is interpreted differently by the service. To deal with the first case the service can simply add the needed term to the local context, as illustrated in the view fragment below.

```
{
  "@context": { "MyToken": "http:/www/example.com/MyToken" },
  "annotations": [
    { "@type": "MyToken", "id": "t0", "start": 0, "end": 5 } ]
}
```

The second case is more complicated. Say the service creates Token elements but these elements have an idiosyncratic interpretation which cannot be explained away by using the `type` or `rules` keys (see below). And, more importantly (and a more likely scenario), say the service adds Token elements to a view that already has Token elements. Adding a Token definition to the context in the existing view now overwrites the existing interpretation of Token, which is not acceptable. There are two solutions: (i) do not allow a service to redefine a term that was not added by the service, and (ii) do not allow services to change the context of an existing view. The latter is preferred because the former is much harder to do and to enforce. Note also that if you have two kinds of Tokens in a view it is impossible to say who was the producer. With the latter approach, services that want to use their own context definitions either have to create a new view for adding that context or use a fully expanded URI.

This needs to be vetted and agreed on.

The **id** key is required and its value should be unique relative to all view objects. If annotation elements refer to an Annotation in another view then they have to use the view identifier as part of the reference.

The **metadata** key contains information to describe the annotations in a view. At this point, its only key is `contains`. The `contains` dictionary has keys that refer to annotation objects in the LAPPS vocabulary or properties of those annotation objects (they can also refer to user-defined objects or properties). And the value of each of those keys is a JSON object with `producer`, `type` and `rules` keys. The relevant part of the example above is repeated here:

```
{
  "contains": {
    "Token": {
      "producer": "edu.brandeis.cs.lappsgrid.opennlp.Tokenizer:0.0.4",
      "type": "tokenization:opennlp",
      "rules": "tokenization:opennlp_basic" }}
}
```

The `producer` key contains a string that specifies what service created the annotation data. Unfortunately, this string cannot be the unique name that the LAPPS grid has for this service, nor can it be the URL where the service resides. The reason for this is that the service itself has no access to this information and it is the service (actually, the service wrapper) that adds information to the LIF objects. The current convention is to use the java class name of the service and the producer name is actually added to the LIF object by accessing a name or identifier method on the server.

We have discussed adding (1) a `timestamp` key, probably using Unix epoch, and (2) a `dependsOn` key which could be used to specify what views a view depends on.

The `type` key is used to specify what kind of token we are dealing with. It allows several tokenizers to specify the same type, for example if two tokenizers are both implementations of the OpenNLP tokenization scheme. In the example here the type key has the compact IRI value "tokenization:opennlp", where tokenization refers to the tokenization key in the external context file in [http://vocab.lappsgrid.org/context-1.0.0.jsonld](http://vocab.lappsgrid.org/context-1.0.0.jsonld), which contains the following two lines:

```
    "types": "http://vocab.lappsgrid.org/types/",
    "tokenization": "types:tokenization/",
```

Because of these definitions, `tokenization:opennlp` will be expanded to http://vocab.lappsgrid.org/types/tokenization/opennlp. The `rules` key inside of Token can be used to specify a rule set, in this case one defined by http://vocab.lappsgrid.org/types/tokenization/opennlp_basic.

Finally, the value of **annotations** is a list of annotation objects. The relevant part of the view printed above is repeated here:

```
"annotations": [
  { "@type": "Token",
    "id": "t0",
    "start": 0,
    "end": 5,
    "features": {}
  }
```

The keys allowed are specified in the [JSON LIF schema](http://vocab.lappsgrid.org/schema/lif-schema.json) in the definitions for `annotations` and `annotation`. The value of `@type` is an element of the LAPPS vocabulary or an annotation category added by the user. If a user-defined category is used then it would be defined outside of the LAPPS vocabulary and in that case the user should either use the full URI or add a context to the view in which this new annotation category lives.

Identifiers are unique to the view. It is allowed that two views both have an annotation with the same identifier and these could even be annotations of the same type (Token for example) and have the same start and end character offset. To uniquely refer to one of them we use the view identifier and the annotation identifier separated by a colon and the Token in the example above can be referred to as "v0:t0".

Technically all that is required of the keys in the features dictionary is that they expand to a URI. In most cases, the keys reflect properties in the LAPPS vocabulary and we prefer to use the same name. So if we have a property "pos", we will use "pos" in the dictionary. This implies that "pos" needs to be defined in the context so that it can be expanded to the correct URI in the vocabulary. Note that we need to be careful with properties that are defined on more than one annotation category. Say, for the sake of argument, that we have "pos" as a property on both the Token and NamedEntity annotation types. We then can use "pos" as the abbreviation of only one of the full URI and if we expand "pos" to http://vocab.lapps.grid.org/Token#pos then we need either use "NamedEntity#pos" or come up with a new abbreviated term. So far this situation has not presented itself.

All annotation elements in a view are direct members of the list of annotations, that is, annotations are not embedded inside of other annotation. For example, Constituent annotations will not contain other Constituent objects. However, in the features dictionary annotations can refer to other annotations using their identifiers.

The rest of the LIF specifications consists of examples of some common annotation categories in the [vocabulary](http://vocab.lappsgrid.org), showing how the annotation types translate into LIF structures.
