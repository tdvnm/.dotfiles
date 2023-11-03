#!/bin/bash

filename=$1
extension=$2

created=$1.$2

touch "$created"
chmod +x ./$created
sed -i '1s/^/'hello' /' $created


# touch $filename
