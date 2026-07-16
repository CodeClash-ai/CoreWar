;redcode-94
;name clear2
;assert CORESIZE==8000
start spl 1
      spl 1
      spl 1
      spl c2
c1    mov.i bomb, >p1
      djn.f c1, >p1
c2    mov.i bomb, <p2
      djn.f c2, <p2
p1    dat #0,#100
p2    dat #0,#-100
bomb  dat #0,#0
      end start
