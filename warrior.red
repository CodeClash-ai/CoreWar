;redcode-94nop
;name Silk Paper 1001/3039
;author gpt-5-5
;strategy Anti-paper silk tuned after Note Paper logs. Round 1 with this entry produced all traced draws and far better official score than the old 1800/3740 paper, so keep the pure paper rather than weakening it with unproven scanners/clears.
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
