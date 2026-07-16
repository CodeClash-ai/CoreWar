#!/bin/sh
for s in 73 103 151 187 229 251 263 309 331 533 791 1143 2667 3413; do
 f=tmp/v$s.red
 {
 echo ';redcode-94'; echo ";name v$s"; echo ';assert CORESIZE==8000'; echo 'start spl b1';
 for i in $(seq 2 23); do echo " spl b$i"; done; echo ' jmp b0';
 for i in $(seq 0 23); do echo "b$i mov.i bomb, $s"; echo " add.ab #$s, b$i"; echo " jmp b$i"; done
 echo 'bomb dat.f #0,#0'; echo 'end start';
 } > $f
 printf "$s "; ./src/pmars -b -r 1000 $f tmp/smooth6_guess.red | tail -1
done
