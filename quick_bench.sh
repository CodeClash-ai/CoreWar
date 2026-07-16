#!/bin/sh
for a in 1200 1500 1800 2100 2200 2500 2667 3039 3417 3510 3740 4001; do
 for b in 1800 2200 2365 2667 3039 3417 3510 3740 4001; do
  [ "$a" = "$b" ] && continue
  for c in 777 1500 2667 3044 3417 5334; do
   cat > ptmp.red <<EOR
;redcode-94nop
;name ptmp-$a-$b-$c
;assert CORESIZE==8000 && MAXLENGTH>=100
step1 equ $a
step2 equ $b
step3 equ $c
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
   out1=$(./src/pmars -@ config/94nop.opt -b -r 50 ptmp.red rotld_guess.red | tail -1)
   out2=$(./src/pmars -@ config/94nop.opt -b -r 50 ptmp.red warrior.red | tail -1)
   set -- $out1; w1=$2; l1=$3; t1=$4
   set -- $out2; w2=$2; l2=$3; t2=$4
   score=$((3*w1+t1+3*w2+t2))
   echo "$score $a $b $c rg:$w1/$l1/$t1 cur:$w2/$l2/$t2"
  done
 done
done
