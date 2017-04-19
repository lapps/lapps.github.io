---
layout: default
title: LAPPS Vocabulary Issues
---

# lapps.github.io

# LAPPS Vocabulary - Current Issues

Last update: November 20 <sup>th</sup>), 2014.

There are now four spots where the syntax and semantics of the LAPPS data structures are defined: the source code (mainly the wrappers), the [LAPPS Web Services Exchange
        Vocabulary](vocab.lappsgrid.org), the [
        LAPPS JSON schema](http://vocab.lappsgrid.org/schema/lif-schema.json) and the [LAPPS
        Interchange Format specifications](http://lapps.github.io/interchange/). None of these are final and all of them have open issues. In addition, these four sources are not in sync. This page contains open issues for the LAPPS vocabulary: unclarities, ommisions, and inconsistencies relative to the LIF specifications (for those cases where the latter are ahead of the vocabulary).
<dl><dt>Required versus optional attributes</dt>
<dd>The vocabulary does not make a distinction between required and optional attributes. We do not yet have a clear idea what attributes should be required. Take for example the <em>Annotation</em> element. We should probably require the <em>id</em> attribute. But we cannot require <em>start</em> and <em>end</em> since under <em>Annotation</em> we may have things like <em>Dependency</em>, for which character offsets are not meaningful.</dd>
<dt>Lists versus sets</dt>
<dd>When the vocabulary says "List of URIs", does this imply that the list is ordered? Shall we use List and Ordered List, or List and Set?</dd>
<dt>Adding vocabulary pages for coreference</dt>
<dd>See the [
          Coreference in LIF](http://lapps.github.io/interchange/coref-v3.html) page. We need to add two elements. 
<table>
<tr valign='top'>
<td>Coreference</td><td>Stores all information on coreference. It has two features: <ul><li><em>mentions</em>. A list of identifiers. Each identifier points at an object of type <em>Annoation</em> or a subtype thereof.</li>
<li><em>representative</em>. An identifier that points to the full form of the elements in the coreference chain, that is, one of the elements of the <em>menrions</em> list.</li>
</ul>An alternative here is to not use the identifiers but the objects themselves. using the identifiers seems the better choice, it lines up better with the representation in LIF.</td></tr>
<tr valign='top'>
<td>Markable</td><td>This is needed in LIF in case we do not have annotation objects that the mentions list can point to. An object then needs to be created from the offsets alone and we called this a <em>Markable</em> object. It has an extra feature named <em>targets</em> that allows it to point to other annotation objects. It may also need features like ENTITY_MENTION_TYPE in order to store what is available in the output of typical coreference services.</td></tr>
</table>

**Note**. The <em>Markable</em> element may be used for other, non-coreference, purposes as well. How do we deal with this when it comes to features from a wide variety of views? One answer would be to stipulate that <em>Markable</em> elements are only used for creference and that similar elements for other purposes need other names.
</dd>
<dt>Adding vocabulary pages for phrase structure</dt>
<dd>See the [
          Phrase structure in LIF](http://lapps.github.io/interchange/phrase_structure-v1.html) page. We need to add two elements. 
<table>
<tr valign='top'>
<td>PhraseStructure</td><td>The container with all phrase structure information. Possibly an immediate subtype of <em>Annotation</em>. It has two features: <ul><li><em>categorySet</em>. A meta data feature containing a URI for a particular category set. If defined in the LAPPS vocabulary, this URI would be inside http://vocab.lappsgrid.org/ns/types. <br/>
Question: should this be a list of URIs?</li>
<li><em>constituents</em>. A set of annotation objects of type <em>Constituent</em>.</li>
</ul></td></tr>
<tr valign='top'>
<td>Constituent</td><td>The list of constituents defines the tree structure of the parse tree. Each constituent has two features. <ul><li><em>label</em>. A category label, defined in the URI that is the value of <em>PhraseStructure#categorySet</em>.</li>
<li><em>children</em>. An ordered list of identifiers. Each identifier points to an annotation object of type <em>Constituent</em>.</li>
</ul></td></tr>
</table>
</dd>
<dt>Adding vocabulary pages for dependency structure</dt>
<dd>See the [
          Dependency structure in LIF](http://lapps.github.io/interchange/dependencies-v1.html) page. Two new elements: 
<table>
<tr valign='top'>
<td>DependencyStructure</td><td>The container with all phrase structure information. Possibly an immediate subtype of <em>Annotation</em>. It has two features: <ul><li><em>dependencySet</em>. A URI for a particular set of dependency labels. If defined in the LAPPS vocabulary, the URI would be inside http://vocab.lappsgrid.org/ns/types. This is a meta data feature.</li>
<li><em>type</em>. The type of dependencies: basic-dependencies, collapsed-dependencies, etcetera. Given Steve Cassidy's insistence on having <em>@type</em> as well as <em>type</em> in his JSON-LD, and the possibility that we go along with this, maybe this feature should be called <em>dependencyType</em>.</li>
<li><em>dependencies</em>. A set of annotation objects of type <em>Dependency</em>.</li>
</ul></td></tr>
<tr valign='top'>
<td>Dependency</td><td>The list of dependencies defines the dependency structure. Each dependency has three features: <ul><li><em>label</em>. A dependency label, defined in the URI that is the value of <em>DependencyStructure#dependencySet</em>.</li>
<li><em>governor</em>. An identifier pointing at an object of type <em>Annotation</em> or a subtype thereof. Can be <em>null</em> for the root dependency.</li>
<li><em>dependent</em>. An identifier pointing at an object of type <em>Annotation</em> or a subtype thereof.</li>
</ul></td></tr>
</table>
</dd>
<dt>The Date object</dt>
<dd>Dates have a <em>dateType</em> feature with values like <em>date</em>, <em>datetime</em> and <em>time</em>. With features like this, should we add a meta data feature like <em>dateTypeSet</em>, which has a URI containing type definitions? This question is relevant for other object types as well. 
Also, we should add a <em>value</em> feature to store the normalized value, as well as other Timex2 and Timex3 features.
</dd>
<dt>Other Issues</dt>
<dd>
<table>
<tr valign='top'>
<td>Thing</td><td>layout of the headers is different from the other pages</td></tr>
<tr valign='top'>
<td>Date</td><td>URLs in sameAs and similarTo are not links</td></tr>
<tr valign='top'>
<td>Person</td><td>URLs in sameAs and similarTo are not links</td></tr>
<tr valign='top'>
<td>Document</td><td>URLs in sameAs isocat reference is not a link. Also, Document is where the language property is defined. But in LIF we use @language as a key asscoiated with a text string. We should probably add a Text element.</td></tr>
<tr valign='top'>
<td>Sentence</td><td>sentenceType is in red</td></tr>
<tr valign='top'>
<td>Location</td><td>locType is in red</td></tr>
<tr valign='top'>
<td>TextDocument</td><td>has a different table layout than other pages</td></tr>
<tr valign='top'>
<td>AudioDocument</td><td>has a different table layout than other pages</td></tr>
<tr valign='top'>
<td>Token</td><td>pos needs to be changed into posTag</td></tr>
</table>
</dd>
</dl>
