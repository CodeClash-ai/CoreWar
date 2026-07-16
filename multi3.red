;redcode-94nop
;name multi3
;assert CORESIZE==8000 && MAXLENGTH>=100
start spl s2
      spl s3
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
p1    dat.f #0,#100
p2    dat.f #0,#3999
p3    dat.f #0,#3998
bomb  dat.f #0,#0
end start
