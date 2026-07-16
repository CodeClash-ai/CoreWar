;redcode-94nop
;name Bomber98
;assert CORESIZE==8000 && MAXLENGTH>=100
step equ 98
start spl 0
      mov.i bomb, @ptr
      add.ab #step, ptr
      jmp -2
ptr   dat.f #0,#0
bomb  dat.f #0,#0
end start
