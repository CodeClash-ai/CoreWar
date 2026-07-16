;redcode-94nop
;name TargetNP Paper
;assert CORESIZE==8000 && MAXLENGTH>=100
step1 equ 1001
step2 equ 3039
step3 equ 2667
start spl 1
      mov.i bomb, -3778+6722
      mov.i bomb, -3778+5562
      mov.i bomb, -3778+6931
      spl 1
      mov.i bomb, -3778+54
      mov.i bomb, -3778+5368
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
