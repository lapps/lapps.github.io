---
layout: default
title: Grid Integration
---

# Integrating services from the Language Grid and the LAPPS Grid

*This document resulted from discussions at the May 2015 Grid meeting at Vassar College, attended by Takao Nakaguchi, Keith Suderman, Nancy Ide, Chunqi Shi and Marc Verhagen. Notes by Marc Verhagen.*

There are four Language Grid service types for which there can be a meaningful exchange between the Language Grid and the LAPPS Grid:

1. MorphologicalAnalysis
1. NamedEntityTagging
1. DependencyParser
1. ConceptDictionary

For the second and third types it is obvious what LAPPS services we will be mapping to and from. Note that for the first type we are talking about mapping a single Language Grid service to a sequence of two LAPPS services, a tokenizer and a tagger. The rest of this document discusses the issues in those three mappings. The ConceptDictionary service may in the future map to LAPPS-LDC dictionary services, but are excluded from the discussion here.

## 1. MorphologicalAnalysis

On the Language Grid end we have a MorphologicalAnalysisService (MA), for example jp.go.langrid.service_1_2.morphologicalanalysis. As input it takes a pair <"language", "text"> and as output it produces a list of lemmas, where each lemma has a lemma, a word and a part of speech:

```
[ {"lemma", "word", "partOfSpeech"}, ... ]
```

This list is guaranteed to follow the token order as expressed in the text. But note that it may not be possible to exactly generate the input text from this list.

On the LAPPS end we have a tokenizer and a tagger, both accepting LIF JSON as input and output (in the following, the LIF format is liberally violated for brevity). The StanfordTokenizer, or any tokenizer, takes as input a structure with a discriminator and a payload, where the payload is an object in LIF format with a text and an empty list of views.

```
{
  "text": { 
        "@value": "Fido barks.",
        "@language": "en" },
  "views": []
}
```

The output has a view added:

```
{
  "text": { 
        "@value": "Fido barks.",
        "@language": "en" },
  "views": [
        {
        "metadata": {...}
        "annotations": [ 
        "annotations": [ 
           { "@type": "Token", "id": "t0", "start": 0, "end": 4, 
                "features": { "word": "Fido" } },
           { "@type": "Token", "id": "t1", "start": 5, "end": 10, 
                "features": { "word": "barks" } },
           { "@type": "Token", "id": "t1", "start": 10, "end": 11, 
                "features": { "word": "." } } ]
        }
  ]
}
```

Note: the offical LIF specifications do currently not require there to be a "word" feature in the feature dictionary.

This object will be input to a tagger, for example the StanfordPosTagger, which will then add a view and produce

```
{
  "text": { 
        "@value": "Fido barks.",
        "@language": "en" },
  "views": [
        {
        "metadata": {...}
        "annotations": [ 
           { "@type": "Token", "id": "t0", "start": 0, "end": 4, 
                "features": { "word": "Fido" } },
           { "@type": "Token", "id": "t1", "start": 5, "end": 10, 
                "features": { "word": "barks" } },
           { "@type": "Token", "id": "t1", "start": 10, "end": 11, 
                "features": { "word": "." } } ]
        }
        {
        "metadata": {...}
        "annotations": [ 
           { "@type": "Token", "id": "t0", "start": 0, "end": 4, 
                "features": { "word": "Fido", "pos": "NNP" } },
           { "@type": "Token", "id": "t1", "start": 5, "end": 10, 
                "features": { "word": "barks", "pos": "VBZ" } },
           { "@type": "Token", "id": "t1", "start": 10, "end": 11, 
                "features": { "word": ".", "pos": "." } } ]
        }
  ]
}
```

There may or may not be a "lemma" feature, in the case of the wrapped Stanford tokenizer and tagger there is no such feature.

### Conversion

The conversion for the input format is fairly straightforward. The input text and the language are independent variables on both ends. Converting the output is more involved.

#### LAPPS Grid --> Language Grid

This is fairly straightforward. First the list of annotations may need to be ordered since LIF does not guarantee and ordered list (yet commonly does order tokens). Pick out the word and pos features. Use the lemma feature if there is one, otherwise use the word. If there is no word features, use the start and end offsets to get the word from the text feature. The pos needs to be translated to the Language Grid set of tags.

#### Language Grid --> LAPPS Grid

The main issues is that the MorphologicalAnalyzer does not create standoff so we need a mapping from lemmas to text offsets. We can use Keith's alignment program and/or the Brandeis alignment code. The former is already wrapped, the latter needs to be dusted off. There may be issues when for example the MA would take "The dog don't bite." and creates lemmas ["the" "dog" "does" "not" "bite" "."]. We will aim to have alignment that gets most cases right, but reserve the right to gracefully fail on parts of the input.

The Language Grid categories are a reduced set that is much smaller than the typical POS sets on the LAPPS Grid. We will not attempt a mapping but simply use the source set and specify this in the meta data fo the view. The LAPPS Vocab will add the Language Grid tag set, for example at vocab.lappsgrid.org/tagsets/laguage-grid

## 2. NamedEntityTagging

The Language Grid StanfordNE again takes a pair of language and text as input. If morphological analysis is needed than it will be embedded in the service. The output is a list of entity-tag pairs:

```
[ { "entity", "tag" }, ... ]
```

The entities basically line up with the lemmas that would be created by an MA. All lemmas will be listed, not just the ones in entities, and the order reflects the order in the text:

```
[
  { entity: 'John', tag: 'Person' },
  { entity: 'Smith', tag: 'Person' },
  { entity: 'sleeps', tag: 'MISC' }
]
```

This is basically an IO format (but not a BIO format so we have to guess that 'John Smith' is one NE which is usually the right guess). There is no type system that specifies what tags (in addition to MISC) are allowed, the types depend on the tool that is wrapped.

On the LAPPS Grid end, assuming we use the Stanford NE, the input would include a view with tokens and tags as created by a tokenizer and a tagger. The output has a view added with the named entities.

```
{
  "text": { 
        "@value": "John Smith sleeps",
        "@language": "en" },
  "views": [
        {
          "metadata": {...}
          "annotations": [ 
              { "@type": "Token", "id": "t0", "start": 0, "end": 4,

                "features": { "word": "Fido", "pos": "NNP" } },
              { "@type": "Token", "id": "t1", "start": 5, "end":
10, 
                "features": { "word": "barks", "pos": "NNP" } },
              { "@type": "Token", "id": "t1", "start": 10, "end":
16, 
                "features": { "word": ".", "pos": "." } } 
           ]
        }
        {
          "metadata": {...}
          "annotations": [ 
              { "@type": "Person", "id": "ne0", "start": "0",
"end": "11" } 
          ]
        }
  ]
}
```

NOTE. There are currently no LIF specifications for named entities so aspects of this may change. However, NamedEntity, Person and some other entity types are mentioned in the vocabulary.

### Conversion

There are three issues with conversion.

1. As with mapping from an MA, there are no character offsets in the Language Grid service output. However, since the entities line up with lemma, the same alignment code as used for the MA can be used here.
1. The phrase "John Smith" is represented differently: "[John] [Smith]" versus "[John Smith]". For mapping to the LAPPS Grid format we can just group adjacent entities and for the opposite direction we split the phrase.
1. Listing all tokens versus listing only those in the named entity. This is no issue for the mapping to the LAPPS Grid format since it would just ignore the extra tokens (even though it would use them when calculating the offsets). When mapping to the Language Grid format we would need to reconstruct the full list of lemmas, which may be tricky if there is no LIF view with tokens.

To elaborate a bit on the last point. The input for LAPPS NE services may be just text or text with a tokens view. For now we should perhaps only deal with the latter (that is, do not expose NE components that do not use the tokens; this makes integration easier because we do not have to worry about inconsistent tokenizations between LANG output and NEs that might be created.

## 3. DependencyParser

The dependency parsers on the Language Grid again take a text and a language as input. The output they create is a list of chunks where each chunk has an identifier, a dependency and a list of morphemes. Here are the first two chunks for "Our son Isaac lifted..." as parsed by the Stanford dependency parser:

```
{
        "chunkId": "0",
        "dependency": { "headChunkId": "1", "label": "DEPENDENCY"
},
        "morphemes": [
                { "lemma": "My", "partOfSpeech": "noun.pronoun",
"word": "My" } ]
},
{
        "chunkId": "1",
        "dependency": { "headChunkId": "5", "label": "DEPENDENCY"
},
        "morphemes": [
                { "lemma": "son", "partOfSpeech": "noun.common",
"word": "son" } ]
},
```

As with the other services, the order in the chunks and morphemes list reflects the order in the text. The label always is DEPENDENCY. If there are more sentences in the input, the output is still just one list of chunks. There are no explicit sentence boundaries, but the root element of each sentence has the headChunkID set to -1. For the Stanford dependency parser, the list of morphemes always has one element. This is different for the Japanese CabochaService, where the dependencies are not between individual lemmas.

Dependency parsers on the LAPPS Grid (should) produce the following output.

```
{
  "text": "Sue sees herself",
  "views": [
    { "metadata": {},
      "annotations": [
         { "@type": "Token", "id": "tok0", "start": 0, "end": 3 },
         { "@type": "Token", "id": "tok1", "start": 4, "end": 8 },
         { "@type": "Token", "id": "tok2", "start": 9, "end": 16 }
]
    },
    { "metadata": {}
      "annotations": [
         { "@type": "DependencyStructure",
           "id": "depstructure0",
           "start": 0,
           "end": 16,
           "features": {
              "type": "basic-dependencies",
              "dependencies": [
                 { "@type": "Dependency",
                   "label": "ROOT",
                   "id": "dep0",
                   "features":   {
                     "governor": null,
                     "dependent": "tok1" }},
                 { "@type": "Dependency",
                   "label": "nsubj",
                   "id": "dep1",
                   "features":   {
                     "governor": "tok1",
                     "dependent": "tok0" }},
                 { "@type": "Dependency",
                   "label": "nobj",
                   "id": "dep2",
                   "features":   {
                     "governor": "tok1",
                     "dependent": "tok2" }}]}}]
    }
  ]
}
```

The main differences with the Language Grid dependency parse output are:

1. There are no multi-token chunks, all nodes in the parse are single tokens. But note that in the Language Grid format there are only multi-token chunks for Japanese, for English there is no difference.
1. There are actual labels
1. There is one dependency structure per sentence
1. The links are embedded deeper in the strucutre
1. There are character offsets (indirectly)

The mapping from the Language Grid format to the LAPPS Grid format is pretty straightforward, assuming the allignment problem is solved. The main problem going the other direction is to calculate the order of the chunks.

## 4. Final Notes

We will create eight converters:

* Language Grid data <--> LAPPS Grid data
* MorphologicalAnalyzer output format <--> LIF with Token view
* NamedEntityTagging output format <--> LIF with NE view
* DependencyParser output format <--> LIF with token view and DependencyStructure view

LAPPS people to create the convertors to the LIF format <br/>
Language Grid people to create the converters to the LANG formats

LAPPS - will have all converters living locally, at workflow creation time these will be used as needed, for now this may be the responsibility of the user.

LAPPS - we will create a service that gets metadata from services, it forwards to local LAPPS services or does some local lookup for LANG services

Available LappsGrid and LangGrid services will at first be hard-coded somewhere.

A note on view meta data. When LAPPS gets Person types from LANG, we can use http://vocab.lapps.org/language-grid/SERVICE_NAME/Person. We will have a lookup list that may map this to Person, created manually. The converter will access that list.
