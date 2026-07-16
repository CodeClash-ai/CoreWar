#!/bin/sh
for step in 1 3 5 7 11 13 17 19 21 23 25 27 29 31 37 39 41 43 47 73 97 127 3039 2667; do
cat > tmp.red <<EOR
;redcode-94nop
;name stone$step
;assert CORESIZE==8000
start spl 0
      mov.i bomb, @ptr
      add.ab #$step, ptr
      jmp -2
ptr   dat #0, #100
bomb  dat #0, #0
end start
EOR
echo -n "$step "
./src/pmars -@ config/94nop.opt -b -r 300 tmp.red doc/examples/dwarf.red 2>/dev/null | tail -1
done
