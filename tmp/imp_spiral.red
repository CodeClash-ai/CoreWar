;redcode-94
;name imp spiral test
;assert CORESIZE == 8000
istep equ 2667
start spl 1
      spl 1
      spl 1
      spl 2
      jmp imp
      add.ab #istep, -1
imp   mov.i #0, istep
      end start
