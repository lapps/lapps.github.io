---
layout: default
title: LIF Coreference
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

## Coreference

Last updated: May 5<sup>th</sup>, 2017

This document contains examples on how to represent coreference in the LAPPS Interchange Format. It also has examples of the output of some common coreference tools.

[ [linguistics](#linguistics) | [tool output](#output) | [coreference in LIF](#lif) ]
<a name='linguistics'></a>

## Some Linguistics

Coreference occurs when two or more text elements have the same referent, that is, they refer to the same person or thing. One of these text elements is a full form. There are several kinds of coreference:

1. *Joe Doe hurt himself*. The anophor *himself* refers to the same thing as the full form *himself*. In this case the full form is called the antecedent.
1. *Despite her reluctance, Jane Doe understood the issue*. The cataphor *her* occurs before the postcedent (the full form).
1. *Carol told Bob to attend the party. They arrived together*. The anaphor *they* has a split antecedent.
1. *The man refuses to help. The jerk thinks he is too good for that*. Coreferring noun phrases, where the second noun phrase is a predication over the first.

Much of this is taken from [http://en.wikipedia.org/wiki/Coreference](http://en.wikipedia.org/wiki/Coreference).
<a name='output'></a>

## Coreference output examples

The **Stanford tools** create a list of mentions for each coreference chain and assigns the "representative" attribute to one of the elements. Each mention refers to sentence and token identifiers. For the text *"John is sick. He is home. Jill sees her dog."*, we have the following output:

```
<root>
  <document>
    <sentences>
      <sentence id="1">
        <tokens>
          <token
id="1"><word>John</word>...</token>
          ...
        </tokens>
        <parse>(ROOT (S (NP (NNP John)) (VP (VBZ is) (ADJP
(JJ sick))) (. .))) </parse>
        <dependencies
type="basic-dependencies">...</dependencies>
        <dependencies
type="collapsed-dependencies">...</dependencies>
        <dependencies
type="collapsed-ccprocessed-dependencies">...</dependencies>
      </sentence>
      <sentence id="2">...</sentence>
      <sentence id="3">...</sentence>
    </sentences>
    <coreference>
      <coreference>
        <mention representative="true">

<sentence>1</sentence><start>1</start><end>2</end><head>1</head><text>John</text>
        </mention>
        <mention>

<sentence>2</sentence><start>1</start><end>2</end><head>1</head><text>He</text>
        </mention>
      </coreference>
      <coreference>
        <mention representative="true">

<sentence>3</sentence><start>1</start><end>2</end><head>1</head><text>Jill</text>
        </mention>
        <mention>

<sentence>3</sentence><start>3</start><end>4</end><head>3</head><text>her</text>
        </mention>
      </coreference>
    </coreference>
  </document>
</root>
```

Here is some output from the **OpenNLP coreference**:

```
OpenNLP Coreference
-------------------------------------------------------------------------------------------------------
Input sentences 1 ::
Carol told Bob to attend the party. They arrived together.

Sentence#1 parse after POS & NER tag:
(TOP (S (NP (NNP Carol)) (VP (VBD told) (NP (NNP Bob)) (S (VP (TO
to) (VP (VB attend) (NP (DT the) (NN party))))))(. .)))

Sentence#2 parse after POS & NER tag:
(TOP (S (NP (PRP They)) (VP (VBD arrived) (ADVP (RB together)))(.
.)))

Now displaying all discourse entities::
        Mention set:: [ Bob  :: They  ]
        Mention set:: [ the party  ]
        Mention set:: [ Carol  ]
```

Here too, we have sets of mentions. From this print it is not possible to see how internally mentions in the data structure refer to text elements, whether it is by pointing to sentence and token identifiers, as with the Stanford tool, or to nodes in the parse tree. This example, by the way, shows that split antecedents are not dealt with by OpenNLP (at least, not in this case).

And here is the **ANNIE coreference** output from GATE. This is the coreference component as wrapped at Vassar ( [http://grid.anc.org:8080/service_manager/wsdl/anc:gate.coref_1.3.5](http://grid.anc.org:8080/service_manager/wsdl/anc:gate.coref_1.3.5). The className and itemClassName attributes were removed to make the datas tructure easier to read.

```
<Annotation Id="28" Type="Person" StartNode="9" EndNode="13">
<Feature>
  <Name>matches</Name>
  <Value>28;31</Value>
</Feature>
<Feature>
  <Name>string</Name>
  <Value>John</Value>
</Feature>
</Annotation>
<Annotation Id="31" Type="Person" StartNode="27"
EndNode="30">
<Feature>
  <Name>ENTITY_MENTION_TYPE</Name>
  <Value>PRONOUN</Value>
</Feature>
<Feature>
  <Name>antecedent_offset</Name>
  <Value>9</Value>
</Feature>
<Feature>
  <Name>matches</Name>
  <Value>28;31</Value>
</Feature>
</Annotation>
```

This is a fragment of the result for *There is John Smith. I saw him in London*. This particular result was obtained from a pipeline where the coreference occurred after named entity recognition. Without NER, there are no coreference results (this may be a feature of the particular coreference coponent wrapped). The NER found *John* and *him* as persons, but not *Smith*. Coreference information is added to the Person annotations. StartNode and EndNode refer to the character offsets, whereas matches refers to the annotation object identifiers. <a name='lif'></a>


## Coreference in the LAPPS Interchange Format

Time for some coreference representations in JSON. The examples below are all for the simple phrase *Sue sees herself*. The JSON is fairly informal, just showing the bits and pieces that are relevant to the discussion.

The LIF approach to coreference is closer to the Stanford and OpenNLP output than to the GATE output, that is, we express corefence as an attribute or set of attributes on Token or Person objects. Instead, we introduce Coreference and Markable annotation categories, defined in the vocabulary at [http://vocab.lappsgrid.org/Coreference.html](http://vocab.lappsgrid.org/Coreference.html) and [http://vocab.lappsgrid.org/Markable.html](http://vocab.lappsgrid.org/Markable.html). The latter category is a common appearance in coreference annotation.

There are several ways in which coreference can be represented. Here is an example where the coreference view refers to elements in another view and where in fact the tokenization in that view may have been input to the coreference tool.

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
]},
    { "id": "v2",
      "metadata": {
        "contains": {
          "Markable": {
            "producer":
"edu.brandeis.cs.lappsgrid.xxxx.coref:n.n.n" },
          "Coreference": {
            "producer":
"edu.brandeis.cs.lappsgrid.xxxx.coref:n.n.n" }}},
      "annotations": [
         { "@type": "Markable", "id": "m0", "targets": [ "v1:tok0"
] },
         { "@type": "Markable", "id": "m1", "targets": [ "v1:tok2"
] },
         { "@type": "Coreference",
           "id": "coref0",
           "features": {
             "mentions": [ "m0", "m1" ],
             "representative": "m0" }}]}]
}
```

The Coreference element contains a list of mentions, which are identifiers of annotation objects in the same view. In this case the mentions refer to markables that refer to eleents in another view. Markables either have start and end attributes or the target attribute. These attibutes are inherited from Span (see [http://vocab.lappsgrid.org/Span.html](http://vocab.lappsgrid.org/Span.html)). Note that this use of Span is a bit peculiar since we allow spans to either have a start and end or have a list of targets which each have a start and end, th eformer use is common, but the latter use may raise eyebrows.

Here is an example where there is no other view to refer to and where the markables directly refer to text offsets.

```
{
  "text": "Sue sees herself",
  "views": [
    { "id": "v1",
      "metadata": {
        "contains": {
          "Markable": { },
          "Coreference": { } }},
      "annotations": [
         { "@type": "Markable", "id": "m0", "start": 0, "end": 3 },
         { "@type": "Markable", "id": "m1", "start": 9, "end": 16
},
         { "@type": "Coreference",
           "id": "coref0",
           "features": {
             "mentions": [ "m0", "m1" ],
             "representative": "m0" }}]}]
}
```

If a coreference component generates actual annotations that can be used, but that are not available in other views, then we put them in the coreference view. Below we have Token annotations in the coreference view. Instead of Token we could also have Person or NounChunk or any other Annotation type.

```
{
  "text": "Sue sees herself",
  "views": [
    { "id": "v1",
      "metadata": {
        "contains": {
          "Token": { },
          "Markable": { },
          "Coreference": { } }},
      "annotations": [
         { "@type": "Token", "id": "tok0", "start": 0, "end": 3 },
         { "@type": "Token", "id": "tok2", "start": 9, "end": 16 },
         { "@type": "Markable",
           "id": "m0",
           "features": {
             "targets": [ "tok0" ] }},
         { "@type": "Markable",
           "id": "m1",
           "features": {
             "targets": [ "tok2" ] }},
         { "@type": "Coreference",
           "id": "coref0",
           "features": {
             "mentions": [ "m0", "m1" ],
             "representative": "m0" }}]}]
}
```

Sometimes, coreference modules will have all kinds of other information on the annotations that are linked. For example, the ANNIE Coreference componen has an attribute ENTITY_MENTION_TYPE with value PRONOUN on one of the annotations. We put them in the features directory of the Markable.

```
{
  "text": "Sue sees herself",
  "views": [
    { "id": "v1",
      "metadata": {
        "contains": {
          "Token": { },
          "Markable": { },
          "Coreference": { } }},
      "annotations": [
         { "@type": "Token", "id": "tok0", "start": 0, "end": 3 },
         { "@type": "Token", "id": "tok2", "start": 9, "end": 16 },
         { "@type": "Markable",
           "id": "m0",
           "features": {
             "targets": [ "tok0" ] }},
         { "@type": "Markable",
           "id": "m1",
           "features": {
             "targets": [ "tok2" ],
             "ENTITY_MENTION_TYPE": "PRONOUN" } },
         { "@type": "Coreference",
           "id": "coref0",
           "features": {
             "mentions": [ "m0", "m1" ],
             "representative": "m0" }}]}]
}
```

The list of targets can be used to deal with split antecedents. For example, in "John and Mary left, they were late", the mentions can be m1 and m2, and m1 is a Markable with "John" and "Mary" as targets. Note though that in this case we need to be able to refer to annotation objects that contain "John" and "Mary". If they are not available then we need to introduce markables that refer to other markables.

```
{
  "text": "John and Mary left, they were late",
  "views": [
    { "id": "v1",
      "metadata": { },
      "annotations": [
         { "@type": "Markable", "id": "m0", "start": 0, "end": 4 },
         { "@type": "Markable", "id": "m1", "start": 9, "end": 13 },
         { "@type": "Markable",
           "id": "m2",
           "features": {
             "targets": [ "mo", "m1" ] }},
         { "@type": "Markable", "id": "m3", "start": 20, "end": 24 },
         { "@type": "Coreference",
           "id": "coref0",
           "features": {
             "mentions": [ "m2", "m3" ],
             "representative": "m2" }}]}]
}
```

Markables m0 and m1 could be other annotation types like Token or Person.
