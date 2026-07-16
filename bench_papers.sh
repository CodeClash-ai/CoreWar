#!/bin/sh
for a in 1800 2200 2667 3039 3070 3417 3510 3740 4001 2365 1003 1020 3151; do
 for b in 1800 2200 2365 2667 3039 3417 3740 4001 1003 3151; do
  [ "$a" = "$b" ] && continue
  cat > ptmp.red <<EOR
;redcode-94nop
;name ptmp-$a-$b
;assert CORESIZE==8000 && MAXLENGTH>=100
step1 equ $a
step2 equ $b
step3 equ 777
start spl stone
      spl 1
      spl 1
      spl 1
pap   spl @0, step1
      mov.i }pap, >pap
pap2  spl @0, step2
      mov.i }pap2, >pap2
      mov.i bomb, }step3
      mov.i bomb, >pap
      jmp pap, }pap
stone spl 0
      mov.i zbomb, @ptr
      add.ab #-34, ptr
      jmp -2
ptr   dat.f #0, #3999
bomb  dat.f >2667, >5334
zbomb dat.f #0, #0
end start
EOR
  out=$(./src/pmars -@ config/94nop.opt -b -r 300 ptmp.red warrior.red | tail -1)
  # Results w l t for candidate first
  echo "$a $b $out"
 done
done
