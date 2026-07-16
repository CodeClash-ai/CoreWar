#!/bin/sh
name=$1; shift
f=tmp/$name.red
n=$#
{
echo ';redcode-94'; echo ";name $name"; echo ';assert CORESIZE==8000';
for i in $(seq 1 $((n-1))); do echo " spl b$i"; done; echo ' jmp b0';
i=0; for s in "$@"; do echo "b$i mov.i bomb, $s"; echo " add.ab #$s, b$i"; echo " jmp b$i"; i=$((i+1)); done
echo 'bomb dat.f #0,#0'; echo 'end 0';
} > $f
./src/pmars -b -r 2000 $f tmp/smooth6_guess.red | tail -1
./src/pmars -b -r 2000 $f tmp/smooth_exactish.red | tail -1
