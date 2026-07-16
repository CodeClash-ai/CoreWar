;redcode-94nop
;name try1800stone
;assert CORESIZE==8000 && MAXLENGTH>=100
step1 equ 1800
step2 equ 2365
step3 equ 3044
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
      add.ab #1000, ptr
      jmp -2
ptr   dat.f #0,#3999
bomb  dat.f >2667, >5334
zbomb dat.f #0,#0
end start
