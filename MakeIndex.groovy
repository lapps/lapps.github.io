

ignored = [ '404.md', 'index_old.md' ] as HashSet
indent = new Indentation()
void process(File dir) {
	dir.eachFile { file ->
		if (file.isDirectory() && !file.name.startsWith('_') && !file.name.startsWith('.')) {
			println "${indent}- ${file.name.capitalize()}"
			indent.more()
			process(file)
			indent.less()
		}
		else if (file.path.endsWith('.md')) {
			if (!ignored.contains(file.name)) {		
				String name = file.name
				int index = name.lastIndexOf(".")
				if (index > 0) {
					name = name.substring(0,index)
				}
				println "${indent}- [${name.capitalize()}](${file.path.substring(1).replace('.md', '')})"
			}
		}
	}
	//return lines
}

println '''---
layout: default
title: Site Index
---

# Site Index
'''
process(new File('.'))
//List lines = process(new File('.'))
//lines.each { println it }


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

/*
new File(".").eachDirRecurse { dir ->
	dir.eachFileMatch(~/.*\.md$/) { file ->
		println file.path
	}
}
*/