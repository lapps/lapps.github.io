---
layout: default
title: LIF Tokens
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


# Tokens and Tags

Last updated: October 29 <sup>th</sup>, 2015

This section contains examples on how to represent tokenized and split text. It includes how to represent token-level information, in particular part of speech tags.

Sentence splitters create annotation objects of type Sentence and tokenizers create objects of type Token, these are both defined in the LAPPS vocabulary at [http://vocab.lappsgrid.org/Sentence.html](http://vocab.lappsgrid.org/Sentence.html) and [http://vocab.lappsgrid.org/Token.html](http://vocab.lappsgrid.org/Token.html). POS taggers fill in the `pos` property in the `features` dictionary on the Token (but note that some taggers create Token objects as part of that process). There are many pipelines for creating sentences, tokens and part of speech tags. As an example, we take a pipeline where the OpenNLP splitter as wrapped at Brandeis is followed by the Vassar Stanford tokenizer and the Vassar Stanford POS tagger (we assume here that the Stanford tokenizer and tagger are wrapped as separate services).

The example LIF object handed into the pipeline is as follows:

```
{
  "@context": "http://vocab.lappsgrid.org/context-1.0.0.jsonld",
  "text": { "@value": "Fido barks." },
  "views": []
}
```

With this object as input, the sentence splitter will append a Sentence view to the views array and the tokenizer a Token view. Recall from the LIF overview that wrapped components are expected to add views to the end of the views array and to give each view a unique identifier.

```
{
  "@context": "http://vocab.lappsgrid.org/context-1.0.0.jsonld",
  "text": { "@value": "Fido barks." },
  "views": [
    {
      "id": "v1",
      "metadata": {
        "contains": {
          "Sentence": {
            "producer": "edu.brandeis.cs.lappsgrid.opennlp.Splitter:0.0.4",
            "type": "splitter:opennlp" }}},
      "annotations": [
         { "@type": "Sentence", "id": "s0", "start": 0, "end": 11 }
      ]
    },
    {
      "id": "v2",
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
    }
  ]
}
```

The Stanford tagger, the third step in the pipeline, could do one of two things: add part-of-speech information to the existing Token view or add a new view. In the first case, the view with the identifier "v2" will be amended to look as follows:

```
{
  "id": "v2",
  "metadata": {
     "contains": {
       "Token": {
         "producer": "org.anc.lapps.stanford.SATokenizer:1.4.0",
         "type": "tokenization:stanford" },
       "Token#pos": {
         "producer": "org.anc.lapps.stanford.SATagger:1.4.0",
         "posTagSet": "penn",
         "type": "postagging:stanford" }}},
  "annotations": [
     { "@type": "Token", "id": "tok0", "start": 0, "end": 4, "features": { "pos": "NNP" } },
     { "@type": "Token", "id": "tok1", "start": 5, "end": 10, "features": { "pos": "VBZ" } },
     { "@type": "Token", "id": "tok2", "start": 10, "end": 11, "features": { "pos": "." } } ]
}
```

Information is added both to the meta data and to the annotations list. In the vocabulary, `posTagSet` is defined as a meta data property on Token and `producer` and `rules` are meta data properties inherited from Annotation. Note the use of `Token#pos` and `pos`. These are two alternative ways of pointing to the same URL in the vocabulary and this works if the context contains the following lines:

```
"@vocab": "http://vocab.lappsgrid.org/",
"token": "http://vocab.lappsgrid.org/Token#",
"pos": "token:pos",
```

The first line allows `Token#pos` to be expanded to "http://vocab.lappsgrid.org/Token#pos" and the second and third line do the same for `pos`. We could have used `Token#pos` in the features dictionary but we prefer the shorter version.

We have discussed not allowing a service to add information to an existing view. While this introduces some redundancy (a POS service cannot just add a feature anymore and would have to create an new view and copy information into it), it would create a clear picture where a view, once added, can never be changed. And if a view would say on what other view it is based with the `dependsOn` metdadat attribute, then we could derive a flow chart of what views were used in the processing chain. We have decided to allow additions.

The second way for the tagger to add to the LIF object is to add a view and not change the existing Token view. While the views with identifier "v1" and "v2" would remain the same, the next view would be appended to the views list:

```
{
  "id": "v3",
  "metadata": {
     "contains": {
       "Token#pos": {
         "producer": "org.anc.lapps.stanford.SATagger:1.4.0",
         "posTagSet": "penn",
         "type": "postagging:stanford" }}},
  "annotations": [
     { "@type": "Token", "id": "tok0", "start": 0, "end": 4, "features": { "pos": "NNP" } },
     { "@type": "Token", "id": "tok1", "start": 5, "end": 10, "features": { "pos": "VBZ" } },
     { "@type": "Token", "id": "tok2", "start": 10, "end": 11, "features": { "pos": "." } } ]
}
```

The view's annotation list is identical to the previous one shown because meta data elements from "v2" are copied and the tagger does not overwrite existing information. There are other cases though where existing information could be overwritten (for example a cascade of taggers where later taggers are allowed to overwrite results of earlier taggers). In those cases, adding a view with merged information has the benefit of not removing information.

At this point, there is no established way in the meta data to specify that this view is based on view "v2", if we adopt the `dependsOn` attribute then we would be able to do that.

In the above, we have used types like "splitter:nlp", "tokenization:stanford" and "postagging:stanford". These refer to URLs in the types section of the vocabulary. An initial type system for these is under construction.
