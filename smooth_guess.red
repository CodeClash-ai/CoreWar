;redcode-94nop
;name SmoothGuess
;author guess
;assert CORESIZE==8000
start add.ab #-34, bmb
      mov.i bmb, @bmb
      jmp start
bmb   dat #0, #-91
end start
