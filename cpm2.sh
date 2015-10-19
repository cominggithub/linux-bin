#!/bin/bash

find /home/linms/.m2/repository -name "*.jar" -type f

# find /home/linms/.m2/repository -name *.jar -type f -exec sed -i 's/\/home\/linms\/.m2\/repository//g' {} \;