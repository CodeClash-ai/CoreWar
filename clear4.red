;redcode-94nop
;name clear4
;assert CORESIZE==8000 && MAXLENGTH>=100
start spl stone
      spl anti2
      spl anti3
      spl anti4
anti1 mov.i bomb, @p1
      add.ab #-34, p1
      jmp anti1
anti2 mov.i bomb, @p2
      add.ab #-34, p2
      jmp anti2
anti3 mov.i bomb, @p3
      add.ab #-34, p3
      jmp anti3
anti4 mov.i bomb, @p4
      add.ab #-34, p4
      jmp anti4
stone spl 0
      mov.i bomb, @ptr
      add.ab #3, ptr
      djn.f -2, <-20
      mov.i bomb, >clear
      jmp -1
p1    dat.f #0,#3999
p2    dat.f #0,#3998
p3    dat.f #0,#1999
p4    dat.f #0,#1998
ptr   dat.f #0,#200
clear dat.f #0,#0
bomb  dat.f #0,#0
end start
