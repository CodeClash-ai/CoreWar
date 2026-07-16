#!/bin/sh
set -e
opp=warrior.red
for s1 in 1001 1200 1600 1800 2200 2500 2667 3039 3417 3510 3740 4000 5010; do
 for s2 in 777 1001 1800 2200 2365 2667 3039 3417 3740; do
  for s3 in 777 1800 2667 3044 3740 5334; do
   cat > cand.red <<EOR
;redcode-94nop
;name cand
;assert CORESIZE==8000 && MAXLENGTH>=100
step1 equ $s1
step2 equ $s2
step3 equ $s3
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
   r=$(./src/pmars -@ config/94nop.opt -b -r 200 cand.red $opp | tail -1)
   set -- $r; w=$2; l=$3; t=$4; echo $((3*w+t)) $w $l $t $s1 $s2 $s3
  done
 done
done | sort -nr | head -20
