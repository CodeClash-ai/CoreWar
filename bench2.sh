#!/bin/sh
for step in 3 7 13 17 21 37 47 73 97 127 3039 3044; do for off in 0 10 50 100 500 1000 2000 4000; do
cat > tmp.red <<EOR
;redcode-94nop
;name s
;assert CORESIZE==8000
start spl 0
      mov.i bomb, @ptr
      add.ab #$step, ptr
      jmp -2
ptr   dat #0, #$off
bomb  dat #0, #0
end start
EOR
res=$(./src/pmars -@ config/94nop.opt -b -r 200 tmp.red doc/examples/dwarf.red 2>/dev/null | tail -1)
echo "$step $off $res" | awk '{w=$4;l=$5;t=$6; score=w*3+t; print score,$1,$2,w,l,t}'
done; done | sort -nr | head -20
