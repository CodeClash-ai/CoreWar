;redcode-94
;name splclear
;assert CORESIZE==8000
start spl 1
      spl 1
      spl 1
      spl c2
c1    mov.i sb, >p1
      mov.i db, >p1
      jmp c1
c2    mov.i sb, <p2
      mov.i db, <p2
      jmp c2
p1    dat #0,#100
p2    dat #0,#-100
sb    spl #0,#0
db    dat #0,#0
      end start
