---
layout: cayman
title: Groovy DSL
buttons: 
  - text: Getting Started
    href: 'getting_started.html'
  - text: Examples
    href: '/code/examples.html'
  - text: Support
    href: 'support.html'
---

## The Language Applications Grid and Groovy DSLs

> A *Domain Specific Language* (DSL) is a computer programming language specialized to a specific application domain. [1]

The Language Applications Grid (LAPPS Grid, or just LAPPS) uses several domain specific languages:

1. LAPPS Services DSL (LSD)
1. LAPPS Database Definition Language (LDDL)
1. Vocabulary DSL
1. Discirminator DSL

LSD is basically just Groovy bundled with the LAPPS API modules that are automatically imported into user scripts. The other three can be thought of executable configuration languages. To effectively leverage these languages it is important to understand how a Groovy DSL is constructed and operates.

## It is all just Groovy

While the syntax may look odd at times, every DSL is a syntactically correct Groovy program. 

#### Lists and Maps
Creating instances of ArrayList and HashMap is concise and lists and maps can be initialized when they are defined.

```groovy
def list = [ 'one', 'two', 'three' ]
def map = [key:'value', foo:'bar']
```

If the map keys are strings the 'dot syntax' can be used to fetch/set values. Array style access is also supported.

```groovy
def map = [key:'value', foo:'bar']
assert map.key == 'value'
assert map['key'] == 'value'
assert map.get('key') == 'value'
```

#### Calling Functions

Method/function calls do not require parenthesis.

```groovy
println "hello world"
println("hello world")
```

Groovy will collect `name:value` parameters together and pass them as a single map.

```groovy
doSomething foo:'bar', name:'value', 'hello world'

void doSomething(Map parameters, String message) { 
	assert parameters.foo == 'bar'
	assert parameters.name == 'value'
	assert message == 'hello world'
}
```

Closures can also be passed as parameters.

```groovy
void runIt(Closure cl) {
	cl()
}

def closure = { println 'Hello world' }
runIt(closure)
```

If the closure is the last parameter to the function the closure may be defined at the same time that it is used.  That is, there is no need to assign the closure to a variable unless it is being used in more than one location.

```groovy
runIt {
	println "hello world"
}
```

If we add all of the above together we can write things like:

```groovy 
box width:50, height: 20, border:'1px solid black' {
	paragraph 'Your text here.'
}
```

This is calling a function named `box` and passing two parameters, a `HashMap` and a `Closure`. The `HashMap` contains three elements with the keys *width*, *height*, and *border*. The closure in turn calls a function name paragraph with a single string parameter.

### Method Delegation

Groovy's method resolution and delegation strategies are beyond the scope of this article, but having some understanding of delegates and metaclasses is important when designing a Groovy DSL.

#### Class Delegates

If a method to be invoked can not be found in the class definition Groovy will check if a delegate has been defined. If a delegate has been defined Groovy will look in the delegate instance for the method before searching up the inheritance chain.

```groovy
class Company {
	int orderPart(int quantity) { return quantity }
}

class StockItem {
	String partNumber
	@Delegate
	Company company = new Company()
	@Delegate
	List parts = []
}
StockItem item = new StockItem(partNumber:'00-0000-000')
assert item.size() == 0 // delgates to List.size()
item.add('thingamajig') //delegates to List.add()
item << 'whatchamacallit' // delegates to List.leftShift()
assert item.size() == 2
assert item.orderPart(10) == 10 // delegates to Company.orderPart()
```

If more than one `@Delegate` contains a matching method the method from the first delegate defined is chosen. 

```groovy
class D1 { 
	String foo() { 'd1' } 
}
class D2 { 
	String foo() { 'd2' }
}
class Root {
	@Delegate 
	D1 d1 = new D1()
	@Delegate 
	D2 d2 = new D2()
}
assert new Root().foo() == 'd1'
```

#### Closure Delegates

Delegate objects can also be set for closures.

```groovy
def greet = { echo "Hello $it" }
greet('Alice')  // MissingMethodException : echo()

class Greeter {
	void echo(String message) { println message }
}	
greet.delegate = new Greeter()
greet('Bob') // delegates to Greeter.echo()
```

Groovy closures also have an *owner*, which is the object that invoked the closure and will either be a class instance or another closure.

```groovy
String echo(String message) { return message }
def greet = { echo "Hello $it" }  // Resolves to the echo() method in the owner class
assert 'Hello Bob' == greet('Bob')
```

We can control how Groovy chooses between methods in the *owner* or *delegate* by setting the `resolveStrategy` property on the closure.

```groovy
String echo() { return 'owner' }

class Delegate {
	String echo() { return 'delegate' }
}

def test = { echo() }
test.delegate = new Delegate()
assert test() == 'owner'  // dispatches to the owner by default
test.resolveStrategy = Closure.DELEGATE_FIRST
assert test() == 'delegate'
```

The possible values for `resolveStrategy` are:

* Closure.OWNER_FIRST
* Closure.OWNER_ONLY
* Closure.DELEGATE_FIRST
* Closure.DELEGATE_ONLY

#### MetaProgramming and the MetaClass

In addition to a super (parent) class, Groovy classes can also have a [metaclass](http://docs.groovy-lang.org/latest/html/api/groovy/lang/MetaClass.html) associated with them at runtime that provides another mechanism to dynamically inject behavior into an existing class. In particular, missing methods can be intercepted before a MissingMethodException is thrown.

```groovy
class Foo {
	String foo() { return 'foo' }
}

Foo foo = new Foo()
foo.metaClass.bar = { return 'bar' }
foo.metaClass.methodMissing = { String name, def args ->
	return 'missing'
}
assert foo.foo() == 'foo'
assert foo.bar() == 'bar' // added by the metaclass
assert foo.foobar() == 'missing' // methodMissing()
```

Methods and properties can also be added to existing classes. Consider a simple DSL to make comparing distances easier:

```groovy
ExpandoMetaClass.enableGlobally()
Number.metaClass.getProperty = { String name ->
	if (name == 'inches') return delegate
	if (name == 'feet') return delegate * 12
	throw new MissingPropertyException("Invalid unit: $name")
}
assert 2.feet == 24.inches
print 1.mile // MissingPropertyException: Invalid unit mile
```

**NOTE** The `ExandoMetaClass.enableGlobally()` statement is required so that methods and properties that are added dynamically are also available in sub-classes.  The above example adds an implementation for `getProperty` to the `Number` class while it is called from instances of `Integer`.

## Putting it all together

Assume we are unhappy with the Groovy MarkupBuilder class and we would like to write our own Builder that accepted our DSL and returned a tree of `groovy.util.Node` objects.  We might start with something like:

```groovy
import groovy.util.Node

class Builder {
	// The last node constructed by the builder.
	Node node

	// Catch all missing methods and create a Node with the same name
	// as the method. args will contain attributes, if any, in a HashMap and
	// a value that will be a string or a closure.
    def methodMissing(String name, args) {
        Map atts = [:]
        def value = args[0]
        if (args.size() > 1) {
            atts = args[0]
            value = args[1]
        }
        if (value instanceof Closure) {
            node = new Node(node, name, atts)
            value()
            node = node.parent()
        } else {
            new Node(node, name, atts, value)
        }
    }

    Node build(Closure cl) {
        node = new Node(null, 'dummy_node')
        cl.delegate = this
        cl()
        return node.children()[0]
    }
}```

We can use our new builder with:

```groovy
def builder = new Builder()
def root = builder.build {
	inventory {
		part {
			id 'nail'
			cost 1.25
			description 'The pointy bit."
		}
		part {
			id 'hammer'
			cost 29.95
			description 'When your only tool is a hammer all your problems look like nails.'
		}
	}
}

// Print our inventory as XML
println XmlUtil.serialize(root)
```

## Compiling Groovy at runtime

The `GroovyShell` class makes it easy to compile a String into code that can be executed.

```groovy
String code = 'println "hello world"'
def shell = new GroovyShell()
def script = shell.parse(code)
script.run()
// prints hello world
```

## References

1. https://en.wikipedia.org/wiki/Domain-specific_language
