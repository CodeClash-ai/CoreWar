;redcode-94
;name scanner331
;assert CORESIZE==8000
step equ 331
start spl 1
      spl 1
scan  add.ab #step, test
test  jmz.f scan, 100
      mov.i db, >test
      mov.i db, <test
      jmp scan
db    dat #0,#0
      end start
