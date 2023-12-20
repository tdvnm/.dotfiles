#!/bin/bash

echo "choose "
echo "1. svelte"
echo "2. react"
echo " "

read choice

echo "enter app name"
read name

if [ $choice -eq 1 ]
then
    npm create svelte@latest $name
    cd $name
    npm install
    npm run dev
elif [ $choice -eq 2 ]
then
    npx create-react-app $name
    cd $name
    npm start
else
    echo "enter 1 or 2"
fi
```
