;redcode-94nop
;name p1000
;assert CORESIZE==8000
start spl 1
      spl 1
      spl 1
pap   spl @0, 1000
      mov.i }pap, >pap
      mov.i bomb, >pap
      jmp pap, }pap
bomb  dat #0,#0
end start
