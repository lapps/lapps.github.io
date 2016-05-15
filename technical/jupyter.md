---
layout: slate
title: Jupyter Notebook
---

# {{ page.title }}

The Lappsgrid Services DSL (LSD) is a [Groovy](http://groovy-lang.org/) Domain Specific 
Language that can be used to interact with service on the LAPPS Grid. The Language 
Application Grid has also developed a LSD kernel for use in [Jupyter Notebooks](http://jupyter.org/).  

## Installation

It is assumed that users already have [Jupyter installed](http://jupyter.readthedocs.io/en/latest/install.html).

1. [Download](http://www.anc.org/downloads/jupyter-lsd-kernel-1.0.0-SNAPSHOT.tgz) the LSD Kernel.
1. Open the above archive and edit the jupyter-lsd-kernel.properties file.
  - Set `GALAXY_HOST` to the URL of the Galaxy server you would like to interact with.
  - Set `GALAXY_KEY` to the Galaxy API key for your user account on the above Galaxy server.
1. Run the `install.sh` script with the directory where the DSL jar file will be stored. This
directory must already exist.

```bash
$> mkdir $HOME/kernels
$> ./install.sh $HOME/kernels
```

Advanced users are free to put the jar file anywhere and edit the *kernel.json* file appropriately.
The kernel expects two command line parameters.  The first is the `{connection file}` provided
by Jupyter and the second is the path to the *jupyter-lsd-kernel.properties* file, which 
provides the information the kernel need to communicate with a Galaxy instance. To communicate
with a different Galaxy instance simply update the *jupyter-lsd-kernel.properties* file and
change GALAXY_HOST and GALAXY_KEY to the appropriate values.

## Starting Jupyter

You should now be able to start Jupyter with `jupyter notebook` or `jupyter console --kernel lsd`.

## Interacting with Galaxy

The LSD kernel provides two methods for interacting with Galaxy: `get` and `put`. The `get`
method downloads a data set item from the current history into a `java.io.File` object and the `put` command
uploads a `java.io.File` to the current Galaxy history.

```groovy
f = get(80)

f = new File('/tmp/HelloWorld.txt')
f.text = 'Hello world'
put(f)
```

### Handling JSON

Use the `parse(String, Class)` method to parse a JSON String into an object.  **Note:** in
Groovy you do not need to include the *.class* suffix when specifying a Java/Groovy class.

```groovy
f = get(80)
data = parse(f.text, DataContainer)
```

The above reads the JSON from the file and parses it into a [DataContainer](http://wiki.lappsgrid.org/org.lappsgrid.serialization/groovydoc/org/lappsgrid/serialization/DataContainer.html) object.

Use the `toJSon` or `toPrettyJson` methods to convert an object into a JSON string.

```groovy
data = [ name:'Bob', species:'Dog' ] 
f = new File('/tmp/test.json')
f.text = toJson(data)
```

### Programming Notes

1. The last statement executed in a cell will be the *return value* for that cell.

### Scoping

The LSD kernel supports both global and local variables. To define a local variable
include the type (or use the `def` keyword) when defining the variable.  If the first use
of a variable does not include a type it is assumed to be a global variable.

```groovy
String s1 = 'This is a local variable.'
s2 = 's2 will be global variable if it has not been declared already.'
```

Global variables can be used in any cell while local variables are only visible in the cell
that defines them.

A cell can also define functions that can be used later in that cell.

```groovy
Container getContainer(int historyId) {
	File f = get(historyId)
	DataContainer dc = parse(f.text, DataContainer)
	return dc.payload
}

container = getContainer(80)
container.text
```

Use a Groovy closure to define a function that can be used in other cells

```groovy
// In one cell.
getContainer =  { historyId ->
	File f = get(historyId)
	DataContainer dc = parse(f.text, DataContainer)
	return dc.payload
}

// In another cell.
container = getContainer(80)
container.text
```

# Exercise : Create a list of all locations in a document.

Each of the following steps should be run in their own cell in a Jupyter Notebook. A Notebook
with the folling exercise can be downloaded [here](WikiExample.ipynb).

#### Step 1 : Load a document into a Galaxy history

1. Log in to Galaxy and create a new History.
1. Select the `Get Document` tool from the MASC section.  Use the key *MASC2-0040* and select *Gold Annotations* as the `type`.

#### Step 2 : Load the Galaxy document into Jupyter

1. Open a Jupyter Notebook and start a LSD kernel.
1. In the first cell run the following text (ctl+Enter runs the current cell).

```groovy
f = get(1)
```

After a moment you should see something like:

```groovy
/var/folders/3g/l8qm57w53zl2ndjlblpgd26h0000gn/T/groovy-kernel-4125104986707886180.dat
```

#### Step 3 : Parse the document text

```groovy
data = parse(f.text, DataContainer)
container = data.payload
```

#### Step 4 : Find the view with named entities

In the MASC Gold Annotation data each annotation type is loaded into its own [View](http://wiki.lappsgrid.org/org.lappsgrid.serialization/groovydoc/org/lappsgrid/serialization/lif/View.html)
object. Before we can construct a list of locations we first need to find the view that
contains named entities.  That is, we need to check the metadata for each view to see which
one contains [Uri.NE](http://wiki.lappsgrid.org/org.lappsgrid.discriminator/apidocs/org/lappsgrid/discriminator/Discriminators.Uri.html) annotations.

Fortunately, the Groovy `find` method makes this easy.

``` groovy
view = container.views.find { it.metadata.contains[Uri.NE] }
```

#### Step 5 : Filter just the location

Now that we have the view that contains the named entities we need to find the annotations
for locations. 

```groovy
locations = view.annotations.findAll { it.atType == Uri.LOCATION }
```

#### Step 5 : Write a method (closure) to retrieve the text covered by an annotation.

The MASC NE annotations do not include the span of text being annotated so we need to 
retrieve the text from the document text, which is stored in `container.text`.

```groovy
getText = { Annotation a ->
	return container.text.substring((int)a.start, (int)a.end)
}
```

##### Step 7 : Get the text for each location

We will save the locations to a Set object so we get a list
of unique locations.

```groovy
unique = [] as HashSet
locations.each { 
	unique << getText(it)
}
```

#### Step 8 : Save the locations and upload to Galaxy.

We first need to write the unique location names to a temporary file and then `put` that
file to Galaxy.  The name of the file will be the name of the history item in Galaxy so it
is a good idea to use a human-friendly name.  We also sort the set before writing to the 
file to make the output easier to read.

```groovy
File t = new File('/tmp/Locations.txt')
t.withWriter { writer ->
	unique.sort().each { writer.println(it) }
}
put(t)
t.delete()
```

**Note** When you return to Galaxy you will need to refresh the history to see the newly
uploaded item.

Enjoy!
