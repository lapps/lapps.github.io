---
layout: default
title: URI Inventory
---

# Discriminators DSL

<div class="note">These are scribbles in response to <a href="/installation/discriminators.html">installation/discriminators</a>.
</div>

Discriminators are the set of URI used by LAPPS Grid services and should really be referred to as *The LAPPS URI Inventory*. URI in the LAPPS inventory fall into three general categories:

1. Media types. For example the URI for LIF documents.
1. Metadata. Information about licensing, allowable uses, or actions a service should perform.
1. Vocabulary types.  Annotation types added by services that have additional semantics associated with them.

For historical reasons the Discriminator DSL language includes keywords and provisions for concepts that no longer apply.  In particular, *parents*, *offset*, and *bank* will go away in the future.

The only important fields are *uri* and *description*.  

## URI

All URI in the LAPPS inventory begin with <tt>http://vocab.lappsgrid.org</tt> and URI that are not one of the *vocabulary types* begin with <tt>http://vocab.lappsgrid.org/ns</tt>.

# Syntax

A BNF(-ish) grammar for the Discriminator DSL:

```html
<dsl>         ::= ( <bank-block> | <offset-decl> | <groovy> )+
<bank-block>  :: <bank-decl> <bank>
<bank-decl>   ::= 'bank' '(' <number> ')' 
<offset-decl> ::= 'offset' '(' <offset-expr> ')' <bank>
<offset-expr> ::= <number> | <bank-decl> ( <add-op> <number> )?
<add-op>      ::= '+' | '-'

<bank>        ::= '{' decl* '}'
<decl>        ::= <type-string> '{' <decl-body> '}'
<type-string> ::= <ident> | <string>
<decl-body>   ::= <uri> <eol> <description>
<uri>         ::= 'uri' <string>
<description> ::= 'description' <string>

<eol>         ::= ';' | '\n'
<groovy>      ::= any syntactically correct Groovy statements
<number>      ::= [0..9]+
<ident>       ::= any valid Groovy identifier
<string>      ::= anything that evaluates to a java.lang.String
```


### Grammar Notes

Since the Disciminators DSL is a [Groovy DSL](technical/dsl) Groovy code can be used almost anywhere. For example, the `discriminators.config` file defines several closures that are used to generate URI.

```
vocab = { "http://vocab.lappsgrid.org/$it" }
...
token {
	uri vocab('Token')
	description '...'
}
```

# Generating Discriminator/Vocabulary files


#### Generate the vocabulary.config file

```bash
./vocab -d -o target/ lapps.vocab
```

**OPTIONS***<br/>
- The **-d** option tells the vocab program to generate discriminators
- The **-o** option specifies the output directory.

#### Generate the discriminator.html file

```bash
./ddsl -h target/discriminator.html -t discriminator-html.template discriminator.config
```


#### Generate individual discriminato pages

```bash
./ddsl -p target/ -t discriminator-page.template discriminator.config
```
 

