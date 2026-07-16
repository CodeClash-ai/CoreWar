;redcode-94nop
;name Note Paper guess
;author Scott Nelson?
;assert CORESIZE==8000 && MAXLENGTH>=100
start spl 1
      spl 1
      spl 1
pap   spl @0, 5002
      mov.i }pap, >pap
pap2  spl @0, 6720
      mov.i }pap2, >pap2
      mov.i bomb, }5740
      mov.i bomb, >pap
      jmp pap, }pap
bomb  dat.f <2667, <5334
end start
