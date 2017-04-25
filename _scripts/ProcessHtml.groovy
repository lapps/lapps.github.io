/*
 * Creates a sorted summary of all HTML tags used in all the
 * .html files. This script was used to bootstrap the HtmlToMarkup
 * program.
 */
parser = new groovy.util.XmlParser()
tags = [] as HashSet
passed = 0
failed = []

void record(Node node) {
	//println node.name()
	tags << node.name()
}

void record(String ignored) { }

void process(File dir) {
	//println "Processing ${dir.path}" 
	dir.eachFile { file ->
		if (file.isDirectory()) {
			if (!file.name.startsWith('.') && !file.name.startsWith('_')) {
				process(file)
			}
		}
		else if (file.name.endsWith('.html')) {
			try {
				println "Parsing ${file.path}"
				Node node = parser.parse(file)
				node.depthFirst().each { record it }
				++passed
			}
			catch(e) {
				println e.message
				failed << file
				//System.exit(1)
			}
		}
	}
}

Node parse(File file) {
	String filename = file.path
	boolean done = false
	boolean tidied = false
	Node node = null
	while (!done) {
		try {
			println "Attempting to parse ${file.path}"
			node = parser.parse(file)
			done = true
		}
		catch(org.xml.sax.SAXParseException e) {
			if (tidied) {
				done = true
				println "Unable to process $filename"
			}
			else {
				println "Attempting to tidy  ${file.path}"
				file = new File('/tmp/fixed.html')
				if (file.exists()) {
					file.delete()
				}
				"tidy -i -b --output-xml --doctype omit -o /tmp/fixed.html ${file.path}".execute()
				if (!file.exists()) {
					//throw new FileNotFoundException("Tidy did not write ${file.path}")
					return null
				}
				tidied = true
			}
		}
	}
	return node
}

process(new File('.'))
println "Passed: $passed"
println "Failed: ${failed.size()}"
failed.each { println "tidy -n --output-xml yes --doctype omit -m -i $it" }

tags.sort().each { 
	println "${it}: { Node $it ->\n\t\n},"
}
