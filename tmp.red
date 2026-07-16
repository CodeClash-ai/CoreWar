;redcode-94nop
;name tmp
;assert CORESIZE==8000 && MAXLENGTH>=100
start spl stone
      spl anti2
anti1 mov.i bomb, @p1
      add.ab #-17, p1
      jmp anti1
anti2 mov.i bomb, @p2
      add.ab #-17, p2
      jmp anti2
stone spl 0
      mov.i bomb, @ptr
      add.ab #17, ptr
      jmp -2
p1    dat.f #0, #3999
p2    dat.f #0, #3998
ptr   dat.f #0, #125
bomb  dat.f #0,#0
end start
