---
layout: default
title: The Wiki
menu:
 - Layouts
 - Pages
 - Scripts	
---

# The Wiki

The LAPPS Grid wiki is just the [GitHub Pages](https://pages.github.com) website for the [LAPPS Grid organization](https://github.com/lapps). GitHub uses [Jekyll](https://github.com/jekyll/jekyll) to render the markdown files into static html files and if you have Jekyll installed locally it is possible to preview any local changes before pushing them to GitHub.

If you don't already have Jekyll you will need to install it.

```bash
gem install jekyll bundler  
```

To preview the wiki site run the following commands in the directory containing the wiki pages:

```bash
bundle exec jekyll serve --watch
```

Now open http://localhost:4000 in your web browser.  The `--watch` parameter tells Jekyll to rebuild any files that change on disk.

# Layouts

A Jekyll layout is a [Liquid](https://shopify.github.io/liquid/) template file stored in the \_layouts directory. The variable `{% raw %}{{ content }}{% endraw %}` will be replaced by the HTML generated from the markdown.  For example, suppose we have the following in `_layouts/example.html`:

```html
<html>
	<head>
		<title>{% raw %}{{ page.title }}{% endraw %}</title>
	</head>
	<body>
		{% raw %}{{ content }}{% endraw %}
	</body>
<body>
```

we can use this layout with the following"

```
---
layout: example
title: This is an example
---

# Examples

1. list item one
1. list item two
```

which will result in the following html being generated:

```html
<html>
	<head>
		<title>This is an example</title>
	</head>
	<body>
		<h1>Examples</h1>
		<ol>
			<li>list item one</li>
			<li>list item two</li>
		</ol>
	</body>
<body>
```

Available layouts

- basic
- cayman
- slate
- modernist

Make a copy of the desired layout and rename it *default.html*.

{{ site.top }}

# Pages

Every GitHub Page consists of:

1. some front matter
1. some markdown

## Front Matter

For GitHub/Jekyll to serve a page it must contain the required *front matter*.  The *front matter* is some YAML wrapped in triple dashes:

```
---
layout: default
---
```

{{ site.top }}

# Scripts

### ./start
Starts the local Jekyll server.  The web site will be available at http://localhost:4000

### ./restyle 
Changes the `layout:` for all *.md* files in the current directory add all subdirectories.

```bash
./restyle slate cayman
```

<div class="note">
<em>Note</em> this script should not be required as all pages should use the <i>default</i> layout.
</div>

Information about the available scripts.

{{ site.top }}
