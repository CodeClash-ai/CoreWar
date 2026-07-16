#!/bin/sh
makecand(){ a=$1; b=$2; c=$3; cat > cand.red <<EOR
;redcode-94nop
;name cand-$a-$b-$c
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
}
for combo in "1001 3039 2667" "911 1001 2667" "400 1122 2667" "1800 3740 3044" "3039 2365 777" "3510 2200 777" "2200 3740 3044"; do set -- $combo; makecand $1 $2 $3; echo $combo; ./src/pmars -@ config/94nop.opt -b -r 1000 cand.red warrior.red 2>/dev/null | tail -1; ./src/pmars -@ config/94nop.opt -b -r 1000 warrior.red cand.red 2>/dev/null | tail -1; done
