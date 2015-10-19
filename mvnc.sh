#!/bin/bash

export BOLD=`tput bold`
export UNDERLINE_ON=`tput smul`
export UNDERLINE_OFF=`tput rmul`
export TEXT_BLACK=`tput setaf 0`
export TEXT_RED=`tput setaf 1`
export TEXT_GREEN=`tput setaf 2`
export TEXT_YELLOW=`tput setaf 3`
export TEXT_BLUE=`tput setaf 4`
export TEXT_MAGENTA=`tput setaf 5`
export TEXT_CYAN=`tput setaf 6`
export TEXT_WHITE=`tput setaf 7`
export BACKGROUND_BLACK=`tput setab 0`
export BACKGROUND_RED=`tput setab 1`
export BACKGROUND_GREEN=`tput setab 2`
export BACKGROUND_YELLOW=`tput setab 3`
export BACKGROUND_BLUE=`tput setab 4`
export BACKGROUND_MAGENTA=`tput setab 5`
export BACKGROUND_CYAN=`tput setab 6`
export BACKGROUND_WHITE=`tput setab 7`
export RESET_FORMATTING=`tput sgr0`

#[ERROR] symbol:   class 

mvn $@ | sed -e "s/\(\[INFO\]\ \-.*\)/${TEXT_WHITE}\1/g" \
        -e "s/\(\[INFO\]\ \[.*\)/${RESET_FORMATTING}${BOLD}\1${RESET_FORMATTING}/g" \
        -e "s/\(\[INFO\]\ BUILD SUCCESSFUL\)/${BOLD}${TEXT_GREEN}\1${RESET_FORMATTING}/g" \
        -e "s/\(\[WARNING\].*\)/${BOLD}${TEXT_YELLOW}\1${RESET_FORMATTING}/g" \
        -e "s/\(\[ERROR\].*\)/${BOLD}${TEXT_RED}\1${RESET_FORMATTING}/g" \
		-e "s/\[ERROR\] symbol:\(.\+\)/${RESET_FORMATTING}${TEXT_WHITE}${BOLD}\1${RESET_FORMATTING}${BOLD}${TEXT_RED}/g" \
		-e "s/\([a-zA-Z]\+\.java:\?\[.\+\]\)/${RESET_FORMATTING}${TEXT_WHITE}${BOLD}\1${RESET_FORMATTING}${BOLD}${TEXT_RED}/g" \
        -e "s/Tests run: \([^,]*\), Failures: \([^,]*\), Errors: \([^,]*\), Skipped: \([^,]*\)/${BOLD}${TEXT_GREEN}Tests run: \1${RESET_FORMATTING}, Failures: ${BOLD}${TEXT_RED}\2${RESET_FORMATTING}, Errors: ${BOLD}${TEXT_RED}\3${RESET_FORMATTING}, Skipped: ${BOLD}${TEXT_YELLOW}\4${RESET_FORMATTING}/g"

# Make sure formatting is reset

#-e "s/\([a-zA-Z]\+\.java:\[[0-9]\+\(,\|:\)[0-9]\+\]\)/${RESET_FORMATTING}${TEXT_WHITE}${BOLD}\1${RESET_FORMATTING}${BOLD}${TEXT_RED}/g" \
echo -ne ${RESET_FORMATTING}

#[ERROR] src/main/java/com/estinet/controller/impl/PacketHandler.java[605:9] (extension) TreeWalker: Got an exception - expecting EOF, found '}'
