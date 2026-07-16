;redcode-94nop
;name P
;assert CORESIZE==8000 && MAXLENGTH>=100
step1 equ 2200
step2 equ 3740
step3 equ 777
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
