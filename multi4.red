;redcode-94nop
;name multi4
;assert CORESIZE==8000 && MAXLENGTH>=100
start spl s2
      spl s3
      spl s4
s1    spl 0
      mov.i bomb, @p1
      add.ab #3, p1
      jmp -2
s2    spl 0
      mov.i bomb, @p2
      add.ab #-34, p2
      jmp -2
s3    spl 0
      mov.i bomb, @p3
      add.ab #-34, p3
      jmp -2
s4    spl 0
      mov.i bomb, @p4
      add.ab #-251, p4
      jmp -2
p1    dat.f #0,#200
p2    dat.f #0,#3999
p3    dat.f #0,#3998
p4    dat.f #0,#3997
bomb  dat.f #0,#0
end start
