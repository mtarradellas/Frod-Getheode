#!/bin/bash
./gescieppan < $1 > parsedCode.c
gcc -Wall -pedantic -std=c99 -o $2 parsedCode.c lib/dugan.c
