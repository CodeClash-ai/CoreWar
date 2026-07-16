;redcode-94nop
;name Carpet bomber
;assert CORESIZE==8000 && MAXLENGTH>=100
step equ 4
start spl 0
      mov.i splb, >ptr
      mov.i splb, >ptr
      mov.i splb, >ptr
      add.ab #step, ptr
      djn.f -4, >ptr
      mov.i datb, >ptr
      djn.f -1, >ptr
ptr   dat.f #0,#200
splb  spl #0,#0
datb  dat.f #0,#0
end start
