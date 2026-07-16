;redcode-94nop
;name NoteGuess
;assert CORESIZE==8000 && MAXLENGTH>=100
start spl 1
      spl 1
      spl 1
pap   spl @0, 6722
      mov.i }pap, >pap
p2    spl @0, 684
      mov.i }p2, >p2
      mov.i bomb, >pap
      jmp pap, }pap
bomb  dat.f >2667, >5334
end start
