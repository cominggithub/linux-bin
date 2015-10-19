#!/bin/bash
eval grep --color --include=*.{${2}} -rnw '.' -e "$1"