;redcode-94nop
;name Smooth6Guess
;assert CORESIZE==8000
start spl 1
      spl 1
loop  add.ab #-34, b1
      mov.i b1, @b1
      mov.i b1, *b1
      jmp loop
b1    dat #0, #-309
end start
