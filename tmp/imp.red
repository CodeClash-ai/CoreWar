;redcode-94
;name imp
;assert CORESIZE==8000
step equ 2667
start spl 1
      spl 1
      spl 1
      spl 2
      jmp imp
      add #step,-1
imp   mov.i #step,*0
      end start
