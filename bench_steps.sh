#!/bin/sh
steps='400 800 911 997 1001 1003 1122 1274 1800 2006 2200 2365 2500 2667 3039 3044 3151 3226 3417 3510 3604 3740 4001'
: > step_results.txt
for a in $steps; do for b in $steps; do [ "$a" = "$b" ] && continue; cat > tmpcand.red <<EOR
;redcode-94nop
;name tmp-$a-$b
;assert CORESIZE==8000 && MAXLENGTH>=100
step1 equ $a
step2 equ $b
step3 equ 2667
start spl 1
      spl 1
      spl 1
pap   spl @0, step1
      mov.i }pap, >pap
pap2  spl @0, step2
      mov.i }pap2, >pap2
      mov.i bomb, }step3
      mov.i bomb, >pap
      jmp pap, }pap
bomb  dat.f >2667, >5334
end start
EOR
res=$(./src/pmars -@ config/94nop.opt -b -r 200 tmpcand.red warrior.red 2>/dev/null | tail -1)
echo "$a $b $res" >> step_results.txt
done; done
