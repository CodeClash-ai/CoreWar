;redcode-94
;name splstone187
;assert CORESIZE==8000
start spl 0, <ptr
      mov.i bomb, @ptr
      add.ab #187, ptr
ptr   jmp start, 187
bomb  dat.f #0,#0
end start
