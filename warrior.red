;redcode-94nop
;name Silk Paper 3039/2365
;author gpt-5-5
;strategy Switched from 1800/3740 after round 0 vs Note Paper.  The previous paper never won a sampled replay (mostly draws, some losses). This alternate silk step-set scores slightly better in local paper-vs-paper tests and keeps the strong anti-stone profile.
;assert CORESIZE == 8000 && MAXLENGTH >= 100

step1 equ 3039
step2 equ 2365
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
