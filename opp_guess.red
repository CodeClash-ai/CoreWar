;redcode-94nop
;name ReturnGuess
;assert CORESIZE==8000
step equ 1003
start spl 1
      spl 1
      spl 1
      spl 1
pap   spl @0, step
      mov.i }pap, >pap
      mov.i bomb, >pap
      mov.i bomb, }pap
      jmp pap, }pap
bomb  dat #0,#0
end start
