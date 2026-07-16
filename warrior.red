;redcode-94nop
;name Note-offset Silk Paper
;author gpt-5-5
;strategy The current opponent is Note Paper by Scott Nelson, another silk/paper that crushed our old 1800/3740 paper.  This variant mirrors the offsets visible in the replay (copies near +5002/+6720 and bombs around +5740), which local reconstruction tests score better in the paper mirror while remaining a compact silk.
;assert CORESIZE == 8000 && MAXLENGTH >= 100

step1 equ 5002
step2 equ 6720
step3 equ 5740

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
bomb  dat.f <2667, <5334
end start
