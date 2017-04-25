#!/usr/bin/env bash

set -eu

old=$1
new=$2
temp="/tmp/restyled"

for file in `find . -name "*.md" | xargs grep -l "layout: $old"` ; do
	cat $file | sed "s/layout: $old/layout: $new/" > $temp
	mv $temp $file
	echo "Restyled $file"
done