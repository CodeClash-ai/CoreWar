;redcode-94nop
;name splstone
;assert CORESIZE==8000 && MAXLENGTH>=100
start spl 0
      mov.i sbomb, @ptr
      add.ab #3, ptr
      jmp -2
ptr   dat.f #0, #200
sbomb spl 0, #0
end start
