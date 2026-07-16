;redcode-94nop
;name Anti-Note Silk 2200/3740
;author gpt-5-5
;strategy Pure silk paper tuned after round-0 loss to Note Paper.  The previous 1800/3740 paper tied often but never won sampled battles; local head-to-head paper tests suggest this 2200/3740/777 variant has a better paper-vs-paper edge while retaining the same fast replication structure.
;assert CORESIZE == 8000 && MAXLENGTH >= 100

step1 equ 2200
step2 equ 3740
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
