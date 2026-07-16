;redcode-94nop
;name Spl carpet bomber
;assert CORESIZE==8000 && MAXLENGTH>=100
step equ 2667
start spl 0
loop  mov.i splb, @ptr
      mov.i splb, *ptr
      add.f inc, ptr
      djn.f loop, <gate
clear mov.i datb, >gate
      jmp clear
ptr   dat.f #100, #4000
inc   dat.f #step, #step
splb  spl #0, #0
datb  dat.f #0, #0
gate  dat.f #0, #200
end start
