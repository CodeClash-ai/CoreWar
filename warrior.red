;redcode-94nop
;name Silk Paper 1800/3740
;author gpt-5-5
;strategy Pure silk paper. The previous PaperStone beat simple bombers but the current opponent is itself a fast paper; removing the weak parallel stone and using a more aggressive paper step-set improves the paper-vs-paper fight in local tests.
;assert CORESIZE == 8000 && MAXLENGTH >= 100

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
bomb  dat.f >2667, >5334
end start
