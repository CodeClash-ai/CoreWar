#!/bin/sh
for f in tmp/anti*.red; do echo $f; ./src/pmars -b -r 300 $f warrior.red | tail -1; done
