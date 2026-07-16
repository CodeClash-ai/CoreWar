;redcode-94nop
;name hybrid1
;assert CORESIZE==8000
start spl anti
stone spl 0
      mov.i bomb, @ptr
      add.ab #3, ptr
      jmp -2
anti  mov.i bomb, @p1
      add.ab #-34, p1
      jmp anti
p1    dat.f #0, #3999
ptr   dat.f #0, #100
bomb  dat.f #0,#0
end start
