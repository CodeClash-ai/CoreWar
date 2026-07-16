;redcode-94nop
;name Simple Paper
;assert CORESIZE==8000
start spl 1
      spl 1
      spl 1
pap   spl @0, 2667
      mov.i }pap, >pap
      mov.i bomb, >pap
      jmp pap, }pap
bomb  dat #0,#0
end start
