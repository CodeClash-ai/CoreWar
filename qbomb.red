;redcode-94nop
;name QuickBomb 98
;assert CORESIZE==8000 && MAXLENGTH>=100
start spl clear
      mov.i bomb, 0+98*1
      mov.i bomb, 0+98*2
      mov.i bomb, 0+98*3
      mov.i bomb, 0+98*4
      mov.i bomb, 0+98*5
      mov.i bomb, 0+98*6
      mov.i bomb, 0+98*7
      mov.i bomb, 0+98*8
      mov.i bomb, 0+98*9
      mov.i bomb, 0+98*10
      mov.i bomb, 0+98*11
      mov.i bomb, 0+98*12
      mov.i bomb, 0+98*13
      mov.i bomb, 0+98*14
      mov.i bomb, 0+98*15
      mov.i bomb, 0+98*16
      mov.i bomb, 0+98*17
      mov.i bomb, 0+98*18
      mov.i bomb, 0+98*19
      mov.i bomb, 0+98*20
      jmp start
clear spl 0
      mov.i bomb, >ptr
      djn.f -1, >ptr
ptr   dat.f #0,#100
bomb  dat.f #0,#0
end start
