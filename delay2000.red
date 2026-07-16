;redcode-94nop
;name delay2000
;assert CORESIZE==8000 && MAXLENGTH>=100
start spl stone
      spl anti2
      spl delay
anti1 mov.i bomb, @p1
      add.ab #-34, p1
      jmp anti1
anti2 mov.i bomb, @p2
      add.ab #-34, p2
      jmp anti2
stone spl 0
      mov.i bomb, @ptr
      add.ab #3, ptr
      djn.f -2, <-20
delay djn.b delay, #2000
clear mov.i bomb, >cp
      jmp clear
p1    dat.f #0,#3999
p2    dat.f #0,#3998
ptr   dat.f #0,#200
cp    dat.f #0,#0
bomb  dat.f #0,#0
end start
