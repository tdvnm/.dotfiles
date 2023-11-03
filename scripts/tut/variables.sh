#! /bin/bash

echo "whats your name? "
read name
echo "hello $name "

# variable types
letter = 'c'
word = 'string'
integer = 27

# constant variables
readonly PI = 3.1415

# command output in a variable
# variable = $(command)
TODAY = $(date)
USER = $(whoami)
