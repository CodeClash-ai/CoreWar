;redcode-94nop
;name SPL Oneshot
;assert CORESIZE==8000 && MAXLENGTH>=100
step equ 8
scan  add.ab #step, ptr
      jmz.f scan, @ptr
      add.ab #-30, ptr
wipe  mov.i splb, @ptr
      add.ab #1, ptr
      djn.b wipe, #120
clear mov.i datb, <gate
      djn.f clear, <gate
ptr   dat.f #0,#100
gate  dat.f #0,#4000
splb  spl #0,#0
datb  dat.f #0,#0
end scan
