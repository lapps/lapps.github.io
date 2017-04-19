#!/bin/bash
set -eu

backup="./_backup/html"

for html in `find . -name "*.html" | grep -v "/_"` ; do
	dir=`dirname $html`
	if [ ! -e $backup/$dir ] ; then
		mkdir -p $backup/$dir
	fi
	mv $html $backup/$html
	echo "Moved $html"
done