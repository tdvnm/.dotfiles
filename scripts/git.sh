#!/bin/bash

git add .
echo "commit message "
read mess
git commit -m "$mess"
git push -u origin master
