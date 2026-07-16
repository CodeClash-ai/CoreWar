;redcode-94nop
;name Multi SPL carpet
;assert CORESIZE==8000 && MAXLENGTH>=100
start spl s2
      spl s3
s1    spl 0
      mov.i splb, @p1
      add.ab #3039, p1
      jmp -2
s2    spl 0
      mov.i splb, @p2
      add.ab #2365, p2
      jmp -2
s3    spl 0
      mov.i splb, @p3
      add.ab #777, p3
      jmp -2
p1    dat.f #0,#100
p2    dat.f #0,#2700
p3    dat.f #0,#5300
splb  spl #0,#0
end start
