;redcode-94nop
;name rotld_guess
;assert CORESIZE==8000
start spl 1
      spl 1
      spl 1
pap   spl @0, 1001
      mov.i }pap, >pap
      spl @0, 1002
      mov.i }pap, >pap
      spl @0, 1003
      mov.i }pap, >pap
      spl @0, 1005
      mov.i }pap, >pap
      spl @0, 1006
      mov.i }pap, >pap
      mov.i bomb, >pap
      jmp pap, }pap
bomb  dat #0,#0
end start
