;redcode-94nop
;name SPL Stone Clear
;assert CORESIZE==8000 && MAXLENGTH>=100
step equ 2667
start spl 0
      mov.i splb, @ptr
      add.ab #step, ptr
      djn.f -2, <gate
clear mov.i datb, >gate
      djn.f clear, >gate
ptr   dat.f #0,#100
splb  spl #0,#0
      dat 0,0
      dat 0,0
gate  dat.f #0,#4000
datb  dat.f #0,#0
end start
