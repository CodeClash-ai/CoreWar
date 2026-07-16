#!/bin/sh
for step in 7 13 17 23 31 37 47 53 73 79 97 127 167 197 223 237 251 293 331 397 509 997 1031; do
cat > tmp/sc$step.red <<EOF
;redcode-94
;name scanner$step
;assert CORESIZE==8000
step equ $step
start spl 1
      spl 1
scan  add.ab #step, test
test  jmz.f scan, 100
      mov.i db, >test
      mov.i db, <test
      jmp scan
db    dat #0,#0
      end start
EOF
printf "$step "; ./src/pmars -b -r 200 tmp/sc$step.red tmp/rotld_guess.red | tail -1
done
