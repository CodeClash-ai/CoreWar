#!/bin/sh
mkpaper(){ f=$1; a=$2; b=$3; c=$4; cat > $f <<EOR
;redcode-94nop
;name P$a-$b-$c
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
mkpaper p3039.red 3039 2365 777
mkpaper p2200.red 2200 3740 3044
mkpaper p3510.red 3510 2200 777
mkpaper p1001.red 1001 3039 2667
mkpaper p3417.red 3417 2365 3044
mkpaper p2500.red 2500 3740 3044
