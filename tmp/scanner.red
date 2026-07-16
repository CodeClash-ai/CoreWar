;redcode-94
;name simple scanner
;assert CORESIZE==8000
step equ 237
start spl 1
      spl 1
scan  add.ab #step, test
test  jmz.f scan, 100
      mov.i sb, >test
      mov.i db, >test
      mov.i sb, <test
      mov.i db, <test
      jmp scan
sb    spl #0,#0
db    dat #0,#0
end start
