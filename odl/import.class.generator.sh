#!/bin/bash

# | xargs -I {} jar -tf {} | grep rev130709

JARS=$(find . -name *.jar)

for jar in ${JARS};
do
	result=$(jar -tf $jar | grep 'class$')

	for s in ${result};
	do
		class=$(echo "import $s" | sed 's/\//./g' | sed 's/.class//g')
		echo "$class $jar"
	done

	#echo $result | sed 's/\//./g' | xargs -I {}  echo import  {}
	

	# if [ ! -z "$result" ]; then
	# 	printf "\033[0;32m $jar \033[0m\n"

	# 	if [ -z "$2" ]; then
	# 		jar -tf $jar | grep --color=auto *.class
	# 	fi
	# fi
	

done
