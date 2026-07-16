;redcode-94
;assert CORESIZE==8000
start spl b1
      jmp b0
b0    mov.i bomb,3039
      add.ab #3039,b0
      jmp b0
b1    mov.i bomb,3039
      add.ab #3039,b1
      jmp b1
bomb dat.f #0,#0
end start
