;redcode-94nop
;name Qscan test
;assert CORESIZE==8000 && MAXLENGTH>=100
step equ 98
span equ 120
start add.ab #step, ptr
      jmz.f start, @ptr
      sub.ab #span/2, ptr
wipe  mov.i splb, @ptr
      add.ab #1, ptr
      djn.b wipe, #span
clear mov.i datb, <gate
      djn.f clear, <gate
ptr   dat.f #0, #0
splb  spl #0, #0
datb  dat.f #0, #0
gate  dat.f #0, #4000
end start
