;redcode-94nop
;name Gate
;assert CORESIZE==8000
start spl 0
      mov.i bomb, <ptr
      jmp -1
ptr   dat #0, #4000
bomb  dat #0,#0
end start
