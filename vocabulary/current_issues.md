---
layout: default
title: LAPPS Vocabulary Issues
---

# lapps.github.io

# LAPPS Vocabulary - Current Issues

Last update: November 20
        <sup>th</sup>), 2014.

There are now four spots where the syntax and semantics
        of the LAPPS data structures are defined: the source code
        (mainly the wrappers), the 
        [LAPPS Web Services Exchange
        Vocabulary](vocab.lappsgrid.org), the 
        [
        LAPPS JSON schema](http://vocab.lappsgrid.org/schema/lif-schema.json) and the 
        [LAPPS
        Interchange Format specifications](http://lapps.github.io/interchange/). None of these are
        final and all of them have open issues. In addition, these
        four sources are not in sync. This page contains open
        issues for the LAPPS vocabulary: unclarities, ommisions,
        and inconsistencies relative to the LIF specifications (for
        those cases where the latter are ahead of the
        vocabulary).
<dl><dt>Required versus optional attributes</dt>
<dd>The vocabulary does not make a distinction between
          required and optional attributes. We do not yet have a
          clear idea what attributes should be required. Take for
          example the 
          <em>Annotation</em> element. We should probably require
          the 
          <em>id</em> attribute. But we cannot require 
          <em>start</em> and 
          <em>end</em> since under 
          <em>Annotation</em> we may have things like 
          <em>Dependency</em>, for which character offsets are not
          meaningful.</dd>
<dt>Lists versus sets</dt>
<dd>When the vocabulary says "List of URIs", does this
          imply that the list is ordered? Shall we use List and
          Ordered List, or List and Set?</dd>
<dt>Adding vocabulary pages for coreference</dt>
<dd>See the 
          [
          Coreference in LIF](http://lapps.github.io/interchange/coref-v3.html) page. We need to add two elements.
          
|-----|-----|

| 
| 
**Note**. The 
          <em>Markable</em> element may be used for other,
          non-coreference, purposes as well. How do we deal with
          this when it comes to features from a wide variety of
          views? One answer would be to stipulate that 
          <em>Markable</em> elements are only used for creference
          and that similar elements for other purposes need other
          names.
</dd>
<dt>Adding vocabulary pages for phrase structure</dt>
<dd>See the 
          [
          Phrase structure in LIF](http://lapps.github.io/interchange/phrase_structure-v1.html) page. We need to add two
          elements.
          
|-----|-----|

| 
| </dd>
<dt>Adding vocabulary pages for dependency structure</dt>
<dd>See the 
          [
          Dependency structure in LIF](http://lapps.github.io/interchange/dependencies-v1.html) page. Two new elements:
          
|-----|-----|

| 
| </dd>
<dt>The Date object</dt>
<dd>Dates have a 
          <em>dateType</em> feature with values like 
          <em>date</em>, 
          <em>datetime</em> and 
          <em>time</em>. With features like this, should we add a
          meta data feature like 
          <em>dateTypeSet</em>, which has a URI containing type
          definitions? This question is relevant for other object
          types as well.
          
Also, we should add a 
          <em>value</em> feature to store the normalized value, as
          well as other Timex2 and Timex3 features.
</dd>
<dt>Other Issues</dt>
<dd>
|-----|-----|

| 
| 
| 
| 
| 
| 
| 
| 
| </dd>
</dl>
