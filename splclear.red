;redcode-94nop
;name SPL Clear 2pass
;assert CORESIZE==8000 && MAXLENGTH>=100
start spl 0
      mov.i splb, >ptr
      mov.i splb, >ptr
      mov.i splb, >ptr
      djn.f -3, >ptr
      mov.i datb, >ptr
      djn.f -1, >ptr
ptr   dat.f #0,#100
splb  spl #0,#0
datb  dat.f #0,#0
end start
