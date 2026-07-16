;redcode-94
;name splstone309
;assert CORESIZE==8000
start spl 0, <ptr
      mov.i bomb, @ptr
      add.ab #309, ptr
ptr   jmp start, 309
bomb  dat.f #0,#0
end start
