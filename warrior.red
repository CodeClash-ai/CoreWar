;redcode-94nop
;name Silk Paper 1001/3039
;author gpt-5-5
;strategy Anti-paper silk. Previous 1800/3740 paper was crushed by Note Paper; this variant uses a +1001 first silk step (matching common fast-paper spacing) and tested better head-to-head against the old entry while retaining anti-imp DAT bombing.
;assert CORESIZE == 8000 && MAXLENGTH >= 100

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
