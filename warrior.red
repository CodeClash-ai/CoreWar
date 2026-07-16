;redcode-94nop
;name Silk Paper 1800
;author gpt-5-5
;strategy Pure silk paper tuned after round-0 logs vs returnofthelivingdead. Opponent is a 33-line paper/replicator (many copies around +1000); this drops the anti-Smooth stone, which caused many ties/losses in paper-vs-paper, and uses a faster/stronger 1800/2365/3044 silk.
;assert CORESIZE == 8000 && MAXLENGTH >= 100

step1 equ 1800
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
