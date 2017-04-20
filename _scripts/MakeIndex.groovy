import groovy.transform.*

stack = new Stack<MenuItem>()
ignored = [ '404.md', 'index_old.md', 'Test.md', 'Themes.md' ] as HashSet
indent = new Indentation()
void process(File dir) {
	dir.eachFile { file ->
		if (file.isDirectory() && !file.name.startsWith('_') && !file.name.startsWith('.')) {
			Menu menu = new Menu(file.name)
			stack.peek() << menu
			stack.push(menu)
			process(file)
			stack.pop()
		}
		else if (file.path.endsWith('.md')) {
			if (!ignored.contains(file.name)) {		
				String name = file.name
				int index = name.lastIndexOf(".")
				if (index > 0) {
					name = name.substring(0,index)
				}
				item = new Item(name.capitalize(), file.path.substring(1).replace(".md", ""))
				stack.peek() << item
			}
		}
	}
}

println '''---
layout: default
title: Site Index
---

# Site Index
'''
stack.push(new Menu('ROOT'))
process(new File('.'))
Menu root = stack.pop()
root.prune()
root.print(System.out, new Indentation())
return


interface MenuItem {
	void print(PrintStream stream, Indentation indent)
	int size()
	void prune()
}

@TupleConstructor 
class Menu implements MenuItem {
	String name

	@Delegate	
	List<MenuItem> items = []
	
	void print(PrintStream out, Indentation indent) {
		out.println "${indent}- $name"
		indent.more()
		items.each { it.print(out, indent) }
		indent.less()
	}
	
	void prune() {
		items.each { it.prune() }
		items = items.findAll { it.size() > 0 }
	}
}

@TupleConstructor
class Item implements MenuItem {
	String name
	String url
	
	int size() { 1 }
	void print(PrintStream out, Indentation indent) {
		out.println("${indent}- [$name]($url)")
	}
	void prune() { }
}

class Indentation {
	Stack<String> stack = new Stack()
	String indent = ''
	String pad = '  '
	
	Indentation() { }
	Indentation(String pad) {
		this.pad = pad
	}
	
	Indentation more() {
		stack.push(indent)
		indent = indent + '  '
		return this
	}
	Indentation less() {
		if (stack.empty()) {
			indent = ''
		}
		else {
			indent = stack.pop()
		}
		return this
	}
	String toString() {
		return indent
	}		
}
