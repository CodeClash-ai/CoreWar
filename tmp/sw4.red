;redcode-94
;assert CORESIZE == 8000
start spl b1
      spl b2
      spl b3
      jmp b0
b0    mov.i bomb,3039
      add.ab #3039,b0
      jmp b0
b1    mov.i bomb,3039
      add.ab #3039,b1
      jmp b1
b2    mov.i bomb,3039
      add.ab #3039,b2
      jmp b2
b3    mov.i bomb,3039
      add.ab #3039,b3
      jmp b3
bomb dat.f #0,#0
end start
