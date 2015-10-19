#!/bin/bash
src="."

if [ "$#" -eq 1 ]; then
    src=$1
fi

fileList=`find $src -type f -name "*.xml" -or -name "*.pom"`

for file in ${fileList}; do
    sha1sum $file | cut -d ' ' -f1 > ${file}.sha1
done
