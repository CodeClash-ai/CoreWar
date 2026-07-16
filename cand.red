;redcode-94nop
;name Spl Stone
;assert CORESIZE==8000
start spl 0
      mov.i bomb, @ptr
      add.ab #4, ptr
      jmp -2
ptr   dat #0, #0
bomb  dat #0, #0
end start
