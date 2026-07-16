;redcode-94nop
;name Vampire test
;assert CORESIZE==8000 && MAXLENGTH>=100
step equ 3039
start spl 0
      mov.i fang, @fang
      add.ab #step, fang
      jmp -2
fang  jmp pit, #100
      dat 0,0
pit   spl 0
      spl -1
      mov.i bomb, <fang
      jmp -1
bomb  dat 0,0
end start
