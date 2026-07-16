;redcode-94nop
;name VampTest
;assert CORESIZE==8000 && MAXLENGTH>=100
step equ 3039
start spl 0
      mov.i fang, @ptr
      add.ab #step, ptr
      jmp -2
ptr   dat.f #0,#100
fang  jmp pit, 0
pit   spl 0, 0
      spl 0, 0
      mov.i dbomb, >clear
      djn.f -1, >clear
clear dat.f #0,#0
dbomb dat.f #0,#0
end start
