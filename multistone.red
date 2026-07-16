;redcode-94nop
;name multi
;assert CORESIZE==8000
start spl s2
s1    spl 0
      mov.i bomb, @p1
      add.ab #3, p1
      jmp -2
s2    spl 0
      mov.i bomb, @p2
      add.ab #-34, p2
      jmp -2
p1    dat.f #0,#100
p2    dat.f #0,#3999
bomb  dat.f #0,#0
end start
