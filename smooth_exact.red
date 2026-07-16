;redcode-94nop
;name SmoothExactGuess
;assert CORESIZE==8000
start add.ab #-34, bmb
      mov.i bmb, @bmb
      jmp start
bmb   dat #0, #-93
end start
