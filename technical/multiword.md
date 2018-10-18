# Multi-Word Tokens

Previous discussion can be found [here](https://www.dropbox.com/s/20tfij7q55gbi5e/tcf-lif-lindat.pdf?dl=0).

## Examples

**German**

``` 
1-2 im  _   _
1   in  in  PREP
1   dem der DET
```

**Czech**
```
4-5 abych   _   _
4   aby     aby SCONJ
5   bych    bÿt AUX
```

## LIF Proposals

1. [Put in separate views](#put-in-separate-views)
1. [Put in same view different annotation types](#option-#1)
1. [Put in same view differnt tokenTypes](#option-#2)
1. [Single token with features](#option-#3)

### Put In Separate Views

```json
{
    "text": {
        "@value": "im",
        "@language": "de"
    },
    "views": [
        {
            "id": "v1",
            "metadata": {
                "contains": {
                    "http://vocab.lappsgrid.org/Token": {
                        "type": "lumped"
                    }
                }
            },
            "annotations": [
                {
                    "@type": "Token",
                    "id": "tk0",
                    "start": 0,
                    "end": 2
                }
            ]
        },
        {
            "id": "v2",
            "metadata": {
                "contains": {
                    "http://vocab.lappsgrid.org/Token": {
                        "type": "split"
                    }
                }
            },
            "annotations": [
                {
                    "@type": "Token",
                    "id": "tk0",
                    "targets": "v1:tk0"
                },
                {
                    "@type": "Token",
                    "id": "tk1",
                    "targets": "v1:tk0"
                }
            ]
        }
    ]
}
```

**Issues**

1. Complicates processing as tools will need to look in two (or more) views to reconcile all information.  Naive tools may end up with the wrong token view.

### Put In a Single View

#### Option #1

The surface token is annotated with *http://vocab.lappsgrid.org/Token* and the component tokens with *http://vocab.lappsgrid.org/Word*

```json
{
    "text": {
        "@value": "im",
        "@language": "de"
    },
    "views": [
        {
            "id": "v1",
            "metadata": {
                "contains": {
                    "http://vocab.lappsgrid.org/Token": {
                        "type": "lumped"
                    },
                    "http://vocab.lappsgrid.org/Word": {
                        "type": "lumped"
                    }
                }
            },
            "annotations": [
                {
                    "@type": "Token",
                    "id": "tk0",
                    "start": 0,
                    "end": 2
                },
                {
                    "@type": "Word",
                    "id": "w0",
                    "features": {
                        "targets": "tk0",
                        "position": "1"
                    }
                },
                {
                    "@type": "Word",
                    "id": "w1",
                    "features": {
                        "targets": "tk0",
                        "position": "2"
                    }
                }
            ]
        }
    ]
}
```

**Issues**

1. How to annotate the *Token* with *pos* and *lemma* annotations.

#### Option #2

The surface token and component tokens are annotated with *http://vocab.lappsgrid.org/Token* and the component tokens have the *tokenType* feature set.

```json
{
    "id": "tok4-5",
    "start": 177,
    "end": 182,
    "@type": "http://vocab.lappsgrid.org/Token",
    "features": {
        "word": "abych",
        "targets": [
            "mwt-4",
            "mwt-5"
        ]
    }
},
{
    "id": "mwt-4",
    "@type": "http://vocab.lappsgrid.org/Token",
    "features": {
        "word": "aby",
        "lemma": "aby",
        "pos": "SCONJ",
        "targets": [
            "tok4-5"
        ],
        "tokenType": "http://vocab.lappsgrid.org/ns/syntax/mwt"
    }
},
{
    "id": "mwt-5",
    "@type": "http://vocab.lappsgrid.org/Token",
    "features": {
        "word": "bych",
        "lemma": "b\u00fdt",
        "pos": "AUX",
        "targets": [
            "tok4-5"
        ],
        "tokenType": "http://vocab.lappsgrid.org/ns/syntax/mwt"
    }
},
```

#### Option #3

The surface token is annotated with *http://vocab.lappsgrid.org/Token* and the component tokens are features of the Token.

```json
{
    "id": "tok4-5",
    "start": 177,
    "end": 182,
    "@type": "http://vocab.lappsgrid.org/Token",
    "features": {
        "word": "abych",
        "components": [
            {
                "word": "aby",
                "lemma": "aby",
                "pos": "SCONJ"
            },
            {
                "word": "bych",
                "lemma": "b\u00fdt",
                "pos": "AUX"
            }   
        ]
    }
}
```

**Issues**

1. What should really be an annotation is now the feature of another annotation.