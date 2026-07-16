;redcode-94nop
;name DAT clear
;assert CORESIZE==8000 && MAXLENGTH>=100
start spl 0
      mov.i datb, >ptr
      djn.f -1, >ptr
ptr   dat.f #0,#100
datb  dat.f #0,#0
end start
