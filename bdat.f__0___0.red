;redcode-94nop
;name bombvar
;assert CORESIZE==8000 && MAXLENGTH>=100
step1 equ 1800
step2 equ 3740
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
bomb  dat.f #0, #0
end start
