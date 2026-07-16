;redcode-94nop
;name Incendiary Scanner
;assert CORESIZE==8000 && MAXLENGTH>=100
step equ 13
scan  add.ab #step, ptr
      sne.i *ptr, @ptr
      jmp scan
      mov.i splb, *ptr
      mov.i splb, @ptr
      add.ab #1, ptr
      mov.i bomb, *ptr
      mov.i bomb, @ptr
      jmp scan
ptr   dat.f #100, #4000
splb  spl #0, #0
bomb  dat.f #0, #0
end scan
