#!/bin/bash

# | xargs -I {} jar -tf {} | grep rev130709

JARS=$(find . -name *.jar)

for jar in ${JARS};
do
	result=$(jar -tf $jar | grep $1)
	
	if [ ! -z "$result" ]; then
		printf "\033[0;32m $jar \033[0m\n"

		if [ -z "$2" ]; then
			jar -tf $jar | grep --color=auto $1
		fi
	fi
	

done

