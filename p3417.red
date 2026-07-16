;redcode-94nop
;name P3417-2365-3044
;assert CORESIZE==8000 && MAXLENGTH>=100
step1 equ 3417
step2 equ 2365
step3 equ 3044
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
