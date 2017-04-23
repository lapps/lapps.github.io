---
layout: default
title: Groovy DSL
edit: true
buttons:
- text: Home
  href: /
- text: Index
  href: /Contents
---

## The Language Applications Grid and Groovy DSLs

> A *Domain Specific Language* (DSL) is a computer programming language specialized to a specific application domain. [1]

The Language Applications Grid uses several domain specific languages:

1. [LAPPS Services DSL](https://github.com/lappsgrid-incubator/org.anc.lapps.dsl) (LSD)
1. [LAPPS Database Definition Language](https://github.com/lappsgrid-incubator/org.anc.lapps.lddl) (LDDL)
1. [Vocabulary DSL](https://github.com/lappsgrid-incubator/vocabulary-dsl)
1. [Discirminator DSL](https://github.com/lappsgrid-incubator/org.lappsgrid.discriminator.dsl)

LSD is basically just Groovy bundled with the LAPPS API modules that are automatically imported into user scripts. The other three can be thought of executable configuration languages. The advantage of a DSL over a data format like Yaml or JSON is that it is *executable* code that can define functions, store commonly used values in variables, and make use of flow of control and looping statements.

## It is all just Groovy

While the syntax may look odd at times, every DSL is a syntactically correct Groovy program. So even though the DSL may look like a configuration file it will actually be compiled in to Java bytecode and executed on the JVM.  Consider a statement from the Discriminator DSL:

```groovy
token {
	uri 'http://vocab.lappsgrid.org/Token'
	description 'A string of one or more characters that serves as an indivisible unit for the purposes of morpho-syntactic labeling (part of speech tagging).
}
```

The above calls a method named `token` that takes a closure as its only parameter:

```java
public void token(Closure body) { ... }
```

The closure contains two statements. The first statement calls the method `uri` with a single String parameter and the second statement calls the method `description` with a single String parameter.

## Compiling Groovy at runtime

The `GroovyShell` class makes it easy to compile a String into code that can be executed.

```groovy
String code = 'println "hello world"'
def shell = new GroovyShell()
def script = shell.parse(code)
script.run()
// prints hello world
```

Groovy allows us to [customize the compiler](http://docs.groovy-lang.org/latest/html/api/org/codehaus/groovy/control/customizers/CompilationCustomizer.html) so we can do things like:

- Add import statements to the script
- Set a base class for the script
- Provide a [Binding](http://docs.groovy-lang.org/latest/html/api/groovy/lang/Binding.html) object to the script to inject variables.

## Metaprogramming

Groovy provides several [metaprogramming](http://groovy-lang.org/metaprogramming.html#_runtime_metaprogramming) techniques that assist in writing a DSL. Two of the most useful are:

1. `methodMissing(String,List)` allows us to synthesize methods dynamically.  This is a powerful technique for creating *Builders*, that is, objects that build other objects based on some sort of description.
2. Closure delegates. A delegate is like a super class for a closure.  If Groovy can not resolve a method call in the closure's scope it will look in the delegate for the method. 

{{ site.top }}

## Example DSL

Suppose we want to transform the following simplified Discriminator DSL into a JSON representation.

```groovy
token {
	url 'http://vocab.lappsgrid.org/Token'
	description 'A string of one or more characters that serves as an indivisible unit.'
}
sentence {
	url 'http://vocab.lappsgrid.org/Sentence'
	description 'A sequence of one or more words.'
}
```

Our DSL processor will do three things:

1. Implement a delegate class that provides the `url` and `description` methods.
1. Parse the code into a [Script](http://docs.groovy-lang.org/latest/html/api/groovy/lang/Script.html) object.
1. Implement `script.metaClass.methodMissing` to intercept method calls.
1. Generate the JSON from the constructed data structure.

### 1. The delegate class is simple enough.

The `Delegate` class will provide the `url` and `description` methods.  Each method takes a String and will save it in a field of the same name.

```groovy
class Delegate {
	String url
	String description
	
	void url(String url) { this.url = url }
	void description(String description) { this.description = description }
}
```

### 2. Parsing the code

We have already seen how to do this above.  

```groovy
Script script = new GroovyShell().parse(code)
```

### 3. Handle missing methods

```groovy
def objects= [:]
script.metaClass.methodMissing = { String name, args ->
	Closure cl = args[0]
	cl.delegate = new Delegate()
	cl();
	objects[name] = cl.delegate
}
```

First we create a `HashMap` to hold the generated objects. We assume that the first parameter to the missing method will always be a closure, but in practice we would need to so some error checking here.  After running the closure we add the `Delegate` object to the map. In practice we would do some error checking here as well to make sure any required fields in the delegate were initialized and that fields were initialized with proper values.

### 4. Write the output

Groovy's `JsonBuilder` class makes the final step trivial.

```groovy
println new groovy.json.JsonBuilder(objects).toPrettyString()
```

### The finished product

Putting it all together the complete DSL processor looks like:

```groovy
class Dsl {
    public static void main(String[] params)
    {
        String code = new File(params[0]).text
        def objects = [:]
        Script script = new GroovyShell().parse(code)
        script.metaClass.methodMissing = { String name, args ->
            Closure cl = args[0]
            cl.delegate = new Delegate()
            cl();
            annotations[name] = cl.delegate
        }

        script.run()
        println new groovy.json.JsonBuilder(objects).toPrettyString()
    }
}
class Delegate {
    String url
    String description
    
    void url(String url) { this.url = url }
    void description(String description) { this.description = description }
}
```

If we did not implement `script.metaClass.methodMissing` then Groovy would complain about the missing method `token` when we tried to run the program on the example input.  Similarly, if we did not add a delegate that implemented `url` and `description` to the closure Groovy would complain about the missing method `url` when attempting to execute the closure.

{{ site.top }}

## References

1. https://en.wikipedia.org/wiki/Domain-specific_language
