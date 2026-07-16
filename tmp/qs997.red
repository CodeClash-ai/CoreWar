;redcode-94
;name qspl997
;assert CORESIZE==8000
step equ 997
start spl b1
      spl b2
      spl b3
      spl b4
      spl b5
      spl b6
      spl b7
      jmp b0
b0    mov.i sb, 1000
      add.ab #step, b0
      jmp b0
b1    mov.i db, 1000
      add.ab #step, b1
      jmp b1
b2    mov.i sb, 2000
      add.ab #step, b2
      jmp b2
b3    mov.i db, 2000
      add.ab #step, b3
      jmp b3
b4    mov.i sb, 3000
      add.ab #step, b4
      jmp b4
b5    mov.i db, 3000
      add.ab #step, b5
      jmp b5
b6    mov.i sb, 4000
      add.ab #step, b6
      jmp b6
b7    mov.i db, 4000
      add.ab #step, b7
      jmp b7
sb    spl #0,#0
db    dat #0,#0
end start
