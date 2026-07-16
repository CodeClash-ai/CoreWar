;redcode-94nop
;name Boot Stone
;assert CORESIZE==8000
start mov.i b1, 3000
      mov.i b2, 3001
      mov.i b3, 3002
      mov.i b4, 3003
      mov.i b5, 3004
      jmp 3000
b1    spl 0
b2    mov.i 3, @2
b3    add.ab #3, 1
b4    jmp -2
b5    dat #0, #50
      dat #0,#0
end start
