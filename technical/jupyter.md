---
layout: default
title: Jupyter Notebook
nav:
  - installing
  - galaxy
  - example
---

# {{ page.title }}

The Lappsgrid Services DSL (LSD) is a [Groovy](http://groovy-lang.org/) Domain Specific 
Language that can be used to interact with services on the LAPPS Grid. The Language 
Application Grid has also developed a LSD kernel for use in [Jupyter Notebooks](http://jupyter.org/).  

## Installation

It is assumed that users already have [Jupyter installed](http://jupyter.readthedocs.io/en/latest/install.html).
If you don't have Jupyter, but do have Python the following should work:

```bash
$> pip install jupyter
```

<a name="installing"></a>
### Install the kernel

#### From Source

Building the Jupyter LSD Kernel project requires Maven 3.x or higher.

```bash
$> git clone https://github.com/lappsgrid-incubator/jupyter-lsd-kernel.git 
$> cd jupyter-lsd-kernel
$> mvn package
$> ./install.sh <kernel directory>
```

Where *&lt;kernel directory&gt;* is a directory where the kernel jar file will be copied and can be any directory on your system.

#### From Pre-compiled Binaries

Download and expand the [LSD Kernel archive](http://www.lappsgrid.org/downloads/jupyter-lsd-kernel-latest.tgz) and then run the *install.sh* script.

```bash
$> wget http://www.lappsgrid.org/downloads/jupyter-lsd-kernel-latest.tgz
$> tar xzf jupyter-lsd-kernel-latest.tgz
$> cd jupyter-lsd-kernel-x.y.z
$> ./install.sh <kernel directory>
```

Where *&lt;kernel directory&gt;* is a directory where the kernel jar file will be copied and can be any directory on your system. Replace *x.y.z* with the current version number.

#### Notes

By default the *install.sh* script will install the Jupyter kernel to the system kernel directory. This is typically */usr/local/share/juptyer* on Linux/MacOS systems and *%PROGRAMDATA%\jupyter\kernels* on Windows systems.  To install the Jupyter kernel to the User's directory you must either:

* Edit the *install.script* and add the *--user* option to the `kernelspec` command, or
* Edit the kernel.json file to set the *argv* paramater to the location of the Jupyter Groovy kernel and then run the `jupyter kernelspec install` command manually.

You can view the default directories that Jupyter uses by running the command `jupyter --paths`.

### Starting Jupyter

You should now be able to start Jupyter with `jupyter notebook` or `jupyter console --kernel lsd`.

Jupyter will read/write files (notebooks) in the current directory. 

### Docker

A Docker image containing the LSD kernel is available from the [Docker Hub](https://hub.docker.com/r/lappsgrid/jupyter-lsd-kernel/).  The container expects two environment variables to be defined that are used to connect to a Galaxy server:

1. **GALAXY_HOST** The URL to a Galaxy server.
1. **GALAXY_KEY** The API key for the user on the Galaxy server.

Inside the container Jupyter uses the directory */home/jovyan* to save and load notebooks.  To persists notebooks created inside the container mount a local directory as */home/jovyan*.

```bash
$> HOST=http://galaxy.lappsgrid.org
$> KEY=1234567890DEADBEEF
$> ENV="-e GALAXY_HOST=$HOST -e GALAXY_KEY=$KEY"
$> VOLUME="-v $HOME/notebooks:/home/jovyan"
$> PORTS="-p 8888:8888"
$> docker run -d $PORTS $ENV $VOLUME lappsgrid/jupyter-lsd-kernel 
```

Or, if you don't mind really long command lines the above can be achieved in one line:

```bash
$> docker run -d -p 8888:8888 -e GALAXY_HOST=http://galaxy.lappsgrid.org -e GALAXY_KEY=1234567890DEADBEEF -v $HOME/kernels:/home/jovyan lappsgrid/jupyter-lsd-kernel
```

{{ site.top }}

<a name="galaxy"></a>
## Interacting with Galaxy

### Connecting to Galaxy

The LSD kernel needs two pieces of information to be able to interact with Galaxy:

1. The URL of the Galaxy server.
1. Your Galaxy API key.  If you do not have a Galaxy API key you will need to log in to the Galaxy instance and generate one (User -> Preferences -> Manager your API keys.)

You will need to set the environment variables **GALAXY_HOST** and **GALAXY_KEY** before launching Jupyter:

```bash
$> export GALAXY_HOST=http://galaxy.example.com:8000
$> export GALAXY_KEY=1234567890DEADBEEF
$> jupyter notebook
```

### Galaxy Notebook Functions

The following functions are built in to the Jupyter LSD kernel to simplify working with a Galaxy instance.

**void selectHistory(String history_name)**<br/>
Select the Galaxy history to work with.  It is a good practice to always name histories in Galaxy so they may be easily selected in Jupyter.  Since the Galaxy API has no concept of the *current history* it is impossible to select a history if they are all named *"Unnamed history"*.

**File get(int history_id)**<br/>
Returns a *java.io.File* object with the contents of the dataset with the given history id. The history id is simply the integer to the left of the dataset name in the history panel.

**void put(Stirng path)**<br/>
**void put(File file)**<br/>
Uploads the file to the currently selected Galaxy history.  You may need to refresh the history in Galaxy to see the newly uploaded file.  The dataset name will be the name of the uploaded file.

**Object parse(String json)**<br/>
**Object parse(String json, Class theClass)**<br/>
Parses a JSON string into an instance of **theClass**.  Calling `parse(json)` is the same as calling `parse(json, org.lappsgrid.serialization.Data)`.

**String toJson(Object object)**<br/>
Returns the compact JSON string representation of the `object`.

**String toPrettyJSon(Object object)**<br/>
Returns a pretty-printed JSON string representation of the `object`.

**String readline(String prompt)**<br/>
Prompts the user to enter a line of input and returns that string.  The Jupyter user interface will 
determine the best way to display the prompt to the user and read the user input.

**void version()**<br/>
Displays the current Groovy and LSD kernel versions.

**GalaxyInstance galaxy()**<br/>
**HistoriesClient histories()**<br/>
**ToolsClient tools()**<br/>
**History history()**<br/>
Returns handles to the various Galaxy clients. See the Blend4J API documentation (link needed) for more information on these clients.

## Examples 
The LSD kernel provides two methods for interacting with Galaxy: `get(int)` and `put(File)`. The `get`
method downloads a data set item from the current history into a `java.io.File` object. The
int parameter is the history id number of the item to be downloaded. 

```groovy
f = get(42)
```

The `put` command uploads a `java.io.File` to the current Galaxy history.

```groovy
f = new File('/tmp/HelloWorld.txt')
f.text = 'Hello world'
put(f)
```
The filename will be used as the dataset name in the history panel so it is recommended to use a meaningful filename.

### Handling JSON

Use the `parse(String, Class)` method to parse a JSON String into an object.  **Note:** in
Groovy you do not need to include the *.class* suffix when specifying a Java/Groovy class.

```groovy
f = get(42)
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

container = getContainer(42)
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
container = getContainer(42)
container.text
```

{{ site.top }}

<a name="example"></a>
# Example : Create a list of all locations in a document.

Each of the following steps should be run in their own cell in a Jupyter Notebook. A Notebook
with the following exercise can be downloaded [here](WikiExample.ipynb).

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

#### Step 5 : Create a closure to get the text covered by an annotation.

The MASC NE annotations do not include the span of text being annotated so we need to 
retrieve the text from the document text, which is stored in `container.text`.

```groovy
getText = { Annotation a ->
	return container.text
		.substring((int)a.start, (int)a.end)
		.replaceAll('\n', ' ')
		.replaceAll('  +', ' ')
}
```

##### Step 7 : Get the text for each location

We will save the locations to a Set object so we get a list
of unique locations.

```groovy
unique = [] as HashSet
locations.each { 
	unique.add(getText(it))
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

## Map/Reduce/Filter

Version 1.1.0-SNAPSHOT of the Jupyter LSD kernel adds the methods *map*, *reduce*, and *filter* to the Java Collection classes.
While Groovy has the methods *collect*, *inject*, and *grep* (or *find*/*findAll*) many people are more comfortable
with the names map, reduce and filter.  In fact the map, reducer, filter methods simply delegate to
collect, inject and grep.

This is the same example as above only using map, reduce, filter methods:

```groovy
data = parse(get(1).text, DataCollection)
data.payload.views
	.find { it.metadata.contains[Uri.NE] }
	.annotations
	.filter { it.atType == Uri.LOCATION }
	.map { data.payload.text.substring((int)it.start, (int)it.end) }
	.map { it.replaceAll('\n', ' ') }
	.map { it.replaceAll('  +', ' ') }
	.reduce([] as HashSet) { set,value -> set << value }
	.sort()
	.reduce(new StringWriter()) { writer, value -> writer << value; writer << '\n' }
	.toString()	
	
```
