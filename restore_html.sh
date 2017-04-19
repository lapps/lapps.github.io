#!/bin/bash
set -eu

backup="./_backup/html"
cd $backup
for html in `find . -name "*.html"` ; do
	dir=`dirname $html`
	cp $html ../../$html
	echo "Copied $html"
done