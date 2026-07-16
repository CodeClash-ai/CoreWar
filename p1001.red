;redcode-94nop
;name P1001-3039-2667
;assert CORESIZE==8000 && MAXLENGTH>=100
step1 equ 1001
step2 equ 3039
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
