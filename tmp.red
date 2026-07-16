;redcode-94nop
;name s
;assert CORESIZE==8000
start spl 0
      mov.i bomb, @ptr
      add.ab #3044, ptr
      jmp -2
ptr   dat #0, #4000
bomb  dat #0, #0
end start
