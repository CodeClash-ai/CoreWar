;redcode-94nop
;name qscan test
;assert CORESIZE==8000 && MAXLENGTH>=100
start seq.i 98, 99
      jmp found98
      seq.i 6722, 6723
      jmp found6722
      seq.i 5562, 5563
      jmp found5562
      jmp paper
found98 mov.i dbomb, 98
       mov.i dbomb, 99
       jmp paper
found6722 mov.i dbomb, 6722
       mov.i dbomb, 6723
       jmp paper
found5562 mov.i dbomb, 5562
       mov.i dbomb, 5563
       jmp paper
paper spl 1
      spl 1
      spl 1
pap   spl @0, 3039
      mov.i }pap, >pap
pap2  spl @0, 2365
      mov.i }pap2, >pap2
      mov.i bomb, }777
      mov.i bomb, >pap
      jmp pap, }pap
bomb  dat.f >2667, >5334
dbomb dat.f #0,#0
end start
