#!/bin/sh
set -eu
rm -f res.txt
for s1 in 1800 2200 2667 3039 3200 3417 3740 3900; do for s2 in 1000 1800 2365 2667 3044 3417 3740; do for s3 in 777 1000 1500 2667 3044 5334; do
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
r1=$(./src/pmars -@ config/94nop.opt -b -r 200 cand.red opp_guess.red 2>/dev/null | tail -1)
r2=$(./src/pmars -@ config/94nop.opt -b -r 200 cand.red warrior.red 2>/dev/null | tail -1)
echo "$s1 $s2 $s3 $r1 $r2" | awk '{w1=$5;l1=$6;t1=$7; w2=$10;l2=$11;t2=$12; print (3*w1+t1)+(3*w2+t2),$0}' >> res.txt
done; done; done
sort -nr res.txt | head -30
