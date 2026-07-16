;redcode-94nop
;name C-800-2200-3740
;assert CORESIZE==8000 && MAXLENGTH>=100
step1 equ 800
step2 equ 2200
step3 equ 3740
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
