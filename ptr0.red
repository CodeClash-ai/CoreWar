;redcode-94nop
;name ptr0
;assert CORESIZE==8000
start spl 0
mov.i bomb, @ptr
add.ab #3, ptr
jmp -2
ptr dat.f #0,#0
bomb dat.f #0,#0
end start
